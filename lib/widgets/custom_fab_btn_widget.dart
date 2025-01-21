import 'package:flutter/material.dart';
import 'package:recruiter_app/core/constants.dart';

class CustomFabBtnWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String heroTag;

  const CustomFabBtnWidget({Key? key, 
  required this.onPressed, 
  this.icon,
  required this.heroTag
  })
      : super(key: key);

  @override
  _CustomFabBtnWidgetState createState() => _CustomFabBtnWidgetState();
}

class _CustomFabBtnWidgetState extends State<CustomFabBtnWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            secondaryColor,
            const Color.fromARGB(255, 95, 72, 164),
            // const Color.fromARGB(255, 79, 56, 150), // End color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
            spreadRadius: 2.0,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: widget.heroTag,
        onPressed: widget.onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(widget.icon ??  Icons.add, color: Colors.white),
      ),
    );
  }
}
