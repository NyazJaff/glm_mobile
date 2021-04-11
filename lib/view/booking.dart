import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:glm_mobile/PrayerModel/SelectablePrayerCard.dart';
import 'package:glm_mobile/class/CustomShapes.dart';
import 'package:glm_mobile/class/Input.dart';
import 'package:glm_mobile/class/SelectableCard.dart';
import 'package:glm_mobile/PrayerModel/PrayerRadioModel.dart';
import 'package:glm_mobile/model/RadioModel.dart';
import 'package:glm_mobile/utilities/constants.dart';
import 'package:glm_mobile/utilities/layout_helper.dart';
import 'package:glm_mobile/utilities/util.dart';
import 'package:glm_mobile/utilities/booking_helper.dart';
import 'package:glm_mobile/view/current_booking.dart';
import 'package:intl/intl.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BookingHelper bookingHelper = new BookingHelper();

  TextEditingController full_name = TextEditingController();  final focus_full_name = FocusNode();
  TextEditingController phone_number = TextEditingController(); final focus_phone_number = FocusNode();
  TextEditingController email = TextEditingController(); final focus_email = FocusNode();
  // TextEditingController address_line_1 = TextEditingController(); final focus_address_line_1 = FocusNode();
  // TextEditingController address_line_2 = TextEditingController(); final focus_address_line_2 = FocusNode();
  // TextEditingController city = TextEditingController(); final focus_city = FocusNode();
  // TextEditingController postcode = TextEditingController(); final focus_postcode = FocusNode();

  StepperType stepperType = StepperType.horizontal;

  String warningMessage = '';
  String bookingDate = '';

  bool isLoading = false;
  bool complete = false;
  bool loadingPrayers = true;
  var prayerTimes = {};
  var dates = {};

  int _currentStep = 0;

  List<Widget> prayerWidgets = [];
  List<TextEditingController> inputsToValidate;

  Map bookingSlotData = {'gender': '', 'prayers': [], 'date': ''};

  final List<RadioModel> genderOptions = [
    RadioModel(false, "male", "Male", Icons.brightness_medium, display: 'image'),
    RadioModel(false, "female", "Female", Icons.brightness_medium, display: 'image'),
  ];

  List<Map<String, dynamic>> configSteps = [
    {"key": "gender"},
    {"key": "prayer_times"},
    {"key": "details"},
  ];

  @override
  Future<void> initState() {
    super.initState();

    inputsToValidate = [full_name, phone_number, email];
    getPrayerSlots();
    getUserInfoFromPreference();
  }

  getUserInfoFromPreference() async{
    Map<String,dynamic> data = await bookingHelper.getUserInfoFromPreference();
    if (data.isEmpty){
      return;
    }
    full_name.text = data['full_name'];
    phone_number.text = data['phone_number'];
    email.text = data['email'];
    // address_line_1.text = data['address_line_1'];
    // address_line_2.text = data['address_line_2'];
    // city.text = data['city'];
    // postcode.text = data['postcode'];
  }

  setUserInfoFromPreference() async{
    Map<String,dynamic> data = {};
    data['full_name'] = full_name.text;
    data['phone_number'] = phone_number.text;
    data['email'] = email.text;
    // data['address_line_1'] = address_line_1.text;
    // data['address_line_2'] = address_line_2.text;
    // data['city'] = city.text;
    // data['postcode'] = postcode.text;
    await bookingHelper.setUserInfoInPreference(data);
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  formatPrayerSlots(gender) {}

  getPrayerSlots() async {
    prayerTimes = await bookingHelper.getPrayerSlots();

    int index = 0;
    prayerTimes['slots'].forEach((date, v) {
      dates[date] = index;
      index++;
    });

    bookingSlotData['date'] = dates.keys.toList()[0];
    setState(() {
      loadingPrayers = false;
    });
  }

  createPrayerSlots(date) {
    prayerWidgets = [];
    var currentSelectedPrayers = bookingSlotData['prayers'];
    bookingSlotData['prayers'] = [];
    setState(() {
      loadingPrayers = true;
    });

    // Text('Isha Prayers include Traweeh and Witr', style: kLabelStyle()),
    bookingSlotData['date'] = date; // current date is selected by default
    prayerTimes['slots'][date][bookingSlotData['gender']].forEach((group) {
      prayerWidgets.add(SizedBox(height: 20));
      List<PrayerRadioModel> prayers = [];
      group.forEach((group) {
        PrayerRadioModel prayerModel = PrayerRadioModel.fromJson(group);
        if (currentSelectedPrayers.contains(prayerModel.key) && prayerModel.availableSpaces != 0){
          prayerModel.isSelected = true;
          bookingSlotData['prayers'].add(prayerModel.key);
        }
        prayers.add(prayerModel);
      });
      prayerWidgets.add(SelectablePrayerCard(
          key: UniqueKey(),
          options: prayers,
          step: 1,
          function: selectPrayerSlot));
      prayerWidgets.add(SizedBox( height: 10));
      prayerWidgets.add(Divider(height: 20, color: Colors.grey,));
    });

    setState(() {
      loadingPrayers = false;
    });

  }

  bookSlotOnSystem() {}

  bookNewSlot() async{
    setState(() {
      isLoading = true;
    });

    var validData = await validateData();
    if (validData == false) {
      setState(() { isLoading = false; });
      return;
    }

    String deviceId = await bookingHelper.getDeviceId();
    bookingSlotData['deviceId']       = deviceId;
    bookingSlotData['full_name']      = full_name.text;
    bookingSlotData['phone_number']   = phone_number.text;
    bookingSlotData['email']          = email.text;
    // bookingSlotData['address_line_1'] = address_line_1.text;
    // bookingSlotData['address_line_2'] = address_line_2.text;
    // bookingSlotData['city']           = city.text;
    // bookingSlotData['postcode']       = postcode.text;
    var response = await bookingHelper.bookSlotOnSystem(bookingSlotData);
    if(response['status'] == 'error'){
      setWarning(response['message']);
    }else{
      complete = true;
    }

    setUserInfoFromPreference();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            // decoration: BoxDecoration(color: Color(0x50A04C0)),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/brand/masjid-outside.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage("assets/brand/grid.jpeg"),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                createTopCurved(),
                // addCurvedImage('home-backround-shape'),
                // addCurvedImage('home-backround'),
                flashContainer([
                  SizedBox(height: 40.0),
                  createLogoDisplay(),
                  SizedBox(height: 50.0),
                  complete == false
                      ? createBookingBox()
                      : createSummary(),
                  SizedBox(height: 10),
                  TextButton(
                    child: Text('My Bookings',
                        style: txtStyle(paramBold: true, paramSize: 16)),
                    onPressed: () {
                      _showModalBottomSheet(context);
                    },
                  ),
                  TextButton(
                    child: Text('Prayer Timetable',
                        style: txtStyle(paramBold: true, paramSize: 16)),
                    onPressed: () async {
                      await InAppBrowser.openWithSystemBrowser(
                          url: 'https://honeyforsyria.com/wp-content/uploads/2021/04/current_prayer_timetable.pdf');
                    },
                  )
                  // TextButton(onPressed: _showModalBottomSheet(context), child: Container())
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  weInRamadan(){
    var startDate = new DateTime(2021, 4, 7);
    var endDate = new DateTime(startDate.year, startDate.month + 1, startDate.day+5);
    DateTime now = new DateTime.now();
    if(now.isAfter(startDate) && now.isBefore(endDate) ){
      return true;
    }
    return false;
  }

  _showModalBottomSheet(context){
    showModalBottomSheet(context: context, builder: (BuildContext cotext) {
      return SingleChildScrollView(
        child: Column(children: [
          Row(
            children: [
              Spacer(),
              IconButton(icon: Icon(Icons.cancel, color: Colors.grey, size: 25,),
                  onPressed: (){
                    Navigator.of(context).pop();
                  })
            ],
          ),
          Container(
            padding: EdgeInsets.only(top:10),
            height: MediaQuery.of(context).size.height * 0.5,
            child: CurrentBookings(),
          )
        ]
        ),
      );
    });
  }

  callCreateOptionMethod(key, data) {
    switch (key) {
      case "gender":
        {
          return createGenderOptions();
        }
        break;
      case "prayer_times":
        {
          return createPrayerOptions();
        }
        break;
      case "details":
        {
          return createSubmitBox();
        }
        break;
    }
    return Container(child: Text(''));
  }

  createBookingBox() {
    return FittedBox(
      child: Container(
          alignment: Alignment.center,
          decoration: valueBoxDecorationStyle,
          width: scrSize(context) * 43,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10), // Some height
                child: Text('Book your space for prayer',
                    style: txtStyle(paramBold: true, paramSize: 18)),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1),
                height: scrSize(context) * 45,
                child: createSteps(),
              ),
              Row(
                mainAxisAlignment: _currentStep > 0 && _currentStep < 2
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                children: [
                  _currentStep > 0
                      ? TextButton(
                    child: Text(' Back',
                        style: txtStyle(paramBold: true, paramSize: 16)),
                    onPressed: () {
                      cancelStep();
                    },
                  )
                      : Center(),
                  _currentStep < 2 &&
                      loadingPrayers == false &&
                      bookingSlotData['gender'] != ''
                      ? TextButton(
                    child: Text(' Next',
                        style: txtStyle(paramBold: true, paramSize: 16)),
                    onPressed: () {
                      nextStep();
                    },
                  )
                      : Center(),
                ],
              ),
            ],
          )),
    );
  }

  selectGender(gender) {
    bookingSlotData['gender'] = gender;
    createPrayerSlots(bookingSlotData['date']);
    nextStep();
  }

  createGenderOptions() {
    return new SelectableCard(
        key: UniqueKey(),
        options: genderOptions,
        step: 1,
        function: selectGender);
  }

  crateDateSelect() {
    var currentDateIndex = dates[bookingSlotData['date']];
    return Container(
      // alignment:  Alignment.center,
        decoration: valueBoxDecorationStyle,
        height: 45.0,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: 35,
                child: currentDateIndex > 0
                    ? TextButton(
                  onPressed: () {
                    setState(() {
                      createPrayerSlots(
                          dates.keys.toList()[currentDateIndex - 1]);
                    });
                  },
                  child: Icon(Icons.arrow_back_ios_outlined,
                      color: navButtons),
                )
                    : Container()),
            Flexible(
              child: Text(
                  formatDate(bookingSlotData['date']),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                      color: textAndIconColour,
                      fontSize: 15,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              width: 35,
              child: currentDateIndex + 1 != dates.values.toList().length
                  ? TextButton(
                onPressed: () {
                  setState(() {
                    createPrayerSlots(
                        dates.keys.toList()[currentDateIndex + 1]);
                    // bookingDate = 'Friday 14/12/2020';
                  });
                },
                child: Icon(Icons.arrow_forward_ios_outlined,
                    color: navButtons),
              )
                  : Container(),
            )
          ],
        ));
  }

  createPrayerOptions() {
    return Column(
      children: [
        crateDateSelect(),
        Column(
          children: prayerWidgets,
        )
      ],
    );
  }

  selectPrayerSlot(PrayerRadioModel prayer) {
    if (bookingSlotData['prayers'].contains(prayer.key)) {
      bookingSlotData['prayers'].remove(prayer.key);
      setWarning('');
      return false;
    }

    // if(bookingSlotData['prayers'].length >= 2){
    //   setWarning('Current limit is 2 slots for each day');
    //   return false;
    // }

    bookingSlotData['prayers'].add(prayer.key);
    setWarning('');
    return true;
  }

  createSubmitBox() {
    return Column(
      children: [
        Input(
          controller: full_name,
          label: 'Fill all required * fields *',
          hint: 'Full Name *',
          leadingIcon: Icons.person,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        Input(
          controller: phone_number,
          // label: 'Phone Number *',
          hint: 'Phone Number *',
          leadingIcon: Icons.phone_android,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        Input(
          controller: email,
          // label: 'Email Address *',
          hint: 'Email Address *',
          leadingIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
        // Input(
        //   controller: address_line_1,
        //   // label: 'Address line 1 *',
        //   hint: 'Address line 1 *',
        //   leadingIcon: Icons.location_on_rounded,
        //   keyboardType: TextInputType.text,
        //   textInputAction: TextInputAction.next,
        // ),
        // Input(
        //   controller: address_line_2,
        //   // label: 'Address line 2',
        //   hint: 'Address line 2',
        //   leadingIcon: Icons.location_on_rounded,
        //   keyboardType: TextInputType.text,
        //   textInputAction: TextInputAction.next,
        // ),
        // Input(
        //   controller: city,
        //   // label: 'City *',
        //   hint: 'City *',
        //   leadingIcon: Icons.location_city,
        //   keyboardType: TextInputType.text,
        //   textInputAction: TextInputAction.next,
        // ),
        // Input(
        //   controller: postcode,
        //   // label: 'Postcode *',
        //   hint: 'Postcode *',
        //   leadingIcon: Icons.location_on_rounded,
        //   keyboardType: TextInputType.text,
        //   textInputAction: TextInputAction.done,
        // ),
        SizedBox(
          height: 10,
        ),
        // SizedBox(height: 10),
        Text(warningMessage,
            style: TextStyle(
                color: warning,
                fontWeight: FontWeight.w400,
                fontSize: 15)),
        // createSummary(),
        largeActionButton("Reserve", bookNewSlot, isLoading: isLoading),
      ],
    );
  }

  Future<bool> validateData() async{
    bool invalidValidation = false;
    inputsToValidate.forEach((element) {
      if(element.text == ''){
        setState(() {
          setWarning('Missing required * fields');
          invalidValidation = true;
        });
      }
    });
    return !invalidValidation;
  }

  createSummary() {
    return FittedBox(
      child: Container(
          alignment: Alignment.center,
          decoration: valueBoxDecorationStyle,
          width: scrSize(context) * 30,
          height: scrSize(context) * 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.done,
                color:  Colors.green[500],
                size: 120,
              ),

              TextButton(
                onPressed: () {
                  navigateTo(context, path: '/booking');
                },
                child: Text(
                  'Book another prayer?',
                  style: txtStyle(paramBold: true, paramSize: 18),
                ),
              ),
            ],
          )),
    );
  }

  goTo(int step) {
    // FocusScopeNode currentFocus = FocusScope.of(context);
    // if (!currentFocus.hasPrimaryFocus) {
    //   currentFocus.unfocus();
    // }

    setState(() => _currentStep = step);
  }

  nextStep() async {
    _currentStep < 2 ? goTo(_currentStep + 1) : bookSlotOnSystem();
  }

  cancelStep() {
    if (_currentStep > 0) {
      goTo(_currentStep - 1);
    }
  }

  isStepActive(step) {
    return _currentStep >= step;
  }

  mapSteps() {
    List<Step> createdSteps = [];
    configSteps.asMap().forEach((index, step) => {
      createdSteps.add(Step(
        title: Text(''),
        subtitle: Text(''),
        isActive: isStepActive(index),
        state: StepState.complete,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            callCreateOptionMethod(step['key'], step['data'])
            //step['key'] == 'turn_off' ? createTurnOffOption() : step['optionCreateCall']
          ],
        ),
      ))
    });
    return createdSteps;
  }

  Widget createSteps() {
    return Column(
      children: <Widget>[
        Expanded(
          child: !loadingPrayers
              ? StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Theme(
                  data: ThemeData(
                      shadowColor: Color(0xffffffff),
                      canvasColor: Color(0xffffffff),
                      accentColor: Color(0xFF04C0AD),
                      primarySwatch: Colors.blue,
                      colorScheme: ColorScheme.light(
                        primary: Color(0xFF04C0AD),
                      )),
                  child: Stepper(
                    type: stepperType,
                    steps: mapSteps(),
                    currentStep: _currentStep,
                    onStepContinue: nextStep,
                    onStepTapped: (step) => {},
                    onStepCancel: cancelStep,
                    controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                          VoidCallback onStepCancel}) {
                      return Row(
                        children: <Widget>[
                          Container(child: null),
                          Container(
                            child: null,
                          ),
                        ],
                      );
                    },
                  ),
                );
              })
              : display_loading(),
        )
      ],
    );
  }

  setWarning(msg) {
    setState(() {
      warningMessage = msg;
    });
  }

  Widget createLogoDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: scrSize(context) * 15,
          height: scrSize(context) * 15,
          padding: EdgeInsets.all(5),
          decoration: linearGradientBackground(context),
          child: Container(
            child: Image.asset(
              "assets/brand/logo_transparent.png",
              // fit:BoxFit.cover
            ),
          ),
        )
      ],
    );
  }

  Widget createTopCurved() {
    return Container(
      padding: EdgeInsets.all(0),
      width: double.infinity,
      height: scrSize(context) * 55,
      child: CustomPaint(
        painter: HomeCurvedShape(),
      ),
    );
  }

  Widget addCurvedImage(img) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ClipPath(
            clipper: TriangleClipper(),
            child: Image.asset("assets/brand/${img}.png",
                height: scrSize(context) * 55, fit: BoxFit.fill),
          ),
        )
      ],
    );
  }
}

BoxDecoration linearGradientBackground(context) {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 10,
        offset: Offset(0, 5), // changes position of shadow
      ),
    ],
    gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: [
          0.2,
          0.3,
          0.4,
          0.9
        ],
        colors: [
          Color(0xffffffff),
          Color(0xffffffff),
          Color(0xffe8e8e8),
          Color(0xffe8e8e8)
        ]),
    borderRadius: BorderRadius.circular(scrSize(context) * 3),
    // border: Border.all(width: 0, color: Colors.white)
  );
}
