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
  CraftPersonItem({Key key, this.person}) : super(key: key);

  @override
  _CraftPersonItemState createState() => _CraftPersonItemState();
}

class _CraftPersonItemState extends State<CraftPersonItem> {
  bool isIpad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }

  void check() async {
    var sss = await isIpadd();
    setState(() {
      isIpad = sss;
    });
  }

  Future<bool> isIpadd() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info;
    AndroidDeviceInfo infoAndroid;
    if (Platform.isAndroid) infoAndroid = await deviceInfo.androidInfo;
    if (Platform.isIOS) info = await deviceInfo.iosInfo;
    if (Platform.isIOS) if (info.name.toLowerCase().contains("ipad")) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: InkWell(
          radius: 30,
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            Provider.of<PersonWorks>(context, listen: false).clearItems();
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => PersonDetail(person: widget.person)));
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: GridTile(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.person.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      loadingImage(mediaQuery, 1),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return loadingImage(mediaQuery, 0);
                  },
                  width: mediaQuery.width * 0.35,
                  height: mediaQuery.height * 0.17,
                ),
              ),
              footer: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                child: GridTileBar(
                  backgroundColor: Colors.blue[400].withOpacity(0.4),
                  title: Center(
                    child: Text(
                      '${widget.person.name}',
                      style: Theme.of(context).textTheme.headline3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Container loadingImage(Size mediaQuery, int typeOfLoading) {
    return Container(
        color: Colors.white,
        width: mediaQuery.width * 0.30,
        height: mediaQuery.height * 0.30,
        child: typeOfLoading == 0
            ? Center(
                child: CircularProgressIndicator.adaptive(strokeWidth: 1.1))
            : Image.asset('assets/images/sssssss.png'));
  }
}
