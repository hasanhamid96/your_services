import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'LogScreen.dart';

class StartScreen extends StatelessWidget {
  static var routeName = 'StartScreen';
  StartScreen({Key key}) : super(key: key);
  TextStyle textstyle(double size) {
    return TextStyle(
      color: Colors.white,
      fontSize: size,
      shadows: [
        Shadow(color: Colors.black, offset: Offset(10, 5), blurRadius: 10),
      ],
      fontWeight: FontWeight.bold,
      fontFamily: 'Cairo-Regular',
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Image.asset('assets/images/sssssss.png'),
            SizedBox(
              height: mediaQuery.height * 0.08,
            ),
            Text('أختر حسابك', style: textstyle(25)),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: RaisedButton.icon(
                color: Colors.white,
                icon: Icon(
                  CupertinoIcons.person_add,
                  size: 33,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => LogScreen(
                        isUser: false,
                      ),
                    ),
                  );
                },
                label: Text(
                  'زبون',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Cairo-Regular',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: RaisedButton.icon(
                color: Colors.white,
                icon: Icon(CupertinoIcons.bag_badge_plus, size: 33),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => LogScreen(
                        isUser: true,
                      ),
                    ),
                  );
                },
                label: Text(
                  'مقدم خدمة',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Cairo-Regular',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: RaisedButton.icon(
                color: Colors.white,
                icon: Icon(Icons.login, size: 33),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => LogScreen(
                        isLogin: true,
                      ),
                    ),
                  );
                },
                label: Text(
                  'تسجيل دخول',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Cairo-Regular',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Container(
            //     margin: EdgeInsets.symmetric(horizontal: 20),
            //     width:double.maxFinite,
            //     child: RaisedButton.icon(
            //       icon: Icon(CupertinoIcons.gauge_badge_plus,size: 33),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(6)
            //       ),
            //       padding: EdgeInsets.symmetric(vertical: 10),
            //       onPressed: ()fl{
            //         Navigator.of(context).pushReplacement(CupertinoPageRoute(builder:(context) =>  LoginScreen(isRider: false,))) ;
            //       },label: Text('DRIVER',style: TextStyle(fontSize: 30)),)),
            // SizedBox(height: mediaQuery.height*0.11,),
          ],
        ),
      ),
    );
  }
}
