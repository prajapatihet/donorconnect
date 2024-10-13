import 'package:donorconnect/language/cubit/language_cubit.dart';
import 'package:donorconnect/language/helper/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePopup extends StatelessWidget {
  const LanguagePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Language>(
        builder: (context, currentLangaugeState) {
      return PopupMenuButton(
        onSelected: (languageFromUser) {
          context.read<LanguageCubit>().changeLanguage(languageFromUser);
        },
        itemBuilder: (context) => [
          for (var values in Language.values)
            PopupMenuItem(
              value: values,
              child: Row(
                children: [
                  Text(values.countryFlag),
                  SizedBox(width: 16.0),
                  Text(values.languageName),
                ],
              ),
            )
        ],
        child: BlocBuilder<LanguageCubit, Language>(
          builder: (context, currentLanguage) {
            return Row(
              children: [
                Text(currentLanguage.countryFlag),
                SizedBox(width: 16.0),
                Text(currentLanguage.languageName),
                Icon(Icons.arrow_drop_down_sharp),
              ],
            );
          },
        ),
      );
    });
  }
}
