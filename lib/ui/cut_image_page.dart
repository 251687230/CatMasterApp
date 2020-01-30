import 'dart:io';
import 'dart:ui';

import 'package:catmaster_app/widget/drag_and_scale_gesture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

File image;
class CutImagePage extends StatelessWidget{
  CutImagePage(File selectImage){
    image = selectImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("截取图片"),),
      body: _CutImageBody(),
    );
  }
}

class _CutImageBody extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CutImageState();
  }
}

class _CutImageState extends State<_CutImageBody>{
   double _minScale = 0.5;
   double _maxScale = 2;

  double translateX = 0;
  double translateY = 0;
  double previousTranX = 0;
  double previousTranY = 0;

  double _previousScale = 1;

  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return ScalingGestureDetector(child:
      Stack(
      children: <Widget>[
        ClipRect(child:
          Transform(transform: Matrix4.compose(v.Vector3(translateX,translateY,0),
              v.Quaternion.identity(), v.Vector3(_scale,_scale,1)),
            alignment: Alignment.center,child: Image.file(image,width: double.infinity,height: double.infinity),)
        )
       ,
        CustomPaint(painter: _CutDrawer(),size: Size(double.infinity,double.infinity),)
      ],
    ),
      onScaleUpdate: _handleScaleUpdate,
      onScaleStart: _handleScaleStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
    );
  }

  void _handlePanEnd(){
    previousTranX = translateX;
    previousTranY = translateY;
  }

  void _handlePanUpdate(Offset initialPoint, Offset delta){
    setState(() {
      translateX = previousTranX + delta.dx;
      translateY = previousTranY + delta.dy;
    });
  }

  void _handleScaleUpdate(Offset offset,double scale){
    setState(() {
      var tempScale = (_previousScale * scale);
      if(tempScale < _minScale){
        _scale = _minScale;
      }else if(tempScale > _maxScale){
        _scale = _maxScale;
      }else{
        _scale = tempScale;
      }
    });
  }

  void _handleScaleStart(Offset offset){
    setState(() {
      print("transx " + translateX.toString());
      _previousScale = _scale;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

}

class _CutDrawer extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Offset offset = Offset(size.width/2,size.height/2);
    Rect rect = Rect.fromCircle(center: offset,radius: size.width/4);
    Paint paint = Paint();
    paint.strokeWidth = 3;
    paint.color = Colors.green[500];
    paint.style = PaintingStyle.stroke;
    canvas.drawRect(rect, paint);

    canvas.clipRect(rect,clipOp: ClipOp.difference);
    canvas.drawColor(Color(0x99000000), BlendMode.dstIn);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}