import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/current_avatar.dart';

import '../../../stations/domain/entities/station.dart';
import '../../../stations/domain/usecases/get_stations.dart';
import '../../domain/usecases/download_avatar.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_full_name.dart';
import '../../domain/usecases/upload_profile_picture.dart';
import 'profile_state.dart';

/// One instance per screen visit (spec 005 T099), like `InvoicesCubit`/
/// `CreditCubit` — profile data isn't cached across the session, so a
/// factory registration (not a lazy singleton) is right here.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required String userId,
    required GetProfile getProfile,
    required GetStations getStations,
    required UpdateFullName updateFullName,
    required UploadProfilePicture uploadProfilePicture,
    required DownloadAvatar downloadAvatar,
  }) : _userId = userId,
       _getProfile = getProfile,
       _getStations = getStations,
       _updateFullName = updateFullName,
       _uploadProfilePicture = uploadProfilePicture,
       _downloadAvatar = downloadAvatar,
       super(const ProfileState.loading());

  final String _userId;
  final GetProfile _getProfile;
  final GetStations _getStations;
  final UpdateFullName _updateFullName;
  final UploadProfilePicture _uploadProfilePicture;
  final DownloadAvatar _downloadAvatar;

  Future<void> load() async {
    emit(const ProfileState.loading());
    final result = await _getProfile(_userId);
    await result.fold(
      (failure) async => emit(ProfileState.failure(failure)),
      (user) async {
        final stationsResult = await _getStations();
        final stations = stationsResult.fold(
          (_) => const <Station>[],
          (s) => s,
        );
        final avatarBytes = await _loadAvatar(user.profilePictureFileId);
        // The app bar reads this on every screen; publishing here keeps it
        // in step without a second download.
        CurrentAvatar.publish(avatarBytes);
        emit(
          ProfileState.loaded(
            user: user,
            stations: stations,
            avatarBytes: avatarBytes,
          ),
        );
      },
    );
  }

  Future<Uint8List?> _loadAvatar(String? fileId) async {
    if (fileId == null) return null;
    final result = await _downloadAvatar(fileId);
    return result.fold((_) => null, Uint8List.fromList);
  }

  Future<bool> updateFullName(String fullName) async {
    final current = state;
    if (current is! ProfileLoaded) return false;

    emit(current.copyWith(isSaving: true, saveError: null));
    final result = await _updateFullName(_userId, fullName);
    return result.fold(
      (failure) {
        emit(current.copyWith(isSaving: false, saveError: failure));
        return false;
      },
      (user) {
        emit(current.copyWith(user: user, isSaving: false));
        return true;
      },
    );
  }

  Future<bool> uploadProfilePicture(String filePath) async {
    final current = state;
    if (current is! ProfileLoaded) return false;

    emit(current.copyWith(isSaving: true, saveError: null));
    final result = await _uploadProfilePicture(_userId, filePath);
    return result.fold(
      (failure) async {
        emit(current.copyWith(isSaving: false, saveError: failure));
        return false;
      },
      (user) async {
        final avatarBytes = await _loadAvatar(user.profilePictureFileId);
        // A fresh upload must reach the app bar too, not just this screen.
        CurrentAvatar.publish(avatarBytes);
        emit(
          current.copyWith(
            user: user,
            avatarBytes: avatarBytes,
            isSaving: false,
          ),
        );
        return true;
      },
    );
  }

  /// Called by the screen once [ProfileLoaded.saveError] has been shown.
  void clearSaveError() {
    final current = state;
    if (current is ProfileLoaded && current.saveError != null) {
      emit(current.copyWith(saveError: null));
    }
  }
}
