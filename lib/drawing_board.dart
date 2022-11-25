import 'dart:ui';

import 'package:flutter/material.dart';

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  //testing
  //Color Chose
  Color selectedColor = Colors.black;
  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.amberAccent,
    Colors.green,
    Colors.purple,
  ];

  //Drawing board
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => setState(() => Container(
      //         child: Text("hello"),
      //       )),
      // ),
      body: Stack(children: [
        GestureDetector(
          onPanStart: (details) {
            setState(() {
              drawingPoints.add(DrawingPoint(
                details.localPosition,
                Paint()
                  ..color = selectedColor
                  ..isAntiAlias = true
                  ..strokeWidth = strokeWidth
                  ..strokeCap = StrokeCap.round,
              ));
            });
          },
          onPanUpdate: (details) {
            setState(() {
              drawingPoints.add(DrawingPoint(
                details.localPosition,
                Paint()
                  ..color = selectedColor
                  ..isAntiAlias = true
                  ..strokeWidth = strokeWidth
                  ..strokeCap = StrokeCap.round,
              ));
            });
          },
          onPanEnd: (details) {
            setState(() {
              drawingPoints.add(null);
            });
          },
          child: CustomPaint(
              painter: _DrawingPainter(drawingPoints),
              // ignore: sized_box_for_whitespace
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              )),
        ),
        Positioned(
            top: 40,
            right: 30,
            child: Row(
              children: [
                Slider(
                    min: 0,
                    max: 40,
                    value: strokeWidth,
                    onChanged: (val) => setState(() => strokeWidth = val)),
                ElevatedButton.icon(
                    onPressed: () => setState(() => drawingPoints = []),
                    icon: Icon(Icons.clear),
                    label: Text("Clear All"))
              ],
            ))
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey[500],
          padding: EdgeInsets.all(10),
          child: Row(
            children: List.generate(
                colors.length, (index) => buildColorChose(colors[index])),
          ),
        ),
      ),
    );
  }

  Widget buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 55 : 40,
        width: isSelected ? 55 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: Colors.white,
                  width: 5,
                )
              : null,
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i]!.offset, drawingPoints[i + 1]!.offset,
            drawingPoints[i]!.paint);
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i]!.offset);

        canvas.drawPoints(
            PointMode.points, offsetsList, drawingPoints[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  late Offset offset;
  late Paint paint;

  DrawingPoint(this.offset, this.paint);
}
