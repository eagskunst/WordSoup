import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_soup/ui/initial_screen/initial_screen.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([])
      .then( (_) => SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()))
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Words Soup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'MavenPro',
        backgroundColor: Colors.teal,
        bottomSheetTheme: BottomSheetThemeData(
          modalElevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))
          )
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: InitialScreen(),
      ),
    );
  }

}