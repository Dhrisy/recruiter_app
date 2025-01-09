import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  const CustomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Container Demo'),
      ),
      body: Center(
        child: OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: const Duration(milliseconds: 500),
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return ElevatedButton(
              onPressed: openContainer,
              child: const Text('Open Details'),
            );
          },
          openBuilder: (BuildContext context, VoidCallback closeContainer) {
            return Container(
              child: Column(),
            );
          },
        ),
      ),
    );
  }
}
