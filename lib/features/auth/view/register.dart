import 'package:flutter/material.dart';
import 'package:recruiter_app/widgets/reusable_textfield.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: SafeArea(
          child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Register your company",
                style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              ReusableTextfield(
                controller: _nameCont,
                validation: (_) {},
                labelText: "Name",
                isRequired: true,
              ),
               const SizedBox(
                height: 20,
              ),
              ReusableTextfield(
                controller: _nameCont,
                validation: (_) {},
                labelText: "Name",
                isRequired: true,
              ),
               const SizedBox(
                height: 20,
              ),
              ReusableTextfield(
                controller: _nameCont,
                validation: (_) {},
                labelText: "Name",
                isRequired: true,
              )
            ],
          ),
        ),
      )),
    );
  }
}
