import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushEventBus {
  PushEventBus._();

  static final StreamController<RemoteMessage> _controller =
  StreamController<RemoteMessage>.broadcast();

  static Stream<RemoteMessage> get stream => _controller.stream;

  static void emit(RemoteMessage message) {
    if (!_controller.isClosed) {
      _controller.add(message);
    }
  }
}