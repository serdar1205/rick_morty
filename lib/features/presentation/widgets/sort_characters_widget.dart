import 'package:flutter/material.dart';
import 'package:rick_morty/core/constants/colors/app_colors.dart';

import 'sort_button.dart';

enum CharacterGenders { all, male, female }

enum CharacterLocations { all, earth, others }

class SortBooksWidget extends StatelessWidget {
  const SortBooksWidget({
    super.key,
    required this.selectGender,
    required this.selectLocation,
    required this.onResult,
    required this.selectedGender,
    required this.selectedLocation,
  });

  final ValueNotifier<CharacterGenders> selectedGender;

  final ValueNotifier<CharacterLocations> selectedLocation;

  final ValueChanged<CharacterGenders> selectGender;
  final ValueChanged<CharacterLocations> selectLocation;

  final VoidCallback onResult;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Filter',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 33),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Genders',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<CharacterGenders>(
                  valueListenable: selectedGender,
                  builder: (context, currentGender, _) {
                    return SortButton(
                      title: 'All',
                      isSelected: currentGender == CharacterGenders.all,
                      onTap: () {
                        selectGender(CharacterGenders.all);
                        selectedGender.value = CharacterGenders.all;
                      },
                    );
                  },
                ),
                ValueListenableBuilder<CharacterGenders>(
                  valueListenable: selectedGender,
                  builder: (context, currentGender, _) {
                    return SortButton(
                      title: 'Male',
                      isSelected: currentGender == CharacterGenders.male,
                      onTap: () {
                        selectGender(CharacterGenders.male);
                        selectedGender.value = CharacterGenders.male;
                      },
                    );
                  },
                ),
                ValueListenableBuilder<CharacterGenders>(
                  valueListenable: selectedGender,
                  builder: (context, currentGender, _) {
                    return SortButton(
                      title: 'Female',
                      isSelected: currentGender == CharacterGenders.female,
                      onTap: () {
                        selectGender(CharacterGenders.female);
                        selectedGender.value = CharacterGenders.female;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Locations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<CharacterLocations>(
                  valueListenable: selectedLocation,
                  builder: (context, currentLocation, _) {
                    return SortButton(
                      title: 'All',
                      isSelected: currentLocation == CharacterLocations.all,
                      onTap: () {
                        selectLocation(CharacterLocations.all);
                        selectedLocation.value = CharacterLocations.all;
                      },
                    );
                  },
                ),
                ValueListenableBuilder<CharacterLocations>(
                  valueListenable: selectedLocation,
                  builder: (context, currentLocation, _) {
                    return SortButton(
                      title: 'Earth',
                      isSelected: currentLocation == CharacterLocations.earth,
                      onTap: () {
                        selectLocation(CharacterLocations.earth);
                        selectedLocation.value = CharacterLocations.earth;
                      },
                    );
                  },
                ),
                ValueListenableBuilder<CharacterLocations>(
                  valueListenable: selectedLocation,
                  builder: (context, currentLocation, _) {
                    return SortButton(
                      title: 'Others',
                      isSelected: currentLocation == CharacterLocations.others,
                      onTap: () {
                        selectLocation(CharacterLocations.others);
                        selectedLocation.value = CharacterLocations.others;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: onResult,
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(AppColors.mainbuttonColor),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sort, size: 28, color: Colors.white),
                  SizedBox(width: 20),
                  Text(
                    'Sort',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
