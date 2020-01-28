import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/models/board_data.dart';
import 'package:word_soup/ui/game_view.dart';


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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'MavenPro',
        bottomSheetTheme: BottomSheetThemeData(
          modalElevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))
          )
        )
      ),
      home: BlocProvider<WordsBloc>(
          creator: (_context, bag) => WordsBloc(),
          child: MyHomePage(title: 'Flutter Demo Home Page')
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  var itemsNumber = 7;

  @override
  void initState() {
    super.initState();
    /*final WordsBloc wordsBloc = BlocProvider.of(context);
    wordsBloc.generateWords(itemsNumber);*/
  }


  @override
  Widget build(BuildContext context) {
    final WordsBloc wordsBloc = BlocProvider.of(context);
    wordsBloc.generateWords(itemsNumber, BoardData.BOARD_MAP[itemsNumber].wordsNumber);
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<String>(
          stream: wordsBloc.wordsStream,
          builder: (context, snapshot) {
            print("Is null or data is empty: ${snapshot.data == null || snapshot.data.isEmpty}");
            if(snapshot.data == null || snapshot.data.isEmpty)
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
                          child: Text('Cargando')
                      )
                    ],
                  )
              );
            else
              return Column(
                children: <Widget>[
                  GameView(sentence: snapshot.data, tableSize: itemsNumber),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: FloatingActionButton(
                      child: Icon(Icons.update),
                      onPressed: () => updateTableSize(),
                    ),
                  )
                ],
              );
          }
        ),
      ),
    );
  }

  void updateTableSize(){
    final wordsBloc = BlocProvider.of<WordsBloc>(context);
    setState(() {
      wordsBloc.cleanWordsSink();
      itemsNumber = itemsNumber == 12 ? 7 : itemsNumber+1;
    });
  }

}