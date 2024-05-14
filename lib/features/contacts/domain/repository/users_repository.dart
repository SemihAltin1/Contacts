import 'package:contacts/features/contacts/domain/entities/user.dart';
import '../../../../core/resources/data_state.dart';

abstract class UsersRepository {
  Future<DataState<List<UserEntity>>> getUsers({required int skip, required int take, required String search});
  Future<DataState<UserEntity>> createUser({required UserEntity userEntity});
  Future<DataState<String>> uploadImage({required String imagePath});
  Future<DataState<UserEntity>> updateUser({required UserEntity userEntity});
  Future<DataState<bool>> deleteUser({required String id});
}