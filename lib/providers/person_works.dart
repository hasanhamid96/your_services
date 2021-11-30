import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:your_services/model/person_work.dart';
import 'package:your_services/providers/user.dart';



class PersonWorks extends ChangeNotifier {
  List<PersonWork> _items = [
    // PersonWork(
    //   id: 1,
    //   title: 'dcdvsdv',
    //   imageUrl: 'https://images.theconversation.com/files/212467/original/file-20180328-109175-bbj2a5.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=1200.0&fit=crop',
    //   description: 'sdvmvimopdamcovmsdopvmaopd'
    // ),
    //
  ];

  List<PersonWork> get items {
    return [..._items];
  }
  void clearItems(){
    _items=[];
    notifyListeners();
  }



  Future<bool> addWork(
      {int work_id,
      File file,
      String title,
      String description,
      isEdting:false,

     }) async{

    print(description);
    print(file);
    print(work_id);
    print(title);
    var url;
    if(!isEdting)
     url = '${UserProvider.hostName}/api/user/achievement';
   else
    url =   '${UserProvider.hostName}/api/user/achievement/edit/${work_id}';


    var request = http.MultipartRequest("POST", Uri.parse(url));

    // add text fields
    try {
      request.headers.addAll({
        'Content-type': 'application/json',
        'Authorization': '${UserProvider.token}',
        'Accept': 'application/json',
        "X-Requested-With": "XMLHttpRequest"
      });

      request.fields["title"] = title;
      request.fields["description"] = description;
      if (file != null) {
        var pic = await http.MultipartFile.fromPath("photo", file.path);
        request.files.add(pic);
      }
      var response = await request.send();
      if(isEdting){
        var index=_items.indexWhere((element) => element.id==work_id);
        _items[index]=PersonWork(id: _items[index].id, title: title, description: description, imageFile: file);
      }
      else
        _items.add(PersonWork(id: 1, title: title, description: description, imageFile: file))  ;

      notifyListeners();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      print(responseString);
      print(responseData);

      if (response.statusCode == 200)
        return Future.value(true);
      else
        return Future.value(false);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> getAllDoctorWorks({int Id,isFromList:false}) async {
    var url;
    var response;
  if(UserProvider.token != null&&!isFromList)
    url='${UserProvider.hostName}/api/user/achievement';
  else
    url='${UserProvider.hostName}/api/user/achievement?id=$Id';
   print(url);
    final List<PersonWork> loadedWorks = [];
    _items=[];
    try {
      if (UserProvider.token != null&&!isFromList)
        response = await http.get(Uri.parse(url), headers: {
          'Authorization': '${UserProvider.token}',
          'Accept': 'application/json',
        },);
      else
        response = await http.get(Uri.parse(url), headers: {
          'Accept': 'application/json',
          'Authorization':'${UserProvider.token}'
        });
      var extractWorkData = json.decode(response.body);
      print('$extractWorkData extractWorkDataextractWorkData');
      var data = extractWorkData['achievement']['data'];
      data.forEach((item) {
        loadedWorks.add(PersonWork(
          id: item['id'],
          title: item['title'],
          description: item['description'],
          imageUrl: item['photo'],
        ));
      });
      _items = loadedWorks;
      notifyListeners();
      if (loadedWorks == null || loadedWorks.isEmpty ||
          loadedWorks.length == 0) {
        return true;
      } else
        return false;
    }catch(e){
      print('${e.toString()} person work error');
      return false;
    }
  }



  Future<bool> deleteDoctorWork(int id) async {
    var url = '${UserProvider.hostName}/api/user/achievement/$id';

    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'Authorization': '${UserProvider.token}',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        var index = _items.indexWhere((element) => element.id == id);
        _items.removeAt(index);
        notifyListeners();
        return true;
      } else
        return false;
    } catch (error) {
      print('$error  deleeetee fail deleteDoctorWorks');
    }
  }
}
