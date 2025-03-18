import 'dart:convert';

import 'package:client/core/constants/constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_mode.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final respose = await http.post(
        Uri.parse('${ServerConstant.serverURL}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final resBody = json.decode(respose.body);
      if (respose.statusCode == 200) {
        return Right(
          UserModel.fromMap(resBody['user']).copyWith(token: resBody['token']),
        );
      } else {
        return Left(Failure(resBody['detail']));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final respose = await http.post(
        Uri.parse('${ServerConstant.serverURL}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );
      final resBody = json.decode(respose.body);
      if (respose.statusCode == 201) {
        return Right(UserModel.fromMap(resBody));
      } else {
        return Left(Failure(resBody['detail']));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> getCurrentUser({
    required String token,
  }) async {
    try {
      final respose = await http.get(
        Uri.parse('${ServerConstant.serverURL}/auth'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      final resBody = json.decode(respose.body);
      if (respose.statusCode == 200) {
        return Right(UserModel.fromMap(resBody).copyWith(token: token));
      } else {
        return Left(Failure(resBody['detail']));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
