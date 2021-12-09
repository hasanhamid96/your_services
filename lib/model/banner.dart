import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:your_services/providers/user.dart';

class Baner {
  int id;
  int doctor_id;
  String image;

  Baner({
    this.id,
    this.image,
    this.doctor_id,
  });
}

class Bannsers extends ChangeNotifier {
  Future<List<Baner>> getImagesBanner() async {
    var url = '${UserProvider.hostName}/api/banners';
    List<Baner> banner = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': '${UserProvider.token}',
          'Accept': 'application/json',
        },
      );
      var extractCarData = json.decode(response.body);
      print(extractCarData);
      extractCarData['banners'].forEach(
        (item) {
          banner.add(
            Baner(
              id: item['id'],
              image: item['photo'].toString(),
              doctor_id: item['user_id'],
            ),
          );
        },
      );

      notifyListeners();
      return banner;
    } on SocketException {
      throw SocketException;
    } catch (error) {
      print('$error  nnnnnnnnnnnnnnnnnnnnnnnnnn banners');
    }
  }
}
