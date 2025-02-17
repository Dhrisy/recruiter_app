import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recruiter_app/services/api_lists.dart';
import 'package:recruiter_app/widgets/common_snackbar.dart';
import 'package:share_plus/share_plus.dart';

class CustomFunctions {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> storeCredentials(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> retrieveCredentials(String key) async {
    final accessToken = await _secureStorage.read(key: key);
    return accessToken;
  }

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  static String toSentenceCase(String input) {
    if (input.isEmpty) return input;

    // Convert first letter to uppercase and the rest to lowercase
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

   String? validateUrl(String? url) {
    const String baseUrl = ApiLists.imageBaseUrl;

    if (url == null || url.isEmpty) {
      return null;
    }

    Uri? uri;
    try {
      uri = Uri.parse(url);
      if (!uri.hasScheme) {
        url = url.startsWith('/') ? url.substring(1) : url;
        url = baseUrl + url;
        uri = Uri.parse(url);
      }
      if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
        return url;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> shareContent({
    required String content, 
    required String subject
    }) async {
    try {
      await Share.share(content, subject: subject);
    } catch (e) {
      print('Error sharing: $e');
    }
  }

    String formatCTC(dynamic ctc) {
    if (ctc == null) return 'N/A';

    try {
      double ctcValue = double.parse(ctc.toString());
      if (ctcValue >= 1000000) {
        // For millions
        return '${(ctcValue / 1000000).toStringAsFixed(1)}M';
      } else if (ctcValue >= 1000) {
        // For thousands
        return '${(ctcValue / 1000).toStringAsFixed(1)}K';
      }
      return '$ctcValue';
    } catch (e) {
      return 'N/A';
    }
  }

/// Checks for internet connection before making API calls
  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false; // No internet
    }
    return true; // Internet available
  }



static void showNoInternetPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please check your internet connection and try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

}
