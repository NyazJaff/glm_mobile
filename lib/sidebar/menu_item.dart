import 'package:flutter/material.dart';
import 'package:glm_mobile/utilities/constants.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const MenuItem({Key key, this.icon, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: logoYellow,
              size: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
