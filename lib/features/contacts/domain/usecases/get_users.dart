import 'package:contacts/core/resources/data_state.dart';
import 'package:contacts/core/usecase/usecase.dart';
import 'package:contacts/features/contacts/domain/entities/user.dart';
import 'package:contacts/features/contacts/domain/repository/users_repository.dart';

class GetUsersUseCase implements UseCase<DataState<List<UserEntity>>, GetUsersParams> {
  final UsersRepository _repository;
  GetUsersUseCase(this._repository);

  @override
  Future<DataState<List<UserEntity>>> call(GetUsersParams params) {
    return _repository.getUsers(skip: params.skip, take: params.take, search: params.search);
  }

}


class GetUsersParams {
  int skip;
  int take;
  String search;
  GetUsersParams({required this.skip, required this.take, required this.search});
}