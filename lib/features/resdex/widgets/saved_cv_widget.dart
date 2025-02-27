import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:recruiter_app/core/utils/navigation_animation.dart';
import 'package:recruiter_app/features/resdex/provider/resume_provider.dart';
import 'package:recruiter_app/features/resdex/widgets/pdf_view_screen.dart';

class SavedCvWidget extends StatefulWidget {
  const SavedCvWidget({Key? key}) : super(key: key);

  @override
  _SavedCvWidgetState createState() => _SavedCvWidgetState();
}

class _SavedCvWidgetState extends State<SavedCvWidget> {


  @override
  void initState() {
    super.initState();


WidgetsBinding.instance.addPostFrameCallback((_){

  // Provider.of<ResumeProvider>(context, listen: false).d

});

  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildCvCard(),
            );}),
        )
      ],
    );
  }


  Widget _buildCvCard(){
      return AnimatedContainer(
              duration: 500.ms,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/cv_folder.webp",
                        height: 50,
                        width: 60,
                      ),
                      Text("Name.pdf"),
                    ],
                  ),
                  childrenPadding: EdgeInsets.only(bottom: 10),
                  children: [
                    const Divider(),
                    Wrap(
                      spacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        ElevatedButton.icon(onPressed: () {
                          Navigator.push(context, AnimatedNavigation().fadeAnimation(PdfViewerScreen(cv: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",)));
                        }, label: Text("View CV")),
                        OutlinedButton.icon(onPressed: (){
                        
                        }, 
                        icon: Icon(Icons.visibility),
                        label: Text("View seeker details")),
                      ],
                    )
                  ],
                ),
              ),
            );
           
  }
}
