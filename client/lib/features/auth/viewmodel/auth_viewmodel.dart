import 'package:client/features/auth/model/user_mode.dart';
import 'package:client/features/auth/repositories/auth_remote_repositories.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = AuthRemoteRepository();
    return null;
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
      fpdart.Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}
