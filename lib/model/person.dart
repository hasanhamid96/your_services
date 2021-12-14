import 'package:flutter/cupertino.dart';

class Person {
  int id;
  String name;
  String image;
  String phone;
  String gender;
  String birthDay;
  String city_id;
  String section_id;
  String address;
  int approval;
  String lat;
  String long;
  String type;
  Person({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.phone,
    @required this.gender,
    @required this.birthDay,
    @required this.city_id,
    @required this.section_id,
    @required this.address,
    @required this.approval,
    @required this.lat,
    @required this.long,
    @required this.type,
  });
}
