import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpx/gpx.dart';
import 'package:natour21/Accessory_Class/global_variable.dart';
import 'package:natour21/Accessory_GUI/custom_dialog.dart';
import 'package:natour21/Dao_Class/Itinerary/postgres_itinerary.dart';
import 'package:natour21/Entity_Class/interest_point.dart';
import 'package:natour21/Entity_Class/itinerary.dart';
import 'package:natour21/Entity_Class/way_point_root.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class ItineraryController {
  ItineraryController._privateConstructor();

  static final ItineraryController _instance =
      ItineraryController._privateConstructor();

  factory ItineraryController() => _instance;

  Future<void> getItinerary() async {
    await PostgresItinerary().getItinerary();
  }

  Future<void> getMyItinerary() async {
    await PostgresItinerary().getMyItinerary();
  }

  Future<List> getRouteMarkers() async {
    Set<Marker> _markers = {};
    Set<Polyline> _polylines = {};

    var _startMarker = await getBitmapDescriptorFromAssetBytes(
        'assets/images/markers/start_marker.png', 110);

    var _endMarker = await getBitmapDescriptorFromAssetBytes(
        'assets/images/markers/end_marker.png', 110);

    if (Global().itinerary.route!.isNotEmpty) {
      for (int i = 0; i < Global().itinerary.route!.length; i++) {
        if (i == 0) {
          _markers.add(Marker(
            markerId: MarkerId(LatLng(Global().itinerary.route![0].phi,
                    Global().itinerary.route![0].lambda)
                .toString()),
            position: LatLng(Global().itinerary.route![0].phi,
                Global().itinerary.route![0].lambda),
            visible: true,
            icon: _startMarker,
          ));
        } else {
          _markers.add(Marker(
            markerId: MarkerId(LatLng(Global().itinerary.route![i].phi,
                    Global().itinerary.route![i].lambda)
                .toString()),
            position: LatLng(Global().itinerary.route![i].phi,
                Global().itinerary.route![i].lambda),
            visible: i == Global().itinerary.route!.length - 1 ? true : false,
            icon: _endMarker,
          ));
          _polylines.add(Polyline(
            polylineId: PolylineId(getRandomString(10)),
            visible: true,
            width: 4,
            patterns: [PatternItem.dash(40), PatternItem.gap(0)],
            points: [
              LatLng(Global().itinerary.route![i - 1].phi,
                  Global().itinerary.route![i - 1].lambda),
              LatLng(Global().itinerary.route![i].phi,
                  Global().itinerary.route![i].lambda),
            ],
            color: Colors.orange,
          ));
        }
      }
    }
    return [_markers, _polylines];
  }

  Future<Set<Marker>> getInterestPointMarkers() async {
    Set<Marker> _markers = {};
    if (Global().itinerary.interestPoint!.isNotEmpty) {
      for (int i = 0; i < Global().itinerary.interestPoint!.length; i++) {
        _markers.add(Marker(
          markerId: MarkerId(LatLng(Global().itinerary.interestPoint![i].phi,
                  Global().itinerary.interestPoint![i].lambda)
              .toString()),
          position: LatLng(Global().itinerary.interestPoint![i].phi,
              Global().itinerary.interestPoint![i].lambda),
          visible: true,
          infoWindow: InfoWindow(
            title: InterestPoint().getInterestPointTitle(
                (Global().itinerary.interestPoint![i].typology)),
            snippet: 'Clicca per eliminare',
          ),
          icon: await getBitmapDescriptorFromAssetBytes(
              'assets/images/markers/' +
                  Global().itinerary.interestPoint![i].typology.toString() +
                  '.png',
              110),
        ));
      }
    }
    return _markers;
  }

  Future<void> confirmRoute(Set<Marker> _markers) async {
    List<WayPointRoot> _temp = [];

    for (int i = 0; i < _markers.length; i++) {
      if (i == 0) {
        _temp.add(WayPointRoot(
            phi: _markers.elementAt(i).position.latitude,
            lambda: _markers.elementAt(i).position.longitude,
            isStart: true,
            isEnd: false));
      } else if (i == _markers.length - 1) {
        _temp.add(WayPointRoot(
            phi: _markers.elementAt(i).position.latitude,
            lambda: _markers.elementAt(i).position.longitude,
            isStart: false,
            isEnd: true));
      } else {
        _temp.add(WayPointRoot(
            phi: _markers.elementAt(i).position.latitude,
            lambda: _markers.elementAt(i).position.longitude,
            isStart: false,
            isEnd: false));
      }
    }

    Global().itinerary.setRoute(_temp);
  }

  Future<void> deleteRoute() async {
    Global().itinerary.setRoute([]);
  }

  Future<void> addItinerary(context) async {
    CustomAlertDialog.loadingScreen(context, null);
    if (await PostgresItinerary().addItinerary()) {
      Navigator.pop(context);
      Global().itinerary = Itinerary();
      await Global.analytics.logEvent(
        name: 'add_itinerary_event',
        parameters: <String, dynamic>{
          'user': Global().myUser.value.id,
        },
      );
      CustomAlertDialog(
          title: 'Congratulazioni',
          body: 'Hai inserito con successo il tuo itinerario.',
          titleConfirmButton: 'Chiudi',
          onPressConfirm: () {
            Navigator.of(Global().navigatorKey.currentContext!).pop();
            Navigator.pop(context);
          }).showCustomDialog(context);
    } else {
      Navigator.pop(context);
      CustomAlertDialog(
          title: 'Attenzione',
          body: 'Non è stato possibile aggiungere l\'itinerario.',
          titleConfirmButton: 'Chiudi',
          onPressConfirm: () {
            Navigator.of(Global().navigatorKey.currentContext!).pop();
          }).showCustomDialog(context);
    }
  }

  Future<bool> editItineraryRoute(BuildContext context) async {
    CustomAlertDialog.loadingScreen(context, null);
    if (await PostgresItinerary().editItinerary()) {
      Navigator.pop(context);
      return true;
    } else {
      Navigator.pop(context);
      return false;
    }
  }

  Future<void> deleteItinerary(context, int itineraryId) async {
    CustomAlertDialog.loadingScreen(context, null);
    if (await PostgresItinerary().deleteItinerary(itineraryId)) {
      Navigator.pop(context);
      Navigator.pop(context);
      await Global.analytics.logEvent(
        name: 'delete_itinerary_event',
        parameters: <String, dynamic>{
          'user': Global().myUser.value.id,
        },
      );
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<void> confirmInterestPoint(Set<Marker> _markers) async {
    List<InterestPoint> _temp = [];

    for (int i = 0; i < _markers.length; i++) {
      _temp.add(InterestPoint(
        phi: _markers.elementAt(i).position.latitude,
        lambda: _markers.elementAt(i).position.longitude,
        typology: InterestPoint()
            .getTypology(_markers.elementAt(i).infoWindow.title!),
      ));
    }

    Global().itinerary.setInterestPoint(_temp);
  }

  Future<void> exportGpx(List<WayPointRoot> _list, String itineraryName,
      BuildContext context) async {
    try {
      await Global.analytics.logEvent(
        name: 'export_gpx_event',
        parameters: <String, dynamic>{
          'user': Global().myUser.value.id,
        },
      );
      var gpx = Gpx();
      gpx.creator = "dart-gpx library";
      for (int i = 0; i < _list.length; i++) {
        gpx.wpts.add(Wpt(lat: _list[i].phi, lon: _list[i].lambda));
      }

      var gpxString = GpxWriter().asString(gpx, pretty: true);

      File _newFile;

      if (Global().howOS == 'ios') {
        _newFile = File((await getApplicationDocumentsDirectory()).path +
            '/' +
            itineraryName +
            '.gpx');
      } else {
        _newFile = File((await getExternalStorageDirectories(
                    type: StorageDirectory.downloads))!
                .first
                .path +
            '/' +
            itineraryName +
            '.gpx');
      }

      await _newFile.writeAsString(gpxString);
      String path = _newFile.path;
      await Global.analytics.logEvent(
        name: 'export_itinerary_event',
        parameters: <String, dynamic>{
          'user': Global().myUser.value.id,
        },
      );
      CustomAlertDialog(
          title: 'Congratulazioni',
          body:
              'Il percorso dell\'itinerario è stato correttamente esportato in formato gpx. Premi directory per visualizzare la cartella di salvataggio.',
          titleConfirmButton: 'Chiudi',
          titleDeclineButton: 'Directory',
          declineButton: true,
          onPressDecline: () => CustomAlertDialog(
                  title: 'Directory',
                  body: path,
                  titleConfirmButton: 'Chiudi',
                  onPressConfirm: () => Navigator.of(context).pop())
              .showCustomDialog(context),
          onPressConfirm: () =>
              Navigator.of(context).pop()).showCustomDialog(context);
    } catch (_) {
      CustomAlertDialog(
          title: 'Errore',
          body: 'Non è stato possibile esportare il percorso in formato gpx.',
          titleConfirmButton: 'Chiudi',
          onPressConfirm: () =>
              Navigator.of(context).pop()).showCustomDialog(context);
    }
  }

  Future<bool> convertGpxIntoClass(File? file) async {
    Gpx gpx;

    if (file == null) {
      return false;
    }
    final fileString = await file.readAsString();

    try {
      gpx = GpxReader().fromString(fileString);
    } catch (_) {
      return false;
    }

    int rCount = 0;
    int tCount = 0;
    int wCount = 0;

    if (gpx.rtes.isNotEmpty) {
      for (int i = 0; i < gpx.rtes.length; i++) {
        for (int j = 0; j < gpx.rtes[i].rtepts.length; j++) {
          rCount = 1;
          Global().itinerary.route!.add(
                WayPointRoot(
                    phi: gpx.rtes[i].rtepts[j].lat,
                    lambda: gpx.rtes[i].rtepts[j].lon,
                    isStart: j == 0 ? true : false,
                    isEnd: j == gpx.rtes[i].rtepts.length - 1 ? true : false),
              );
        }
      }
    } else if (gpx.trks.isNotEmpty) {
      for (int i = 0; i < gpx.trks.length; i++) {
        for (int j = 0; j < gpx.trks[i].trksegs.length; j++) {
          for (int z = 0; z < gpx.trks[i].trksegs[j].trkpts.length; z++) {
            tCount = 1;
            Global().itinerary.route!.add(WayPointRoot(
                phi: gpx.trks[i].trksegs[j].trkpts[z].lat,
                lambda: gpx.trks[i].trksegs[j].trkpts[z].lon,
                isStart: z == 0 ? true : false,
                isEnd: z == gpx.trks[i].trksegs[j].trkpts.length - 1
                    ? true
                    : false));
          }
        }
      }
    } else {
      for (int i = 0; i < gpx.wpts.length; i++) {
        wCount = 1;
        Global().itinerary.route!.add(WayPointRoot(
            phi: gpx.wpts[i].lat,
            lambda: gpx.wpts[i].lon,
            isStart: i == 0 ? true : false,
            isEnd: i == gpx.wpts.length - 1 ? true : false));
      }
    }
    if (rCount == 0 && tCount == 0 && wCount == 0) {
      return false;
    }
    return true;
  }

  Future<void> importGpx(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        if (await convertGpxIntoClass(File(result.files.single.path!))) {
          CustomAlertDialog(
            barrierDismissible: false,
            declineButton: false,
            title: 'Attenzione',
            body:
                'Non è stato possibile caricare il file gpx, controlla il formato e la correttezza del file',
            titleConfirmButton: 'Ok',
            onPressConfirm: () {
              Navigator.pop(context);
            },
          ).showCustomDialog(context);
        }
      }
    } catch (_) {
      CustomAlertDialog(
        barrierDismissible: false,
        declineButton: false,
        title: 'Attenzione',
        body:
            'Non è possibile utilizzare questa funzionalità senza aver dato i permessi di storage',
        titleConfirmButton: 'Ok',
        onPressConfirm: () {
          Navigator.pop(context);
        },
      ).showCustomDialog(context);
    }
  }

  Future<void> exportPdf(Itinerary itinerary, BuildContext context) async {
    try {
      final pdf = pw.Document();
      final byteData = await rootBundle.load('assets/images/first.png');
      final file = File((await getTemporaryDirectory()).path + 'temp.png');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      final image = pw.MemoryImage(
        file.readAsBytesSync(),
      );
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(mainAxisSize: pw.MainAxisSize.max, children: [
                pw.Image(image, width: 100, height: 100),
                pw.Text('NaTour21',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.SizedBox(height: 20),
                pw.Text(itinerary.name!.capitalizeFirstOfEach,
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.normal)),
                pw.SizedBox(height: 6),
                if (itinerary.description!.isNotEmpty)
                  pw.Text(itinerary.description!,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                      )),
                pw.SizedBox(height: 20),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                          'Difficoltà: ' +
                              Itinerary().getLevelTitle(itinerary.level!),
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.normal,
                          )),
                      pw.SizedBox(width: 10),
                      pw.Text(
                          'Durata: ' +
                              itinerary.deltaTime.toString() +
                              ' minuti',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.normal,
                          )),
                      pw.SizedBox(width: 10),
                      pw.Text(
                          'Distanza: ' + itinerary.distance.toString() + 'km',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.normal,
                          )),
                    ]),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                          'Presenta un tracciato Geografico?' +
                              (itinerary.route!.isNotEmpty ? ' (SI)' : ' (NO)'),
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.normal,
                          )),
                      pw.SizedBox(width: 10),
                      pw.Text(
                          'Presenta uno o più Punti di Interesse?' +
                              (itinerary.interestPoint!.isNotEmpty
                                  ? ' (SI)'
                                  : ' (NO)'),
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.normal,
                          )),
                    ]),
                pw.SizedBox(height: 20),
                if (itinerary.interestPoint!.isNotEmpty)
                  pw.Column(children: [
                    pw.Text('Punti di Interesse:',
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.SizedBox(height: 5),
                    pw.ListView.builder(
                      itemCount: itinerary.interestPoint!.length,
                      itemBuilder: (context, int index) {
                        return pw.Text(
                            InterestPoint().getInterestPointTitle(
                                itinerary.interestPoint![index].typology),
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.normal,
                            ));
                      },
                    )
                  ])
              ]),
            ); // Center
          }));

      File _newFile;

      if (Global().howOS == 'ios') {
        _newFile = File((await getApplicationDocumentsDirectory()).path +
            '/' +
            'Riepilogo-' +
            itinerary.name!.capitalizeFirstOfEach +
            '.pdf');
      } else {
        _newFile = File((await getExternalStorageDirectories(
                    type: StorageDirectory.downloads))!
                .first
                .path +
            '/' +
            'Riepilogo-' +
            itinerary.name!.capitalizeFirstOfEach +
            '.pdf');
      }

      await _newFile.writeAsBytes(await pdf.save());
      String path = _newFile.path;
      CustomAlertDialog(
          title: 'Congratulazioni',
          body:
              'I dettagli dell\'itinerario sono stati correttamente esportati in formato pdf. Premi directory per visualizzare la cartella di salvataggio.',
          titleConfirmButton: 'Chiudi',
          titleDeclineButton: 'Directory',
          declineButton: true,
          onPressDecline: () => CustomAlertDialog(
                  title: 'Directory',
                  body: path,
                  titleConfirmButton: 'Chiudi',
                  onPressConfirm: () => Navigator.of(context).pop())
              .showCustomDialog(context),
          onPressConfirm: () =>
              Navigator.of(context).pop()).showCustomDialog(context);
    } catch (_) {
      CustomAlertDialog(
          title: 'Errore',
          body:
              'Non è stato possibile esportare i dettagli dell\'itinerario in formato pdf.',
          titleConfirmButton: 'Chiudi',
          onPressConfirm: () =>
              Navigator.of(context).pop()).showCustomDialog(context);
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }
}
