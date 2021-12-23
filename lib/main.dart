import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:your_services/providers/cities.dart';
import 'package:your_services/providers/sections.dart';
import 'package:your_services/providers/person_works.dart';
import 'package:your_services/providers/persons.dart';
import 'package:your_services/providers/user.dart';
import 'package:your_services/screens/auth/subscription.dart';
import 'package:your_services/screens/auth/waiting_Approvel_screen.dart';
import 'package:your_services/screens/maps/map-screen.dart';
import 'package:your_services/screens/works/works_details.dart';
import 'model/banner.dart';
import 'model/socail.dart';
import 'screens/auth/LogScreen.dart';
import 'screens/auth/startScreen.dart';
import 'screens/bottomScreens/bottomNavBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.init("2131fbed-5890-46e5-9a19-c68f22b6bd09", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: false
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(value: Sections()),
        ChangeNotifierProvider.value(
          value: Bannsers(),
        ),
        ChangeNotifierProvider.value(
          value: Persons(),
        ),
        ChangeNotifierProvider.value(
          value: PersonWorks(),
        ),
        ChangeNotifierProvider.value(
          value: GetSocial(),
        ),
        ChangeNotifierProvider.value(value: Cities()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'خدماتك',
          theme: ThemeData(
            // platform: TargetPlatform.iOS,
            primaryColor: CupertinoColors.systemTeal,
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontSize: 17,
                fontFamily: 'Cairo-Regular',
                color: Colors.black45,
              ),
              bodyText2: TextStyle(
                  color: CupertinoColors.systemTeal,
                  fontSize: 15,
                  fontFamily: 'Cairo-Regular',
                  fontWeight: FontWeight.normal),
              headline1: TextStyle(
                  color: CupertinoColors.black,
                  fontFamily: 'Cairo-Regular',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              headline2: TextStyle(
                  color: CupertinoColors.black,
                  fontFamily: 'Cairo-Regular',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              headline3: TextStyle(
                  color: CupertinoColors.white,
                  fontFamily: 'Cairo-Regular',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              headline4: TextStyle(
                  color: CupertinoColors.black,
                  fontFamily: 'Cairo-Regular',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),

            scaffoldBackgroundColor: CupertinoColors.extraLightBackgroundGray,
          ),
          routes: {
            DoctorWorksDetails.routeName: (ctx) => DoctorWorksDetails(),
            MapScreen.routeName: (ctx) => MapScreen(),
            LogScreen.routeName: (ctx) => LogScreen(),
            StartScreen.routeName: (ctx) => StartScreen(),
          },
          onGenerateRoute: (RouteSettings settings) {
            return MaterialWithModalsPageRoute(
                builder: (context) => BottomNavBar(), settings: settings);
          },
          home: FutureBuilder(
              future: auth.checkLogin(),
              builder: (ctx, authResultSnapshot) {
                if (!authResultSnapshot.hasData)
                  Scaffold(
                    body: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                return SplashScreen();
              }),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  var chewieController;
  var sub;
  var id;
  int status;
  @override
  void initState() {
    super.initState();
    final userPro = Provider.of<UserProvider>(context, listen: false);
    userPro.settings().then((value) {
      setState(() {
        status = value;
        print('statusstatus $status');
      });
    });
    userPro.checkLogin();
    initializePlayer(userPro);
  }

  Future<void> initializePlayer(userPro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var subId = prefs.getString('$appName' + '_' + "subId");
    _controller = VideoPlayerController.asset('assets/images/sss.mp4');
    await Future.wait(
      [
        _controller.initialize().then(
              (value) => _controller.addListener(
                () {
                  //custom Listner
                  setState(() {
                    id = subId;
                    if (_controller.value.duration ==
                        _controller.value.position) {
                      print(
                          'video compeleteeed'); //checking the duration and position every time
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => status == 1
                              ? BottomNavBar()
                              : (UserProvider.token != null &&
                                      userPro.loginType == 'provider' &&
                                      subId != null &&
                                      userPro.approval == 0)
                                  ? WatingApprovelScreen()
                                  : (UserProvider.token != null &&
                                          userPro.loginType == 'provider' &&
                                          subId == null &&
                                          userPro.approval == 0)
                                      ? subscrptionsScreen()
                                      : UserProvider.token == null
                                          ? StartScreen()
                                          : BottomNavBar(),
                        ),
                      );
                      setState(
                        () {},
                      );
                    }
                  });
                },
              ),
            ),
      ],
    );
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: false,
        showControls: false);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userPro = Provider.of<UserProvider>(context);
    userPro.checkLogin();

    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 2,
        child: Stack(
          children: [
            Positioned.fill(
              top: 0,
              bottom: -30,
              left: -30,
              right: -30,
              child: FittedBox(
                fit: BoxFit.cover,
                child: _chewieController != null &&
                        _chewieController
                            .videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: _chewieController,
                      )
                    : Scaffold(
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Center(child: CircularProgressIndicator()),
                            SizedBox(height: 20),
                            Text('Loading'),
                          ],
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: OutlineButton(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.white,
                  style: BorderStyle.solid,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                disabledBorderColor: Colors.white,
                highlightedBorderColor: Colors.white,
                onPressed: () {
                  // Navigator.of(context).pushReplacementNamed('ss');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => status == 1
                          ? BottomNavBar()
                          : (UserProvider.token != null &&
                                  userPro.loginType == 'provider' &&
                                  id != null &&
                                  userPro.approval == 0)
                              ? WatingApprovelScreen()
                              : (UserProvider.token != null &&
                                      userPro.loginType == 'provider' &&
                                      id == null &&
                                      userPro.approval == 0)
                                  ? subscrptionsScreen()
                                  : UserProvider.token == null
                                      ? StartScreen()
                                      : BottomNavBar(),
                    ),
                  );
                },
                child: Text(
                  'تخطي',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
