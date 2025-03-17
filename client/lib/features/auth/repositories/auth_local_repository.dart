import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_local_repository.g.dart';

@riverpod
AuthLocalRepository authLocalRepository(ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void setToken(String? token) {
    if (!isInitialized()) {
      print(
        "ERROR: SharedPreferences is not initialized when calling setToken!",
      );
      return;
    }

    if (token != null) {
      print("Saving token: $token");
      _sharedPreferences.setString('x-auth-token', token);
    }
  }

  bool isInitialized() {
    return _sharedPreferences != null;
  }

  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }
}
