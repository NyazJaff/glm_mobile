import 'package:flutter/material.dart';
import 'package:glm_mobile/utilities/util.dart';
import '../utilities/constants.dart';
import '../PrayerModel/PrayerRadioModel.dart';
import 'PrayerRadioItem.dart';

class SelectablePrayerCard extends StatefulWidget {
  final List<PrayerRadioModel> options;
  int step;
  Function function;
  SelectablePrayerCard({Key key, @required this.options, @required this.step, @required this.function}) : super(key: key);

  @override
  _SelectablePrayerCardState createState() => _SelectablePrayerCardState();
}

class _SelectablePrayerCardState extends State<SelectablePrayerCard> {
  List<PrayerRadioModel> listData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //listData = widget.options;
    //print(listData.toString());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = 160;
    final double itemWidth = size.width / 2;

    listData = widget.options;
    // print(listData.toString());
    return GridView.builder(
      physics: ScrollPhysics(),
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
      ),
      itemCount: listData.length,
      itemBuilder: (context, index) {
        PrayerRadioModel prayer = listData[index];
        return Card(
          shape: prayer.isSelected
              ? RoundedRectangleBorder(
              side: BorderSide(color: logoPrimary, width: 2.0),
              borderRadius: BorderRadius.circular(4.0))
              : RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey[200], width: 2.0),
              borderRadius: BorderRadius.circular(4.0)),
          color: Colors.white,
          elevation: 0,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if(prayer.availableSpaces > 0) {
                setState(() {
                    prayer.isSelected = widget.function(prayer);
                });
              }
            },
            child: GridTile(child: RadioPrayerItem(prayer)),
          )
        );
      },
    );
  }
}