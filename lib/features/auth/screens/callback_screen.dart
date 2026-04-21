import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';

/// Shown briefly after Discord redirects back with ?code=...
/// Exchanges the code for a JWT then navigates to the dashboard (or back to login on error).
class CallbackScreen extends ConsumerStatefulWidget {
  final String code;

  const CallbackScreen({super.key, required this.code});

  @override
  ConsumerState<CallbackScreen> createState() => _CallbackScreenState();
}

class _CallbackScreenState extends ConsumerState<CallbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _exchange());
  }

  Future<void> _exchange() async {
    await ref.read(authProvider.notifier).handleCallback(widget.code);

    if (!mounted) return;

    final authState = ref.read(authProvider);
    authState.when(
      data: (user) {
        if (user != null) {
          context.go(AppConstants.routeDashboard);
        } else {
          _goLoginWithError('Đăng nhập thất bại.');
        }
      },
      error: (e, _) => _goLoginWithError(e.toString()),
      loading: () {}, // handleCallback already set loading; shouldn't stay here
    );
  }

  void _goLoginWithError(String message) {
    context.go(AppConstants.routeLogin);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang xác thực…'),
          ],
        ),
      ),
    );
  }
}
