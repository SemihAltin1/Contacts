import 'package:contacts/features/contacts/data/repository/users_repository_impl.dart';
import 'package:contacts/features/contacts/domain/entities/user.dart';
import 'package:contacts/features/contacts/domain/usecases/create_user.dart';
import 'package:contacts/features/contacts/domain/usecases/delete_user.dart';
import 'package:contacts/features/contacts/domain/usecases/updaload_image.dart';
import 'package:contacts/features/contacts/domain/usecases/update_user.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/data_sources/remote/users_api_service_impl.dart';
import '../../domain/usecases/get_users.dart';

class UserController extends GetxController {
  late UsersDelegate delegate;

  ///UseCases
  final GetUsersUseCase _getUsersUseCase = GetUsersUseCase(UsersRepositoryImpl(UsersApiServiceImpl()));
  final UploadImageUseCase _uploadImageUseCase = UploadImageUseCase(UsersRepositoryImpl(UsersApiServiceImpl()));
  final CreateUserUseCase _createUserUseCase = CreateUserUseCase(UsersRepositoryImpl(UsersApiServiceImpl()));
  final UpdateUserUseCase _updateUserUseCase = UpdateUserUseCase(UsersRepositoryImpl(UsersApiServiceImpl()));
  final DeleteUserUseCase _deleteUserUseCase = DeleteUserUseCase(UsersRepositoryImpl(UsersApiServiceImpl()));

  ///Get Users
  int skip = 0;
  int take = 10;
  bool isPaginationLoading = false;
  var users = <UserEntity>[].obs;
  Future<void> getUsers(String search, {required bool isReset,}) async {
    isPaginationLoading  = true;
    if(isReset){
      skip = 0;
    }else {
      skip = skip + 10;
    }
    final GetUsersParams param  = GetUsersParams(skip: skip, take: take, search: search);
    final dataState = await _getUsersUseCase.call(param);
    if(dataState.data!=null) {
      if(isReset){
        users.value = dataState.data!;
      }else{
        users.addAll(dataState.data!);
      }

    } else if(dataState.error != null) {
      delegate.notify(UsersPageSituations.error);
    }
    isPaginationLoading  = false;
  }


  ///Create && Update User
  ImagePicker imagePicker = ImagePicker();
  var selectedImage = "".obs;
  var isEditActive = false.obs;
  var selectedUser = const UserEntity().obs;
  Future<void> uploadProfileImage(String imagePath) async {
    final UploadImageParams params = UploadImageParams(imagePath: imagePath);
    final dataState = await _uploadImageUseCase.call(params);
    if(dataState.data != null){
      selectedImage.value = dataState.data!;
    } else if(dataState.error != null){
      delegate.notify(UsersPageSituations.error);
    }
  }
  Future<void> createUser({required String firstName, required String lastName, required String phoneNumber}) async {
    final UserEntity userEntity = UserEntity(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      profileImageUrl: selectedImage.value,
    );
    final CreateUserParams params = CreateUserParams(userEntity: userEntity);
    final dataState = await _createUserUseCase.call(params);
    if(dataState.data != null){
      selectedUser.value = dataState.data!;
      isEditActive.value = false;
      users.add(dataState.data!);
      delegate.notify(UsersPageSituations.userCreated);
    } else if(dataState.error != null){
      delegate.notify(UsersPageSituations.error);
    }
  }
  Future<void> updateUser({required String firstName, required String lastName, required String phoneNumber}) async {
    final UserEntity userEntity = UserEntity(
      id: selectedUser.value.id,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      profileImageUrl: selectedImage.value,
    );
    final UpdateUserParams params = UpdateUserParams(userEntity: userEntity);
    final dataState = await _updateUserUseCase.call(params);
    if(dataState.data != null){
      int index = users.indexWhere((element) => element == selectedUser.value);
      if (index != -1) {
        users[index] = dataState.data!;
        users.refresh();
      }
      selectedUser.value = dataState.data!;
      isEditActive.value = false;

      delegate.notify(UsersPageSituations.userUpdated);
    } else if(dataState.error != null){
      delegate.notify(UsersPageSituations.error);
    }
  }
  Future<void> deleteUser(String id) async {
    final DeleteUserParams params = DeleteUserParams(id: id);
    final dataState = await _deleteUserUseCase.call(params);
    if(dataState.data == true){
      int index = users.indexWhere((element) => element == selectedUser.value);
      if (index != -1) {
        users.removeAt(index);
        users.refresh();
      }
      delegate.notify(UsersPageSituations.userDeleted);
    } else if(dataState.error != null){
      delegate.notify(UsersPageSituations.error);
    }
  }
  
  Future<void> selectImageFromCamera() async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if(pickedImage != null){
      uploadProfileImage(pickedImage.path);
    }
  }
  Future<void> selectImageFromGallery() async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if(pickedImage != null){
      uploadProfileImage(pickedImage.path);
    }
  }
}

mixin UsersDelegate {
  void notify(UsersPageSituations status);
}

enum UsersPageSituations {
  userDeleted,
  userUpdated,
  userCreated,
  error,
}