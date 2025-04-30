import 'package:flutter/material.dart';
import 'package:rick_morty/core/constants/colors/app_colors.dart';

class SortButton extends StatelessWidget {
  const SortButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.mainbuttonColor,
            width: 1,
          ),
          color: isSelected
              ? AppColors.mainbuttonColor
              : Theme.of(context).cardTheme.color,
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: isSelected
                      ? AppColors.whiteColor
                      : Theme.of(context).textTheme.titleMedium!.color,
                ),
          ),
        ),
      ),
    );
  }
}
