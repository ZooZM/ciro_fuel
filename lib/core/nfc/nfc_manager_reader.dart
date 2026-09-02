import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform;
import 'package:flutter/services.dart' show PlatformException;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:nfc_manager/nfc_manager_ios.dart';

import 'nfc_reader.dart';

/// spec 008 research R5 — **the only file in the app that imports
/// `nfc_manager`**. Reads the tag's identifier only; never parses NDEF,
/// never writes.
///
/// Android exposes a single, tech-agnostic `NfcTagAndroid.id`. iOS has no
/// such generic accessor — each tag technology (MIFARE, ISO 7816, ISO
/// 15693, FeliCa) carries its own identifier field, so this tries each in
/// turn. `null` from every one of them (an unsupported tag, or an iOS
/// device without the paid-account entitlement) is read the same way by
/// the caller as "no card presented" — never a crash.
class NfcManagerReader implements NfcReader {
  @override
  Future<bool> isAvailable() async {
    final availability = await NfcManager.instance.checkAvailability();
    return availability == NfcAvailability.enabled;
  }

  @override
  Future<String?> readTagId() async {
    final completer = Completer<String?>();

    void finish(String? id) {
      if (!completer.isCompleted) completer.complete(id);
    }

    // Defensive: a session left open by an interrupted previous attempt
    // (an uncaught error, the app backgrounded mid-read, a hot restart)
    // makes iOS refuse a new one with `session_already_exists` — clear
    // it first. `stopSession()` already no-ops when nothing is active.
    await stopSession();

    try {
      await NfcManager.instance.startSession(
        // iso18092 (FeliCa) is deliberately NOT polled: iOS requires
        // `com.apple.developer.nfc.readersession.felica.systemcodes` in
        // Info.plist whenever it is, and without that key it refuses the
        // WHOLE session up-front with `readerErrorSecurityViolation`
        // ("Missing required entitlement") — no system NFC sheet, no read of
        // any kind, however correctly the app is signed. Truck cards are
        // 13.56MHz ISO 14443 (FR-004); FeliCa is a Japan-only transit/payment
        // family with no place in this fleet, so polling it bought nothing
        // and cost every tap.
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
        },
        onDiscovered: (tag) async {
          // Nothing thrown while reading a presented tag may escape: this
          // callback is invoked from the platform channel, so an escaping
          // error is merely "uncaught" — the session stays open and the
          // completer below never resolves, stranding the caller in its
          // reading state forever with no way back.
          String? id;
          try {
            id = _extractId(tag);
          } catch (e) {
            debugPrint('[NFC] could not read tag id: $e');
            id = null;
          }
          // TEMPORARY (manual test diagnostics).
          debugPrint('[NFC] tag discovered, extracted id: $id');
          await stopSession();
          finish(id);
        },
        onSessionErrorIos: (error) {
          // TEMPORARY (manual test diagnostics).
          debugPrint('[NFC] session error: ${error.code} ${error.message}');
          finish(null);
        },
      );
    } on PlatformException catch (e) {
      // TEMPORARY (manual test diagnostics).
      debugPrint('[NFC] startSession failed: ${e.code} ${e.message}');
      // Starting the session itself failed — there is nothing to await a
      // tag for. Previously this went uncaught, leaving `completer` (and
      // the cubit's `reading` state) stuck forever.
      finish(null);
    }

    return completer.future;
  }

  @override
  Future<void> stopSession() async {
    try {
      await NfcManager.instance.stopSession();
    } on PlatformException catch (e) {
      // iOS throws rather than no-op when nothing is active (e.g. the
      // screen closes before a tap ever starts a session) — this method's
      // own contract promises "safe to call even if none is active", so
      // that specific case is swallowed here rather than surfacing as an
      // uncaught error.
      if (e.code != 'no_active_sessions') rethrow;
    }
  }

  String? _extractId(NfcTag tag) {
    // The two platforms' accessors are NOT interchangeable, and the Android
    // one is not merely inert on iOS: each plugin declares its own
    // `TagPigeon`, and `NfcTagAndroid.from` casts to Android's without
    // checking, so on an iOS tag it THROWS rather than returning null —
    // killing the read at the moment a card is finally delivered. Branch on
    // the platform; never let one platform's accessor see the other's tag.
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidId = NfcTagAndroid.from(tag)?.id;
      return androidId == null ? null : _hex(androidId);
    }

    final mifare = MiFareIos.from(tag)?.identifier;
    if (mifare != null) return _hex(mifare);

    final iso7816 = Iso7816Ios.from(tag)?.identifier;
    if (iso7816 != null) return _hex(iso7816);

    final iso15693 = Iso15693Ios.from(tag)?.identifier;
    if (iso15693 != null) return _hex(iso15693);

    final felica = FeliCaIos.from(tag)?.currentIDm;
    if (felica != null) return _hex(felica);

    return null;
  }

  String _hex(Uint8List bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
}
