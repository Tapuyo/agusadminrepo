import 'package:agus/admin/views/home.dart';
import 'package:agus/constants/string.dart';
import 'package:agus/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (debugTo == 'web') {
        Navigator.of(context).pushReplacementNamed(Routes.web);
      }else if(debugTo == 'reader') {
        
      }else{

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
