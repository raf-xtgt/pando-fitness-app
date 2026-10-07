import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../game/asset_manifest.dart';

/// Text drawn from the fire glyph SVGs, one per character. Supports digits,
/// `m`, `+` and spaces (e.g. `+123 m`).
class FireText extends StatelessWidget {
  const FireText(this.text, {super.key, this.height = 52});

  final String text;

  /// Glyph height; every glyph has the same 60:100 box.
  final double height;

  @override
  Widget build(BuildContext context) {
    final width = height * 0.6;
    return Semantics(
      label: text,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final char in text.split(''))
            if (char == ' ')
              SizedBox(width: width * 0.4)
            else
              SvgPicture.asset(
                AssetManifest.fireGlyph(char),
                height: height,
                width: width,
              ),
        ],
      ),
    );
  }
}
