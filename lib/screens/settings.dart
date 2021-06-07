import 'package:argon_flutter/constants/Theme.dart';
import 'package:argon_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Color.fromRGBO(213, 21, 36, 1)),
      // Nav Bar (title: 'Profilo', bgColor: Color.fromRGBO(213, 21, 36, 1)),
      drawer: ArgonDrawer("settings"),
      body: SizedBox(
        // width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 34.0, right: 34.0, top: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(52),
              primary: ArgonColors.redUnito,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {},
            child: Padding(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 12, bottom: 12),
                child: Text("Delete User", style: TextStyle(fontSize: 16.0))),
          ),
        ),
      ),
    );
  }
}
