import 'dart:async';
import 'dart:io';

import 'package:bb/models/user_model.dart';
import 'package:bb/utils/database.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bb/controller/home_page.dart';
import 'package:bb/controller/receipts_page.dart';
import 'package:bb/controller/user_page.dart';
import 'package:bb/utils/app_localizations.dart';
import 'package:bb/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final String? payload;
  MyApp({
    Key? key, this.payload,
  }) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  TranslationsDelegate? _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = TranslationsDelegate(newLocale: null);
    _initialize();
    _authStateChanges();
    _subscribe();
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = TranslationsDelegate(newLocale: locale);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      fontFamily: 'Montserrat',
      brightness: Brightness.light,
      primaryColor: primaryColor,
    );
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.text('app_title'),
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: primaryColor),
      ),
      home: MyHomePage(),
      builder: EasyLoading.init(),
      localizationsDelegates: [
        _newLocaleDelegate!,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('fr'), // French
      ]
    );
  }
  _initialize() async {
    // final provider = Provider.of<EditionNotifier>(context, listen: false);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // provider.setEdition(prefs.getBool(EDITION_MODE_KEY) ?? false);
    // provider.setEditable(prefs.getBool(EDIT_KEY) ?? false);
  }

  _authStateChanges() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      UserModel? model;
      if (user != null) {
        model = await Database().getUser(user.uid);
        if (model != null) {
          model.user = user;
          print('[$APP_NAME] User \'${user.email}\' is signed in with \'${model.role}\'.');
        }
      }
      setState(() {
        currentUser = model;
      });
    });
  }

  Future<void> _subscribe() async {
    if (!Foundation.kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic(Foundation.kDebugMode ? NOTIFICATION_TOPIC_DEBUG : NOTIFICATION_TOPIC);
      print('[$APP_NAME] Firebase messaging subscribe from "${Foundation.kDebugMode ? NOTIFICATION_TOPIC_DEBUG : NOTIFICATION_TOPIC}"');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      });
    }
  }
}

class MyHomePage extends StatefulWidget {
  final String? payload;
  const MyHomePage({Key? key, this.payload}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/logo.png')),
            label: AppLocalizations.of(context)!.text('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink_outlined),
            label: AppLocalizations.of(context)!.text('receipts'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: AppLocalizations.of(context)!.text('user'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.black54,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _showPage(),
    );
  }

  Widget? _showPage() {
    switch (_selectedIndex) {
      case 0: return HomePage();
      case 1: return ReceiptsPage();
      case 2: return UserPage();
    }
  }
}