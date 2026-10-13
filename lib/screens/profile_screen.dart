import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../providers/auth/auth_cubit.dart';
import '../widgets/responsive_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to access your savings.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (p, c) => p.errorMessage != c.errorMessage && c.errorMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.errorMessage!))),
      builder: (context, state) {
        final user = state.user;
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: SafeArea(
            child: ResponsiveBody(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: scheme.primaryContainer,
                      child: Text(
                        user?.initials ?? '?',
                        style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onPrimaryContainer),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card.filled(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text('Full Name'),
                          subtitle: Text(user?.fullName ?? '-'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.email_outlined),
                          title: const Text('Email'),
                          subtitle: Text(user?.email ?? '-'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.phone_outlined),
                          title: const Text('Phone Number'),
                          subtitle: Text(user?.phone ?? '-'),
                        ),
                      ],
                    ),
                  ),
                  if (state.biometricAvailable) ...[
                    const SizedBox(height: 12),
                    Card.filled(
                      child: SwitchListTile(
                        secondary: const Icon(Icons.fingerprint),
                        title: const Text('Biometric lock'),
                        subtitle: const Text('Require fingerprint / face to open the app'),
                        value: state.biometricEnabled,
                        onChanged: (v) => context.read<AuthCubit>().setBiometric(v),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => _confirmLogout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      foregroundColor: scheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
