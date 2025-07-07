import 'package:flutter/material.dart';
import 'package:school_planting/app_widget.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_ANON_KEY);

  runApp(const AppWidget());
}
