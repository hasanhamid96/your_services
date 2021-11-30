import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:your_services/model/person_work.dart';
import 'package:your_services/providers/person_works.dart';

class AddPersonWorks extends StatefulWidget {
  static String routeName = "ssss";
  PersonWork personWork;
  bool isEdting;

  AddPersonWorks({this.personWork, this.isEdting: false});

  @override
  _AddPersonWorksState createState() => _AddPersonWorksState();
}

class _AddPersonWorksState extends State<AddPersonWorks> {
  final _key = GlobalKey<FormState>();
  ImagePicker _picker = ImagePicker();
  String title;
  String description;
  File _image;
  bool isAdding = false;

  Future picked(int type) async {
    var _imagePick = await _picker.getImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720);
    if (_imagePick != null)
      setState(() {
        _image = File(_imagePick.path);
      });
  }

  Future<bool> _willPopScopeCall(BuildContext context) async {
    //Navigator.of(context).pushReplacementNamed(DashBoardScreen.routeName);
    return true;
  }

  void _saveAddWork() {
    final isValide = _key.currentState.validate();
    if (isValide && _image != null) {
      //do something
      _key.currentState.save();
      setState(() {
        isAdding = true;
      });
      Provider.of<PersonWorks>(context, listen: false)
          .addWork(
        isEdting: widget.isEdting,
        work_id: _doctorWork.id,
        file: _image,
        title: _doctorWork.title,
        description: _doctorWork.description,
      )
          .then((value) {
        setState(() {
          if(value==true)
            Navigator.of(context).pop();
          isAdding = false;
        });

      });
    } else {

    }
  }

  PersonWork _doctorWork =
      PersonWork(id: 1111111, title: null, description: null, imageUrl: null);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isEdting)
      _doctorWork=widget.personWork;
  }

  @override
  Widget build(BuildContext context) {
    var doctorWork;
    if (widget.personWork != null) {
      doctorWork = widget.personWork;
      _doctorWork = PersonWork(
          id: doctorWork.id,
          title: doctorWork.title,
          description: doctorWork.description,
          imageUrl: doctorWork.imageUrl);
    }

    final mediaQuery = MediaQuery.of(context).size;
    return
        CupertinoPageScaffold(
                      navigationBar: CupertinoNavigationBar(
                        middle: widget.isEdting
                            ? Text('تعديل',
                                style: Theme.of(context).textTheme.headline2)
                            : Text("اضافة اعمال",
                                style: Theme.of(context).textTheme.headline2),
                      ),
                      child: Material(
                        color: Colors.transparent,
                          child: WillPopScope(
                        onWillPop: () => _willPopScopeCall(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _key,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                  ),
                                  Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            // border: Border.all(color: Colors.yellow),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(10, 5),
                                                  blurRadius: 20,
                                                  spreadRadius: -5)
                                            ],
                                            gradient: LinearGradient(colors: [
                                              Colors.redAccent,
                                              Colors.orange
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: EdgeInsets.only(
                                            top: 0,
                                            left: 0.5,
                                            right: 4.5,
                                            bottom: 3.5),
                                        height: mediaQuery.height * 0.303,
                                        width: mediaQuery.width * 0.801,
                                        child: GridTile(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (_image != null)
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.file(
                                                      _image,
                                                      fit: BoxFit.fill,
                                                      height:
                                                          mediaQuery.height *
                                                              0.30,
                                                      width: mediaQuery.width *
                                                          0.80,
                                                    ),
                                                  ),
                                                if (_image == null &&
                                                    _doctorWork.imageUrl !=
                                                        null)
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      _doctorWork.imageUrl,
                                                      fit: BoxFit.fill,
                                                      height:
                                                          mediaQuery.height *
                                                              0.30,
                                                      width: mediaQuery.width *
                                                          0.80,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          header: _image != null
                                              ? Center(
                                                  child: IconButton(
                                                      icon: Icon(
                                                        CupertinoIcons
                                                            .clear_circled,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _image = null;
                                                        });
                                                      }),
                                                )
                                              : Text(''),
                                          footer: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                                color: Colors.black26),
                                            child: GridTileBar(
                                              title: FlatButton(
                                                  // color: Color.fromRGBO(191, 141, 44, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  onPressed: () {
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
                                                                return Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              leading: Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                color: Colors
                                                                    .brown,
                                                              ),
                                                              title: Text(
                                                                'camera',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline1,
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
                                                                return Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              leading: Icon(
                                                                Icons.panorama,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: Text(
                                                                'gallery',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline1,
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
                                                  },
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 30.0,
                                                      vertical: 8.0),
                                                  textColor: Theme.of(context)
                                                      .primaryTextTheme
                                                      .button
                                                      .color,
                                                  child: _doctorWork.imageUrl !=
                                                          null
                                                      ? Text(
                                                          'تغير الصورة',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline3,
                                                        )
                                                      : Text(
                                                          (_image == null)
                                                              ? 'اضافة صورة'
                                                              : 'تغير الصورة',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline2,
                                                        )),
                                            ),
                                          ),
                                        )),
                                  ),
                                  if (_image == null &&
                                      _doctorWork.imageUrl == null)
                                    Text(
                                      'الصورة فارغة*',
                                      style: TextStyle(color: Colors.red),
                                      textAlign: TextAlign.right,
                                    ),
                                  textField(
                                      'العنوان', context, _doctorWork.title),
                                  textField('الوصف', context,
                                      _doctorWork.description,
                                      maxLines: 5),
                                  // Container(
                                  //   margin: EdgeInsets.all(8),
                                  //   width: mediaQuery.width * 0.8,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: new BorderRadius.circular(10),
                                  //     shape: BoxShape.rectangle,
                                  //     color: Colors.lightBlueAccent,
                                  //     boxShadow: [
                                  //       BoxShadow(
                                  //           color: Colors.black26,
                                  //           offset: Offset(10, 5),
                                  //           blurRadius: 20,
                                  //           spreadRadius: -10)
                                  //     ],
                                  //   ),
                                  //   child: RaisedButton(
                                  //     elevation: 0,
                                  //     shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(10)),
                                  //     color: Colors.lightBlueAccent,
                                  //     padding: EdgeInsets.all(16),
                                  //     onPressed: _saveAddWork,
                                  //     child: Text(
                                  //       lang.translation['save'][Languages.selectedLanguage],
                                  //       style: Theme.of(context).appBarTheme.textTheme.headline5,
                                  //     ),
                                  //   ),
                                  // ),
                                  CupertinoButton.filled(
                                    child:isAdding?CupertinoActivityIndicator(): Text(
                                      'حفظ',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    onPressed: _saveAddWork,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                    );
  }

  Widget textField(String lebal, BuildContext context, String initalValue,
      {int maxLines}) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(8),
      width: mediaQuery.width * 0.8,
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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          minLines: maxLines,
          validator: (value) {
            if (value.isEmpty) return '$lebal' + ' ' + 'empty';
            // if (double.tryParse(value) == null){
            //   _priceController.clear();
            //   return 'ادخال خاطيء';}
            if (value == null) return 'يرجى مليء الحقل';
            return null;
          },
          onSaved: (value) {
            if (lebal == 'العنوان')
              _doctorWork = PersonWork(
                  id: _doctorWork.id,
                  title: value,
                  description: _doctorWork.description,
                  imageUrl: _doctorWork.imageUrl);
            else if (lebal == 'الوصف')
              _doctorWork = PersonWork(
                  id: _doctorWork.id,
                  title: _doctorWork.title,
                  description: value,
                  imageUrl: _doctorWork.imageUrl);
          },
          // if (label == 'title')
          //   title = value;
          // else if (label == 'description')
          //   description = value;
          // else if (label == 'price')
          //   price = double.parse(value);
          // else if (label == 'size') size = value;
          maxLines: null,
          maxLength: lebal == 'title' ? 30 : 200,
          style: Theme.of(context).textTheme.headline4,
          initialValue: initalValue,
          // style: Theme.of(context)
          //     .textTheme
          //     .headline1,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            counterText: "",
            hintText: lebal,
            border: InputBorder.none,
            // focusedErrorBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     borderSide: BorderSide(
            //       color: Colors.deepPurple,
            //     )),
            contentPadding: EdgeInsets.all(13),
            // enabledBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     borderSide: BorderSide(color: Colors.blue, width: 1)),
            // focusedBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     borderSide: BorderSide(
            //       color: Colors.deepPurple,
            //     )),
            // errorBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     borderSide: BorderSide(
            //       color: Colors.transparent,
            //     )),
            // icon: Icon(icons),
          ),
        ),
      ),
    );
  }
}
