import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_services/model/subscrption.dart';
import 'package:your_services/providers/user.dart';
import 'package:your_services/screens/auth/startScreen.dart';
import 'package:your_services/screens/auth/subscription.dart';
import 'package:your_services/screens/bottomScreens/bottomNavBar.dart';

class WatingApprovelScreen extends StatefulWidget {
  int id;
  WatingApprovelScreen({@required this.id});
  @override
  State<WatingApprovelScreen> createState() => _WatingApprovelScreenState();
}

class _WatingApprovelScreenState extends State<WatingApprovelScreen>
    with WidgetsBindingObserver {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      Provider.of<UserProvider>(context, listen: false)
          .userSubscrption(id: widget.id);
    if (UserProvider.approval == '1') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BottomNavBar(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userPro=Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Subscrption()));
          },
        ),
      ),
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
                  'الرجاء الدفع عند اقرب منفذ كي كارد علما ان الرمز سيتم ارساله برسالة ',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'سيتم تفعيل الحساب تلقائيا بعد اكمال عملية الدفع',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),

                FlatButton(onPressed: (){
                  userPro.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartScreen(),));
                }, child: Text('logout'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
