import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/app_notification.dart';

part 'notifications_state.freezed.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.loading() = NotificationsLoading;
  const factory NotificationsState.loaded(List<AppNotification> notifications) =
      NotificationsLoaded;
  const factory NotificationsState.failure(Failure failure) = NotificationsFailureState;
}
