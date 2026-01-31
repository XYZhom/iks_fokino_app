import 'package:flutter/material.dart';
import 'package:iks_fokino_app/constants/colors.dart';
import 'package:iks_fokino_app/screens/auth/login_screen.dart';
import 'package:iks_fokino_app/services/database_service.dart';
import 'package:provider/provider.dart';

class IKSFokinoApp extends StatelessWidget {
  const IKSFokinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: AppColors.primaryBlue,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Загрузка ИКС Фокино...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            Provider<DatabaseService>(
              create: (_) => DatabaseService(),
              dispose: (_, service) => service.close(),
            ),
          ],
          child: MaterialApp(
            title: 'ИКС Фокино',
            theme: ThemeData(
              primaryColor: AppColors.primaryBlue,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryBlue,
                primary: AppColors.primaryBlue,
                secondary: AppColors.accentBlue,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              fontFamily: 'Roboto',
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: const LoginScreen(),
          ),
        );
      },
    );
  }

  Future<void> _initializeApp() async {
    // Здесь можно добавить другие асинхронные инициализации
    await Future.delayed(const Duration(milliseconds: 500));
  }
}