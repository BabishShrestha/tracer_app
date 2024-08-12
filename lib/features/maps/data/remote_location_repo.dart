import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:tracer_app/features/maps/domain/user_location.dart';
import 'package:tracer_app/features/user/repositories/user_repo.dart';

abstract class LocationRepo {
  Stream<List<UserLocation>> getUserLocationHistory(); // Add this line
}

class LocationRepoImpl extends LocationRepo {
  LocationRepoImpl({
    required this.ref,
  });
  final Logger _logger = Logger('Location');
  Ref ref;

  @override
  Stream<List<UserLocation>> getUserLocationHistory() {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Location')
        .snapshots()
        .map(
          (event) => event.docChanges
              .map((e) => UserLocation.fromJson(e.doc.data()!))
              .toList(),
        );
  }
}
