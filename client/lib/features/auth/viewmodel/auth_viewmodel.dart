import 'package:client/core/providers/current_user_provider.dart';
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
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPrference() async {
    await _authLocalRepository.init();
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
    final _ = switch (res) {
      fpdart.Left(value: final l) =>
        state = AsyncValue.error(l.toString(), StackTrace.current),
      fpdart.Right(value: final r) => state = AsyncValue.data(r),
    };
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
    final _ = switch (res) {
      fpdart.Left(value: final l) =>
        state = AsyncValue.error(l.toString(), StackTrace.current),
      fpdart.Right(value: final r) => state = _loginSuccess(r),
    };
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getUser() async {
    state = const AsyncValue.loading();
    final token = await _authLocalRepository.getToken();
    if (token == null) {
      state = AsyncValue.data(
        UserModel(name: '', email: '', id: '', token: ''),
      );
      return null;
    }
    final res = await _authRemoteRepository.getCurrentUser(token: token);
    final val = switch (res) {
      fpdart.Left(value: final l) =>
        state = AsyncValue.error(l.message.toString(), StackTrace.current),
      fpdart.Right(value: final r) => state = _getDataSuccess(r),
    };
    return val.value;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
