import 'package:agus/constants/constant.dart';
import 'package:agus/route_generator.dart';
import 'package:agus/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flagsmith/flagsmith.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBrat0SZ6NgQ1wzB9GG9FfMhT9l8MjBoaw",
        appId: "1:734439168307:web:1b3d9f44fcdd88dd450646",
        messagingSenderId: "734439168307",
        projectId: "agus-9b8da",
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> initFirebase = Firebase.initializeApp();
    
    return MaterialApp(
      title: 'Agus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: initFirebase,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            print('active');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container();
            } else {
              return const MyHomePage(title: 'Agus');
            }
          }
          return const CircularProgressIndicator();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late FlagsmithClient flagsmithClient;
  bool buttonStat = false;




  featureButton() async {
    await flagsmithClient.getFeatureFlags(reload: true);
    bool buttonStatus = await flagsmithClient.hasFeatureFlag("button_feature");
    final banner_size = await flagsmithClient.getFeatureFlagValue("button_feature");
    debugPrint(buttonStatus.toString());
    debugPrint(banner_size.toString());
    if (buttonStatus) {
      if (banner_size == 'on') {
        setState(() {
          buttonStat = true;
        });
      } else {
        setState(() {
          buttonStat = false;
        });
      }
    }
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    initFlagSmith();
  }

  
  initFlagSmith() async {
    flagsmithClient = FlagsmithClient(
      apiKey: 'MRmm4ZU3GZaYPSbJBWx3hY',
      seeds: [
        Flag.seed('button_feature', enabled: true),
      ],
    );
    await flagsmithClient.initialize();
    featureButton();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      title: 'Driving Lesson Routes',
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        platform: TargetPlatform.iOS,
        scaffoldBackgroundColor: Colors.white,
        toggleableActiveColor: kColorPrimary,
        appBarTheme: const AppBarTheme(
          elevation: 1,
          color: Colors.white,
          iconTheme: IconThemeData(
            color: kColorPrimary,
          ),
          actionsIconTheme: IconThemeData(
            color: kColorPrimary,
          ), systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        dividerColor: Colors.grey[300],
       
        // ignore: prefer_const_constructors
        iconTheme: IconThemeData(
          color: kColorBlue,
        ),
        fontFamily: 'NunitoSans',
        cardTheme: CardTheme(
          elevation: 0,
          color: Color(0xffEBF2F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            //side: BorderSide(width: 1, color: Colors.grey[200]),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}