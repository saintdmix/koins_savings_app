import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../providers/auth/auth_cubit.dart';
import '../widgets/primary_button.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AuthCubit>().unlock();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (p, c) => p.errorMessage != c.errorMessage && c.errorMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.errorMessage!))),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fingerprint, size: 88, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('App locked', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      'Verify it\'s you to open Koins Savings',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Unlock',
                      icon: Icons.lock_open,
                      onPressed: () => context.read<AuthCubit>().unlock(),
                    ),
                    TextButton(
                      onPressed: () => context.read<AuthCubit>().logout(),
                      child: const Text('Sign out'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
