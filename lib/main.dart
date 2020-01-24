import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  Offset from;
  Offset to;
  final List<List<Offset>> drawPoints = List<List<Offset>>();
  int currentPath = 0;
  _MyHomePageState({this.from = Offset.zero, this.to = Offset.zero});

  changePos({bool updatePos = false}){
    setState(() {
      if(updatePos)
        currentPath++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
          onPanStart: (DragStartDetails details) {
            drawPoints.add(List<Offset>());
            drawPoints[currentPath].add(details.localPosition);
            changePos();
          },
          onPanUpdate: (DragUpdateDetails details){
            drawPoints[currentPath].add(details.localPosition);
            changePos();
          },
          onPanEnd: (DragEndDetails details) => changePos(updatePos: true),
          child: CustomPaint(
            painter: MyPainter(
              from: this.from,
              to: this.to,
              points: this.drawPoints
            ),
            child: Container(),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {

  final Offset from;
  final Offset to;
  final List<List<Offset>> points;
  MyPainter({this.from, this.to, this.points});

  @override
  void paint(Canvas canvas, Size size) {

    final painter = Paint()
        ..color = Colors.indigo
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;
    final path = Path();
    points.forEach( (List<Offset> point) => path.addPolygon(point, false) );
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;

}
