import 'package:flutter/material.dart';
import '../widgets/maintenance/update_uom.dart';
import '../widgets/maintenance/machine_list.dart';
import '../widgets/maintenance/minute_input.dart';
import '../widgets/maintenance/supervisor_password.dart';
import '../widgets/maintenance/shift_form.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {

  @override
  Widget build(BuildContext context) {
    final transaction = Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[

          MinuteInput(),

          Divider(height: 20.0, color: Colors.black87),

          MachineList(),

          ShiftForm(),

          Divider(height: 20.0, color: Colors.black87),

          SupervisorPassword(),

          Divider(height: 20.0, color: Colors.black87),

          UpdateUOM(),

        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: transaction,
      ),
    );
  }
}
