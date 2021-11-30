import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:your_services/providers/user.dart';
class Social {

   String id='2';
   String faceBook='2';
   String instagram='2';
   String massenger='2';
   String whatsApp1='2';
   String whatsApp2='2';
   String webSite='2';
   String youtube='2';
   String twitter='2';
   String share='2';

  Social({
    this.id,
    this.faceBook,
    this.instagram,
    this.massenger,
    this.whatsApp1 ,
    this.whatsApp2,
    this.webSite ,
    this.youtube ,
    this.twitter ,
    this.share ,
  });



}
class GetSocial extends ChangeNotifier{

static Social social;
  Future<Social>getSocial()async{
    final url=Uri.parse("${UserProvider.hostName}/api/social");
    List<String> links=[];
    // Social social;
    try {
      final response = await http.get(url,
          headers: {
            // 'Content-type': 'application/json',
            'Authorization': '${UserProvider.token}',
            'Accept': 'application/json',
          }
      );

      var extractCarData = json.decode(response.body);
      // extractCarData= extractCarData[0];
    extractCarData['Social'].forEach((item){
      links.add(item['link'].toString());
    });

      social=Social(
        share: links[0],
        instagram:  links[1],
        faceBook:  links[2],
        youtube:  links[3],
        webSite: links[4],
        whatsApp1:  links[5],
        whatsApp2:  links[6],
        // massenger:  links[7],


      );
      return social;
    }

    catch(e){
      print(e);
      return social;
    }
  }

}

