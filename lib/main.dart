import 'dart:async';


import 'main_common.dart';

void main() async {
  unawaited(
    runZonedGuarded<Future<void>>(() async {
      unawaited(MainCommon());
    }, (Object error, StackTrace stack) {}),
  );
}
