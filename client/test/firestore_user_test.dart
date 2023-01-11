import 'dart:io';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:natour21/Dao_Class/User-Admin/firestore_user.dart';
import 'package:path_provider/path_provider.dart';

class FireStoreUserTest {
  Future<void> updateAvatarCE1(FakeFirebaseFirestore mock) async {
    var result = await FireStoreUser(mock: mock).updateAvatar(null, null);
    assert(result == false);
  }

  Future<void> updateAvatarCE2(FakeFirebaseFirestore mock) async {
    final data = await rootBundle.load('assets/test/avatar.png');

    final directory = (await getTemporaryDirectory()).path;
    var temp = await File('$directory/avatar.png')
        .writeAsBytes(data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));

    var result = await FireStoreUser(mock: mock).updateAvatar(null, temp);

    assert(result == false);
  }

  Future<void> updateAvatarCE3(FakeFirebaseFirestore mock) async {
    var result = await FireStoreUser(mock: mock).updateAvatar('fabio', null);
    assert(result == false);
  }

  Future<void> updateAvatarCE4(FakeFirebaseFirestore mock) async {
    final data = await rootBundle.load('assets/test/avatar.png');

    final directory = (await getTemporaryDirectory()).path;
    var temp = await File('$directory/avatar.png')
        .writeAsBytes(data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));

    var result = await FireStoreUser(mock: mock).updateAvatar('fabio', temp);

    assert(result == false);
  }

  Future<void> updateAvatarCE5(FakeFirebaseFirestore mock) async {
    var result =
        await FireStoreUser(mock: mock).updateAvatar('andrea', null);
    assert(result == false);
  }

  Future<void> updateAvatarCE6(FakeFirebaseFirestore mock) async {
    final data = await rootBundle.load('assets/test/avatar.png');

    final directory = (await getTemporaryDirectory()).path;
    var temp = await File('$directory/avatar.png')
        .writeAsBytes(data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));

    var result =
        await FireStoreUser(mock: mock).updateAvatar('andrea', temp);

    assert(result == true);
  }
}
