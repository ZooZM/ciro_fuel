import 'package:easy_localization/easy_localization.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../shared/enums/session_revocation_cause.dart';

/// Maps a `SessionRevocationCause` wire value (as carried on the
/// `session:revoked` socket push and the `SESSION_REVOKED` HTTP response's
/// `cause` field) to its translation key — a pure function so the mapping
/// itself is testable without a localization harness (mirrors
/// `passwordResetFailureMessageKey`'s shape).
String sessionRevocationMessageKey(String? causeWire) =>
    switch (SessionRevocationCause.fromWire(causeWire)) {
      SessionRevocationCause.signedInElsewhere => SessionKeys.signedInElsewhere,
      SessionRevocationCause.passwordReset => SessionKeys.passwordReset,
      SessionRevocationCause.accountDeactivated => SessionKeys.accountDeactivated,
      null => SessionKeys.ended,
    };

/// Resolves the key above to real, localized copy.
String sessionRevocationMessage(String? causeWire) =>
    sessionRevocationMessageKey(causeWire).tr();
