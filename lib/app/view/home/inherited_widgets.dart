import 'package:flutter/cupertino.dart';

class SpecialColor extends InheritedWidget{
  const SpecialColor({Key? key, required Widget child, required this.color}) : super(key: key, child: child);

  final Color color;

  static SpecialColor of(BuildContext context){
    final result = context.dependOnInheritedWidgetOfExactType<SpecialColor>();
    if(result == null) throw Exception('SpecialColor not foumd');
    return result;
  }

  @override
  bool updateShouldNotify(SpecialColor oldWidget) {
    return oldWidget.color != color;
  }

}