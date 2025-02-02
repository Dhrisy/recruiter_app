import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({Key? key}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    downloadPdf();
  }

  Future<void> downloadPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/sample_cv.pdf');

      // Sample PDF URL for testing
      const samplePdfUrl =
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

      final response = await Dio().download(samplePdfUrl, file.path);
      if (response.statusCode == 200) {
        setState(() {
          localFilePath = file.path;
        });
        print("PDF downloaded successfully: ${file.path}");
      }
    } catch (e) {
      print("Error downloading PDF: $e");
    }
  }

 @override
Widget build(BuildContext context) {
  return Material(
    child: Scaffold(
      body: localFilePath != null
          ? SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                  children: [
                    CommonAppbarWidget(
                      title: "Name.pdf",
                      isBackArrow: true,),
                    Expanded(
                      child: PDFView(
                        filePath: localFilePath!,
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: true,
                        pageFling: true,
                      ),
                    ),
                  ],
                ),
            ),
          )
          : Center(child: CircularProgressIndicator()),
    ),
  );
}

}
