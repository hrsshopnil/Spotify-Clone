import 'package:client/features/auth/model/user_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_user_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  UserModel? build() {
    return null;
  }

  void addUser(UserModel user) {
    state = user;
  }
}
