import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recruiter_app/features/account/account_data.dart';
import 'package:recruiter_app/features/account/account_repository.dart';

class AccountProvider extends ChangeNotifier {
  bool isLoading = false;
  AccountData? accountData;
  Map<String, dynamic>? accountFetch;
  UserModel? userData;
  bool fetchError = false;
  String accountFetchError = "";

  bool detailsFetch = false;

  File? selectedPicture;

  Future<void> fetchAccountData() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await AccountRepository().fetchAccountDetails();
      print("aaaaaaaaaaaaaaaaaaaaaaa  $result");
      if (result != null) {
        accountFetch = result;
        detailsFetch = false;
        if (accountFetch != null) {
          accountData = accountFetch!["account"];
          accountFetchError = accountFetch!["message"];
          notifyListeners();
        } else {
          accountData = accountFetch!["account"];
          accountFetchError = accountFetch!["message"];
          notifyListeners();
        }
      } else {
        accountFetchError = result!["message"];
        detailsFetch = true;
        notifyListeners();
      }


      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);

      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> editCompanyDetails({required AccountData account}) async {
    isLoading = true;
    notifyListeners();
    try {
      final result =
          await AccountRepository().editCompanyDetails(accountData: account);
      fetchAccountData();
      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  void setImage(File? selectedImage) {
    selectedPicture = selectedImage;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    try {
      final result = await AccountRepository().fetchUserData();
      print("userdata = $result");
      if (result != null) {
        fetchError = false;
        userData = result;
        // fetchAccountData();
        notifyListeners();
      }
    } catch (e) {
      fetchError = true;
      notifyListeners();
    }
  }
}
