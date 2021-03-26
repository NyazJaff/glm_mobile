import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import 'PrayerRadioModel.dart';

class RadioPrayerItem extends StatelessWidget {
  final PrayerRadioModel _item;
  RadioPrayerItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // SizedBox(height: 10),
          Flexible(
            child: Text(
              _item.label.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                _item.isSelected ? textAndIconColour : Colors.grey[500],
              ),
            ),
          ),
          SizedBox(height: 5,),
          // Text(
          //   _item.prayerTime,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: 15,
          //     fontFamily: '',
          //     color:
          //     _item.isSelected ? textAndIconColour : Colors.grey[500],
          //   ),
          // ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Divider(
                color: Colors.grey
            ),
          ),
          Text(
            _item.availableSpaces > 0
                ? _item.availableSpaces.toString() + ' Spaces'
                : 'Full',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: '',
              color:
              _item.isSelected ? textAndIconColour : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}