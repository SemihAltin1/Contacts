import 'package:contacts/config/theme/custom_colors.dart';
import 'package:contacts/config/theme/text_styles.dart';
import 'package:contacts/features/contacts/domain/entities/user.dart';
import 'package:contacts/features/contacts/presentation/controller/users_controller.dart';
import 'package:contacts/features/contacts/presentation/widget/contact_card.dart';
import 'package:contacts/features/contacts/presentation/pages/create_udpate_user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';


class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> implements UsersDelegate {
  final UserController _controller = Get.put(UserController());
  final TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    _controller.getUsers("", isReset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pageColor,
      body: _buildPageBody(),
    );
  }

  Widget _buildPageBody() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchField(),
            Expanded(child: Obx(()=>_buildContactsGetBuilder())),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader(){
    return Row(
      children: [
        Expanded(
          child: Text(
            "Contacts",
            style: TextStyles.titleLarge(),
          ),
        ),
        IconButton(
          onPressed: (){
            _showCreateUserBottomSheet();
          },
          icon: const ImageIcon(
            AssetImage("assets/icons/add.png"),
            color: CustomColors.blue,
          ),
        ),
      ],
    );
  }
  Widget _buildSearchField() {
    return CupertinoTextField(
      controller: searchController,
      placeholder: "Search by name",
      placeholderStyle: TextStyles.bodyLarge(color: CustomColors.grey),
      prefix: const Icon(Icons.search),
      padding: const EdgeInsets.only(
        left: 5,
        top: 10,
        bottom: 10,
        right: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      onChanged: (value){
        _controller.getUsers(value, isReset: true);
      },
    );
  }
  Widget _buildContactsGetBuilder() {
    if(_controller.users.isEmpty){
      return _buildEmptyChild();
    }
    return _buildContactsList();
  }
  Widget _buildEmptyChild() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/icons/user.png",
          width: 60,
          height: 60,
        ),
        Text(
          "No Contacts",
          style: TextStyles.titleLarge(),
          textAlign: TextAlign.center,
        ),
        Text(
          "Contacts you’ve added will appear here.",
          style: TextStyles.bodyLarge(),
          textAlign: TextAlign.center,
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            "Create New Contact",
            style: TextStyles.bodyLarge(color: CustomColors.blue),
          ),
          onPressed: (){
            _showCreateUserBottomSheet();
          },
        ),
      ],
    );
  }
  Widget _buildContactsList(){
    return LazyLoadScrollView(
      isLoading: _controller.isPaginationLoading,
      onEndOfPage: (){
        _controller.getUsers("", isReset: false);
      },
      child: ListView.builder(
        itemCount: _controller.users.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context,index){
          return ContactCard(user: _controller.users[index], onTap: (){
            _showCreateUserBottomSheet(userEntity: _controller.users[index]);
          });
        },
      ),
    );
  }

  _showCreateUserBottomSheet({UserEntity? userEntity}) {
    showModalBottomSheet(
        context: (context),
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        builder: (context) {
          return CreateAndUpdateUserPage(userEntity: userEntity);
        },
    );
  }

  @override
  void notify(UsersPageSituations status) {
    switch(status){
      case UsersPageSituations.userDeleted:
        _showSnackBar("Account deleted!");
        break;
      case UsersPageSituations.userUpdated:
        _showSnackBar("Changes have been applied!");
        break;
      case UsersPageSituations.error:
        _showSnackBar("Somethings went wrong!");
        break;
      case UsersPageSituations.userCreated:
        _showSnackBar("User added");
        break;
    }
  }

  _showSnackBar(String message) {
    Get.showSnackbar(
        GetSnackBar(
          messageText: Text(message,style: TextStyles.bodyLarge(color: CustomColors.green),),
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.white,
          borderRadius: 15,
          icon: const ImageIcon(
            AssetImage(
              "assets/icons/check.png",
            ),
            color: CustomColors.green,
          ),
        ),
    );
  }
}


