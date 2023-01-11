import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'global_variable.dart';

class Connection {
  Connection._internal();
  bool isOpen = false;

  static final Connection _instance = Connection._internal();

  static Connection get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    var result = await (Connectivity().checkConnectivity());
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
        if (isOpen) Navigator.of(Global().navigatorKey.currentContext!).pop();
      } else {
        isOnline = false;
        if (Global().navigatorKey.currentContext != null) {
          Global().navigatorKey.currentState!.pushNamed('/error');
          isOpen = true;
        }
      }
    } on SocketException catch (_) {
      isOnline = false;
      if (Global().navigatorKey.currentContext != null) {
        Global().navigatorKey.currentState!.pushNamed('/error');
        isOpen = true;
      }
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
