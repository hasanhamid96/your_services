import 'dart:convert';
import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:your_services/model/socail.dart';
import 'package:your_services/providers/user.dart';
import 'package:your_services/helper/flushDialog.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:your_services/screens/auth/startScreen.dart';
import 'package:your_services/screens/auth/subscription.dart';
import 'package:your_services/widgets/profileScreen.dart';
import 'dart:ui' as ui;

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isLoad = false;
  var index = true;
  var isArabic = true;
  var status;

  void getNotify() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(
        () {
          index = prefs.getBool('IsNotification') == null
              ? true
              : prefs.getBool('IsNotification');
        },
      );
  }

  void getLang() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(
        () {
          isArabic = prefs.getBool('isArabic') == null
              ? true
              : prefs.getBool('isArabic');
        },
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotify();
    getLang();
    // isLoad = true;

    Provider.of<GetSocial>(context, listen: false).getSocial().whenComplete(
      () {
        social = GetSocial.social;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            color: CupertinoColors.systemTeal,
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  offset: Offset(10, 5),
                  blurRadius: 20,
                  spreadRadius: -10)
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.67,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Center(
              child: Text(
                'الأعدادت',
                textDirection: ui.TextDirection.rtl,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: isLoad
          ? SizedBox(
              width: mediaQuery.width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Shimmer.fromColors(
                  baseColor: Colors.black12,
                  highlightColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 10; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              width: mediaQuery.width * 0.4,
                              height: mediaQuery.height * 0.25,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              width: mediaQuery.width * 0.4,
                              height: mediaQuery.height * 0.25,
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      // ListView.builder(
                      //   shrinkWrap: false,
                      //   itemBuilder: (_, __) => Padding(
                      //     padding: const EdgeInsets.only(bottom: 8.0,top: 10,left: 5,right: 5),
                      //     child:
                      //   ),
                      //   itemCount: 10,
                      // ),
                    ],
                  ),
                ),
              ),
            )
          : Material(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            sheet(
                              mediaQuery.height * 0.30,
                              mediaQuery.width * 0.45,
                              'assets/images/suport.png',
                              'تواصل معنا',
                              context,
                            ),
                            sheet(
                              mediaQuery.height * 0.175,
                              mediaQuery.width * 0.45,
                              'assets/images/share.png',
                              'شاركنا',
                              context,
                            ),
                          ],
                        ),
                        sheet(
                          mediaQuery.height * 0.5,
                          mediaQuery.width * 0.45,
                          'assets/images/who we.png',
                          'من نحن',
                          context,
                        ),
                      ],
                    ),
                    sheet(
                      mediaQuery.height * 0.3,
                      mediaQuery.width * 0.93,
                      'assets/images/follow.png',
                      'تابعنا',
                      context,
                    ),
                    if (UserProvider.token != null)
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: InkWell(
                          onTap: () {
                            //old
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => ProfileScreen()));
                            //new
                            // Navigator.of(context).push(CupertinoPageRoute(
                            //     builder: (context) => Subscrption()));
                          },
                          highlightColor: Colors.yellowAccent,
                          splashColor: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  offset: Offset(10, 5),
                                  blurRadius: 20,
                                  spreadRadius: -10,
                                ),
                              ],
                            ),
                            width: MediaQuery.of(context).size.width * 0.93,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    CupertinoIcons.person_crop_circle,
                                    size: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    'ملفي الشخصي',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (UserProvider.token != null)
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: InkWell(
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                    "هل تريد تسجيل الخروج",
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                  // content: Text(
                                  //   'هل انت متأكد؟',
                                  //   style:
                                  //       Theme.of(context).textTheme.headline1,
                                  // ),
                                  actions: [
                                    CupertinoButton(
                                      // color: Colors.red,
                                      child: Text("لا",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoButton(
                                      child: Text(
                                        "نعم",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: 'Cairo-Regular',
                                        ),
                                      ),
                                      onPressed: () {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .signOut();
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                StartScreen.routeName,
                                                (Route<dynamic> route) =>
                                                    false);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          highlightColor: Colors.yellowAccent,
                          splashColor: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(10, 5),
                                    blurRadius: 20,
                                    spreadRadius: -10)
                              ],
                            ),
                            width: MediaQuery.of(context).size.width * 0.93,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    CupertinoIcons.square_arrow_left_fill,
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  'تسجيل الخروج',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(10, 5),
                            blurRadius: 20,
                            spreadRadius: -10,
                          )
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.93,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Icon(!index?FlutterIcons.notifications_off_mdi:FlutterIcons.notifications_mdi,color:index? Colors.pinkAccent:Colors.black,),
                          Switch.adaptive(
                            value: index,
                            onChanged: (value) async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('IsNotification', value);
                              setState(
                                () {
                                  Toast.show(
                                      !index
                                          ? 'تم تفعيل الاشعارات'
                                          : "تم الغاء تفعيل الاشعارات",
                                      context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.CENTER);
                                  index = value;
                                  print(index);
                                },
                              );
                              await OneSignal.shared.setSubscription(index);
                            },
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                ' الاشعارات',
                              )),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only( bottom: 8),
                    //   padding: EdgeInsets.all(8),
                    //   decoration: BoxDecoration(
                    //     borderRadius: new BorderRadius.circular(10),
                    //     shape: BoxShape.rectangle,
                    //     color: Colors.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //           color: Colors.black38,
                    //           offset: Offset(10, 5),
                    //           blurRadius: 20,
                    //           spreadRadius: -10)
                    //     ],
                    //   ),
                    //   width: MediaQuery.of(context).size.width * 0.93,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       // Icon(!index?FlutterIcons.notifications_off_mdi:FlutterIcons.notifications_mdi,color:index? Colors.pinkAccent:Colors.black,),
                    //       // Switch.adaptive(
                    //       //   value: isArabic,
                    //       //   onChanged: (value) async {
                    //       //     final prefs=await SharedPreferences.getInstance();
                    //       //     prefs.setBool('isArabic', value);
                    //       //     if(value){
                    //       //       setState(() {
                    //       //       //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //       //       //     builder: (context) => FloatingBottomNavBar(),
                    //       //       //   ));
                    //       //       //   lang.saveLanguageIndex(0);
                    //       //       //   Languages.selectedLanguage = 0;
                    //       //       //   lang.saveLanguageIndex(0);
                    //       //       // });
                    //       //
                    //       //     }
                    //       //     else{
                    //       //       setState(() {
                    //       //         Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //       //           builder: (context) => FloatingBottomNavBar(),
                    //       //         ));
                    //       //         lang.saveLanguageIndex(1);
                    //       //         Languages.selectedLanguage = 1;
                    //       //         lang.saveLanguageIndex(1);
                    //       //       });
                    //       //
                    //       //     }
                    //       //     setState(() {
                    //       //       Toast.show(!isArabic?'تم تحويل اللغة الى العربية ':"The language has been converted to Engilsh", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                    //       //
                    //       //       isArabic = value;
                    //       //       print(isArabic);
                    //       //     });
                    //       //
                    //       //   },
                    //       // ),
                    //       Padding(
                    //           padding: const EdgeInsets.only(right: 10.0),
                    //           child: Text(
                    //             lang.translation['changeLang'][Languages.selectedLanguage],
                    //           )),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget sheet(
    double height,
    double width,
    String image,
    String text,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        _bottomsheet(context, text);
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.all(8),
          width: width,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(10, 5),
                  blurRadius: 20,
                  spreadRadius: -10)
            ],
          ),
          // color: Colors.black45,
          // width: mediaQuery.width*0.4,
          height: height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Image.asset(
                    image,
                    width: width - 10,
                    height: height - 49,
                  ),
                  Center(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _bottomsheet(
    BuildContext context,
    String text,
  ) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: text == 'تابعنا' ? 400 : 300,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(
                  height: 20,
                ),
                if (text == 'من نحن')
                  Text(
                      'تطبيق خدماتك يمك يقدم كل ما يحتاجه البيت العراقي من خدمات صحيه،منزليه،نقل،خدمات بناء عن طريق افضل شركات البناء ،شركات سياحية،دليل مطاعم، حجوزات فنادق و غيرها من تسهيلات اخرى تكدر تحصله انت و بالبيت بدون تعب( اطباء ، عيادات ، مستشفيات ، محامين ، اسوق ، ) وغيرها',
                      textAlign: TextAlign.center),
                if (text == 'من نحن')
                  Image.asset(
                    'assets/images/sssssss.png',
                    width: 200,
                  ),
                if (text == 'شاركنا')
                  Text(
                    'قم بمشاركة رابط التطبيق خدماتك يمك من خلال ارسالة الى اصدقائك واقاربك او مشاركة عبر وسائل التواصل الاجتماعي لكي تسهم في انجاح وتطوير العمل',
                    textAlign: TextAlign.center,
                  ),
                SizedBox(
                  height: 25,
                ),
                if (text == 'شاركنا')
                  NiceButton(
                    // mini: true,
                    text: 'مشاركة التطبيق',
                    elevation: 8.0,
                    radius: 50.0,
                    gradientColors: [
                      Colors.pinkAccent,
                      Colors.deepPurpleAccent
                    ],
                    icon: CupertinoIcons.share,
                    background: Colors.red,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Share.share('${social.share}');
                    },
                  ),
                if (text == 'تواصل معنا')
                  Text(
                    'يمكنكم التواصل معنا من خلال الضغط على زر الاتصال  حيث سنكون متواجدين على مدار الاسبوع',
                    textAlign: TextAlign.center,
                  ),
                if (text == 'تواصل معنا')
                  SizedBox(
                    height: 30,
                  ),
                if (text == 'تواصل معنا')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // NiceButton(
                      //     width: 50,
                      //     mini: true,
                      //     elevation: 8.0,
                      //     radius: 50.0,
                      //     // gradientColors: [Colors.pinkAccent,Colors.deepPurpleAccent],
                      //     icon: FlutterIcons.whatsapp_faw,
                      //     background: Colors.green,
                      //     onPressed: ()async {
                      //       Navigator.of(context).pop();
                      //       await  whatsApp1();
                      //     }),
                      NiceButton(
                        width: 50,
                        mini: true,
                        elevation: 8.0,
                        radius: 50.0,
                        // gradientColors: [Colors.pinkAccent,Colors.deepPurpleAccent],
                        icon: FlutterIcons.call_end_mdi,
                        background: Colors.red,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          launch("tel://${social.whatsApp1}");
                        },
                      ),
                    ],
                  ),
                if (text == 'تابعنا')
                  Text(
                    'يمكنكم متابعتنا من خلال وسائل التواصل الاجتماعي لمعرفة اخر التحديثات المضافة لتطبيق وجميع انواع الخدمات  عبر صفحتنا على الفيس بوك و الانستغرام',
                    textAlign: TextAlign.center,
                  ),
                SizedBox(
                  height: 30,
                ),
                if (text == 'تابعنا')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NiceButton(
                          mini: true,
                          width: 50,
                          elevation: 8.0,
                          radius: 50.0,
                          // gradientColors: [Colors.pinkAccent,Colors.deepPurpleAccent],
                          icon: FlutterIcons.facebook_box_mco,
                          background: Colors.blue,
                          onPressed: () {
                            Navigator.of(context).pop();
                            openFaceBook();
                          }),
                      NiceButton(
                          width: 50,
                          mini: true,
                          elevation: 8.0,
                          radius: 50.0,
                          gradientColors: [
                            Colors.pinkAccent,
                            Colors.deepPurpleAccent
                          ],
                          icon: FlutterIcons.instagram_ant,
                          background: Colors.red,
                          onPressed: () {
                            Navigator.of(context).pop();
                            openInstagram();
                          }),
                      NiceButton(
                          width: 50,
                          mini: true,
                          elevation: 8.0,
                          radius: 50.0,
                          gradientColors: [Colors.redAccent, Colors.red[200]],
                          icon: FlutterIcons.web_mco,
                          background: Colors.red,
                          onPressed: () {
                            Navigator.of(context).pop();
                            openWebSite();
                          }),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                if (text == 'تابعنا')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NiceButton(
                        width: 50,
                        mini: true,
                        elevation: 8.0,
                        radius: 50.0,
                        gradientColors: [
                          Colors.lightBlue,
                          Colors.lightBlue[200]
                        ],
                        icon: FlutterIcons.twitter_ant,
                        background: Colors.lightBlue,
                        onPressed: () {
                          Navigator.of(context).pop();
                          openTwitter();
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Social social = Social(
    share: null,
    youtube: null,
    whatsApp2: null,
    whatsApp1: null,
    massenger: null,
    instagram: null,
    twitter: null,
    id: null,
    faceBook: null,
    webSite: null,
  );
  var shareApp;

  Future<void> openFaceBook() async {
    String facebookUrl = 'https://${social.faceBook}';
    await launch(facebookUrl);
    if (await canLaunch(facebookUrl)) {
      await launch(facebookUrl);
    } else {
      FlushDialog.flushDialog(
          context, 'error', "لايمكن فتح الفيس بوك او لم يتم تنصيبه");
      throw 'Could not open the facebook.';
    }
  }

  Future<void> openTwitter() async {
    String twitterUrl = 'https://${social.twitter}';
    if (await canLaunch(twitterUrl)) {
      await launch(twitterUrl);
    } else {
      FlushDialog.flushDialog(
          context, 'error', "لايمكن فتح تويتر  او لم يتم تنصيبه");
      throw 'Could not open the Twitter.';
    }
  }

  Future<void> openYouTube() async {
    String youTubeUrl = 'https://${social.youtube}';
    if (await canLaunch(youTubeUrl)) {
      await launch(youTubeUrl);
    } else {
      FlushDialog.flushDialog(
          context, 'error', "لايمكن فتح يتوتيوب  او لم يتم تنصيبه");

      throw 'Could not open the youtube.';
    }
  }

  Future<void> openMessenger() async {
    String openMassenget = 'https://${social.massenger}';
    if (await canLaunch(openMassenget)) {
      await launch(openMassenget);
    } else {
      FlushDialog.flushDialog(
          context, 'error', "لايمكن فتح  ماسنجر او لم يتم تنصيبه");

      throw 'Could not open the youtube.';
    }
  }

  Future<void> openInstagram() async {
    String openInstagram = 'https://${social.instagram}';
    if (await canLaunch(openInstagram)) {
      await launch(openInstagram);
    } else {
      FlushDialog.flushDialog(
          context, 'error', "لايمكن فتح  انستغرام او لم يتم تنصيبه");

      throw 'Could not open the youtube.';
    }
  }

  Future<void> share() async {
    final url = Uri.parse("https://iraqiboursa.creativeapps.me/api/share");
    try {
      final response = await http.get(url, headers: {
        // 'Content-type': 'application/json',
        // 'Authorization': 'bearer ${Auth.Token}',
        'Accept': 'application/json',
        // "X-Requested-With": "XMLHttpRequest"
      });
      var extractCarData = json.decode(response.body);
      extractCarData = extractCarData[0];
      shareApp = extractCarData['link'];

      print(shareApp);
    } catch (e) {
      print(e);
    }
  }

  Future<String> whatsApp1() async {
    var url;
    if (Platform.isAndroid) {
      // add the [https]
      url =
          "https://wa.me/964${social.whatsApp1}/?text=السلام عليكم استاذ"; // new line
    } else {
      // add the [https]
      // return "whatsapp://send?phone=96407810000205&text=السلام عليكم استاذ";    }
      url = "https://api.whatsapp.com/send?phone=964${social.whatsApp1}";
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      FlushDialog.flushDialog(context, 'error', 'لم يتم تنزيل الواتس');
      throw 'Could not launch ${whatsApp1()}';
    }
  }

  Future<void> openWebSite() async {
    String youTubeUrl = '${social.webSite}';
    if (await canLaunch(youTubeUrl)) {
      await launch(youTubeUrl);
    } else {
      FlushDialog.flushDialog(
          context, 'error', "لايمكن فتح ويب سايت  او لم يتم تنصيبه");

      throw 'Could not open the WebSite.';
    }
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint paint = Paint()..color = const Color(0xcfe05d49);
    Paint paint = Paint()..color = Colors.pinkAccent;
    Path path = Path()
      ..relativeLineTo(0, 120)
      ..quadraticBezierTo(size.width / 4.7, 250.0, size.width, 20)
      ..relativeLineTo(1, -11450)
      ..close();
    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
