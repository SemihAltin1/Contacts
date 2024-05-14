import 'package:contacts/core/resources/data_state.dart';
import 'package:contacts/core/usecase/usecase.dart';
import 'package:contacts/features/contacts/domain/entities/user.dart';

import '../repository/users_repository.dart';

class CreateUserUseCase implements UseCase<DataState<UserEntity>,CreateUserParams> {
  final UsersRepository _repository;
  CreateUserUseCase(this._repository);

  @override
  Future<DataState<UserEntity>> call(CreateUserParams params) {
    return _repository.createUser(userEntity: params.userEntity);
  }

}


class CreateUserParams {
  UserEntity userEntity;
  CreateUserParams({required this.userEntity});
}