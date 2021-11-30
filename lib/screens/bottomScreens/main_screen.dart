import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:your_services/model/banner.dart';
import 'package:your_services/providers/cities.dart';
import 'package:your_services/providers/user.dart';
import 'package:your_services/widgets/searchScreen.dart';
import 'package:your_services/templete/CityItem.dart';

class MainScreen extends StatefulWidget {
  static  List<Baner> imgList=[];
  bool islogining;

  MainScreen({this.islogining=false});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool  isLoadingCities=false;

  bool isLoadingBanner = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(UserProvider.token!=null)
    Provider.of<UserProvider>(context,listen: false).getProfile();
    if(widget.islogining)
      Future.delayed(Duration(milliseconds: 400)).then((value){
        showCupertinoDialog(context: context, builder: (context) => StatefulBuilder(
          builder: (context, setState) =>  CupertinoAlertDialog(
            title: Text('تم تسجيل بنجاح',style: TextStyle(color: Colors.blue,fontFamily: 'Cairo-Regular',),),
            content: Container(
                margin: EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width*0.60,
                child: Text('مرحبا ( ${UserProvider.userName}) تم استلام طلبك بنجاح سيتم التفعيل خلال ٢٤ساعه',
                  style: TextStyle(color: Colors.black54, fontFamily: 'Cairo-Regular',fontSize: 16),
                  textAlign: TextAlign.right,)),
            actions: [
              CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('رجوع',style: TextStyle(color: Colors.red, fontFamily: 'Cairo-Regular',fontSize: 13),)),
            ],
          ),
        ),);
      });
    isLoadingBanner=true;
    Provider.of<Bannsers>(context, listen: false)
        .getImagesBanner()
        .then((value) {
      if (value.length != 0) {
        setState(() {
          MainScreen.imgList = value;
          isLoadingBanner = false;
        });

      }
    }).catchError((onError){
      setState(() {
        isLoadingBanner = false;
      });
    });
    isLoadingCities=true;
    Provider.of<Cities>(context,listen: false).fetchDataCity().then((value){
      setState(() {
        isLoadingCities=false;
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: NestedScrollView(
          physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  CupertinoSliverNavigationBar(
                    key: _key,
                    middle: Container(
                      margin:  EdgeInsets.all(8),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                        color: CupertinoColors.systemTeal,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(10, 5),
                              blurRadius: 20,
                              spreadRadius: -10)
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.67,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Center(
                              child: Text(
                                'خدماتك يمك',
                                style: Theme.of(context).textTheme.headline3,
                              ))),
                    ),
                    backgroundColor: Colors.white70,
                    largeTitle: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: CupertinoTextField(
                          readOnly: true,
                          onTap: () {
                            Navigator.of(context)
                                .push(CupertinoPageRoute(builder: (context) => SearchScreen(),maintainState: false));
                          },
                          prefix: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.search),
                          ),
                          placeholderStyle:
                              TextStyle(color: CupertinoColors.inactiveGray),
                          placeholder: 'البحث',
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CupertinoColors.lightBackgroundGray),
                        )),
                  ),
                ],
            body: RefreshIndicator(
              onRefresh: ()async{
                setState(() {
                  isLoadingBanner=true;
                });

                Provider.of<Bannsers>(context, listen: false)
                    .getImagesBanner()
                    .then((value) {
                  if (value.length != 0) {
                    setState(() {
                      MainScreen.imgList = value;
                      isLoadingBanner = false;
                    });

                  }
                }).catchError((onError){
                  setState(() {
                    isLoadingBanner = false;
                  });
                });
                isLoadingCities=true;
                Provider.of<Cities>(context,listen: false).fetchDataCity().then((value){
                  setState(() {
                    isLoadingCities=false;
                  });
                });
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Color.fromRGBO(247, 247, 247, 1),
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(MediaQuery.of(context).size.height*0.23),
                  child:isLoadingBanner?
                  Center(child: Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)
                    ),
                  )):
                  Carousel(
                    images: MainScreen.imgList == null
                        ? null
                        : MainScreen.imgList
                            .map((url) => InkWell(
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (context) => DoctorProfileScreen(doctor_id:url.doctor_id ,isBanner:true),
                                  // ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: '${url.image}',
                                      fit: BoxFit.fill,
                                      // placeholder: (context, url) => Center(
                                      //     child:
                                      //         CircularProgressIndicator.adaptive()),
                                    ),
                                  ),
                                )))
                            .toList(),
                    dotBgColor: Colors.transparent,
                    overlayShadowColors: Colors.black,
                    animationCurve: Curves.easeOutQuint,
                    boxFit: BoxFit.cover,
                    autoplay: true,
                    // dotColor: Colors.red,
                    // dotIncreasedColor: Colors.blue,
                    overlayShadow: true,
                    showIndicator: true,
                    noRadiusForIndicator: true,
                    dotPosition: DotPosition.bottomLeft,
                    // borderRadius: true,
                    animationDuration: Duration(milliseconds: 500),
                    // indicatorBackgroundColor: Colors.greenAccent,
                  ),
                ),
                body: isLoadingCities
                    ? Center(child: loadShimmer(context))
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        child: Consumer<Cities>(
                          builder: (context, categories, child) =>
                              ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: categories.cityItems.length,
                            itemBuilder: (context, index) => CityItem(
                              city: categories.cityItems[index],
                            ),
                          ),
                        ),
                      ),
              ),
            )));
  }

  Widget loadShimmer(context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Shimmer(
        enabled: true,
        loop: 123,
        period: Duration(seconds: 1),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.black12, Colors.grey],
            tileMode: TileMode.repeated,
            stops: [12.12, 123.3]),
        direction: ShimmerDirection.rtl,
        child: ListView.builder(
            itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    // color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          // padding:  EdgeInsets.only(right:8.0,
                          //     ),
                          width: mediaQuery.width * 0.6,
                          height: 100,
                          // margin: EdgeInsets.symmetric(horizontal: 10),
                          child:  Container(
                              padding: EdgeInsets.all(8),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        bottomLeft: Radius.circular(40))),
                                child: Column(
                                  children: [Text('      ')],
                                ),
                              ),
                            ),

                        ),
                      ),
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(122),
                                topRight: Radius.circular(122),
                                bottomLeft: Radius.circular(122),
                                topLeft: Radius.circular(122))),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(''),
                          radius: 70,
                          onBackgroundImageError: (exception, stackTrace) =>
                              Icon(Icons.broken_image),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
