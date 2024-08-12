import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tracer_app/features/maps/data/remote_location_repo.dart';
import 'package:tracer_app/features/maps/domain/user_location.dart';

part 'location_provider.g.dart';

@riverpod
LocationRepoImpl location(Ref ref) {
  return LocationRepoImpl(ref: ref);
}

@riverpod
Stream<List<UserLocation>> locationStream(Ref ref) {
  final locationRepository = ref.read(locationProvider);
  return locationRepository.getUserLocationHistory();
}
