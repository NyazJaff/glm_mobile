import 'package:flutter/material.dart';
import 'package:glm_mobile/model/RadioModel.dart';
import 'package:glm_mobile/utilities/constants.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _item.display == 'image'
          ? Container(
            child: Image.asset(
              "assets/icons/${_item.key}_${_item.isSelected ? 'dark' : 'grey'}.png",
              height: 50,
              // fit:BoxFit.cover
            ),
          )
          : Icon(
            _item.icon,
            color: _item.isSelected ? textAndIconColour : Colors.grey[500],
            size: 35,
          ),
          // Text(
          //   _item.key.toUpperCase(),
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //     color:
          //     _item.isSelected ? textAndIconColour : Colors.grey[500],
          //   ),
          // ),
          SizedBox(height: 5,),
          Text(
            _item.label,
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