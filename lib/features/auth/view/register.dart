import 'package:flutter/material.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(child: Scaffold(
        body: Column(
          children: [
            ReusableTextfield(
              controller: _nameCont,
              validation: (_){

              },
              labelText: "Name",
              isRequired: true,
            )
          ],
        ),
      )),
      
    );
  }
}