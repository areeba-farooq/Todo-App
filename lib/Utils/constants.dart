import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

///
import '../../main.dart';

/// Empty Title & Subtite TextFields Warning
emptyFieldsWarning(context) {
  return FToast.toast(
    context,
    msg: MyString.oopsMsg,
    subMsg: "You must fill all Fields!",
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

/// Nothing Enter When user try to edit the current tesk
nothingEnterOnUpdateTaskMode(context) {
  return FToast.toast(
    context,
    msg: MyString.oopsMsg,
    subMsg: "You must edit the tasks then try to update it!",
    corner: 20.0,
    duration: 3000,
    padding: const EdgeInsets.all(20),
  );
}

/// No task Warning Dialog
dynamic warningNoTask(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: MyString.oopsMsg,
    message:
        "There is no Task For Delete!\n Try adding some and then try to delete it!",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

/// Delete All Task Dialog
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: MyString.areYouSure,
    message:
        "Do You really want to delete all tasks? You will no be able to undo this action!",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    onTapCancel: () {
      Navigator.pop(context);
    },
    onTapConfirm: () {
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}

/// lottie asset address
String lottieURL = 'assets/lottie.json';

class MyString {
  static const String mainTitle = "My Todos";
  static const String deletedTask = "This task was deleted";
  static const String doneAllTask = "You Have Done All Tasks!👌";
  static const String addNewTask = "Add New ";
  static const String updateCurrentTask = "Update ";
  static const String taskStrnig = "Task";
  static const String titleOfTitleTextField = "What are you planing to do😇?";
  static const String addNote = 'Add Note';
  static const String timeString = "Time";
  static const String dateString = "Date";
  static const String deleteTask = "Delete Task";
  static const String addTaskString = "Add Task";
  static const String updateTaskString = "Update Task";
  static const String oopsMsg = "Oops!";
  static const String areYouSure = "Are You Sure?";
}
