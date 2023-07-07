import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const dotRadius = 5.0;
const pathRadius = 10.0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final random = Random();
double randomBetween(double a, double b) {
  return random.nextDouble() * (b - a) + a;
}

class Dot {
  Offset position;
  double thetaOffset;
  double speed;
  Color color;

  Dot(this.position, this.thetaOffset, this.speed, this.color);
}

const colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.yellow,
  Colors.indigo,
  Colors.deepPurple
];

class _MyHomePageState extends State<MyHomePage> {
  List<Dot> dots = [];

  double time = 0;
  static const timerTickMillis = 10;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: timerTickMillis), (timer) {
      setState(() {
        final time = timer.tick * timerTickMillis;
        this.time = time.toDouble();
      });
    });
  }

  static const border = 20.0;

  void initPositions(Size size) {
    if (dots.isNotEmpty) {
      return;
    }
    for (int i = 0; i <= 2000; ++i) {
      dots.add(Dot(
          Offset(randomBetween(border, size.width - border),
              randomBetween(border, size.height - border)),
          randomBetween(0, 2 * pi),
          randomBetween(-1.5, 1.5),
          colors[random.nextInt(colors.length)]));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    initPositions(size);

    // widget version
    /*return Stack(
        children: dots.map((d) {
      final theta = d.thetaOffset + time * .01 * d.speed;

      return Positioned(
          left: d.position.dx + pathRadius * cos(theta),
          top: d.position.dy + pathRadius * sin(theta),
          child: Container(
            height: dotRadius * 2,
            width: dotRadius * 2,
            decoration: BoxDecoration(
                color: d.color, borderRadius: BorderRadius.circular(dotRadius)
                //more than 50% of width makes circle
                ),
          ));
    }).toList());*/

    // canvas version
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: CustomPaint(painter: DotSketcher(dots: dots, time: time)));
  }
}

class DotSketcher extends CustomPainter {
  final List<Dot> dots;
  final double time;

  const DotSketcher({required this.dots, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    for (final d in dots) {
      final theta = d.thetaOffset + time * .01 * d.speed;
      final x = d.position.dx + pathRadius * cos(theta);
      final y = d.position.dy + pathRadius * sin(theta);

      Paint paint = Paint()
        ..color = d.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
