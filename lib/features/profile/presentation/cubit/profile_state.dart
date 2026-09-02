import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../stations/domain/entities/station.dart';
import '../../domain/entities/profile_user.dart';

part 'profile_state.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.loading() = ProfileLoading;

  /// `isSaving` covers a name edit or picture upload in flight; `saveError`
  /// is a transient mutation failure the screen consumes via a
  /// `BlocListener` and clears — the already-loaded profile stays on
  /// screen rather than being replaced by a full failure state (T100/T103).
  const factory ProfileState.loaded({
    required ProfileUser user,
    required List<Station> stations,
    Uint8List? avatarBytes,
    @Default(false) bool isSaving,
    Failure? saveError,
  }) = ProfileLoaded;

  const factory ProfileState.failure(Failure failure) = ProfileFailureState;
}
