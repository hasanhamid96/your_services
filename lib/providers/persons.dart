import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:your_services/model/section.dart';
import 'package:your_services/model/person.dart';
import 'package:http/http.dart' as http;
import 'package:your_services/providers/user.dart';

class Persons with ChangeNotifier {
  List<Person> _personItems = [];

  List<Person> get personItems {
    return [..._personItems];
  }

  bool isEverythingOkPerson = true;

  Future<void> fetchPersonList(int section_id, int city_id) async {
    try {
      final response = await http.get(
          Uri.parse(
              '${UserProvider.hostName}/api/users?section_id=$section_id&city_id=$city_id'),
          headers: {
            'Accept': 'application/json',
            'Authorization': '${UserProvider.token}'
          });
      var data4 = json.decode(response.body);
      final List<Person> loadedPerson = [];
      if (data4['status'] == false) {
        return null;
      }
      // print(data4);
      data4['users'].forEach((users) {
        loadedPerson.add(
          Person(
            id: users['id'],
            name: users['name'],
            phone: users['phone'],
            image: users['photo'],
            lat: users['lat'],
            long: users['long'],
            address: users['address'],
          ),
        );
      });

      if (data4['status'] == true) {
        isEverythingOkPerson = true;
        notifyListeners();
      }
      _personItems = loadedPerson;
    } catch (e) {
      print('$e fetchDataCity');
    }
  }

  List<Person> loadedPerson = [];
  void clearSearch() {
    loadedPerson = [];
    loadedPerson.clear();
    notifyListeners();
  }

  void clearFilter() {
    _loadedSections = [];
    _loadedSections.clear();
    notifyListeners();
  }

  List<Section> _loadedSections = [];
  List<Section> loadedSec = [];
  List<Section> get loadedSections {
    return [..._loadedSections];
  }

  var nextUrl;
  var prevUrl = 'dd';
  var totalCount = 0;
  var url;
  void clearAppointItems() {
    _loadedSections.clear();
    loadedPerson.clear();
    _loadedSections = [];
    nextUrl = null;
    prevUrl = 'd';
    url = 'o';
    // notifyListeners();
  }

  bool get isNoMore {
    if (_loadedSections == null ||
        _loadedSections.isEmpty ||
        _loadedSections == []) return true;
    // else if(int.parse(_appointemntsItems[0].totalCount)==_appointemntsItems.length)
    if (totalCount == _loadedSections.length)
      return true;
    else
      return false;
  }

  bool get isEmpty {
    if (_loadedSections == null ||
        _loadedSections.isEmpty ||
        _loadedSections == [])
      return true;
    else
      return false;
  }

  Future<List<Person>> searchPersonList({
    String search,
  }) async {

    if (prevUrl != nextUrl) {
      if (nextUrl == null) {
        url = '${UserProvider.hostName}/api/search?lang=ar&search=$search';
      } else if (nextUrl != null) {
        url = '$nextUrl';
        prevUrl = url;
      }
      print('start searching...');

      try {
        final response = await http.get(Uri.parse(url), headers: {
          'Accept': 'application/json',
          'Authorization': '${UserProvider.token}'
        });
        var data4 = json.decode(response.body);


        if (data4['status'] == false) {
          return null;
        }
        final List<Section> loadedCities = [];


        data4['Users']['data'].forEach((users) {
          loadedPerson.add(
            Person(
              id: users['id'],
              name: users['name'],
              phone: users['phone'],
              image: users['photo'],
              lat: users['lat'],
              long: users['long'],
              address: users['address'],
            ),
          );
        });
        totalCount = int.parse(data4['Users']['total'].toString());
        nextUrl = data4['Users']['next_page_url'];
        _personItems = loadedPerson;
        notifyListeners();

        return _personItems;
      } catch (e) {
        print('$e fetchDataCity');
      }
    }
  }

  Future<bool> filterPersonList({
    int section_id,
    int city_id,
  }) async {
    {
      if (section_id != null)
        url =
            '${UserProvider.hostName}/api/filters?city_id=$city_id&section_id=$section_id';
      if (section_id == null)
        url = '${UserProvider.hostName}/api/filters?city_id=$city_id';
    }
    _loadedSections = [];
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        'Authorization': '${UserProvider.token}'
      });
      var data4 = json.decode(response.body);


      if (data4['status'] == false) {
        return null;
      }
      bool isSections = false;
      final List<Section> loadedCities = [];
          if (city_id != null && section_id == null) {
        isSections = true;
        data4['Section'].forEach((city) {
          loadedCities.add(
            Section(
                id: city['id'],
                title: city['description'],
                image: city['image']),
          );
        });
        _loadedSections = loadedCities;
        notifyListeners();
      } else if (section_id != null && city_id != null) {
        data4['Users'].forEach((users) {
          loadedPerson.add(
            Person(
              id: users['id'],
              name: users['name'],
              phone: users['phone'],
              image: users['photo'],
              lat: users['lat'],
              long: users['long'],
              address: users['address'],
            ),
          );
        });
        isSections = false;
        _personItems = loadedPerson;
        notifyListeners();
      }
      if (data4['status'] == true) {
        isEverythingOkPerson = true;
        notifyListeners();
      }
      return isSections;
    } catch (e) {
      print('$e fetchDataCity');
    }
  }
}
