
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:your_services/model/person_work.dart';
import 'package:your_services/providers/person_works.dart';
import 'package:your_services/screens/works/add_person_works.dart';

class WorksItem extends StatelessWidget {
  bool isArabic = true;
  bool isEdting=false;

 PersonWork _personWork;
  WorksItem(this._personWork,this.isEdting,);
  @override
  Widget build(BuildContext context) {


    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: mediaQuery.width * 0.35,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    if(isEdting)
                    RaisedButton(
                      color: Colors.redAccent,
                      shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)
                      ),
                      onPressed: (){
                       return showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(
                             "حذف القسم؟",
                              ),
                              content: Text( 'هل انت متأكد؟'),
                              actions: [
                                CupertinoButton(
                                  // color: Colors.red,
                                  child: Text( "رجوع"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoButton(
                                    child: Text(
                                        "نعم",
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () {

                                      Provider.of<PersonWorks>(context, listen: false)
                                          .deleteDoctorWork(_personWork.id).then((value){
                                        Navigator.pop(context);
                                      });
                                    }),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('حذف',
                        style: Theme.of(context).textTheme.headline3 ,),),
                    RaisedButton(
                      shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)
                      ),
                      onPressed: (){
                        if(isEdting)
                          showCupertinoModalBottomSheet(
                              expand: true,
                              closeProgressThreshold:0.6,
                              animationCurve: Curves.easeIn,
                              useRootNavigator:true,
                              bounce: true,
                              enableDrag: true,
                              isDismissible: true,
                              builder: (context) => AddPersonWorks(personWork: _personWork,isEdting: true,),
                              context: context
                          );
                      },
                      child: Text(isEdting?'تعديل':
                     'مزيد',
                        style: Theme.of(context).textTheme.headline4 ,),),
                  ],
                ),

                FittedBox(
                  fit: BoxFit.fill,
                  child: Container(
                    width: mediaQuery.width * 0.25,
                    height: mediaQuery.height * 0.17,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _personWork.title,
                          textAlign: TextAlign.right,
                        ),
                        Expanded(
                          child: Container(
                            width: mediaQuery.width * 0.8,
                            child: Text(
                              '${_personWork.description}',
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                if(_personWork.imageFile==null)
                Image.network(
                  _personWork.imageUrl,
                  errorBuilder: (context, error, stackTrace) =>
                      loadingImage(mediaQuery, 1),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return loadingImage(mediaQuery, 0);
                  },
                  width: mediaQuery.width * 0.35,
                  height: mediaQuery.height * 0.17,
                  fit: BoxFit.cover,
                ),
                if(_personWork.imageFile!=null)
                  Image.file(_personWork.imageFile,
                    errorBuilder: (context, error, stackTrace) =>
                        loadingImage(mediaQuery, 1),
                    width: mediaQuery.width * 0.35,
                    height: mediaQuery.height * 0.17,
                    fit: BoxFit.cover,)
              ],
            )
          // : Row(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Image.network(
          //         _doctorWork.imageUrl,
          //         errorBuilder: (context, error, stackTrace) =>
          //             loadingImage(mediaQuery, 1),
          //         loadingBuilder: (context, child, loadingProgress) {
          //           if (loadingProgress == null) return child;
          //           return loadingImage(mediaQuery, 0);
          //         },
          //         width: mediaQuery.width * 0.35,
          //         height: mediaQuery.height * 0.17,
          //         fit: BoxFit.fill,
          //       ),
          //       Container(
          //         width: mediaQuery.width * 0.35,
          //         height: mediaQuery.height * 0.17,
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Text(_doctorWork.title),
          //             Expanded(
          //               child: Container(
          //                 width: mediaQuery.width * 0.8,
          //                 child: Text(
          //                   '${_doctorWork.description}',
          //                   textAlign: TextAlign.left,
          //                   overflow: TextOverflow.ellipsis,
          //                   style: Theme.of(context).textTheme.bodyText1,
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //       InkWell(
          //           onTap: () {
          //             Navigator.of(context).pushNamed(
          //                 DoctorWorksDetails.routeName,
          //                 arguments: _doctorWork);
          //           },
          //           child: Text('Read More...')),
          //     ],
          //   ),
    );
  }

  Container loadingImage(Size mediaQuery, int typeOfLoading) {
    return Container(
        color: Colors.white,
        width: mediaQuery.width * 0.35,
        height: mediaQuery.height * 0.17,
        child: typeOfLoading == 0
            ? Center(
                child: CircularProgressIndicator(
                strokeWidth: 1.2,
              ))
            : Icon(Icons.broken_image_rounded));
  }
}
