// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glm_mobile/model/UserModel.dart';
import 'package:glm_mobile/utilities/constants.dart';
import 'package:glm_mobile/utilities/generic_shared_preference.dart';
import 'package:glm_mobile/utilities/login_auth.dart';
import 'package:glm_mobile/utilities/util.dart';
import 'menu_item.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  UserModel currentUser;
  final Auth auth = new Auth();
  final GenericSharedPreference genericSharedPreference = new GenericSharedPreference();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();

    auth.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: DRAWER,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: scrSize(context) * 10,
                        ),
                        Divider(
                          height: isLargeScreen(context) ? 64 : 30,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.3),
                          indent: 32,
                          endIndent: 32,
                        ),
                        MenuItem(
                          icon: Icons.person,
                          title: "Customers",
                          onTap: () {
                            navigateTo(context, path: '/search_customer');
                          },
                        ),
                        MenuItem(
                          icon: Icons.multiline_chart,
                          title: "New Estimate",
                          onTap: (){
                            navigateTo(context, path: '/evaluation');
                          },
                        ),
                        Divider(
                          height: scrSize(context) * 5,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.3),
                          indent: 32,
                          endIndent: 32,
                        ),
                        MenuItem(
                          icon: Icons.settings,
                          title: "Settings",
                          onTap: () async {
                            genericSharedPreference.clearLocalEvaluationData();
                            navigateTo(context, path: '/login');
                          },
                        ),
                        currentUser != null
                            ? MenuItem(
                          icon: Icons.exit_to_app,
                          title: "Logout",
                          onTap: () async {
                            genericSharedPreference.clearLocalEvaluationData();
                            auth.logout();
                            navigateTo(context, path: '/login');
                            // setState(() {});
                          },
                        )
                            : Container()
                      ],
                    ),
                  ],
                )
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: Colors.amber,
//                    padding: EdgeInsets.all(0),
                child: ListTile (
                  leading: Icon(Icons.report_problem,color: DRAWER, size: 40.0),
                  title: Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Found an issue?'),
                              // TextSpan(text: ' Nyaz Jaff'),
                            ],
                          )),
                  subtitle: Text ("Log it here.."),
                  onTap: (){
                    Navigator.pop(context);
                    launchURL('https://www.linkedin.com/in/nyazjaff/');
                  },
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
