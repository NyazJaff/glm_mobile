import 'package:flutter/material.dart';
import 'package:glm_mobile/model/RadioModel.dart';
import 'package:glm_mobile/utilities/constants.dart';
import 'RadioItem.dart';

class SelectableCard extends StatefulWidget {
  final List<RadioModel> options;
  int step;
  Function function;
  SelectableCard({Key key, @required this.options, @required this.step, @required this.function}) : super(key: key);

  @override
  _SelectableCardState createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  List<RadioModel> sampleData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //sampleData = widget.options;
    //print(sampleData.toString());
  }

  @override
  Widget build(BuildContext context) {
    sampleData = widget.options;
    // print(sampleData.toString());
    return GridView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sampleData.length,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2.3),
      ),
      itemCount: sampleData.length,
      itemBuilder: (context, index) {
        return Card(
          shape: sampleData[index].isSelected
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
              setState(() {
                sampleData.forEach((element) => element.isSelected = false);
                sampleData[index].isSelected = true;
//                print('step ${widget.step}');
                widget.function(sampleData[index].key);
//                print(answer[widget.step]);
              });
            },
            child: GridTile(child: RadioItem(sampleData[index])),
          ),
        );
      },
    );
  }
}