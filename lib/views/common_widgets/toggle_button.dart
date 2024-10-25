import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:donorconnect/cubit/theme_toggle/theme_cubit.dart';
import 'package:donorconnect/cubit/theme_toggle/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key, required this.switchValue});
  final bool switchValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, Themestate>(
      builder: (context, themeState) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Change App Theme",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 42,
                width: 140,
                child: AnimatedToggleSwitch.dual(
                  current: switchValue,
                  first: false,
                  second: true,
                  height: 40,
                  onChanged: (value) {
                    // Toggle the theme based on the switch value
                    context.read<ThemeCubit>().toggle(value);
                  },
                  styleBuilder: (value) => ToggleStyle(
                    indicatorColor:
                    value ? Colors.purple.shade300 : Colors.yellow,
                    backgroundGradient: value
                        ? const LinearGradient(
                        colors: [Colors.purpleAccent, Colors.deepPurple])
                        : LinearGradient(colors: [
                      Colors.yellow.shade300,
                      Colors.yellow.shade900
                    ]),
                  ),
                  iconBuilder: (value) => value
                      ? const Icon(
                    Icons.nights_stay_rounded,
                    color: Colors.white,
                  )
                      : const Icon(
                    Icons.sunny,
                    color: Colors.black,
                  ),
                  textBuilder: (value) => value
                      ? const Center(
                    child: Text(
                      "Dark Mode",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                      : const Center(
                    child: Text("Light Mode"),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

}
