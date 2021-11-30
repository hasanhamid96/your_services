import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:your_services/model/section.dart';
import 'package:your_services/providers/user.dart';

class Sections with ChangeNotifier{

  List<Section> _sectiontems=[
    // Section(
    //     id: 1,
    //     title: 'بغداد',
    //     image: 'https://www.umultirank.org/export/sites/default/.galleries/generic-images/Others/Winter-Calendar/baghdad-1174177_1280.jpg_1729757343.jpg'
    // ),

  ];

  List<Section>get sectionItems{
    return[..._sectiontems];
  }
bool  isEverythingOkCities = false;
  Future< List<Section>> fetchSections() async {

    try{
      final response = await http.get(Uri.parse( '${UserProvider.hostName}/api/sections'),
          headers: {
            'Accept' :'application/json',

          });
      var data4 = json.decode(response.body);
      final List<Section> loadedCities = [];
      if (data4['status'] == false) {
        return null;
      }
      //print(data4);
      data4['section'].forEach((city) {
        loadedCities.add(
          Section(
            id: city['id'],
            title: city['description'],
            image: city['image']
          ),
        );
      });

      if (data4['status'] == true) {
        isEverythingOkCities = true;
        notifyListeners();
      }
      _sectiontems = loadedCities;
   return _sectiontems;
    }catch(e){
      print('$e fetch section error') ;
    }
  }

}