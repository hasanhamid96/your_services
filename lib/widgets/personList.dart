import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_services/providers/persons.dart';
import 'package:your_services/templete/person_item.dart';

class PersonList extends StatefulWidget {
  int city_id;
  int section_id;

  PersonList({this.city_id, this.section_id});

  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    Provider.of<Persons>(context, listen: false)
        .fetchPersonList(widget.section_id, widget.city_id)
        .then((value) => setState(() => isLoading = false))
        .catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          previousPageTitle: 'رجوع',
          middle: Text(
            'مزودي الخدمات',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        child: isLoading
            ? Center(child: CupertinoActivityIndicator())
            : Consumer<Persons>(
                builder: (context, crafts, child) => crafts.personItems.isEmpty
                    ? Material(
                        color: Colors.transparent,
                        child: Center(child: Text('لايوجد داتا')))
                    : GridView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: crafts.personItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemBuilder: (context, index) => CraftPersonItem(
                          person: crafts.personItems[index],
                        ),
                      ),
              ));
  }
}
