import 'package:contacts/core/constant/contants.dart';
import 'package:contacts/features/contacts/data/data_sources/remote/users_api_service.dart';
import 'package:contacts/features/contacts/data/model/user.dart';
import 'package:dio/dio.dart';


class UsersApiServiceImpl extends UsersApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseApiUrl,
      headers: {
        "ApiKey": apiKey,
        "accept": "text/plain",
      }
    )
  );

  @override
  Future<Response<List<UserModel>>> getUsers({required int skip, required int take, required String search}) async {
    final result = await dio.get(
      "/api/User",
      queryParameters: {
        "skip": skip,
        "take": take,
        "search": search,
      },
    );
    final List<UserModel> value = result.data["data"]["users"].map<UserModel>((e) => UserModel.fromJson(e)).toList();
    return Response(data: value, requestOptions: result.requestOptions, statusCode: result.statusCode);
  }

  @override
  Future<Response<UserModel>> createUser({required UserModel userModel}) async {
    final Map<String,dynamic> data = {
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
      "phoneNumber": userModel.phoneNumber,
      "profileImageUrl": userModel.profileImageUrl!.isEmpty ? null : userModel.profileImageUrl
    };
    final Map<String,String> headers = {
      "ApiKey": apiKey,
      "accept": "text/plain",
      "Content-Type": "application/json"
    };
    final result = await dio.post(
      "/api/User",
      data: data,
      options: Options(
        headers: headers,
      ),
    );
    final UserModel value = UserModel.fromJson(result.data["data"]);
    return Response(data: value, requestOptions: result.requestOptions, statusCode: result.statusCode);
  }

  @override
  Future<Response<String>> uploadProfileImage({required String imagePath}) async {
    final data = FormData.fromMap({
      "image": await MultipartFile.fromFile(imagePath, filename: "image")
    });
    final Map<String,String> headers = {
      "ApiKey": apiKey,
      "accept": "text/plain",
      "Content-Type": "multipart/form-data"
    };
    final result = await dio.post(
      "/api/User/UploadImage",
      data: data,
      options: Options(
        headers: headers,
      ),
    );
    final String imageUrl = result.data["data"]["imageUrl"];
    return Response(data: imageUrl, requestOptions: result.requestOptions, statusCode: result.statusCode);
  }

  @override
  Future<Response<UserModel>> updateUser({required UserModel userModel}) async {
    final Map<String,dynamic> data = {
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
      "phoneNumber": userModel.phoneNumber,
      "profileImageUrl": userModel.profileImageUrl!.isEmpty ? null : userModel.profileImageUrl
    };
    final Map<String,String> headers = {
      "ApiKey": apiKey,
      "accept": "text/plain",
      "Content-Type": "application/json"
    };
    final result = await dio.put(
      "/api/User/${userModel.id}",
      data: data,
      options: Options(
        headers: headers,
      ),
    );
    final UserModel value = UserModel.fromJson(result.data["data"]);
    return Response(data: value, requestOptions: result.requestOptions, statusCode: result.statusCode);
  }

  @override
  Future<Response<bool>> deleteUser({required String id}) async {
    final Map<String,String> headers = {
      "ApiKey": apiKey,
      "accept": "text/plain",
      "Content-Type": "application/json"
    };
    final result = await dio.delete(
      "/api/User/$id",
      options: Options(
        headers: headers,
      ),
    );
    final bool value = result.data["success"];
    return Response(data: value, requestOptions: result.requestOptions, statusCode: result.statusCode);
  }

}