import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_services/model/person.dart';
import 'package:your_services/model/subscrption.dart';
import 'package:your_services/screens/auth/subscription.dart';

class UserProvider with ChangeNotifier {
  static String appName = 'basmazon';
  static bool isLogin = false;
  static bool isLogged = false;
  static String userName;
  static String hostName = 'https://urservices.creativeapps.me';
  static String userPhone;
  static String userPhoto;
  static double latitude;
  static double longitude;
  static String birthDay;
  static String gender;
  static String Image;
  static String type;
   String _loginType;

  String get loginType => _loginType;
  static Uint8List imageMemory;
  static int userId;
  static String token;
  static String address;
  static String approval = '0';

  double get latitudes {
    return latitude;
  }

  double get longitudes {
    return longitude;
  }

  Future<String> registerUser({
    String name,
    String password,
    String phone,
    String genderr,
    String birthday,
  }) async {
    print('1 $name');
    print('2 $password');
    print('3 $phone');

    final prefs = await SharedPreferences.getInstance();
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;
    print(
        'playerIddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd $playerId');

    if (playerId == null) {
      playerId = prefs.getString('playerId');
    }

    var url = Uri.parse("${UserProvider.hostName}/update/api/user/register");
    var request = http.MultipartRequest(
      "POST",
      (url),
    );

    try {
      print("how are you mr");
      request.headers.addAll({
        'Content-type': 'application/json',
        'Authorization': 'bearer',
        'Accept': 'application/json',
        "X-Requested-With": "XMLHttpRequest"
      });

      request.fields["type"] = 'user';
      request.fields["name"] = name;
      request.fields["onesignal"] = playerId.toString();
      request.fields["phone"] = phone;
      request.fields["password"] = password;
      request.fields["birthdate"] = birthday.toString();
      request.fields["gender"] = genderr.toString();

      http.Response response =
          await http.Response.fromStream(await request.send());
      print(
          '${jsonDecode(response.body)} dddddddddddddddddddddddddddddddddddd');
      print("Result: ${response.statusCode}");
      var extractedProfile = jsonDecode(response.body);
      if (extractedProfile['status'].toString() == 'true') {
        prefs.setInt('$appName' + '_' + 'id', extractedProfile['user']['id']);
        prefs.setString(
            '$appName' + '_' + 'name', extractedProfile['user']['name']);
        prefs.setString(
            '$appName' + '_' + 'phone', extractedProfile['user']['phone']);

        prefs.setString(
            '$appName' + '_' + 'token', extractedProfile['user']['token']);
        prefs.setString('$appName' + '_' + 'type', 'user');
        prefs.setString('$appName' + '_' + 'gender', genderr);
        prefs.setString('$appName' + '_' + 'birthday', birthday);
        gender = genderr;
        birthDay = birthday;
        token = extractedProfile['user']['token'];
        userName = name;
        userPhone = phone;
        userId = extractedProfile['user']['id'];
        type = 'user';
      } else {
        return extractedProfile['msg'].toString();
      }
      if (response.statusCode == 200) {
        isLogged = true;
        print('success');
        return 'true';
      }
      return response.statusCode == 200 ? 'true' : 'false';
    } catch (e) {
      print('$e');
      return Future.value(e['msg']);
    }
  }

  Future<String> registerCraft({
    File image,
    File file,
    String name,
    String password,
    String phone,
    String address,
    city_id,
    section_id,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;

    if (playerId == null) {
      playerId = prefs.getString('playerId');
    }

    var url = Uri.parse("${UserProvider.hostName}/update/api/user/register");
    var request = http.MultipartRequest("POST", (url));

    try {
      print("how are you mr");
      request.headers.addAll({
        'Content-type': 'application/json',
        'Authorization': 'bearer',
        'Accept': 'application/json',
        "X-Requested-With": "XMLHttpRequest"
      });
      request.fields["lat"] = latitude.toString();
      request.fields["long"] = longitude.toString();
      request.fields["name"] = name;
      request.fields["type"] = 'provider';
      request.fields["onesignal"] = playerId.toString();
      request.fields["phone"] = phone;
      request.fields["password"] = password;
      request.fields["address"] = address.toString();
      request.fields["city_id"] = city_id.toString();
      request.fields["section_id"] = section_id.toString();
      if (image != null) {
        var pic = await http.MultipartFile.fromPath("photo", image.path);
        //add multipart to request
        // request.files.addAll([pic]);
        request.files.add(pic);
      }
      if (file != null) {
        var fily = await http.MultipartFile.fromPath("identifier", file.path);
        //add multipart to request
        // request.files.addAll([pic]);
        request.files.add(fily);
      }

      //Get the response from the server
      http.Response response =
          await http.Response.fromStream(await request.send());
      print(
          '${jsonDecode(response.body)} dddddddddddddddddddddddddddddddddddd');
      print("Result: ${response.statusCode}");
      var extractedProfile = jsonDecode(response.body);

      if (extractedProfile['status'].toString() == 'true') {
        prefs.setInt('$appName' + '_' + 'id', extractedProfile['user']['id']);
        prefs.setString(
            '$appName' + '_' + 'name', extractedProfile['user']['name']);
        prefs.setString(
            '$appName' + '_' + 'phone', extractedProfile['user']['phone']);
        prefs.setString(
            '$appName' + '_' + 'photo', extractedProfile['user']['photo']);
        prefs.setString(
            '$appName' + '_' + 'address', extractedProfile['user']['address']);
        prefs.setString(
            '$appName' + '_' + 'token', extractedProfile['user']['token']);
        prefs.setString('$appName' + '_' + 'latitude', latitude.toString());
        prefs.setString('$appName' + '_' + 'longitude', longitude.toString());
        prefs.setInt('$appName' + '_' + 'section_id',
            extractedProfile['user']['section_id']);
        prefs.setInt(
          '$appName' + '_' + 'city_id',
          extractedProfile['user']['city_id'],
        );
        prefs.setInt('$appName' + '_' + 'approval',
            extractedProfile['user']['approval']);
        token = extractedProfile['user']['token'];
        userName = name;
        userPhone = phone;
        userId = extractedProfile['user']['id'];
        Image = extractedProfile['user']['photo'];
        approval = extractedProfile['user']['approval'].toString();
        type = 'provider';
        prefs.setString('$appName' + '_' + 'type', 'provider');
      } else {
        return extractedProfile['msg'].toString();
      }
      if (response.statusCode == 200) {
        print('1 $image');
        print('1 $name');
        print('2 $password');
        print('3 $phone');
        print('4 ${approval.toString()}');
        print('5 $type');
        print('6 $token');
        print('7${playerId.toString()}');
        // isLogged = true;
        print('success');
        return 'true';
      }
      return response.statusCode == 200 ? 'true' : 'false';
    } catch (e) {
      print('$e');
      return Future.value(e['msg'].toString());
    }
  }

  var extractedProfile;
  Future<String> login(
    String phone,
    String password,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;
    var retuningData;

    print(phone.toString());
    print(password.toString());

    try {
      var respon = await http
          .post(Uri.parse("${UserProvider.hostName}/api/user/login"), body: {
        "phone": phone.toString(),
        "password": password.toString(),
        "onesignal": playerId.toString(),
      });
      extractedProfile = json.decode(respon.body);
      print(extractedProfile);

      if (extractedProfile['status'] == false) {
        isLogin = false;
        retuningData = extractedProfile['msg'];
        return extractedProfile['msg'];
      } else {
        prefs.setInt('$appName' + '_' + 'id', extractedProfile['user']['id']);
        prefs.setString(
            '$appName' + '_' + 'name', extractedProfile['user']['name']);
        prefs.setString(
            '$appName' + '_' + 'phone', extractedProfile['user']['phone']);
        prefs.setString(
            '$appName' + '_' + 'token', extractedProfile['user']['token']);
        prefs.setString(
            '$appName' + '_' + 'type', extractedProfile['user']['type']);

        token = extractedProfile['user']['token'];
        userName = extractedProfile['user']['name'];
        userPhone = extractedProfile['user']['phone'];
        userId = extractedProfile['user']['id'];
        type = extractedProfile['user']['type'];
        if ('provider' == extractedProfile['user']['type']) {
          prefs.setString('$appName' + '_' + 'address',
              extractedProfile['user']['address']);
          prefs.setString(
              '$appName' + '_' + 'photo', extractedProfile['user']['photo']);
          prefs.setString('$appName' + '_' + 'latitude',
              extractedProfile['user']['lat'].toString());
          prefs.setString('$appName' + '_' + 'longitude',
              extractedProfile['user']['long'].toString());
          prefs.setInt('$appName' + '_' + 'approval',
              extractedProfile['user']['approval']);
          Image = extractedProfile['user']['photo'];
          address = extractedProfile['user']['address'];
          approval = extractedProfile['user']['approval'].toString();
        }
        notifyListeners();
        retuningData = 'login success';
        if (extractedProfile['status'] == true) return 'login success';
      }
      return retuningData;
    } catch (e) {
      print('$e   eeeeeeeeeeeeeeeeee');
      return e['msg'];
    }
  }

  Future<Person> getProfile() async {
    Person person;
    final prefs = await SharedPreferences.getInstance();
    final List<Person> loadedPerson = [];
    List<Person> finalLoadedPerson = [];
    try {
      final response = await http.get(
          Uri.parse('${UserProvider.hostName}/api/user/profile'),
          headers: {'Authorization': '$token', 'Accept': 'application/json'});
      var data4 = json.decode(response.body);

      if (data4['status'] == false) {
        return null;
      }
      print(data4);

      loadedPerson.add(
        person = Person(
          id: data4['user']['id'],
          name: data4['user']['name'],
          phone: data4['user']['phone'],
          image: data4['user']['photo'],
          city_id: data4['user']['city_id'].toString(),
          address: data4['user']['address'],
          section_id: data4['user']['section_id'].toString(),
          approval: data4['user']['approval'].toString(),
          long: data4['user']['long'],
          lat: data4['user']['lat'],
          birthDay: data4['user']['birthdate'],
          gender: data4['user']['gender'],
          type: data4['user']['type'],
        ),
      );
      prefs.setString('$appName' + '_' + 'approval', person.approval);
      approval = person.approval;

      if (data4['status'] == true) {
        finalLoadedPerson = loadedPerson;
        notifyListeners();
      }
      return person;
    } catch (e) {
      print('$e fetchDataCity');
      throw e;
    }
  }

  Future<bool> editProfile({
    section_id,
    city_id,
    File file,
    String name,
    String phone,
    String address,
    String id,
    String birthDay,
    String gender,
  }) async {
    print('1 $file');
    print('1 $name');
    print('3 $phone');
    print('3 ${birthDay}');
    print('3 ${birthDay}');
    print('3 $id');
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;
    var url = Uri.parse("${UserProvider.hostName}/api/user/edit/$id");
    var request = http.MultipartRequest("POST", (url));

    // try {
    print("editing...");
    request.headers.addAll({
      'Authorization': '$token',
      'Accept': 'application/json',
    });
    // request.fields["onesignal"] = playerId.toString();

    request.fields["name"] = name;
    request.fields["phone"] = phone;
    if (UserProvider.type == 'user') {
      request.fields["birthdate"] = birthDay.toString();
      request.fields["gender"] = gender.toString();
    } else {
      request.fields["address"] = address;
      request.fields["section_id"] = section_id;
      request.fields["city_id"] = city_id;
      request.fields["lat"] = UserProvider.latitude.toString();
      request.fields["long"] = UserProvider.longitude.toString();
      if (file != null) {
        var pic = await http.MultipartFile.fromPath("photo", file.path);
        request.files.add(pic);
      }
    }
    http.Response response =
        await http.Response.fromStream(await request.send());
    print('${jsonDecode(response.body)} dddddddddddddddddddddddddddddddddddd');
    print("Result: ${response.statusCode}");

    if (response.statusCode == 200) {
      print('success');
      return true;
    }
    return response.statusCode == 200 ? true : false;
    // }
    // catch (e) {
    //   print('$e');
    //   return Future.value(false);
    // }
  }

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('$appName' + '_' + "id");
    prefs.remove('$appName' + '_' + "name");
    prefs.remove('$appName' + '_' + "password");
    prefs.remove('$appName' + '_' + "phone");
    prefs.remove('$appName' + '_' + "token");
    prefs.remove('$appName' + '_' + "type");
    prefs.remove('$appName' + '_' + "id");
    approval = null;
    token = null;
    userName = null;
    userPhone = null;
    userPhoto = null;
    Image = null;
    userId = null;
    token = null;
    address = null;
    prefs.clear();
    isLogin = false;
    userName = "Guest";

    //showInSnackBar("تم تسجيل الخروج", context);
    // Languages.selectedLanguage == 0
    //     ? pageController.jumpToTab(3)
    //     : pageController.jumpToTab(0);
  }

  bool once = false;
  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (once == false) {
      once = true;

      if (prefs.containsKey('$appName' + '_' + 'token')) {
        if (prefs.getString('$appName' + '_' + "type").toString() ==
            'provider') {
          print("provider");
          isLogin = true;
          userName = prefs.getString('$appName' + '_' + "name");
          Image = prefs.getString('$appName' + '_' + "photo");
          userPhone = prefs.getString('$appName' + '_' + "phone");
          userId = prefs.getInt('$appName' + '_' + "id");
          token = prefs.getString('$appName' + '_' + "token");
          approval = prefs.getString('$appName' + '_' + "approval").toString();
          address = prefs.getString('$appName' + '_' + "address");
          type = 'provider';
          latitude = prefs.getString('$appName' + '_' + "lat") != null
              ? double.parse(prefs.getString('$appName' + '_' + "lat"))
              : 0.0;
          longitude = prefs.getString('$appName' + '_' + "long") != null
              ? double.parse(prefs.getString('$appName' + '_' + "long"))
              : 0.0;
        } else {
          print("user");
          userName = prefs.getString('$appName' + '_' + "name");
          userPhone = prefs.getString('$appName' + '_' + "phone");
          userId = prefs.getInt('$appName' + '_' + "id");
          type = 'user';
          gender = prefs.getString('$appName' + '_' + "gender").toString();
          token = prefs.getString('$appName' + '_' + "token");
        }
        print(token);
        print(type);
      }
    }


    _loginType=prefs.getString('$appName' + '_' + "type");
    notifyListeners();
  }

  // Future subsecrptions() async {
  //   var response = await http.get(
  //     Uri.parse(
  //       'http://urservices.creativeapps.me/update/api/subscriptions',
  //     ),
  //     headers: {'Authorization': '$token', 'Accept': 'application/json'},
  //   );

  //   var data = json.decode(response.body);
  //   List subs = data['subscriptions'];
  //   subscrptions.add(subs);
  //   print(
  //       'ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg$subs');
  //   notifyListeners();
  // }


  Future subsecrptionsTybes() async {
    try {
      var response = await http.get(
        Uri.parse('$hostName/update/api/subscriptions'),
        headers: {'Authorization': '$token', 'Accept': 'application/json'},
      );
      var data = json.decode(response.body);
      var myData = Subscrpion.fromJson(data);
      var subList = myData.subscriptions;
      print(
          ': ${subList.toString()}');
      // return subList;

      return subList;
    } catch (e) {
      print('e: $e');
    }
    notifyListeners();
  }

  Future userSubscrption({int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await http.post(
        Uri.parse(
            'https://urservices.creativeapps.me/update/api/user/subscribe'),
        body: {'subscription_id': '1'},
        headers: {'Authorization': '$token', 'Accept': 'application/json'},
      );
      var data = json.decode(response.body);
      prefs.setInt(
          '$appName' + '_' + 'approval', extractedProfile['user']['approval']);
      print(
          '111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111${response.body}');
    } catch (e) {
      print('e: $e');
    }
    notifyListeners();
  }
}
