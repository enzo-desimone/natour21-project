import 'dart:async';
import 'package:android_power_manager/android_power_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:natour21/Account_GUI/login_signup/login_gui.dart';
import 'package:natour21/Admin_Tab_GUI/admin_home_tab.dart';
import 'package:natour21/Admin_Tab_GUI/main_tab_admin.dart';
import 'package:natour21/Controller/user_controller.dart';
import 'package:natour21/Client_Tab_GUI/main_tab.dart';
import 'package:natour21/Itinerary_GUI/Add/add_itinerary_gui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Accessory_Class/global_variable.dart';
import 'Accessory_GUI/system_screen.dart';
import 'Accessory_GUI/theme_color.dart';
import 'Account_GUI/login_signup/signup_gui.dart';
import 'Account_GUI/login_signup/welcome_pages/welcome_gui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FacebookAuth.instance.webAndDesktopInitialize(
    appId: "573354243724504",
    cookie: true,
    xfbml: true,
    version: "v12.0",
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Elevation()),
        ChangeNotifierProvider(create: (_) => ElevationAdmin()),
        ChangeNotifierProvider(create: (_) => ValidateField()),
        ChangeNotifierProvider(create: (_) => ValidateWelcome()),
        ChangeNotifierProvider(create: (_) => ItineraryCategory()),
        ChangeNotifierProvider(create: (_) => ReviewItinerary()),
        ChangeNotifierProvider(create: (_) => ScrollType()),
      ],
      child: EasyLocalization(
          supportedLocales: const [Locale('en', 'EN'), Locale('it', 'IT')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en', 'EN'),
          child: const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _canBuild;
  late bool _isFireBaseLogin;
  late bool _isCognitoLogin;
  late bool _visible;
  final ThemeData theme = ThemeData();

  @override
  void initState() {
    super.initState();
    _canBuild = false;
    _isFireBaseLogin = false;
    _isCognitoLogin = false;
    _visible = true;
    _init();
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('tutorialSaveRoute') == null) {
      prefs.setBool('tutorialSaveRoute', true);
    }

    if (prefs.getBool('tutorialSaveInt') == null) {
      prefs.setBool('tutorialSaveInt', true);
    }

    await Global()
        .notify
        .initPlatformState(prefs.getBool('notifySetting') ?? true);

    if (Global().howOS != 'ios') {
      await AndroidPowerManager.requestIgnoreBatteryOptimizations();
      Global().isEnablePermission =
          (await AndroidPowerManager.isIgnoringBatteryOptimizations)!;
    }

    bool _fireBaseLogin = false;
    bool _cognitoLogin = false;

    if (FirebaseAuth.instance.currentUser != null) {
      Global().provider = FirebaseAuth
          .instance.currentUser!.providerData.single.providerId
          .toString();

      if (Global().provider == 'facebook.com') {
        _fireBaseLogin =
            await UserController().reauthenticateUser('facebook.com');
      } else if (Global().provider == 'google.com') {
        _fireBaseLogin =
            await UserController().reauthenticateUser('google.com');
      } else {
        Global().provider = 'firebase.com';
        _fireBaseLogin =
            await UserController().reauthenticateUser('firebase.com');
      }
    } else {
      _cognitoLogin = await UserController().reauthenticateUser('aws.com');
    }

    Timer(const Duration(milliseconds: 1000), () async {
      if (mounted) {
        setState(() {
          _visible = !_visible;
        });
      }
    });

    Timer(const Duration(milliseconds: 2000), () async {
      if (await checkUrl()) {
        if (mounted) {
          setState(() {
            _canBuild = true;
            _isFireBaseLogin = _fireBaseLogin;
            _isCognitoLogin = _cognitoLogin;
          });
        }
      } else {
        bool isConnected = false;
        while (!isConnected) {
          await Future.delayed(const Duration(seconds: 5), () async {
            isConnected = await checkUrl();
          });
        }
      }
      if (mounted) {
        setState(() {
          _canBuild = true;
          _isFireBaseLogin = _fireBaseLogin;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    if (!_canBuild) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          navigatorKey: Global().navigatorKey,
          navigatorObservers: <NavigatorObserver>[Global.observer],
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: mainColor,
            fontFamily: 'Poppins',
            colorScheme: theme.colorScheme
                .copyWith(primary: mainColor, secondary: accentColor)
                .copyWith(secondary: accentColor),
          ),
          home: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  onEnd: () {},
                  opacity: _visible ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 700),
                  child: Image.asset(
                    "assets/images/logofull.png",
                    width: 340,
                    height: 340,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          navigatorKey: Global().navigatorKey,
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android:
                    CupertinoWillPopScopePageTransionsBuilder(),
                TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
              },
            ),
            brightness: Brightness.light,
            primaryColor: mainColor,
            fontFamily: 'Poppins',
            colorScheme: theme.colorScheme
                .copyWith(primary: mainColor, secondary: mainColor)
                .copyWith(secondary: mainColor),
          ),
          navigatorObservers: <NavigatorObserver>[Global.observer],
          themeMode: ThemeMode.light,
          home: _isFireBaseLogin
              ? Global().myUser.value.firstLogin!
                  ? WelcomePage(
                      provider: Global().provider,
                    )
                  : const MainTab()
              : _isCognitoLogin
                  ? const MainTabAdmin()
                  : const LoginPage(),
          initialRoute: _isFireBaseLogin
              ? Global().myUser.value.firstLogin!
                  ? '/welcome_page'
                  : '/home'
              : _isCognitoLogin
                  ? '/home'
                  : '/login_page',
          routes: {
            '/login_page': (context) => const LoginPage(),
            '/register_page': (context) => const SignUpPage(),
            '/welcome_page': (context) => WelcomePage(
                  provider: Global().provider,
                ),
            '/error': (context) => const SystemScreen(),
          },
        ),
      );
    }
  }
}
