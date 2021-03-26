import 'package:flutter/material.dart';
import '../utilities/layout_helper.dart';
import '../utilities/booking_helper.dart';
import 'package:intl/intl.dart';

class CurrentBookings extends StatefulWidget {
  @override
  _CurrentBookingsState createState() => _CurrentBookingsState();
//  Yellow FFCA0A
//  Grey 505D58
//  https://coolors.co/gradient-palette/505d58-ffca0a?number=7
}

class _CurrentBookingsState extends State<CurrentBookings> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final BookingHelper bookingHelper = new BookingHelper();

  bool loading = true;
  List<dynamic> userBookings = [];
  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    _getUserBookings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getUserBookings() async{
    userBookings = await bookingHelper.getUsersBookings();
    setState(() {loading  = false;});
  }
  currentPrayers() {
    return FittedBox(
      child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: <Widget>[

              !loading ?
              userBookings.length > 0
                  ? Container(
                decoration: valueBoxDecorationStyle,
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.separated(
                  itemCount: userBookings.length,
                  itemBuilder: (BuildContext context, int index) {
                    var prayer = userBookings[index];
                    return Material(
                      type: MaterialType.transparency,
                      child: ListTile(
                          title: Text(prayer['label']),
                          subtitle: Container(
                              child: Column(
                                children: [
                                  Row(
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        child: Image.asset(
                                          "assets/icons/${(prayer['gender'] == '0' ? "male" : "female")}_dark.png",
                                          height: 20,
                                          // fit:BoxFit.cover
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 3, top: 5),
                                      ),
                                      Spacer(),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Text(DateFormat('EEEE')
                                            .format(DateTime.parse(
                                            prayer['date']))),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.cancel),
                                        iconSize: 24.0,
                                        color: Colors.red,
                                        onPressed: () {
                                          setState(() {
                                            userBookings.removeAt(index);
                                            bookingHelper.deleteUserPrayer(prayer['id']);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                    color: Colors.grey,
                                  )
                                ],
                              )),
                          onTap: () {
                            // navigateTo(context, path: '/evaluation', cleanUp: false);
                          }),
                    );
                  },
                  separatorBuilder:
                      (BuildContext context, int index) {
                    return Container();
                  },
                ),
              )
                  : Container(
                      child: Text('You have not booked any prayers for coming days!', style: txtStyle(paramSize: 15)))
                  : Container(child: display_loading(),)
            ],
          )),
    );
  }

  onAfterBuild(context) {
    // showToast(scaffoldKey.currentContext, "Successfully sent report");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      // drawer: CustomDrawer(),
      // appBar: createAppBar('New Customer'),
      body: Builder(builder: (BuildContext context) {
        return Container(
          height: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  currentPrayers(),
                  SizedBox(height: 20),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
