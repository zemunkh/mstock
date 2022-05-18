import 'package:flutter/widgets.dart';

class Production extends StatefulWidget {
  const Production({ Key? key }) : super(key: key);

  @override
  State<Production> createState() => _ProductionState();
}

class _ProductionState extends State<Production> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('hi'),
    );  
  }
}