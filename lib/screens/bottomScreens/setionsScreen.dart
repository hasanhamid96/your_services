import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_services/model/section.dart';
import 'package:your_services/providers/sections.dart';
import 'package:your_services/templete/section_item.dart';
import 'package:your_services/widgets/personList.dart';

class SetionsScreen extends StatefulWidget {
int city_id;

SetionsScreen({this.city_id});

  @override
  _SetionsScreenState createState() => _SetionsScreenState();
}

class _SetionsScreenState extends State<SetionsScreen> {
bool isIpad=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Platform.isIOS)
    check();
  }
  void check()async{
    var sss=await isIpadd();
    setState(() {
      isIpad=sss;
    });
  }
  Future<bool> isIpadd() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.name.toLowerCase().contains("ipad")) {
      return true;
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          previousPageTitle: 'المحافظات',
          middle: Text('الأقسام',style: Theme.of(context).textTheme.headline1,),
        ),
        child: Consumer<Sections>(
          builder: (context, crafts, child) =>
           GridView.builder(
             physics: BouncingScrollPhysics(),
             itemCount: crafts.sectionItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10
            ),
            itemBuilder: (context, index) => SectionItem(city_id: widget.city_id,section: crafts.sectionItems[index],),
          ),
        ));
  }
}


