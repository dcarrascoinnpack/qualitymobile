import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkModeService {
  Future<bool> shouldUseOfflineMode() async {
    final connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    }

    if (connectivityResult == ConnectivityResult.none) {
      return true;
    }

    return false;
  }
}
