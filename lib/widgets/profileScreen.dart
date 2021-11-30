import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:your_services/model/city.dart';
import 'package:your_services/model/person.dart';
import 'package:your_services/model/section.dart';
import 'package:your_services/providers/cities.dart';
import 'package:your_services/providers/sections.dart';
import 'package:your_services/providers/user.dart';
import 'package:your_services/screens/auth/startScreen.dart';
import 'package:your_services/screens/maps/map-screen.dart';
import '../screens/auth/LogScreen.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();
  bool isEditing = true;
  File _image;
  ImagePicker _picker = ImagePicker();
  var _key=GlobalKey<FormState>();
  bool isReadOnly = true;
  var name;
  var phone;
  var address;
  DateTime _personDate;
  Person _person;
  bool isLoading = false;
  bool once = true;

  bool isLoadingCities=false;
  bool isLoadingSections=false;
List<City> listCity=[];
List<Section> listSec=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingCities=true;
    isLoadingSections=true;
    Provider.of<Cities>(context,listen: false).fetchDataCity().then((value){
      if(mounted) setState(() {
        isLoadingCities=false;
        listCity=value;
      });
    });
    Provider.of<Sections>(context,listen: false).fetchSections().then((value){
      if(mounted)setState(() {
        isLoadingSections=false;
        listSec=value;

      });
    });
   print(UserProvider.type);
    setState(() {
      isLoading = true;
    });
    Provider.of<UserProvider>(context, listen: false).getProfile().then((
        value) {
      if(mounted)
      setState(() {
        _person = value;
        if(UserProvider.type=='provider'){
          UserProvider.latitude=double.parse(_person.lat);
          UserProvider.longitude=double.parse(_person.long);
          if(!isLoadingCities)
          cityTitle= listCity.firstWhere((element) => element.id.toString()==_person.city_id).title;
          if(!isLoadingSections)
          secTitle= listSec.firstWhere((element) => element.id.toString()==_person.section_id).title;
        }
        if(UserProvider.type=='user')
        _personDate=DateTime.parse(_person.birthDay==null?DateTime.now():_person.birthDay);

        Future.delayed(Duration(seconds: 1)).then((value) => setState(()=>
        {isLoading = false,
           once2=true
        })  );
      });
    });
  }
  var cityTitle;
  var secTitle;
  var   kHintTextStyle;
  var kLabelStyle;
  Set<Marker>markers= {};
  bool once2=false;
  @override
  Widget build(BuildContext context) {
       kHintTextStyle =  Theme.of(context).textTheme.headline4;
       kLabelStyle = Theme.of(context).textTheme.headline4;
       if(once2&&  UserProvider.type!='user')
    markers.add(Marker(
        position: LatLng(UserProvider.latitude,UserProvider.longitude),
        markerId: MarkerId('UserProvider.latitude'),
        icon: BitmapDescriptor.defaultMarker
    ));
    final mediaQuery = MediaQuery
        .of(context)
        .size;
    return CupertinoPageScaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        trailing: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      "تسجيل خروج",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    content: Text('هل انت متأكد؟',     style: Theme.of(context).textTheme.headline1,),
                    actions: [
                      CupertinoButton(
                        // color: Colors.red,
                        child: Text("لا",style: Theme.of(context).textTheme.headline1),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoButton(
                          child:
                          Text("نعم", style: TextStyle(color: Colors.red,fontFamily: 'Cairo-Regular',)),
                          onPressed: () {
                            Provider.of<UserProvider>(context, listen: false)
                                .signOut();
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil(StartScreen.routeName, (Route<dynamic> route) => false);
                          }),
                    ],
                  );
                },
              );
            },
            child: Icon(
              FlutterIcons.logout_ant,
              size: 24,
              color:  Colors.black

            ),
          ),
        ),
        leading:Material(
        color: Colors.transparent,
          child: InkWell(
            onTap:  ()=>Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.black,)
          ),
        ),
        border: Border.all(color: Colors.transparent),
        middle: Text('ملفي', style: Theme
            .of(context)
            .textTheme
            .headline1),
        backgroundColor: Colors.transparent,
      ),
      // backgroundColor: Colors.purpleAccent,
      child: isLoading ? Center(child: CupertinoActivityIndicator()) : Scaffold(
        body: Stack(
          key: _stackKey,
          overflow: Overflow.visible,
          // mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              foregroundPainter: CurvePainter(true),
              child: Container(
                width: double.infinity,
                height: 100,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: mediaQuery.height * 0.12),
              width: mediaQuery.width*1,
              height: mediaQuery.height*1,
              child: Form(
                key: _key,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_image != null) imagePicker(mediaQuery, context),
                      if (_image == null&&UserProvider.type=='provider')
                      Stack(
                        overflow: Overflow.visible,
                        children: [
                          Center(
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        200)),
                                child:
                                _person.image == null
                                    ? Icon(
                                  CupertinoIcons.person_crop_circle,
                                  size: 70,
                                )
                                    :
                                CircleAvatar(
                                  backgroundImage:
                                  _image!=null? FileImage(_image) : NetworkImage('${_person.image}'),
                                  radius: 70,
                                  onBackgroundImageError:
                                      (exception, stackTrace) =>
                                      Icon(Icons.broken_image),
                                ),
                              )),
                          if(_person.image != null)
                            Positioned(
                              top: -10,
                              left: 110,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle
                                  ),
                                  child: IconButton(
                                      icon: Icon(
                                        CupertinoIcons.settings,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showCameraAndLibrary(context);
                                        });
                                      }),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if(_person.type=='user')
                        Center(child: Icon(Icons.person_pin_outlined,size: 60,color: Colors.black38,)),
                      SizedBox(
                        height: 20,
                      ),
                      textsProfile(0, 'name', '${_person.name}', context),
                      textsProfile(
                          1, 'phone number', '${_person.phone}', context),
                      if(UserProvider.type=='provider')
                      textsProfile(
                          2, 'address', '${_person.address}', context),
                      if(_person.type=='user')
                      textsProfile(
                          3, 'gender', '${_person.gender}', context),

                      if(   _person.type!='user')
                      Column(
                        children: [
                          // Text('المحافظة'),
                           SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Consumer<Cities>(
                                  builder: (context, value, child) =>
                                      _buildCities(value.cityItems)),
                            ),
                          // Text('القسم'),
                           SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Consumer<Sections>(
                                  builder: (context, value, child) =>
                                      _buildSections(value.sectionItems)),
                            ),
                          if(_person.type=='user')
                            InkWell(
                              // onTap:isReadOnly?null: callDatePicker,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.only(left: 25, right: 15,top: 15,bottom: 15),
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.circular(10),
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  boxShadow: [  BoxShadow(
                                      color: Colors.white54,
                                      offset: Offset(10, 5),
                                      blurRadius: 20,
                                      spreadRadius: -10)  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('اختار يوم ميلادك'),
                                    Text('${DateFormat('yyyy-MM-dd').format(_personDate)}'),
                                  ],
                                ),),
                            ),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed(MapScreen.routeName,).then((value) => setState(() {
                                animateTo(UserProvider.latitude, UserProvider.longitude);
                              }));
                              // Navigator.of(context)
                              //   .push(MaterialPageRoute(builder: (context) => MapScreen(getLat: getLat,),));
                            },
                            child: Stack(
                              overflow: Overflow.visible,
                              children: [
                                if(UserProvider.latitude!=null)
                                  if(!isReadOnly )
                                    Positioned(
                                        top: -7,
                                        right: 010,
                                        child: Text('تعديل')),
                                if(   _person.type!='user')
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
                                          child:UserProvider.latitude!=null?
                                          GoogleMap(
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
                                                  double.parse(UserProvider.latitude.toString()),
                                                  double.parse(UserProvider.longitude.toString())),
                                              zoom: 14.0,
                                            ),
                                            // markers: markers,
                                          ):
                                          Image.asset('assets/images/dribbble_jumpingpin.gif',fit: BoxFit.cover,)
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),



                      // 'تم غلق تعديل' : 'تم فتح تعديل',
                      Container(
                        width: double.infinity,
                        child: FlatButton(
                          splashColor: Colors.black38,
                          highlightColor: Colors.red[100],
                          padding: EdgeInsets.all(18),
                          onPressed: () {
                            setState(() {
                              isReadOnly = !isReadOnly;
                              Toast.show(
                                  isReadOnly ? 'تم غلق تعديل' : 'تم فتح تعديل',
                                  context, gravity: 12);
                            });
                          },
                          child: Text(
                            !isReadOnly
                                ? 'ألغاء تفعيل تعديل'
                                : 'تعديل المعلومات',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Cairo-Regular',
                                color: Colors.red[400]),
                          ),
                        ),
                      ),

                      if(!isReadOnly)
                        Container(
                          margin: EdgeInsets.all(20),
                          width: double.infinity,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)
                            ),
                            color: Color.fromRGBO(
                                24, 15, 40, 0.6196078431372549),
                            splashColor: Colors.black38,
                            highlightColor: Colors.yellowAccent[100],
                            padding: EdgeInsets.all(18),
                            onPressed: () {
                              _key.currentState.save();
                              Provider.of<UserProvider>(context,listen: false).editProfile(
                                  section_id:_person.section_id,
                                  city_id:_person.city_id,
                                  id: _person.id.toString(),
                                  name: _person.name,
                                  phone:_person.phone,
                                  file: _image,
                                  address:_person.address,
                                  birthDay: _personDate.toString(),
                                  gender: _person.gender,
                              ).then((value){
                        if(value==true)
                          Toast.show('تم تعديل', context);
                        Navigator.of(context).pop();
                              });
                            },
                            child: Text(
                              'حفظ التغيرات',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Cairo-Regular',
                                  color: Colors.white),
                            ),
                          ),
                        ),
                    ],

                  ),
                ),
              ),
            ),
          ],
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
    DateTime dateTime=
    DateTime(2010);
    return showDatePicker(
      context: context,
      initialDate:dateTime,
      firstDate: DateTime(1930),
      lastDate: DateTime(2010),
      initialDatePickerMode: DatePickerMode.day,
      currentDate:DateTime.now() ,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  DateTime _currentDate=DateTime.now();
  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      _currentDate = order;
      setState(() {
        _person = Person(
            id: _person.id,
            name: _person.name,
            city_id:_person.city_id ,
            section_id:_person.section_id ,
            image: _person.image,
            phone: _person. phone,
            address: _person.address,
            gender:_person. gender,
            birthDay: _currentDate.toString(),
            lat: _person.lat,
            long: _person.long,
            type: _person.type,
            approval: _person.approval,
        );
        _personDate=_currentDate;
      });
    });
  }

  Section selectedCat;
  String categoryTitle;
  int section_id;
  Widget _buildSections(List<Section> sections) {
    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 15, right: 05),
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          // height: 60.0,
          child: DropdownButtonFormField<Section>(
            isDense: false,
            decoration: InputDecoration(
              helperText: secTitle,
              border: InputBorder.none,
              icon: Container(
                padding: EdgeInsets.only(left: 10),
                child:Padding(
                    padding: const EdgeInsets.only(right:.0),
                    child:Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: isLoadingCities?CupertinoActivityIndicator():Icon(
                        Icons.category,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                ),
              ),
            ),
            value: selectedCat,
            isExpanded: true,
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
            onChanged:isReadOnly?null: (value) {
              setState(() {
                selectedCat = value;
                categoryTitle = selectedCat.title;
                section_id = selectedCat.id;
                _person = Person(
                  id: _person.id,
                  name: _person.name,
                  city_id:_person.city_id ,
                  section_id: section_id.toString() ,
                  image: _person.image,
                  phone: _person. phone,
                  address: _person.address,
                  gender:_person. gender,
                  birthDay: _currentDate.toString(),
                  lat: _person.lat,
                  long: _person.long,
                  type: _person.type,
                  approval: _person.approval,
                );
              });
            },
          ),
        ),
      ],
    );
  }
  Widget _buildCities(List<City> cities) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 15, right: 05),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(10),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: DropdownButtonFormField<City>(
        decoration: InputDecoration(
          enabled: true,
          isDense: false,
          border: InputBorder.none,
          helperText: cityTitle,
          icon: Container(
              padding: EdgeInsets.only(left: 10),
              child:Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: isLoadingCities?CupertinoActivityIndicator():Icon(
                  Icons.approval,
                  color: Theme.of(context).primaryColor,
                ),
              )),
        ),
        value: selectedCity,
        isExpanded: true,
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
        onChanged:isReadOnly?null: (value) {
          setState(() {
            selectedCity = value;
            city_id = selectedCity.id;
            print(city_id);
            _person = Person(
              id: _person.id,
              name: _person.name,
              city_id:city_id.toString(),
              section_id: _person.section_id.toString() ,
              image: _person.image,
              phone: _person. phone,
              address: _person.address,
              gender:_person. gender,
              birthDay: _currentDate.toString(),
              lat: _person.lat,
              long: _person.long,
              type: _person.type,
              approval: _person.approval,
            );
          });
        },
      ),
    );
  }
  City selectedCity;
  int city_id;

  Future picked(int type) async {
    var _imagePick = await ImagePicker.platform.pickImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720);
    if (_imagePick != null)
      setState(() {
        _image = File(_imagePick.path);
      });
  }

  void showCameraAndLibrary(BuildContext context) {
    showModalBottomSheet(
      elevation: 21,
      context: context,
      builder: (context) =>
          Container(
            child: Wrap(
              children: [
                ListTile(
                  onTap: () {
                    picked(1);
                    return Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.brown,
                  ),
                  title: Text(
                    'camera',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline2,
                    // style: Theme.of(
                    //     context)
                    //     .textTheme
                    //     .headline2,
                  ),
                ),
                Divider(
                  height: 0,
                ),
                ListTile(
                  onTap: () {
                    picked(0);
                    return Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.panorama,
                    color: Colors.green,
                  ),
                  title: Text(
                    'gallery',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline2,
                    // style: Theme.of(
                    //     context)
                    //     .textTheme
                    //     .headline2,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget imagePicker(Size mediaQuery, BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Center(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200)),
            elevation: 10,
            child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                // width: mediaQuery.width * 0.34,
                // height: mediaQuery.height * 0.14,
                child: GridTile(
                  child: _image != null
                      ? CircleAvatar(
                    // radius: 60,
                    maxRadius: 70,
                    backgroundImage: FileImage(_image),
                  )
                      : Container(),
                )),
          ),
        ),
        if (_image != null)
          Positioned(
            top: -10,
            left: 110,
            child: Center(
              child: IconButton(
                  icon: Icon(
                    CupertinoIcons.minus_circle_fill,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                  }),
            ),
          ),
      ],
    );
  }

  Padding textsProfile(int index, label, value, BuildContext context,) {
    return Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18),
        child: Column(
          children: [
            Container(
              child: TextFormField(
                style: Theme
                    .of(context)
                    .textTheme
                    .headline1,
                onSaved: (newValue) {
                     _person = Person(
                      id: _person.id,
                      name:index == 0?newValue: _person.name,
                      city_id:_person.city_id ,
                      section_id:_person.section_id ,
                      image: _person.image,
                      phone:index == 1?newValue: _person. phone,
                      address:index == 2?newValue: _person.address,
                      gender:index == 3?newValue: _person. gender,
                      birthDay: _person.birthDay,
                      lat: _person.lat,
                      long: _person.long,
                      type: _person.type,
                      approval: _person.approval
                     );
                },
                keyboardType: index==1?TextInputType.phone:TextInputType.text,
                initialValue:index==4?_personDate.toString(): value,
                decoration: InputDecoration(
                    labelText: label
                ),
                readOnly:index==3?true: isReadOnly,
              ),
            ),
            SizedBox(height: 10,)
          ],
        ));
  }
}

  class CurvePainter extends CustomPainter {
  bool outterCurve;

  CurvePainter(this.outterCurve);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint = Paint()
      ..color = Color.fromRGBO(79, 173, 236, 1.0);
    paint.style = PaintingStyle.fill;
    // paint
    //   ..shader= ui.Gradient.linear(
    //   Offset(0,0),
    //   Offset(0,0),
    //   [
    //     Colors.blue,
    //     Colors.red,
    //   ],
    // );
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width * 0.5,
        outterCurve ? size.height + 150 : size.height - 60,
        size.width,
        size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
