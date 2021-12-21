import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:your_services/model/person.dart';
import 'package:your_services/providers/person_works.dart';
import 'package:your_services/screens/works/works_details.dart';

import '../screens/maps/DoctorLocationOnMap.dart';

class PersonDetail extends StatefulWidget {
  Person person;

  PersonDetail({Key key, this.person}) : super(key: key);

  static final String path = "lib/src/pages/profile/profile10.dart";

  @override
  _PersonDetailState createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      print(widget.person.id);
    });
    Provider.of<PersonWorks>(context, listen: false)
        .getAllDoctorWorks(
      Id: widget.person.id,
      isFromList: true,
    )
        .then((value) {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'رجوع',
        backgroundColor: Colors.transparent,
        border: Border.all(color: Colors.transparent),
      ),
      resizeToAvoidBottomInset: false,
      child: SingleChildScrollView(
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                height: 350,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Image.network(
                        widget.person.image,
                        errorBuilder: (context, error, stackTrace) =>
                            loadingImage(mediaQuery, 1),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return loadingImage(mediaQuery, 0);
                        },
                        width: mediaQuery.width * 0.35,
                        height: mediaQuery.height * 0.17,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        elevation: 0.5,
                        color: Colors.red,
                        child: Text(
                          widget.person.name,
                          style: TextStyle(
                              fontFamily: 'Cairo-Regular',
                              fontSize: 15,
                              color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      readOnly: true,
                      initialValue: widget.person.name,
                      decoration: InputDecoration(
                        labelText: "الاسم",
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        fontFamily: 'Cairo-Regular',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      readOnly: true,
                      style: Theme.of(context).textTheme.headline1,
                      initialValue: widget.person.address,
                      decoration: InputDecoration(
                        labelText: "العنوان",
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      readOnly: true,
                      initialValue: widget.person.phone,
                      style: Theme.of(context).textTheme.headline1,
                      decoration: InputDecoration(labelText: 'الرقم'),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "الأعمالــ",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const SizedBox(height: 5.0),
                    isLoading
                        ? Container(
                            width: double.infinity,
                            height: 130,
                            color: Colors.grey[200],
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                        : Consumer<PersonWorks>(
                            builder: (context, doctorWorks, child) =>
                                doctorWorks.items.length == 0
                                    ? Center(
                                        child: Text(
                                          'لا يوجد اعمال',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1,
                                        ),
                                      )
                                    : Container(
                                        height: mediaQuery.height * 0.27,
                                        width: double.infinity,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          // gridDelegate:
                                          //     SliverGridDelegateWithFixedCrossAxisCount(
                                          //   crossAxisCount: 3,
                                          //
                                          // ),
                                          itemCount: doctorWorks.items.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          DoctorWorksDetails
                                                              .routeName,
                                                          arguments: doctorWorks
                                                              .items[index]);
                                                },
                                                child: Column(
                                                  children: [
                                                    Image.network(
                                                      '${doctorWorks.items[index].imageUrl}',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          loadingImage(
                                                              mediaQuery, 1),
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return loadingImage(
                                                            mediaQuery, 0);
                                                      },
                                                      width: mediaQuery.width *
                                                          0.35,
                                                      height:
                                                          mediaQuery.height *
                                                              0.17,
                                                    ),
                                                    ChoiceChip(
                                                      label: Text(
                                                          "${doctorWorks.items[index].title}",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Cairo-Regular',
                                                          )),
                                                      onSelected: (val) {},
                                                      selected: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                            // ListView.builder(
                            //         scrollDirection: Axis.horizontal,
                            //         itemCount: doctorWorks.items.length,
                            //         itemBuilder: (context, index) =>

                            //       ),
                            ),
                    // Wrap(
                    //   spacing: 10.0,
                    //   runSpacing: 10.0,
                    //   children: [
                    //     ChoiceChip(
                    //       label: Text("Technology"),
                    //       onSelected: (val) {},
                    //       selected: true,
                    //     ),
                    //     ChoiceChip(
                    //       label: Text("Coding"),
                    //       onSelected: (val) {},
                    //       selected: true,
                    //     ),
                    //     ChoiceChip(
                    //       label: Text("Tutoring"),
                    //       onSelected: (val) {},
                    //       selected: false,
                    //     ),
                    //     ChoiceChip(
                    //       label: Text("Video making"),
                    //       onSelected: (val) {},
                    //       selected: false,
                    //     ),
                    //     ChoiceChip(
                    //       label: Text("Gaming"),
                    //       onSelected: (val) {},
                    //       selected: true,
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 20.0),
                    MaterialButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "أتصال",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cairo-Regular',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(CupertinoIcons.phone)
                        ],
                      ),
                      color: CupertinoColors.systemGreen,
                      onPressed: () async {
                        await launch("tel://${widget.person.phone}");
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    if (widget.person.lat != null && widget.person.long != null)
                      MaterialButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "اظهار موقع على الخريطة",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo-Regular',
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(CupertinoIcons.location)
                          ],
                        ),
                        color: CupertinoColors.systemTeal,
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DoctorMapLoc(
                                double.parse(widget.person.lat),
                                double.parse(widget.person.long),
                                widget.person.name,
                                widget.person.phone),
                          ));
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(7.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container loadingImage(Size mediaQuery, int typeOfLoading) {
    return Container(
        color: Colors.white,
        width: mediaQuery.width * 0.25,
        height: mediaQuery.height * 0.17,
        child: typeOfLoading == 0
            ? Center(
                child: CircularProgressIndicator.adaptive(strokeWidth: 1.1))
            : Image.asset('assets/images/sssssss.png'));
  }
}
