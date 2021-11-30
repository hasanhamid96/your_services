import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:your_services/model/city.dart';
import 'package:http/http.dart'as http;
import 'package:your_services/providers/user.dart';
class Cities with ChangeNotifier{

  List<City> _cityItems=[
    City(
      id: 1,
      title: 'بغداد',
      image: 'https://www.umultirank.org/export/sites/default/.galleries/generic-images/Others/Winter-Calendar/baghdad-1174177_1280.jpg_1729757343.jpg'
    ),
    City(
        id: 1,
        title: 'بغداد',
        image: 'https://i.pinimg.com/originals/ba/77/91/ba77911a1e2071e3c9ec3333e985d6fa.jpg'
    ),
    City(
        id: 1,
        title: 'بغداد',
        image: 'https://s.abcnews.com/images/International/GTY_baghdad_mm_160216_16x9_1600.jpg'
    )
  ];
  bool isEverythingOkCities = false;
  List<City>get cityItems{
    return[..._cityItems];
  }
  Future<List<City>> fetchDataCity() async {

    try{
      final response = await http.get(Uri.parse( '${UserProvider.hostName}/api/cities'),
          headers: {
            'Accept' :'application/json',

          });
      var data4 = json.decode(response.body);
      final List<City> loadedCities = [];
      if (data4['status'] == false) {
        return null;
      }
      //print(data4);
      data4['cities'].forEach((city) {
        loadedCities.add(
          City(
            id: city['id'],
            title: city['name_ar'],
            image: city['photo']
          ),
        );
      });

      if (data4['status'] == true) {
        isEverythingOkCities = true;
        notifyListeners();
      }
      _cityItems = loadedCities;
    return _cityItems;
    }catch(e){
      print('$e fetchDataCity') ;
    }
  }

}