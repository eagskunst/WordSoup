import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/models/board_data.dart';
import 'package:word_soup/ui/game/game_view.dart';
import 'package:word_soup/ui/initial_screen/initial_screen.dart';
import 'package:word_soup/utils/base/selection_event.dart';


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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  var itemsNumber = 7;
  var level = 1;
  WordsBloc wordsBloc;

  @override
  void initState() {
    super.initState();
    //wordsBloc = BlocProvider.of(context);
    //wordsBloc.userSelectionStream.listen((event) => updateLevel(event));
    //wordsBloc.generateWords(itemsNumber);*/
  }


  @override
  Widget build(BuildContext context) {
    //wordsBloc.generateWords(itemsNumber, BoardData.BOARD_MAP[itemsNumber].wordsNumber);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: InitialScreen(),
      ),
    );
    /*return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: StreamBuilder<String>(
          stream: wordsBloc.wordsStream,
          builder: (context, snapshot) {
            if(snapshot.data == null || snapshot.data.isEmpty)
              return progressWidget();
            else
              return Column(
                children: <Widget>[
                  GameView(sentence: snapshot.data, tableSize: itemsNumber, level: level),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: FloatingActionButton(
                      child: Icon(Icons.update),
                      onPressed: () => updateLevel(SelectionEvent.LevelCompleteSelection),
                    ),
                  )
                ],
              );
          }
        ),
      ),
    );*/
  }

  Widget progressWidget(){
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Text('Loading')
            )
          ],
        )
    );
  }

  void updateLevel(SelectionEvent event){
    print("Enter update level, event: $event");
    if(event != SelectionEvent.LevelCompleteSelection) return
    print("Enter update level");
    setState(() {
      wordsBloc.cleanWordsSink();
      itemsNumber = itemsNumber == 12 ? 7 : itemsNumber+1;
      level = level == 6 ? 1 : level+1;
    });
  }

}