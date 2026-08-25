import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> hasConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none && connectivityResult != ConnectivityResult.bluetooth;
  }

  static Future<http.Response> sendHttpRequest(bool useGet, String url) async {
    if (useGet) {
      return await http.get(Uri.parse(url));
    } else {
      return await http.head(Uri.parse(url));
    }
  }
}
