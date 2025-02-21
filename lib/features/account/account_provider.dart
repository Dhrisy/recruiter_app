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
  UserData? combinedUserData;
  bool detailsFetch = false;

  File? selectedPicture;


  bool  editLoading = false;

  void setEditLoading(bool val){
    editLoading = val;
    notifyListeners();
  }

  Future<void> fetchAccountData() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await AccountRepository().fetchAccountDetails();

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

  Future<void> fetchAndCombineUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Fetch UserModel
      final userResult = await AccountRepository().fetchUserData();
      if (userResult != null) {
        userData = userResult;
      } else {
        fetchError = true;
        isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch AccountData
      final accountResult = await AccountRepository().fetchAccountDetails();
      if (accountResult != null && accountResult["account"] != null) {
        accountData = accountResult["account"];
        accountFetchError = accountResult["message"];
      } else {
        accountFetchError =
            accountResult?["message"] ?? "Failed to fetch account data";
        isLoading = false;
        notifyListeners();
        return;
      }

      // Combine into UserData
      combinedUserData = UserData.fromModels(
        userModel: userData!,
        accountModel: accountData,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      fetchError = true;
      isLoading = false;
      notifyListeners();
    }
  }
}
