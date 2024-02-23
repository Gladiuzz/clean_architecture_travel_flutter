import 'package:connectivity_plus/connectivity_plus.dart';

// cek koneksi internet
abstract class NetworkInfo {
  Future<bool> isConnected();
}

class NetworkInfoImplementation implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImplementation({required this.connectivity});

  @override
  Future<bool> isConnected() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      return true;
    }
    return false;
  }
}
