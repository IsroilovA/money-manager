import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';
import 'package:money_manager/tabs/tabs.dart';

// Theme for the light mode
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 86, 38, 190), // Primary color for the light theme
    brightness: Brightness.light, // Brightness setting for the light theme
  ),
  textTheme: GoogleFonts.poppinsTextTheme(), // Using Poppins font for the light theme
);

// Theme for the dark mode
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(230, 98, 14, 14), // Primary color for the dark theme
    brightness: Brightness.dark, // Brightness setting for the dark theme
  ),
  textTheme: GoogleFonts.poppinsTextTheme(), // Using Poppins font for the dark theme
);

void main() {
  runApp(const App());
}

// Root widget of the application
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme, // Applying the light theme
      darkTheme: darkTheme, // Applying the dark theme
      home: BlocProvider(
        create: (context) => TabsCubit(), // Providing the TabsCubit for state management
        child: const TabsScreen(), // The initial screen of the app
      ),
    );
  }
}
