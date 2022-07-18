import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:natour21/Controller/itinerary_controller.dart';
import 'package:natour21/Controller/search_statistics_controller.dart';
import 'package:provider/provider.dart';
import '../Admin_Tab_GUI/admin_home_tab.dart';
import 'global_variable.dart';
import 'json_convert.dart';

class WebSocketPostgres {
  static final WebSocketPostgres _singleton = WebSocketPostgres._internal();

  StreamController<String> streamController =
      StreamController.broadcast(sync: true);

  late String wsUrl;

  final String _host = 'natour21.soc.besimsoft.cloud';
  final String _port = '3000';

  late WebSocket channel;
  var isOpen = false;

  factory WebSocketPostgres() {
    return _singleton;
  }

  WebSocketPostgres._internal() {
    wsUrl = 'wss://' + _host + ':' + _port;
    initWebSocketConnection();
  }

  initWebSocketConnection() async {
    //print("connecting...");
    channel = await connectWs();
    //print("socket connection initialized");
    if (isOpen) {
      isOpen = false;
      Navigator.of(Global().navigatorKey.currentContext!).pop();
    }
    channel.done.then((dynamic _) => _onDisconnected());
    broadcastNotifications();
  }

  broadcastNotifications() async {
    channel.listen((message) async {
      var temp = JsonConvert.fromJson(json.decode(message));
      if (temp.table == 'itinerary' ||
          temp.table == 'way_point_route' ||
          temp.table == 'interest_point' ||
          temp.table == 'review') {
        ItineraryController().getMyItinerary();
        ItineraryController().getItinerary();
        Global()
            .navigatorKey
            .currentContext!
            .read<ItineraryCategory>()
            .reloadItinerary();
      } else if (temp.table == 'search_statistics' ||
          temp.table == 'filter_search_statistics') {
        SearchStatisticsController().getSearchStats();
      }
    }, onDone: () {
      if (!isOpen) {
        isOpen = true;
        Global().navigatorKey.currentState!.pushNamed('/error');
      }
      print("connecting aborted");
      initWebSocketConnection();
    }, onError: (e) {
      if (!isOpen) {
        isOpen = true;
        Global().navigatorKey.currentState!.pushNamed('/error');
      }
      print('Server error: $e');
      initWebSocketConnection();
    });
  }

  connectWs() async {
    try {
      return await WebSocket.connect(wsUrl);
    } catch (e) {
      //print("Error! can not connect WS connectWs " + e.toString());
      if (!isOpen) {
        isOpen = true;
        Global().navigatorKey.currentState!.pushNamed('/error');
      }
      await Future.delayed(const Duration(milliseconds: 10000));
      return await connectWs();
    }
  }

  void _onDisconnected() {
    channel.close();
    streamController.close();
  }
}
