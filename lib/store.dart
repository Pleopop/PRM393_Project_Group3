import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'routes/app_router.dart';

final deepLinkNotifierProvider = NotifierProvider<DeepLinkNotifier, void>(
  DeepLinkNotifier.new,
);

class DeepLinkNotifier extends Notifier<void> {
  StreamSubscription<Uri>? _sub;

  @override
  void build() {
    final appLinks = AppLinks();

    // Cold-start: app opened via deep link
    appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleUri(uri);
    });

    // Warm: deep link while app is running
    _sub = appLinks.uriLinkStream.listen(_handleUri);

    // Clean up when the provider is disposed
    ref.onDispose(() => _sub?.cancel());
  }

  void _handleUri(Uri uri) {
    // studybot://callback?code=...
    if (uri.host == 'callback' && uri.queryParameters.containsKey('code')) {
      final code = uri.queryParameters['code']!;
      AppRouter.router.go(
        '${AppConstants.routeCallback}?code=${Uri.encodeComponent(code)}',
      );
    }
  }
}
