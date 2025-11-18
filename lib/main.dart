import 'package:flutter/material.dart';
import 'package:pokemon_clean_arch/core/app_widget/app_widget.dart';
import 'package:pokemon_clean_arch/core/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const AppWidget());
}
