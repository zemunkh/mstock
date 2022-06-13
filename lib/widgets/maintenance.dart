import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  final _minuteController = TextEditingController();

  final FocusNode _minuteNode = FocusNode();

  Future _focusNode(BuildContext context, FocusNode node) async {
    FocusScope.of(context).requestFocus(node);
  }

  final _formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    DateTime createdDate = DateTime.now();
    Widget _minuteInput(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Row(
          children: <Widget>[
            const Expanded(
              flex: 6,
              child: Text(
                'Production Scan delay: ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                key: _formKey,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF004B83),
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _minuteController,
                focusNode: _minuteNode,
                onTap: () {
                  print('Tapped');
                  _focusNode(context, _minuteNode);
                },
              ),
            ),
            const Expanded(
              flex: 2,
              child: Text(
                'minutes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    //     Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: <Widget>[
    //     Expanded(
    //       child: postButton,
    //     ),
    //     Expanded(
    //       child: _saveDraftButton(context),
    //     )
    //   ],
    // ),

    final transaction = Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _minuteInput(context),
          const Divider(
            height: 20.0,
            color: Colors.black87,
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxHeight > constraints.maxWidth) {
            return SingleChildScrollView(
              child: transaction,
            );
          } else {
            return Center(
              child: SingleChildScrollView(
                child: transaction,
              ),
            );
          }
        },
      ),
    );
  }
}
