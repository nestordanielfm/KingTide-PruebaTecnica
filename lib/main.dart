import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:template_app/core/config/environment.dart';
import 'package:template_app/core/router/app_router.dart';
import 'package:template_app/core/theme/app_theme.dart';
import 'package:template_app/injection/injection.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  EnvironmentConfig.init(env: env);

  // Load environment variables
  await dotenv.load(fileName: '.env.$env');

  // Configure dependency injection
  configureDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Futurama App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: _appRouter.config(),
    );
  }
}
