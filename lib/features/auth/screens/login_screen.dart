import 'package:flutter/material.dart';
import '../widgets/discord_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo / title
                const Icon(
                  Icons.school_rounded,
                  size: 80,
                  color: Color(0xFF5865F2),
                ),
                const SizedBox(height: 24),
                Text(
                  'Study Bot',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đăng nhập bằng tài khoản Discord của bạn\ntrong server để tiếp tục.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),
                const DiscordLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
