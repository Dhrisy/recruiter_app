import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/features/settings/viewmodel/settings_provider.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';
import 'package:recruiter_app/widgets/reusable_button.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  String? selectedTopic;


final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height.h;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body:  Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: h * 0.45,
                child: SvgPicture.asset(
                  "assets/svgs/onboard_1.svg",
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                          const  CommonAppbarWidget(
                              isBackArrow: true,
                              title: "Your suggestions matters!",
                            ),
                            
                            SizedBox(height: h * 0.02),
                            const Text(
                              'We value your opinion and strive to improve your experience! Your feedback helps us enhance our app and provide better services.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: greyTextColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // Text field
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: _feedbackController,
                                maxLines:10,
                                validator: (_){
                                  if(_feedbackController.text.trim().isEmpty){
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                decoration:  InputDecoration(
                                  hintText: 'I think this app is...',
                                  hintStyle: TextStyle(color: greyTextColor),
                                  contentPadding: EdgeInsets.all(12),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r,),
                                    borderSide: BorderSide(
                                      color: secondaryColor
                                    )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r,),
                                    borderSide: BorderSide(
                                      color: secondaryColor
                                    )
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r,),
                                    borderSide: BorderSide(
                                      color: Colors.red
                                    )
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r,),
                                    borderSide: BorderSide(
                                      color: Colors.red
                                    )
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ReusableButton(action: (){
                         if (_formKey.currentState!.validate()) {
                             final feedbackProvider =
                                SettingsProvider();
                            feedbackProvider.submitFeedback(
                                _feedbackController.text, context);
                      
                            _feedbackController.clear();
                           
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter your feedback.')),
                            );
                          }
                      }, text: "Submit")
                    
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
