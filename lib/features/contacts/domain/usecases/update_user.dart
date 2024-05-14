import 'package:contacts/core/resources/data_state.dart';
import 'package:contacts/core/usecase/usecase.dart';
import 'package:contacts/features/contacts/domain/entities/user.dart';
import 'package:contacts/features/contacts/domain/repository/users_repository.dart';

class UpdateUserUseCase implements UseCase<DataState<UserEntity>,UpdateUserParams> {
  final UsersRepository _repository;
  UpdateUserUseCase(this._repository);

  @override
  Future<DataState<UserEntity>> call(UpdateUserParams params) {
    return _repository.updateUser(userEntity: params.userEntity);
  }

}

class UpdateUserParams {
  final UserEntity userEntity;
  UpdateUserParams({required this.userEntity});
}