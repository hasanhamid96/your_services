
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:your_services/providers/person_works.dart';
import 'package:your_services/templete/works_item.dart';

import 'add_person_works.dart';

class WorksScreenList extends StatefulWidget {
  static String routeName = "Doctor_Works_Screen";
  int id;
  int cat_id;
  bool isService;
  bool isCenter;
  bool isFromDoctor;
  WorksScreenList({this.id,this.cat_id,this.isService:false,this.isCenter=false,this.isFromDoctor:true});
  @override
  _WorksScreenListState createState() => _WorksScreenListState();
}

class _WorksScreenListState extends State<WorksScreenList> {

  bool isLoading=false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading=true;
      print(widget.id);
    });
    Provider.of<PersonWorks>(context,listen: false).getAllDoctorWorks(
        Id: widget.cat_id,
    ).then((value) {
      if(mounted)
        setState(() {
          isLoading = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle:  Text('أعمال مزود الخدمة',
              style: Theme.of(context).textTheme.headline1),
        ),
        child: Scaffold(
            body:isLoading?
            Center(child: CircularProgressIndicator.adaptive()):
            Consumer<PersonWorks>(
              builder: (context, doctorWorks, child) =>doctorWorks.items.length == 0
                  ? Center(
                child:
                Text('لايوجد اعمال' ,
                  style: Theme.of(context).textTheme.headline1,),
                )
                  : ListView.builder(
                itemCount: doctorWorks.items.length,
                itemBuilder: (context, index) =>
                    WorksItem(doctorWorks.items[index],true),
              ),
            ),
          floatingActionButton:Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(
              overflow: Overflow.visible,
              children: [
                Positioned(
                  right: -30,
                  bottom: 10,
                  child: RaisedButton.icon(
                    padding: EdgeInsets.only(right: 30,left: 30,top: 3,bottom: 3),
                    elevation: 4,
                    icon: Icon(Icons.add,color: Colors.white,),
                    onPressed: (){
                      showCupertinoModalBottomSheet(
                          expand: true,
                          closeProgressThreshold:0.6,
                          animationCurve: Curves.easeIn,
                          useRootNavigator:true,
                          bounce: true,
                          enableDrag: true,
                          isDismissible: true,
                          builder: (context) => AddPersonWorks(),
                          context: context
                      );
                      // showCupertinoModalBottomSheet(
                      //   expand: true,
                      //   context: context,
                      //   backgroundColor: Colors.transparent,
                      //   builder: (context) =>  AddPersonWorks(isEdting: false,)
                      // );
                    },
                    color: Colors.red[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(120),bottomLeft: Radius.circular(120))
                    ),
                    label: Padding(
                      padding: const EdgeInsets.only(right:8.0,left: 8),
                      child:
                      Text( 'أضافة عمل',
                        style: Theme.of(context).textTheme.headline3,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
