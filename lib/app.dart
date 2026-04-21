import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/api/api_client.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'store.dart';
import 'routes/app_router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kick off the deep-link notifier so it starts listening immediately.
    ref.watch(deepLinkNotifierProvider);

    // Wire 401 interceptor → logout via Riverpod auth notifier.
    ApiClient.onUnauthorized = () => ref.read(authProvider.notifier).logout();

    return MaterialApp.router(
      title: 'Study Bot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
    );
  }
}
