import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_router.dart';
import 'core/app_theme.dart';
import 'core/constants.dart';
import 'providers/auth/auth_cubit.dart';
import 'providers/products/products_cubit.dart';
import 'providers/savings/savings_cubit.dart';
import 'providers/tips/tips_cubit.dart';
import 'repositories/auth_repository.dart';
import 'repositories/savings_repository.dart';
import 'repositories/tips_repository.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/biometric_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final storage = StorageService(prefs);

  runApp(
    KoinsApp(
      authRepository: AuthRepository(
        authService: AuthService(),
        storage: storage,
        biometrics: BiometricService(),
      ),
      savingsRepository: SavingsRepository(storage),
      tipsRepository: TipsRepository(ApiService()),
    ),
  );
}

class KoinsApp extends StatefulWidget {
  const KoinsApp({
    super.key,
    required this.authRepository,
    required this.savingsRepository,
    required this.tipsRepository,
  });

  final AuthRepository authRepository;
  final SavingsRepository savingsRepository;
  final TipsRepository tipsRepository;

  @override
  State<KoinsApp> createState() => _KoinsAppState();
}

class _KoinsAppState extends State<KoinsApp> {
  late final AuthCubit _authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit(widget.authRepository)..init();
    _router = AppRouter.create(_authCubit);
  }

  @override
  void dispose() {
    _router.dispose();
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider(
          create: (_) => SavingsCubit(widget.savingsRepository)..load(),
        ),
        BlocProvider(
          create: (_) => ProductsCubit(widget.savingsRepository)..load(),
        ),
        BlocProvider(create: (_) => TipsCubit(widget.tipsRepository)..load()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}
