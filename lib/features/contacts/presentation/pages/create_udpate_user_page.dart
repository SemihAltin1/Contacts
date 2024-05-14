import 'package:contacts/config/theme/custom_colors.dart';
import 'package:contacts/config/theme/text_styles.dart';
import 'package:contacts/features/contacts/domain/entities/user.dart';
import 'package:contacts/features/contacts/presentation/controller/users_controller.dart';
import 'package:contacts/features/contacts/presentation/widget/grey_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAndUpdateUserPage extends StatefulWidget {
  final UserEntity? userEntity;
  const CreateAndUpdateUserPage({super.key, this.userEntity});

  @override
  State<CreateAndUpdateUserPage> createState() => _CreateAndUpdateUserPageState();
}

class _CreateAndUpdateUserPageState extends State<CreateAndUpdateUserPage> {
  final UserController _userController = Get.put(UserController());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setUserController();
  }

  @override
  void dispose() {
    super.dispose();
    _userController.selectedImage.value = "";
    _userController.selectedUser.value = const UserEntity();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: ListView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildHeader(),
          _buildProfileImage(),
          Obx(()=>_userController.isEditActive.value ? _buildTextFields() : _buildPreview()),
        ],
      ),
    );
  }


  _buildHeader() {
    return Row(
      children: [
        CupertinoButton(
          child: Text(
            "Cancel",
            style: TextStyles.bodyLarge(color: CustomColors.blue),
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: Text(
            widget.userEntity == null ? "New Contact" : "",
            style: TextStyles.bodyLarge(),
            textAlign: TextAlign.center,
          ),
        ),
        CupertinoButton(
          child: Obx(()=>Text(
            _userController.isEditActive.value ? "Done" : "Edit",
            style: TextStyles.bodyLarge(color: CustomColors.blue),
          )),
          onPressed: (){
            if(_userController.isEditActive.value){
              _checkContactFields();
            } else {
              _userController.isEditActive.value = true;
              _setTextFieldTexts();
            }

          },
        ),
      ],
    );
  }
  _buildProfileImage() {
    return Column(
      children: [
        ///Profile Image
        Obx(
          () => Container(
            constraints: const BoxConstraints(
              maxHeight: 195,
              maxWidth: 195,
            ),
            width: Get.width * 0.5,
            height: Get.width * 0.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: _userController.selectedImage.value.isEmpty
                  ? const DecorationImage(image: AssetImage("assets/icons/user.png"))
                  : DecorationImage(image: NetworkImage(_userController.selectedImage.value),fit: BoxFit.cover),
            ),
          ),
        ),

        ///Select Image Button
        CupertinoButton(
          child: Text(
            widget.userEntity == null ? "Add Photo" : "Change Photo",
            style: TextStyles.bodyLarge(),
          ),
          onPressed: (){
            if(_userController.isEditActive.value){
              _showMediaTypeSelection();
            }
          },
        ),
      ],
    );
  }
  _buildTextFields()  {
    return Column(
      children: [
        GreyTextField(controller: firstNameController, hint: "First name"),
        GreyTextField(controller: lastNameController, hint: "Last name"),
        GreyTextField(controller: phoneNumberController, hint: "Phone number"),
      ],
    );
  }
  _buildPreview() {
    return Padding(
      padding: const EdgeInsets.only(right: 15,left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPreviewText(_userController.selectedUser.value.firstName ?? ""),
          _buildPreviewText(_userController.selectedUser.value.lastName ?? ""),
          _buildPreviewText(_userController.selectedUser.value.phoneNumber ?? ""),
          ///Delete Button
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(
              "Delete contact",
              style: TextStyles.bodyLarge(color: CustomColors.red),
            ),
            onPressed: (){
              _userController.deleteUser(_userController.selectedUser.value.id ?? "");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
  _buildPreviewText(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyles.bodyLarge(),
        ),
        const Divider(
          color: CustomColors.grey,
          thickness: 1,
          height: 20,
        ),
      ],
    );
  }

  _showMediaTypeSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        )
      ),
      builder: (dialogContext){
        return Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Camera Button
              GestureDetector(
                onTap: (){
                  Navigator.pop(dialogContext);
                  _userController.selectImageFromCamera();
                },
                child: Container(
                  height: 54,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: CustomColors.pageColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ImageIcon(
                        AssetImage("assets/icons/camera.png"),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Camera",
                        style: TextStyles.titleLarge(),
                      )
                    ],
                  ),
                ),
              ),

              ///Gallery Button
              GestureDetector(
                onTap: (){
                  Navigator.pop(dialogContext);
                  _userController.selectImageFromGallery();
                },
                child: Container(
                  height: 54,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: CustomColors.pageColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ImageIcon(
                        AssetImage("assets/icons/gallery.png"),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Gallery",
                        style: TextStyles.titleLarge(),
                      )
                    ],
                  ),
                ),
              ),

              ///Cancel Button
              GestureDetector(
                onTap: (){
                  Navigator.pop(dialogContext);
                },
                child: Container(
                  height: 54,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: CustomColors.pageColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Cancel",
                    style: TextStyles.titleLarge(color: CustomColors.blue),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _checkContactFields(){
    if(firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty && phoneNumberController.text.isNotEmpty){
      if(_userController.selectedUser.value.id == null){
        _userController.createUser(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          phoneNumber: phoneNumberController.text,
        );
      } else {
        _userController.updateUser(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          phoneNumber: phoneNumberController.text,
        );
      }

    }
  }
  _setTextFieldTexts(){
    firstNameController.text = _userController.selectedUser.value.firstName ?? "";
    lastNameController.text = _userController.selectedUser.value.lastName ?? "";
    phoneNumberController.text = _userController.selectedUser.value.phoneNumber ?? "";
  }
  _setUserController() {
    if(widget.userEntity != null){
      _userController.isEditActive.value = false;
      _userController.selectedUser.value = widget.userEntity!;
      _userController.selectedImage.value = widget.userEntity!.profileImageUrl ?? "";
    } else {
      _userController.isEditActive.value = true;
    }
  }
}
