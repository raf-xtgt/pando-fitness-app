"""Builds the Android launcher icon from the mascot (assets/art/mascot/mascot_still.png).

Usage (from pando_flutter/): python3 tool/build_launcher_icon.py

Writes into android/app/src/main/res/:
- mipmap-*/ic_launcher_foreground.png: the mascot on a transparent 108 dp
  square, inside the 66 dp safe zone (launchers crop adaptive icons to a
  circle, squircle or rounded square).
- mipmap-anydpi-v26/ic_launcher.xml: the adaptive icon, foreground on the
  paper colour (values/ic_launcher_background.xml).
- mipmap-*/ic_launcher.png: a legacy icon for Android 7 and older (mascot on
  a paper rounded square).
Needs Pillow.
"""
import os
from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
APP = os.path.dirname(HERE)
SRC = os.path.join(APP, 'assets/art/mascot/mascot_still.png')
RES = os.path.join(APP, 'android/app/src/main/res')
PAPER = (0xF3, 0xED, 0xE2, 255)  # PandoColors.paper

# density: scale (1 dp = scale px)
DENSITIES = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
SAFE = 0.56  # share of the 108 dp side the mascot may span; the wings stay inside a circular crop (66 dp safe zone)


def mascot():
    im = Image.open(SRC).convert('RGBA')
    return im.crop(im.getchannel('A').getbbox())


def fit(im, box):
    k = box / max(im.size)
    return im.resize((round(im.width * k), round(im.height * k)), Image.LANCZOS)


def centred(canvas, im):
    canvas.alpha_composite(im, ((canvas.width - im.width) // 2, (canvas.height - im.height) // 2))
    return canvas


def build():
    m = mascot()
    for name, scale in DENSITIES.items():
        folder = os.path.join(RES, f'mipmap-{name}')
        os.makedirs(folder, exist_ok=True)
        side = round(108 * scale)
        fg = centred(Image.new('RGBA', (side, side), (0, 0, 0, 0)), fit(m, side * SAFE))
        fg.save(os.path.join(folder, 'ic_launcher_foreground.png'), optimize=True)
        legacy_side = round(48 * scale)
        big = legacy_side * 4  # draw large, then scale down for smooth corners
        legacy = Image.new('RGBA', (big, big), (0, 0, 0, 0))
        ImageDraw.Draw(legacy).rounded_rectangle((0, 0, big - 1, big - 1), radius=big // 5, fill=PAPER)
        centred(legacy, fit(m, big * 0.8))
        legacy.resize((legacy_side, legacy_side), Image.LANCZOS).save(
            os.path.join(folder, 'ic_launcher.png'), optimize=True)
        print(name, side, legacy_side)

    os.makedirs(os.path.join(RES, 'mipmap-anydpi-v26'), exist_ok=True)
    with open(os.path.join(RES, 'mipmap-anydpi-v26/ic_launcher.xml'), 'w') as f:
        f.write('<?xml version="1.0" encoding="utf-8"?>\n'
                '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
                '    <background android:drawable="@color/ic_launcher_background" />\n'
                '    <foreground android:drawable="@mipmap/ic_launcher_foreground" />\n'
                '</adaptive-icon>\n')
    with open(os.path.join(RES, 'values/ic_launcher_background.xml'), 'w') as f:
        f.write('<?xml version="1.0" encoding="utf-8"?>\n'
                '<resources>\n'
                '    <!-- PandoColors.paper -->\n'
                '    <color name="ic_launcher_background">#F3EDE2</color>\n'
                '</resources>\n')


if __name__ == '__main__':
    build()
