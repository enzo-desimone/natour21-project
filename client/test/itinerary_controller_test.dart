import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:natour21/Controller/itinerary_controller.dart';
import 'package:path_provider/path_provider.dart';

class ItineraryControllerTest {
  Future<void> importGpxFileCE1() async {
    var result = await ItineraryController().convertGpxIntoClass(null);

    assert(result == false);
  }

  Future<void> importGpxFileCE2() async {
    final data = await rootBundle.load('assets/test/ce2.gpx');

    final directory = (await getTemporaryDirectory()).path;
    var temp =
        await File('$directory/ce2.gpx').writeAsBytes(data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));

    bool result = await ItineraryController().convertGpxIntoClass(temp);

    assert(result == false);
  }

  Future<void> importGpxFileCE3() async {
    final data = await rootBundle.load('assets/test/ce3.gpx');

    final directory = (await getTemporaryDirectory()).path;
    var temp =
        await File('$directory/ce3.gpx').writeAsBytes(data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));

    bool result = await ItineraryController().convertGpxIntoClass(temp);

    assert(result == false);
  }

  Future<void> importGpxFileCE4() async {
    final data = await rootBundle.load('assets/test/ce4.gpx');

    final directory = (await getTemporaryDirectory()).path;
    var temp =
        await File('$directory/ce4.gpx').writeAsBytes(data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));

    bool result = await ItineraryController().convertGpxIntoClass(temp);

    assert(result == true);
  }
}
