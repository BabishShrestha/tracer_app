import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    String? id,
    String? email,
    @JsonKey(
      includeToJson: false,
    )
    String? password,
    String? name,
    List<String>? deviceToken,
    double? longitude,
    double? latitude,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
