import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class CommonBackgroundImage extends StatelessWidget {
  const CommonBackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 1,
      child: SvgPicture.asset(
        "assets/svgs/group_circle.svg",
        fit: BoxFit.cover,
      ),
    );
  }
}
