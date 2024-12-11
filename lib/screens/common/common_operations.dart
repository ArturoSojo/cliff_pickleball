import 'package:flutter/material.dart';
import 'package:cliff_pickleball/db_operations/firestore_operations.dart';
import 'package:cliff_pickleball/services/device_specific_operations.dart';
import 'package:cliff_pickleball/services/local_database_services.dart';

import 'package:cliff_pickleball/services/navigation_management.dart';
import 'package:cliff_pickleball/services/toast_message_show.dart';
import 'package:cliff_pickleball/config/types.dart';
import '../main_screens/main_screen_management.dart';

storagePermissionForStoreCurrAccData(
    BuildContext context, VoidCallback rightBtnOnTap) {
  DialogMsg.showDialog(context, "Require Storage Permission",
      "CliffPickleball will store your some frequent used data with encrypted form in your local system",
      onSuccess: rightBtnOnTap,
      rightBtnText: "Give Permission",
      onFailure: () => closeYourApp(),
      awesomeDialogType: AwesomeDialogType.info);
}

dataFetchingOperations(BuildContext context, _createdBefore, currUserId) {
  final LocalStorage _localStorage = LocalStorage();
  final DBOperations _dbOperations = DBOperations();

  ToastMsg.showSuccessToast("Account Created Before", context: context);

  storagePermissionForStoreCurrAccData(context, () async {
    await _localStorage.storeDataForCurrAccount(
        _createdBefore["data"], currUserId);
    await _dbOperations.updateCurrentAccount(_createdBefore["data"]);
    await _dbOperations.updateToken();

    ToastMsg.showSuccessToast("Data Fetched Successfully", context: context);
    Navigation.intentStraight(context, const MainScreen());
  });
}
