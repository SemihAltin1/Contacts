import 'package:contacts/config/theme/custom_colors.dart';
import 'package:contacts/features/contacts/domain/entities/user.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/text_styles.dart';

class ContactCard extends StatefulWidget {
  final UserEntity user;
  final Function() onTap;
  const ContactCard({super.key, required this.user, required this.onTap});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 70,
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(
          top: 20,
        ),
        padding: const EdgeInsets.only(
          top: 13,
          bottom: 13,
          left: 20,
          right: 20,
        ),
        child: Row(
          children: [
            ///User Image
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: widget.user.profileImageUrl!.isNotEmpty
                    ? DecorationImage(image: NetworkImage(widget.user.profileImageUrl!),fit: BoxFit.cover)
                    : const DecorationImage(image: AssetImage("assets/icons/user.png")),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Name - Surname
                  Text(
                    "${widget.user.firstName ?? ""} ${widget.user.lastName ?? ""}",
                    style: TextStyles.bodyLarge(),
                  ),
                  ///Phone Number
                  Text(
                    widget.user.phoneNumber ?? "-",
                    style: TextStyles.bodyLarge(color: CustomColors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
