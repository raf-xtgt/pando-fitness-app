import 'package:share_plus/share_plus.dart';

import '../../domain/units.dart';

/// The line shared with a replay link, e.g. "I walked 2.4 km with Pando
/// today." plus the link.
String replayShareText(double distanceM, Uri link) =>
    'I walked ${formatWalkDistance(distanceM)} with Pando today. '
    'Watch my walk: $link';

/// Opens the phone's share sheet (WhatsApp, X, …) with the replay link.
Future<void> shareReplay(double distanceM, Uri link) =>
    SharePlus.instance.share(
      ShareParams(
        text: replayShareText(distanceM, link),
        title: 'Share your walk',
        subject: 'My walk with Pando',
      ),
    );
