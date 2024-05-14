import 'package:contacts/core/resources/data_state.dart';
import 'package:contacts/core/usecase/usecase.dart';
import 'package:contacts/features/contacts/domain/repository/users_repository.dart';

class DeleteUserUseCase implements UseCase<DataState<bool>,DeleteUserParams> {
  final UsersRepository _repository;
  DeleteUserUseCase(this._repository);

  @override
  Future<DataState<bool>> call(DeleteUserParams params) {
    return _repository.deleteUser(id: params.id);
  }

}

class DeleteUserParams {
  String id;
  DeleteUserParams({required this.id});
}