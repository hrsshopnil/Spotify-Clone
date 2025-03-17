import 'package:client/features/auth/model/user_mode.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return null;
  }

  Future<void> initSharedPrference() async {
    print("Initializing SharedPreferences...");
    await _authLocalRepository.init();
    print("Initialized SharedPreferences...");
  }

  Future<void> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (res) {
      fpdart.Left(value: final l) =>
        state = AsyncValue.error(l.toString(), StackTrace.current),
      fpdart.Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );
    final val = switch (res) {
      fpdart.Left(value: final l) =>
        state = AsyncValue.error(l.toString(), StackTrace.current),
      fpdart.Right(value: final r) => state = _loginSuccess(r),
    };
    print(val);
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    if (_authLocalRepository.getToken() == null) {
      print(
        "ERROR: Trying to set token before SharedPreferences is initialized!",
      );
      return AsyncValue.error(
        "SharedPreferences not initialized",
        StackTrace.current,
      );
    }

    print("Saving token: ${user.token}");
    _authLocalRepository.setToken(user.token);
    return AsyncValue.data(user);
  }

  // Future<UserModel?> getUser() async {
  //   state = const AsyncValue.loading();
  //   final token = await _authLocalRepository.getToken();
  //   if (token == null) {
  //     throw Exception('Token not found');
  //   }
  //final res = await _authRemoteRepository.getUser(token);
  //return res;
  //}
}
