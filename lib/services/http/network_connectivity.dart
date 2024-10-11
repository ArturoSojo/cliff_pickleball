import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/utils/utils.dart';

part 'network_connectivity.g.dart';

class NetworkConnectivity {
  final _logger = Logger();

  NetworkConnectivity._();

  static final _instance = NetworkConnectivity._();

  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  StreamController<NetworkState> _controller =
      StreamController<NetworkState>.broadcast();

  Stream<NetworkState> get stream => _controller.stream;

  void initialise() async {
    var result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    if (_controller.isClosed) {
      _controller = StreamController<NetworkState>.broadcast();
    }

    _networkConnectivity.onConnectivityChanged.listen((result) {
      if (!_controller.isClosed) {
        _checkStatus(result);
      }
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    var isOnline = false;
    var beforeLookup = DateTime.now();
    if (result != ConnectivityResult.none) {
      try {
        final result = await InternetAddress.lookup(MyUtils.base);
        isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        isOnline = false;
      }
    }
    var afterLookup = DateTime.now();
    var difference = afterLookup.difference(beforeLookup);

    _logger.d("Lookup duration $difference RESULT $result $isOnline");
    _controller.sink.add(NetworkState(result, isOnline));
  }

  void close() {
    _logger.i("CLOSE");
    if (_controller != null && !_controller.isClosed) {
      _controller.close();
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class NetworkState {
  ConnectivityResult result;
  bool isOnline;

  NetworkState(this.result, this.isOnline);

  factory NetworkState.fromJson(Map<String, dynamic> json) =>
      _$NetworkStateFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkStateToJson(this);
}
