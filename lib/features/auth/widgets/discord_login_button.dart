import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

/// "Login with Discord" button.
/// Calls [AuthNotifier.loginToDiscord] which opens the OAuth2 consent page.
/// The actual code exchange happens in [CallbackScreen] after Discord redirects back.
class DiscordLoginButton extends ConsumerStatefulWidget {
  const DiscordLoginButton({super.key});

  @override
  ConsumerState<DiscordLoginButton> createState() => _DiscordLoginButtonState();
}

class _DiscordLoginButtonState extends ConsumerState<DiscordLoginButton> {
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).loginToDiscord();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể mở trang đăng nhập Discord: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5865F2), // Discord Blurple
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isLoading ? null : _handleLogin,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const _DiscordIcon(),
        label: const Text(
          'Đăng nhập với Discord',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Simple Discord logo drawn with a Text widget (Unicode).
class _DiscordIcon extends StatelessWidget {
  const _DiscordIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.discord, size: 22, color: Colors.white);
  }
}
