import 'package:firebase_core/firebase_core.dart';
import 'package:flagsmith/flagsmith.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Visibility(
                visible: buttonStat,
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {},
                  child: const Text('Looks like a RaisedButton'),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          featureButton();
          _incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
