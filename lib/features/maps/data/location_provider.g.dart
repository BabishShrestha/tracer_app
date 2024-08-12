// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationHash() => r'3b9f331ba253538d0e066c17eb2f54309973e0ef';

/// See also [location].
@ProviderFor(location)
final locationProvider = AutoDisposeProvider<LocationRepoImpl>.internal(
  location,
  name: r'locationProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$locationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocationRef = AutoDisposeProviderRef<LocationRepoImpl>;
String _$locationStreamHash() => r'747719e1158713cc0feffb91cc81486e93001f0c';

/// See also [locationStream].
@ProviderFor(locationStream)
final locationStreamProvider =
    AutoDisposeStreamProvider<List<UserLocation>>.internal(
  locationStream,
  name: r'locationStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocationStreamRef = AutoDisposeStreamProviderRef<List<UserLocation>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
