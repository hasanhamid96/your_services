// import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:your_services/model/city.dart';
import 'package:your_services/providers/sections.dart';
import 'package:your_services/screens/bottomScreens/setionsScreen.dart';

class CityItem extends StatefulWidget {
  CityItem({
    this.city,
    Key key,
  }) : super(key: key);
  City city;

  @override
  _CityItemState createState() => _CityItemState();
}

class _CityItemState extends State<CityItem> {
bool  isLoadingSections=false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8,bottom: 8),
      decoration: BoxDecoration(
        // color: Colors.blueGrey,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
          onTap: () {
            setState(() {
              isLoadingSections=true;
            });
        Provider.of<Sections>(context,listen: false).fetchSections().then((value){
        setState(() {
          isLoadingSections=false;
          Navigator.of(context)
              .push(CupertinoPageRoute(builder: (context) => SetionsScreen(city_id: widget.city.id,)));
             });
        });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // padding:  EdgeInsets.only(right:8.0,
                      //     ),
                      width: mediaQuery.width * 0.6,
                      height: 100,
                      // margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            elevation: 2,
                            color: CupertinoColors.systemTeal.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    bottomLeft: Radius.circular(40))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${widget.city.title}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Cairo-Regular",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ),
                    isLoadingSections?
                    Container(
                        width: mediaQuery.width * 0.52,
                        height: 3,
                        child: LinearProgressIndicator(backgroundColor: Colors.black26,)):
                    Container(
                      height: 3,
                    )
                  ],
                ),
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(122),
                        topRight: Radius.circular(122),
                        bottomLeft: Radius.circular(122),
                        topLeft: Radius.circular(122))),
                child: CircleAvatar(
                  backgroundImage: NetworkImage('${widget.city.image}',),
                  radius: 70,
                  onBackgroundImageError: (exception, stackTrace) =>
                      Icon(Icons.broken_image),
                ),
              ),
            ],
          )
          // ),
          ),
    );
  }
}
