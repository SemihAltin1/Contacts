import 'package:contacts/core/resources/data_state.dart';
import 'package:contacts/core/usecase/usecase.dart';
import 'package:contacts/features/contacts/domain/repository/users_repository.dart';

class UploadImageUseCase implements UseCase<DataState<String>,UploadImageParams> {
  final UsersRepository _repository;
  UploadImageUseCase(this._repository);

  @override
  Future<DataState<String>> call(UploadImageParams params) {
    return _repository.uploadImage(imagePath: params.imagePath);
  }

}


class UploadImageParams {
  String imagePath;
  UploadImageParams({required this.imagePath});
}