import 'package:contacts/features/contacts/data/model/user.dart';
import 'package:dio/dio.dart';

abstract class UsersApiService {
  Future<Response<List<UserModel>>> getUsers({required int skip, required int take, required String search});
  Future<Response<UserModel>> createUser({required UserModel userModel});
  Future<Response<String>> uploadProfileImage({required String imagePath});
  Future<Response<UserModel>> updateUser({required UserModel userModel});
  Future<Response<bool>> deleteUser({required String id});
}