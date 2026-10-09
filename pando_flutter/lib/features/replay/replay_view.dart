import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app/theme.dart';
import 'replay_loading.dart';

/// The replay page (`/replay/<replayId>`) inside the report, in a WebView:
/// the same page anyone with the link sees.
class ReplayView extends StatefulWidget {
  const ReplayView({super.key, required this.url});

  final Uri url;

  @override
  State<ReplayView> createState() => _ReplayViewState();
}

class _ReplayViewState extends State<ReplayView> {
  /// Until the page's HTML is in, which shows the same loading look itself.
  bool _starting = true;

  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(PandoColors.paper)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (_) {
          if (mounted) setState(() => _starting = false);
        },
      ),
    )
    ..loadRequest(widget.url);

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(child: WebViewWidget(controller: _controller)),
      if (_starting) const Positioned.fill(child: ReplayLoading()),
    ],
  );
}
