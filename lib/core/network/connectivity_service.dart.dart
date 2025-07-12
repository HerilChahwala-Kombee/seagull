// This file can be used for global network configuration, such as timeouts, base URLs, or other shared settings.
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;
  bool _isConnected = true;

  ConnectivityService() {
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final isConnected = result != ConnectivityResult.none;
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      _connectionController.add(isConnected);
    }
  }

  bool get isConnected => _isConnected;

  void dispose() {
    _connectionController.close();
  }
}
