import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class LocalFirebaseIO {
  Map<String, dynamic> configMap = {};
  File? firebaseConfig;
  Directory? _appdir;
  Future<void> getdir() async {
    _appdir = await getApplicationDocumentsDirectory();
    firebaseConfig = File('${_appdir!.path}/firebase.app');
  }

  Future<void> loadMap() async {
    await getdir();
    configMap = jsonDecode(await firebaseConfig!.readAsString());
  }

  Future<bool> firebasExists() async {
    await loadMap();
    if (configMap['Apps'] == null) {
      return false;
    } else
      return true;
  }
}
