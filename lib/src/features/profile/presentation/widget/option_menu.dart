import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OptionMenu extends StatelessWidget {
  final IconData iconData;
  final String menuName;
  final void Function()? onTap;
  const OptionMenu({
    super.key,
    required this.onTap,
    required this.iconData,
    required this.menuName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            iconData,
            size: 40,
            color: Colors.black54,
          ),
          const Gap(20),
          Text(
            menuName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
