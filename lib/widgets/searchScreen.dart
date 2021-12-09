import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:your_services/model/city.dart';
import 'package:your_services/model/person.dart';
import 'package:your_services/model/section.dart';
import 'package:your_services/providers/cities.dart';
import 'package:your_services/providers/persons.dart';
import 'package:your_services/providers/sections.dart';
import 'package:your_services/templete/person_item.dart';
import 'package:your_services/templete/section_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchString;
  bool isLoading = false;
  List<Person> resSearchItems = [];
  static const _pageSize = 10;
  GlobalKey<NestedScrollViewState> _key = GlobalKey<NestedScrollViewState>();

  PagingController<int, Person> _pagingController =
      PagingController(firstPageKey: 0);

  // Future<void> _fetchCrafts(int skipKey,String value,isFilter,{sec_id,city_id}) async {
  //   List<Person> newItems=[];
  //   try {
  //     // setState(() {
  //     //     isLoading=true;
  //     //   });
  //       newItems = await Provider.of<Persons>(context, listen: false)
  //           .searchAndFilterPersonList(
  //           search:value,
  //           isFilter:isFilter,
  //           city_id: city_id,
  //           section_id: sec_id);
  //
  //     final isLastPage = newItems.length < _pageSize;
  //     if (isLastPage) {
  //       _pagingController.appendLastPage(newItems);
  //     } else {
  //       final nextPageKey = skipKey + newItems.length;
  //       _pagingController.appendPage(newItems, nextPageKey);
  //     }
  //   } catch(error) {
  //     FlushDialog.flushDialog(context, 'رسالة',"$error");
  //     // _pagingController.error = error;
  //   }
  // }

  // @override
  //  void didChangeDependencies() {
  //    // TODO: implement didChangeDependencies
  //    super.didChangeDependencies();
  //    _pagingController.addPageRequestListener((pageKey) {
  //      _fetchCrafts(pageKey,searchString,false).then((value){
  //      });
  //    });
  //  }
  var key = GlobalKey();
  var key2 = GlobalKey();
  bool isFiltering = false;
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    final sec = Provider.of<Sections>(context, listen: false);
    final city = Provider.of<Cities>(context, listen: false);
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      key: _key,
      child: NestedScrollView(
          floatHeaderSlivers: true,
          physics: BouncingScrollPhysics(),
          controller: scorllController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                CupertinoSliverNavigationBar(
                  key: key2,
                  transitionBetweenRoutes: true,
                  previousPageTitle: 'الرئيسية',
                  stretch: false,
                  border: Border.all(color: Colors.transparent),
                  largeTitle: Text('Search'),
                  backgroundColor: Colors.transparent,
                ),
              ],
          body: isLoading
              ? CupertinoActivityIndicator()
              : Scaffold(
                  appBar: PreferredSize(
                      key: key,
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            border: Border(
                                left: BorderSide.none,
                                bottom: BorderSide(
                                    color: Colors.black26, width: 0.7))),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: const EdgeInsets.only(
                                  bottom: 8, right: 18, left: 18, top: 10),
                              child: CupertinoSearchTextField(
                                // onChanged: (value) {
                                //   setState(() {
                                //     searchString=value.toLowerCase();
                                //     Provider.of<Persons>(context, listen: false).clearFilter();
                                //     _pagingController.addPageRequestListener((pageKey) {
                                //       _fetchCrafts(pageKey,searchString,false).then((value){
                                //       });
                                //     });
                                //   });},
                                onSubmitted: (value) async {
                                  setState(() {
                                    isLoading = true;
                                    isSearched = true;
                                  });
                                  searchString = value.toLowerCase();
                                  Provider.of<Persons>(context, listen: false)
                                      .clearAppointItems();
                                  await Provider.of<Persons>(context,
                                          listen: false)
                                      .searchPersonList(
                                    search: value,
                                  )
                                      .then((value) {
                                    setState(() {
                                      isLoading = false;
                                      if (value.isEmpty)
                                        isSearched = false;
                                      else
                                        isSearched = true;
                                    });
                                  });
                                },
                                controller: _searchController,
                                onSuffixTap: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                                style: TextStyle(
                                  fontSize: 19.0,
                                  color: Colors.black,
                                  fontFamily: 'Tajawal-Regular',
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, 0),
                              child: InkWell(
                                onTap: () {
                                  if (mounted)
                                    setState(() {
                                      isFiltering = true;
                                    });
                                  showDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: Text('فلتر ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1),
                                      content: Column(
                                        children: [
                                          _buildCity(city),
                                          _buildSection(sec),
                                        ],
                                      ),
                                      actions: [
                                        CupertinoButton(
                                            child: Text(
                                              'رجوع',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                isFiltering = false;
                                              });
                                              Navigator.of(context).pop();
                                            }),
                                        CupertinoButton(
                                            child: Text('ابحث الان',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4),
                                            onPressed: () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              Navigator.of(context).pop();
                                              print('first filtering...');
                                              Provider.of<Persons>(context,
                                                      listen: false)
                                                  .clearSearch();
                                              await Provider.of<Persons>(
                                                      context,
                                                      listen: false)
                                                  .filterPersonList(
                                                      city_id: city_id,
                                                      section_id: sec_id)
                                                  .then((value) {
                                                setState(() {
                                                  print(value);
                                                  if (value == true)
                                                    isSearched = false;
                                                  else
                                                    isSearched = true;

                                                  isLoading = false;
                                                });
                                              });
                                            })
                                      ],
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.filter_alt_outlined,
                                      color: Colors.black45,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      preferredSize: Size.fromHeight(50)),
                  body: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Consumer<Persons>(
                      builder: (context, sec, child) {
                        if (sec.loadedSections.length == 0 && isSearched)
                          return Column(
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: sec.personItems.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    CraftPersonItem(
                                        person: sec.personItems[index]),
                              ),
                              if (isLoadingMore)
                                Container(
                                  padding: const EdgeInsets.only(bottom: 70.0),
                                  margin: const EdgeInsets.only(bottom: 70.0),
                                  child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive()),
                                ),
                              if (sec.isNoMore)
                                Center(
                                    child: Text('ليس هنالك مزيد',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1)),
                              SizedBox(
                                height: 70,
                              )
                            ],
                          );
                        else if (sec.loadedSections.length != 0)
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: sec.loadedSections.length,
                            itemBuilder: (context, index) => SectionItem(
                                section: sec.loadedSections[index],
                                city_id: city_id),
                          );
                        return Center(
                          child: Material(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_search,
                                    color: Colors.black12,
                                    size: 70,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 13.0),
                                    child: Text('أبحث الأن',
                                        style: TextStyle(
                                            color:
                                                CupertinoColors.activeOrange)),
                                  ),
                                ],
                              )),
                        );
                      },
                    ),
                  ),
                )),
    );
  }

  ScrollController scorllController;

  @override
  void dispose() {
    scorllController.removeListener(_scrollListener);
    // TODO: implement dispose
    super.dispose();
  }

  _scrollListener() {
    // print(scorllController.position.extentAfter);
    if (scorllController.offset == scorllController.position.maxScrollExtent) {
      if (!Provider.of<Persons>(context, listen: false).isNoMore) {
        print('there is more');
        if (mounted)
          setState(() {
            isLoadingMore = true;
          });
        Provider.of<Persons>(context, listen: false)
            .searchPersonList()
            .then((value) {
          if (mounted)
            setState(() {
              isLoadingMore = false;
            });
        });
      }
    }
  }

  bool isLoadingMore = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    scorllController = new ScrollController()..addListener(_scrollListener);
    // if(!Provider.of<AllProviders>(context, listen: false).isEmptyCity()){
    // Provider.of<Cities>(context, listen: false).clearCity();
    Provider.of<Cities>(context, listen: false)
        .fetchDataCity()
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    Provider.of<Sections>(context, listen: false)
        .fetchSections()
        .whenComplete(() {});
  }

  final kBoxDecorationStyle = BoxDecoration(
    // color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    // boxShadow: [
    //   BoxShadow(
    //     color: Colors.black12,
    //     blurRadius: 6.0,
    //     offset: Offset(0, 2),
    //   ),
    // ],
  );
  String cityTitle;
  City selectedCity;
  int city_id;
  Widget _buildCity(Cities city) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        decoration: kBoxDecorationStyle,
        // height: 60.0,
        child: DropdownButtonFormField<City>(
          isDense: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Container(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.location_city,
                  color: Theme.of(context).primaryColor,
                )),
          ),
          value: selectedCity,
          // underline: Container(),
          isExpanded: true,
          //elevation: 5,
          style: Theme.of(context).textTheme.headline1,
          items: city.cityItems.map<DropdownMenuItem<City>>((value) {
            return DropdownMenuItem<City>(
              value: value,
              child: Center(
                  child: Text(
                value.title,
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
            );
          }).toList(),
          hint: Text(
            "يرجى اختيار المحافظة",
            style: TextStyle(
                color: Colors.black45,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          onChanged: (value) {
            setState(() {
              selectedCity = value;
              cityTitle = selectedCity.title;
              city_id = selectedCity.id;
              // Provider.of<AllProviders>(context,listen: false).selRegion(city_id:city_id);
            });
          },
        ),
      ),
    );
  }

  Widget _buildSection(Sections sec) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        decoration: kBoxDecorationStyle,
        // height: 60.0,
        child: DropdownButtonFormField<Section>(
          isDense: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Container(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.category,
                  color: Theme.of(context).primaryColor,
                )),
          ),
          value: selectedRegion,
          // underline: Container(),
          isExpanded: true,
          //elevation: 5,
          style: Theme.of(context).textTheme.headline1,
          items: sec.sectionItems.map<DropdownMenuItem<Section>>((value) {
            return DropdownMenuItem<Section>(
              value: value,
              child: Center(
                  child: Text(
                value.title,
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
            );
          }).toList(),
          hint: Text(
            "يرجى اختيار القسم",
            style: TextStyle(
                color: Colors.black45,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          onChanged: (value) {
            setState(() {
              selectedRegion = value;
              secTitle = selectedRegion.title;
              sec_id = selectedRegion.id;
            });
          },
        ),
      ),
    );
  }

  Section selectedRegion;
  var secTitle;
  var sec_id;

  Scaffold circularProgras(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Platform.isAndroid
            ? AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      '...جاري التحميل',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              )
            : CupertinoAlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'loading....',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
      ),
    );
  }
}
