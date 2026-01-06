import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/customs/country_data.dart';

class CountrySelectorDropdown extends StatefulWidget {
  const CountrySelectorDropdown({super.key, required this.onSelectedCountry});
  final void Function(AppCountry? country) onSelectedCountry;

  @override
  State<CountrySelectorDropdown> createState() =>
      _CountrySelectorDropdownState();
}

class _CountrySelectorDropdownState extends State<CountrySelectorDropdown> {
  AppCountry selectedCountry = AppCountry.india;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AppCountry>(
      underline: Space.z,
      iconSize: 0.0,
      padding: AppPadding.z,
      dropdownColor: AppColors.whiteColor,
      value: selectedCountry,
      hint: const Text('Pick'),
      onChanged: (AppCountry? newValue) {
        setState(() {
          selectedCountry = newValue ?? selectedCountry;
        });
      },
      selectedItemBuilder: (BuildContext context) {
        return AppCountry.values.map((AppCountry country) {
          return Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Text(
                " ${country.dialCode}",
                style: AppStyles.baseStyle.chineseBlack,
              ),
            ),
          );
        }).toList();
      },
      items: AppCountry.values.map((AppCountry country) {
        return DropdownMenuItem<AppCountry>(
          value: country,
          child: FittedBox(
            child: Text(
              country.name,
              style: AppStyles.medium.normal.chineseBlack,
            ),
          ),
        );
      }).toList(),
    );
  }
}
