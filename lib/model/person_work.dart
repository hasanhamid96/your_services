import 'dart:io';

import 'package:flutter/cupertino.dart';

class PersonWork{

  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final File imageFile;

  PersonWork({
   @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.imageFile,
  });
}