import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:your_services/helper/flushDialog.dart';
import 'package:your_services/model/city.dart';
import 'package:your_services/model/section.dart';
import 'package:your_services/providers/cities.dart';
import 'package:your_services/providers/sections.dart';
import 'package:your_services/providers/user.dart';
import 'package:your_services/screens/auth/subscription.dart';
import 'package:your_services/screens/auth/waiting_Approvel_screen.dart';
import 'package:your_services/widgets/curvePainter.dart';
import '../bottomScreens/bottomNavBar.dart';
import '../maps/map-screen.dart';

class LogScreen extends StatefulWidget {
  static var routeName = '/login';

  bool isUser = true;
  bool isLogin;
  LogScreen({this.isUser: true, this.isLogin: false});
  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  bool isloadingregoin = false;
  bool isLogin = false;
  bool isUser = true;
  bool isLoadingCities = false;
  bool isLoadingSections = false;
  File _image;
  var _key = GlobalKey<FormState>();
  var name;
  var phone;
  var address;
  var craft;
  var pass;
  var kHintTextStyle;
  var kLabelStyle;
  bool isLogging = false;
  Section selectedCat;
  String categoryTitle;
  int section_id;
  final kBoxDecorationStyle = BoxDecoration(
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(10.0),
  );
  var third =
      'التطبيق لا يتحمل اي مشاكل او خلافات بين الاطراف المتفقين على اي عمل كان';
  var second =
      ' التطبيق يحملك جميع المسؤلية والمخالفات والتجاوزات القانونيه في حال تم استخدام التطبيق باي شكل مخالف او غير لائق بالمجتع او اي خدش للحياء';
  var first = 'يسمح لك هاذا التطبيق بنشر جميع ما يخص عملك المسجل لدينا';
  void _onSignUp() {
    print('saving...');
    var isValid = _key.currentState.validate();
    if (!isValid) {
      FlushDialog.flushDialog(
          context, 'لم يتم عملية التسجيل', 'يرجى مليء الحقول');
    } else {
      _key.currentState.save();
      setState(() {
        signing = true;
      });
      if (!isLogin)
        showCupertinoDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setStates) => CupertinoAlertDialog(
              title: Text(
                'الشروط والاحكام',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Cairo-Regular',
                ),
              ),
              content: Container(
                  margin: EdgeInsets.only(top: 30),
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(children: [
                      TextSpan(
                        text:
                            'الرجاء قراءة الشروط والاحكام بالكامل لضمان حقوقك ومسؤلياتك عند قيامك باستخدام المحتوى المتوفر\n',
                        style: TextStyle(
                          color: Colors.purple[200],
                          fontFamily: 'Cairo-Regular',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                          text: '١-',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Cairo-Regular',
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                      TextSpan(
                        text: '$first\n',
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Cairo-Regular',
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                          text: '٢-',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Cairo-Regular',
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                      TextSpan(
                        text: '$second\n',
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Cairo-Regular',
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                          text: '٣-',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Cairo-Regular',
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                      TextSpan(
                        text: '$third\n',
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Cairo-Regular',
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ]),
                    //ext('الرجاء قراءة الشروط والاحكام بالكامل لضمان حقوقك ومسؤلياتك عند قيامك باستخدام المحتوى المتوفر\n$first\n$second\n$third',
                    //                style: TextStyle(color: Colors.black54, fontFamily: 'Cairo-Regular',fontSize: 16),
                    //                textAlign: TextAlign.right,)
                  )),
              actions: [
                CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      setState(() {
                        signing = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'رجوع',
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Cairo-Regular',
                          fontSize: 13),
                    )),
                CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: () {
                    var isValid = _key.currentState.validate();
                    if (isValid) {
                      _key.currentState.save();
                      if (isUser) {
                        //old
                        // setStates(() => isLogging = true);
                        //new
                        // setStates(() => isLogging = true);
                        print('registering Craft...');
                        Provider.of<UserProvider>(context, listen: false)
                            .registerCraft(
                          name: name,
                          password: pass,
                          phone: phone,
                          city_id: city_id,
                          section_id: section_id,
                          file: _image,
                          image: imagePicked,
                          address: address,
                        )
                            .then(
                          (value) {
                            if (value == 'true') {
                              setStates(() {
                                // signing = false;
                                // isLogging = false;
                              });
                              Navigator.of(context).pop();
                              //old
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => WatingApprovelScreen(),
                                ),
                              );
                              //new
                              Provider.of<UserProvider>(context, listen: false)
                                  .subsecrptionsTybes();

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => subscrptionsScreen(),
                                ),
                              );
                            } else {
                              setStates(
                                () {
                                  signing = false;
                                  isLogging = false;
                                },
                              );
                              FlushDialog.flushDialog(
                                  context,
                                  'لم يتم عملية التسجيل',
                                  '${value == null ? 'يرجى محاولة مرة اخرى' : value}');
                            }
                          },
                        );
                      } else {
                        setStates(() => isLogging = true);
                        print('registering User...');
                        Provider.of<UserProvider>(context, listen: false)
                            .registerUser(
                                name: name,
                                password: pass,
                                phone: phone,
                                birthday: _currentDate.toString(),
                                genderr: _genderString)
                            .then(
                          (value) {
                            if (value == 'true') {
                              setStates(() {
                                signing = false;
                                isLogging = false;
                              });
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => BottomNavBar(),
                                ),
                              );
                            } else {
                              setStates(() {
                                signing = false;
                                isLogging = false;
                              });
                              FlushDialog.flushDialog(
                                  context,
                                  'لم يتم عملية التسجيل',
                                  '${value == null ? 'يرجى محاولة مرة اخرى' : value}');
                            }
                          },
                        );
                      }
                    }
                  },
                  child: isLogging
                      ? Center(child: CupertinoActivityIndicator())
                      : Text(
                          'قبول وتسجيل',
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Cairo-Regular',
                            fontSize: 13,
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      else {
        {
          {
            Provider.of<UserProvider>(context, listen: false)
                .login(
              phone,
              pass,
            )
                .catchError((onError) {
              FlushDialog.flushDialog(
                context,
                'لم يتم عملية تسجيل الدخول',
                '$onError',
              );
              setState(() {
                signing = false;
              });
            }).then(
              (value) {
                if (value == 'login success') {
                  setState(() {
                    signing = false;
                  });
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => BottomNavBar(),
                  ));
                } else {
                  FlushDialog.flushDialog(
                    context,
                    'لم يتم عملية تسجيل الدخول',
                    '$value',
                  );
                  setState(
                    () {
                      signing = false;
                    },
                  );
                }
              },
            );
          }
        }
      }
    }
  }

  Set<Marker> markers = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(
      () {
        isUser = widget.isUser;
        isLogin = widget.isLogin;
      },
    );
    isLoadingCities = true;
    isLoadingSections = true;
    Provider.of<Cities>(context, listen: false).fetchDataCity().then(
      (value) {
        if (mounted)
          setState(() {
            isLoadingCities = false;
          });
      },
    );
    Provider.of<Sections>(context, listen: false).fetchSections().then(
      (value) {
        if (mounted)
          setState(
            () {
              isLoadingSections = false;
            },
          );
      },
    );
  }

  bool signing = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    if (UserProvider.latitude != null) {
      markers.add(
        Marker(
            position: LatLng(UserProvider.latitude, UserProvider.longitude),
            markerId: MarkerId('UserProvider.latitude'),
            icon: BitmapDescriptor.defaultMarker),
      );
    }
    kHintTextStyle = Theme.of(context).textTheme.headline4;
    kLabelStyle = Theme.of(context).textTheme.headline4;
    double late = 0.0;
    double longe = 0.0;
    bool isMapSel = false;
    Completer<GoogleMapController> completer;
    void getLat(double lat, double long) {
      setState(
        () {
          isMapSel = true;
          longe = long;
          late = lat;

          Future.delayed(
            Duration(seconds: 2),
          ).then(
            (value) {
              setState(
                () {
                  isMapSel = false;
                },
              );
            },
          );
        },
      );
    }

    return Material(
      color: Colors.transparent,
      child: CupertinoPageScaffold(
        // navigationBar: CupertinoNavigationBar(
        //   transitionBetweenRoutes: false,
        //   leading: Container(
        //     child: IconButton(
        //       icon: Icon(Icons.clear),
        //       onPressed: (){
        //         Navigator.of(context).pop(MainScreen());
        //
        //       },
        //     ),
        //   ),
        //   backgroundColor: Colors.white70,
        //   middle: Text(isLogin? "تسجيل دخول":'تسجيل'),
        // ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              // SizedBox(height: 40,),
              CustomPaint(
                painter: CurvePainter(false, CupertinoColors.placeholderText),
                child: Container(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap:
                        !isLogin && isUser ? () => _showPicker(context) : null,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        if (!isUser)
                          CircleAvatar(
                            backgroundColor: CupertinoColors.systemTeal,
                            child: Icon(
                              CupertinoIcons.person_crop_circle,
                              size: 60,
                              color: CupertinoColors.white,
                            ),
                            radius: 70,
                            backgroundImage: imagePicked == null
                                ? null
                                : FileImage(imagePicked),
                          ),
                        if (isUser)
                          CircleAvatar(
                            backgroundColor: imagePicked != null
                                ? Colors.transparent
                                : CupertinoColors.systemTeal,
                            child: imagePicked != null
                                ? null
                                : Icon(
                                    !isLogin
                                        ? CupertinoIcons.photo_camera_solid
                                        : CupertinoIcons.person_crop_circle,
                                    size: !isLogin ? 45 : 60,
                                    color: CupertinoColors.white,
                                  ),
                            radius: 70,
                            backgroundImage: imagePicked == null
                                ? null
                                : FileImage(imagePicked),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _key,
                    child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 700),
                        switchInCurve: Curves.easeInToLinear,
                        switchOutCurve: Curves.easeInToLinear,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: isLogin
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) return 'الحقل فارغ';
                                        if (!value.contains('07'))
                                          return 'اكتب رقم صحيح رجائا';
                                        return null;
                                      },
                                      maxLength: 11,
                                      onSaved: (Phone) {
                                        phone = Phone;
                                      },
                                      keyboardType: TextInputType.phone,
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                      decoration: InputDecoration(
                                        hintText: 'رقم الموبايل',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) return 'الحقل فارغ';
                                        return null;
                                      },
                                      onSaved: (password) {
                                        pass = password;
                                      },
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                      decoration: InputDecoration(
                                        hintText: 'الباسورد',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : AnimatedSwitcher(
                                duration: Duration(milliseconds: 700),
                                switchInCurve: Curves.easeInToLinear,
                                switchOutCurve: Curves.easeInToLinear,
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: !isUser
                                    ? Container(
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return 'الحقل فارغ';
                                                return null;
                                              },
                                              onSaved: (Name) {
                                                name = Name;
                                              },
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1,
                                              decoration: InputDecoration(
                                                hintText: 'الأسم',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return 'الحقل فارغ';
                                                if (!value.contains('07'))
                                                  return 'اكتب رقم صحيح رجائا';
                                                return null;
                                              },
                                              maxLength: 11,
                                              onSaved: (Phone) {
                                                phone = Phone;
                                              },
                                              keyboardType: TextInputType.phone,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1,
                                              decoration: InputDecoration(
                                                hintText: 'رقم الموبايل',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return 'الحقل فارغ';
                                                return null;
                                              },
                                              onSaved: (password) {
                                                pass = password;
                                              },
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1,
                                              decoration: InputDecoration(
                                                hintText: 'الباسورد',
                                              ),
                                            ),
                                            // SizedBox(height: 10,),
                                            // dropDwon(context, _section, 'hint'),
                                            // SizedBox(height: 10,),
                                            // InkWell(
                                            //   onTap: callDatePicker,
                                            //   child: Container(
                                            //     padding: EdgeInsets.only(left: 25, right: 15,top: 15,bottom: 15),
                                            //     decoration: BoxDecoration(
                                            //       borderRadius: new BorderRadius.circular(10),
                                            //       shape: BoxShape.rectangle,
                                            //       color: Colors.white,
                                            //       boxShadow: [
                                            //         BoxShadow(
                                            //           color: Colors.black26,
                                            //           offset: Offset(10, 5),
                                            //           blurRadius: 20,
                                            //           spreadRadius: -10)  ],
                                            //     ),
                                            //     child: Row(
                                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //       children: [
                                            //         Text('اختار يوم ميلادك'),
                                            //         Text('${DateFormat('yyyy-MM-dd').format(_currentDate)}'),
                                            //       ],
                                            //     ),),
                                            // ),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          //name
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return 'الحقل فارغ';
                                              return null;
                                            },
                                            onSaved: (Name) {
                                              name = Name;
                                            },
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                            decoration: InputDecoration(
                                              hintText: 'الأسم',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //phone
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return 'الحقل فارغ';
                                              if (!value.contains('07'))
                                                return 'اكتب رقم صحيح رجائا';
                                              return null;
                                            },
                                            maxLength: 11,
                                            onSaved: (Phone) {
                                              phone = Phone;
                                            },
                                            keyboardType: TextInputType.phone,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                            decoration: InputDecoration(
                                              hintText: 'رقم الموبايل',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return 'الحقل فارغ';
                                              return null;
                                            },
                                            onSaved: (Address) {
                                              address = Address;
                                            },
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                            decoration: InputDecoration(
                                              hintText: 'العنوان',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return 'الحقل فارغ';
                                              return null;
                                            },
                                            onSaved: (Craft) {
                                              craft = Craft;
                                            },
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                            decoration: InputDecoration(
                                              hintText: 'المهنة',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return 'الحقل فارغ';
                                              return null;
                                            },
                                            onSaved: (password) {
                                              pass = password;
                                            },
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                            decoration: InputDecoration(
                                              hintText: 'الباسورد',
                                            ),
                                          ),
                                          // Text('المحافظة'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Consumer<Cities>(
                                              builder:
                                                  (context, value, child) =>
                                                      _buildCities(
                                                          value.cityItems)),
                                          // Text('القسم'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Consumer<Sections>(
                                              builder:
                                                  (context, value, child) =>
                                                      _buildSections(
                                                          value.sectionItems)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //add pdf/image/word
                                          Text(
                                            'اضافة ثبوتية',
                                            textAlign: TextAlign.right,
                                            textDirection: ui.TextDirection.rtl,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _showFilPicker(context);
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              13.0),
                                                      child: _image != null
                                                          ?
                                                          //  Container(
                                                          //     height: 50,
                                                          //     width: 50,
                                                          //     child: Image.file(
                                                          //         imagePicked),
                                                          //   ),
                                                          Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    // Icon(
                                                                    //   CupertinoIcons
                                                                    //       .checkmark_alt_circle,
                                                                    //   color: Colors
                                                                    //       .green,
                                                                    // ),
                                                                    // Text(
                                                                    //     'تمت الاضافة'),
                                                                    Container(
                                                                      height:
                                                                          100,
                                                                      width:
                                                                          100,
                                                                      child: Image
                                                                          .file(
                                                                        _image,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _showFilPicker(
                                                                          context);
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Icon(Icons.add),
                                                    ),
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                              )),
                  ),
                ),
              ),
              if (!isLogin && isUser)
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(MapScreen.routeName, arguments: getLat)
                        .then((value) => setState(() {
                              animateTo(UserProvider.latitude,
                                  UserProvider.longitude);
                            }));
                    // Navigator.of(context)
                    //   .push(MaterialPageRoute(builder: (context) => MapScreen(getLat: getLat,),));
                  },
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      Positioned(
                          top: -9, right: 030, child: Text('اضف عنوانك')),
                      Container(
                        margin: EdgeInsets.all(8),
                        padding: const EdgeInsets.all(13.0),
                        width: double.infinity,
                        height: 200.0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: UserProvider.latitude != null
                                  ? GoogleMap(
                                      // onMapCreated: _onMapCreated,
                                      liteModeEnabled: true,
                                      mapToolbarEnabled: false,
                                      myLocationEnabled: false,
                                      buildingsEnabled: false,
                                      myLocationButtonEnabled: false,
                                      onMapCreated: (controller) {
                                        _completer.complete(controller);
                                      },
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            double.parse(UserProvider.latitude
                                                .toString()),
                                            double.parse(UserProvider.longitude
                                                .toString())),
                                        zoom: 14.0,
                                      ),
                                      markers: markers,
                                    )
                                  : Image.asset(
                                      'assets/images/dribbble_jumpingpin.gif',
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton.filled(
                  child: signing
                      ? CupertinoActivityIndicator()
                      : Text(
                          !isLogin ? 'تسجيل الان' : 'دخول',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                  onPressed: _onSignUp),
              // CupertinoButton(child: Text(isLogin?'تسجيل': 'دخول',style: Theme.of(context).textTheme.bodyText1,), onPressed: (){
              //   setState(() {
              //     isLogin=!isLogin;
              //   });
              // }),
              if (!isLogin)
                CupertinoButton(
                    child: Text(isUser ? ' زبون' : ' مقدم الخدمة',
                        style: Theme.of(context).textTheme.bodyText1),
                    onPressed: () {
                      setState(() {
                        isUser = !isUser;
                      });
                    }),
            ],
          )),
        ),
      ),
    );
  }

  Completer<GoogleMapController> _completer = Completer();
  Future<void> animateTo(double lat, double lng) async {
    final c = await _completer.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  Future<DateTime> getDate() {
    DateTime dateTime = DateTime(2021);
    return showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1930),
      lastDate: DateTime(2021),
      initialDatePickerMode: DatePickerMode.day,
      currentDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  DateTime _currentDate = DateTime.now();
  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      _currentDate = order;
    });
  }

  List<String> _section = [
    'ذكر',
    'أنثى',
  ];
  var _genderString = '';
  Widget dropDwon(BuildContext context, List<String> items, String hint) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 25, right: 15),
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
        child: DropdownButtonFormField<String>(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            elevation: 1,
            focusColor: Colors.orange,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى اختيار الجنس';
              }
              return null;
            },
            onSaved: (newValue) {
              _genderString = newValue;
            },
            dropdownColor: Colors.white,
            hint: Text(hint),
            isExpanded: true,
            items: items.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(
                  dropDownStringItem,
                  textAlign: TextAlign.right,
                  textDirection: ui.TextDirection.rtl,
                ),
              );
            }).toList(),
            // onChanged: (value) => print(value),
            onChanged: (value) {
              setState(() {
                _genderString = value;
              });
            },
            value: _genderString),
      ),
    );
  }

  Widget _buildSections(List<Section> sections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(
        //   lang.translation['username'][Languages.selectedLanguage],
        //   style: kLabelStyle,
        // ),
        // SizedBox(height: 10.0),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 25, right: 15),
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
          // height: 60.0,
          child: DropdownButtonFormField<Section>(
            isDense: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Container(
                padding: EdgeInsets.only(left: 10),
                child: Padding(
                  padding: const EdgeInsets.only(right: .0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: isLoadingCities
                        ? CupertinoActivityIndicator()
                        : Icon(
                            Icons.category,
                            color: Theme.of(context).primaryColor,
                          ),
                  ),
                ),
              ),
            ),
            value: selectedCat,
            // underline: Container(),

            isExpanded: true,
            //elevation: 5,
            style: kHintTextStyle,

            items: sections.map<DropdownMenuItem<Section>>((value) {
              return DropdownMenuItem<Section>(
                value: value,
                child: Center(
                    child: Text(
                  value.title,
                  style: kLabelStyle,
                )),
              );
            }).toList(),
            hint: Text(
              "يرجى اختيار القسم",
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            onChanged: (value) {
              setState(() {
                selectedCat = value;
                categoryTitle = selectedCat.title;
                section_id = selectedCat.id;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCities(List<City> cities) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   lang.translation['username'][Languages.selectedLanguage],
          //   style: kLabelStyle,
          // ),
          // SizedBox(height: 10.0),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 25, right: 15),
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
            // height: 60.0,
            child: DropdownButtonFormField<City>(
              isDense: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: isLoadingCities
                          ? CupertinoActivityIndicator()
                          : Icon(
                              Icons.approval,
                              color: Theme.of(context).primaryColor,
                            ),
                    )),
              ),
              value: selectedCity,
              // underline: Container(),
              isExpanded: true,
              //elevation: 5,
              style: kLabelStyle,
              items: cities.map<DropdownMenuItem<City>>((value) {
                return DropdownMenuItem<City>(
                  value: value,
                  child: Center(
                      child: Text(
                    value.title,
                    style: kLabelStyle,
                  )),
                );
              }).toList(),
              hint: Text(
                "يرجى اختيار المحافظة",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  city_id = selectedCity.id;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  City selectedCity;
  int city_id;

  List<File> files;

  Future pickFile() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      setState(() {
        files = null;
        files = result.paths.map((path) => File(path)).toList();
      });
      Toast.show('تمت الاضافة', context);
    } else {
      // User canceled the picker
    }
  }

  File imagePicked;

  Future pickImage() async {
    try {
      final _image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 100,
        maxWidth: 100,
      );
      if (_image == null) return;
      final imageTemporary = File(_image.path);
      setState(() {
        this._image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('pickImage error $e');
    }
  }

  Future galleryImage() async {
    try {
      final _image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 100,
        maxWidth: 100,
      );
      if (_image == null) return;
      final imageTemporary = File(_image.path);

      setState(() {
        this._image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('galleryImage error $e');
    }
  }

  Future pickImageProfile() async {
    try {
      final imagePicked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 100,
        maxWidth: 100,
      );
      if (imagePicked == null) return;
      final imageTemporary = File(imagePicked.path);
      setState(() {
        this.imagePicked = imageTemporary;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future galleryImageProfile() async {
    try {
      final imagePicked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        // imageQuality: 100,
        // maxHeight: 100,
        // maxWidth: 100,
      );
      if (imagePicked == null) return;
      final imageTemporary = File(imagePicked.path);

      setState(() {
        this.imagePicked = imageTemporary;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _showPicker(context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  pickImageProfile();
                  return Navigator.of(context).pop();
                },
                leading: Icon(
                  CupertinoIcons.camera,
                  color: Colors.black,
                ),
                title: Text(
                  'camera',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              ListTile(
                onTap: () {
                  galleryImageProfile();
                  return Navigator.of(context).pop();
                },
                leading: Icon(
                  CupertinoIcons.photo,
                  color: Colors.black,
                ),
                title: Text(
                  'gallery',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('back'),
          ),
        ],
      ),
    );

    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext bc) {
    //       return SafeArea(
    //         child: Container(
    //           child: new Wrap(
    //             children: <Widget>[
    //               new ListTile(
    //                   leading: new Icon(Icons.photo_library),
    //                   title: new Text('Photo Library'),
    //                   onTap: () {
    //                     galleryImage();
    //                     Navigator.of(context).pop();
    //                   }),
    //               new ListTile(
    //                 leading: new Icon(Icons.photo_camera),
    //                 title: new Text('Camera'),
    //                 onTap: () {
    //                   pickImage();
    //                   Navigator.of(context).pop();
    //                 },
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }

  void _showFilPicker(context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  pickImage();
                  return Navigator.of(context).pop();
                },
                leading: Icon(
                  CupertinoIcons.camera,
                  color: Colors.black,
                ),
                title: Text(
                  'camera',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              ListTile(
                onTap: () {
                  galleryImage();
                  return Navigator.of(context).pop();
                },
                leading: Icon(
                  CupertinoIcons.photo,
                  color: Colors.black,
                ),
                title: Text(
                  'gallery',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              // ListTile(
              //   onTap: () {
              //     pickFile();
              //     return Navigator.of(context).pop();
              //   },
              //   leading: Icon(
              //     CupertinoIcons.folder,
              //     color: Colors.black,
              //   ),
              //   title: Text(
              //     'pdf',
              //     style: Theme.of(context).textTheme.headline1,
              //   ),
              // ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('back'),
          ),
        ],
      ),
    );

    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext bc) {
    //       return SafeArea(
    //         child: Container(
    //           child: new Wrap(
    //             children: <Widget>[
    //               new ListTile(
    //                   leading: new Icon(Icons.photo_library),
    //                   title: new Text('Photo Library'),
    //                   onTap: () {
    //                     galleryImage();
    //                     Navigator.of(context).pop();
    //                   }),
    //               new ListTile(
    //                 leading: new Icon(Icons.photo_camera),
    //                 title: new Text('Camera'),
    //                 onTap: () {
    //                   pickImage();
    //                   Navigator.of(context).pop();
    //                 },
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }
}
