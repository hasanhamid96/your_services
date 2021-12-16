import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:your_services/providers/user.dart';
import 'package:your_services/screens/auth/LogScreen.dart';
import 'package:your_services/screens/bottomScreens/main_screen.dart';
import 'package:your_services/screens/bottomScreens/settingScreen.dart';
import '../works/works_screen_list.dart';

class BottomNavBar extends StatefulWidget {
  bool islogining;
  BottomNavBar({this.islogining = false});
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  ScrollController controller;

  int tabIndex = 0;

  List<Widget> tabs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs = [MainScreen(islogining: widget.islogining), SettingScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
                title: Text(
                  'الرئيسية',
                  style: TextStyle(
                    fontFamily: 'Cairo-Regular',
                  ),
                ),
                icon: Icon(CupertinoIcons.home)),
            BottomNavigationBarItem(
                title: Text(
                  'الاعدادات',
                  style: TextStyle(
                    fontFamily: 'Cairo-Regular',
                  ),
                  textDirection: TextDirection.ltr,
                ),
                icon: Icon(CupertinoIcons.settings))
          ],
        ),
        tabBuilder: (context, index) {
          return tabs[index];
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: UserProvider.type == 'user'
          ? null
          : Padding(
              padding: EdgeInsets.only(
                  bottom: UserProvider.type == 'provider' ? 1 : 33),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: CupertinoColors.systemYellow,
                    onPressed: () {
                      if (Provider.of<UserProvider>(context, listen: false)
                                  .approval ==
                              '0' &&
                          UserProvider.token != null)
                        Toast.show(
                            ' لاتستطيع اضافة اعمال حسابك غير مفعل', context);
                      else
                        showCupertinoModalBottomSheet(
                            expand: true,
                            closeProgressThreshold: 0.6,
                            animationCurve: Curves.easeIn,
                            useRootNavigator: true,
                            bounce: true,
                            context: context,
                            enableDrag: true,
                            isDismissible: true,
                            builder: (context) {
                              if (UserProvider.token == null)
                                return LogScreen();
                              return WorksScreenList();
                            });
                    },
                    child: Icon(
                      UserProvider.token == null
                          ? FlutterIcons.sign_in_oct
                          : CupertinoIcons.add,
                      color: Colors.black38,
                    ),
                  ),
                  if (UserProvider.token != null &&
                      UserProvider.type == 'provider')
                    Text(
                      'اضف عمل  ',
                      textAlign: TextAlign.right,
                    )
                ],
              )),
    );
  }
}
