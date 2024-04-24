import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class DeepLinkService {
  late final AppLinks _appLinks;
  StreamSubscription? _linkSubscription;

  // Callback to handle deep links with context
  void Function(Uri)? onDeepLinkReceived;

  // Singleton instance
  static final DeepLinkService _instance = DeepLinkService._internal();

  factory DeepLinkService() {
    return _instance;
  }

  DeepLinkService._internal() {
    _appLinks = AppLinks();
    initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    final initialLink = await _appLinks.getInitialAppLink();
    // Context cannot be handled here directly since it's initialization phase
    if (initialLink != null && onDeepLinkReceived != null) {
      // Context should be passed from a valid widget after initialization
      print("Initial link is ready but waiting for context to handle it.");
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (onDeepLinkReceived != null) {
        print("URI link stream received but waiting for context to handle it.");
        handleDeepLinks(uri);
      } else {
        print("Deep link received but no handler set: $uri");
      }
    }, onError: (err) {
      print('Failed to handle incoming link: $err');
    });
  }

  void handleDeepLinks(Uri uri) {
    if (onDeepLinkReceived != null) {
      onDeepLinkReceived!(uri);
    } else {
      print("Context available but no deep link handler set.");
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
