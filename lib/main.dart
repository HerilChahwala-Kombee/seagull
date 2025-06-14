import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seagull/i10/app_localizations.dart';

import 'main_common.dart';

void main() async {
  unawaited(
    runZonedGuarded<Future<void>>(() async {
      unawaited(MainCommon());
    }, (Object error, StackTrace stack) {}),
  );
}
