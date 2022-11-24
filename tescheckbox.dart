import 'package:flutter/material.dart';

class testingcekbox extends StatefulWidget {
  const testingcekbox({super.key});

  @override
  State<testingcekbox> createState() => _testingcekboxState();
}

class _testingcekboxState extends State<testingcekbox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text("testing"),
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
            },
          ),
        ),
      );
}
