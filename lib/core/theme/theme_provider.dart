import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Added themeModeProvider to allow settings screen to dynamically change between light, dark, and system modes
/// Controls the active theme mode across the application.
/// Defaults to system preference. Update this provider from a
/// settings screen to switch between light, dark, and system modes.
final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.system);
