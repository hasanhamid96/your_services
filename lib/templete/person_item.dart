import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_services/model/person.dart';
import 'package:your_services/providers/person_works.dart';
import 'package:your_services/widgets/personDetail.dart';

class CraftPersonItem extends StatefulWidget {
  Person person;
  CraftPersonItem({
    Key key,
    this.person
  }) : super(key: key);

  @override
  _CraftPersonItemState createState() => _CraftPersonItemState();
}

class _CraftPersonItemState extends State<CraftPersonItem> {
  bool isIpad=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    IosDeviceInfo info;
    AndroidDeviceInfo infoAndroid;
    if(Platform.isAndroid)
      infoAndroid= await deviceInfo.androidInfo;
     if(Platform.isIOS)
       info = await deviceInfo.iosInfo;
    if(Platform.isIOS)
    if (info.name.toLowerCase().contains("ipad")) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: InkWell(
          radius: 30,
          borderRadius:BorderRadius.circular(4) ,
          onTap: (){
            Provider.of<PersonWorks>(context,listen: false).clearItems();
            Navigator.of(context)
                .push(CupertinoPageRoute(builder: (context) => PersonDetail(person:widget.person)));
          },
          child: Container(
            height:MediaQuery.of(context).size.height*0.25,
            child: GridTile(
              child: ClipRRect(
                  borderRadius:BorderRadius.circular(10) ,
                  child: CachedNetworkImage(
                      imageUrl: widget.person.image,
                      fit: BoxFit.cover,
                      height:MediaQuery.of(context).size.height*0.25,
                      width: double.infinity,
                      placeholder: (context, url) => Image.asset('assets/images/sssssss.png'),
                  )),
              footer: ClipRRect(
                borderRadius:BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)) ,
                child: GridTileBar(
                  backgroundColor: Colors.blue[400].withOpacity(0.4),
                  title:   Center(
                    child: Text('${widget.person.name}',
                      style:Theme.of(context).textTheme.headline3
                      ,overflow: TextOverflow.ellipsis,),
                  ),

                ),
              ),
            ),
          ),
        ));
  }
}