import 'package:contacts/core/resources/data_state.dart';
import 'package:contacts/features/contacts/data/model/user.dart';
import 'package:contacts/features/contacts/domain/entities/user.dart';
import 'package:contacts/features/contacts/domain/repository/users_repository.dart';
import 'package:dio/dio.dart';

import '../data_sources/remote/users_api_service.dart';

class UsersRepositoryImpl extends UsersRepository {
  final UsersApiService _apiService;
  UsersRepositoryImpl(this._apiService);

  @override
  Future<DataState<List<UserModel>>> getUsers({required int skip, required int take, required String search}) async {
    try {
      final response = await _apiService.getUsers(skip: skip, take: take, search: search);
      if(response.statusCode == 200){
        return DataSuccess(response.data!);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            type: DioExceptionType.badResponse,
            error: response.statusMessage,
            response: response,
          ),
        );
      }
    } on DioException catch(error){
      return DataFailed(error);
    }
  }

  @override
  Future<DataState<UserEntity>> createUser({required UserEntity userEntity}) async {
    try {
      final response = await _apiService.createUser(userModel: UserModel.fromEntity(userEntity));
      if(response.statusCode == 200){
        return DataSuccess(response.data!);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            type: DioExceptionType.badResponse,
            error: response.statusMessage,
            response: response,
          ),
        );
      }
    } on DioException catch(error){
      return DataFailed(error);
    }
  }

  @override
  Future<DataState<String>> uploadImage({required String imagePath}) async {
    try {
      final response = await _apiService.uploadProfileImage(imagePath: imagePath);
      if(response.statusCode == 200){
        return DataSuccess(response.data!);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            type: DioExceptionType.badResponse,
            error: response.statusMessage,
            response: response,
          ),
        );
      }
    } on DioException catch(error){
      return DataFailed(error);
    }
  }

  @override
  Future<DataState<UserEntity>> updateUser({required UserEntity userEntity}) async {
    try {
      final response = await _apiService.updateUser(userModel: UserModel.fromEntity(userEntity));
      if(response.statusCode == 200){
        return DataSuccess(response.data!);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            type: DioExceptionType.badResponse,
            error: response.statusMessage,
            response: response,
          ),
        );
      }
    } on DioException catch(error){
      return DataFailed(error);
    }
  }

  @override
  Future<DataState<bool>> deleteUser({required String id}) async {
    try {
      final response = await _apiService.deleteUser(id: id);
      if(response.statusCode == 200){
        return DataSuccess(response.data!);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            type: DioExceptionType.badResponse,
            error: response.statusMessage,
            response: response,
          ),
        );
      }
    } on DioException catch(error){
      return DataFailed(error);
    }
  }

}