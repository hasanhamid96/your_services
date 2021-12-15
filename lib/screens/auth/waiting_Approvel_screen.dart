import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_services/providers/user.dart';
import 'package:your_services/screens/auth/startScreen.dart';
import 'package:your_services/screens/auth/subscription.dart';
import 'package:your_services/screens/bottomScreens/bottomNavBar.dart';

class WatingApprovelScreen extends StatefulWidget {
  String id;
  WatingApprovelScreen({@required this.id});
  @override
  State<WatingApprovelScreen> createState() => _WatingApprovelScreenState();
}

class _WatingApprovelScreenState extends State<WatingApprovelScreen>
    with WidgetsBindingObserver {
  Future checkApproval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var subId = prefs.getString('$appName' + '_' + "subId");
    final userPro = Provider.of<UserProvider>(context, listen: false);
    userPro.userSubscrption(id: subId);
  }

  void initState() {
    super.initState();
    checkApproval();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var subId = prefs.getString('$appName' + '_' + "subId");
    final userPro = Provider.of<UserProvider>(context, listen: false);

    if (state == AppLifecycleState.resumed && userPro.approval == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BottomNavBar(),
        ),
      );
    } else if (subId == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => StartScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userPro = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFE0E0E0),
            ),
            width: double.infinity,
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Text(
                  'الرجاء الدفع عند اقرب منفذ كي كارد علما ان الرمز سيتم ارساله برسالة على رقم هاتفك',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'سيتم تفعيل الحساب تلقائيا بعد اكمال عملية الدفع',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
