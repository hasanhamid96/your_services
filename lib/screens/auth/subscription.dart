import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';
import 'package:your_services/helper/flushDialog.dart';
import 'package:your_services/model/subscrption.dart';
import 'package:your_services/providers/user.dart';
import 'package:your_services/screens/auth/waiting_Approvel_screen.dart';

int subscrptionId;

class Subscrption extends StatefulWidget {
  @override
  _SubscrptionState createState() => _SubscrptionState();
}

class _SubscrptionState extends State<Subscrption> {



  List<Subscriptions> subscriptions=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UserProvider>(context, listen: false).subsecrptionsTybes().then((value){
      subscriptions=value;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'اختر نوع الاشتراك',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            textDirection: ui.TextDirection.rtl,
          ),
          SubscrptionTybe(),
          Align(
            alignment: Alignment.topCenter,
            child: Text('الرجاء الدفع عند اقرب منفذ كي كارد'),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.cyan, Colors.blue]),
                borderRadius: BorderRadius.circular(10.0)),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.transparent),

              // style: ButtonStyle(
              //   // backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //     RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              // ),
              child: Text(
                'موافق',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                if (subscrptionId == null) {
                  FlushDialog.flushDialog(context, 'لم يتم اكمال التسجيل',
                      'يرجى اختبار باقة الاشتراك ');
                } else {
                  await Provider.of<UserProvider>(context, listen: false)
                      .userSubscrption(id: subscrptionId);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => WatingApprovelScreen(
                        id: subscrptionId,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}



class SubscrptionTybe extends StatefulWidget {
  @override
  State<SubscrptionTybe> createState() => _SubscrptionTybeState();
}

class _SubscrptionTybeState extends State<SubscrptionTybe> {
  int selectedIndex = -1;
  List<Subscriptions> subscriptions=[];

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).subsecrptionsTybes().then((value){
    setState(() {
      subscriptions=value;
    });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var _model = Provider.of<UserProvider>(context, listen: true);
    return SizedBox(
      height: 420,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount:subscriptions.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    subscrptionId =subscriptions[index].id;
                  });
                  print(
                      'ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo${subscrptionId.toString()}');
                },
                child: Column(
                  children: [
                    SubscrptionItem(
                      text: '${subscriptions[index].name}' +
                          ' ' +
                          '${subscriptions[index].dollar}' +
                          '\$',
                      color1: selectedIndex == index
                          ? Colors.transparent
                          : Colors.cyan,
                      color2: selectedIndex == index
                          ? Colors.transparent
                          : Colors.blue,
                      containerColor1: selectedIndex == index
                          ? Colors.cyan
                          : Colors.white,
                      containerColor2: selectedIndex == index
                          ? Colors.blue
                          : Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SubscrptionItem extends StatelessWidget {
  Color color1;
  Color color2;
  String text;
  Color containerColor1;
  Color containerColor2;

  SubscrptionItem({
    this.color1,
    this.color2,
    this.containerColor1,
    this.containerColor2,
    this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color1, color2]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.only(right: 15),
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [containerColor1, containerColor2],
          ),
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Colors.amber, width: 1.5),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            textDirection: ui.TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}
