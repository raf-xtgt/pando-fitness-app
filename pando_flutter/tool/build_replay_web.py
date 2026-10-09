#!/usr/bin/env python3
"""Builds the replay web page into pando_server/web/replay for one server.

    python3 tool/build_replay_web.py [PUBLIC_URL]

PUBLIC_URL is the server's address as a browser sees it (default
http://localhost:8080), e.g. the Cloud Run URL. It goes into the page's Open
Graph tags, because X and WhatsApp need an absolute image URL for the link
card. The card image (og.png) is drawn here from the local mascot art, into
the build output only: the art is licensed and stays out of git.

Run from pando_flutter/. Needs Flutter and Pillow.
"""
import subprocess
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

APP = Path(__file__).resolve().parent.parent
OUT = APP.parent / "pando_server" / "web" / "replay"
PLACEHOLDER = "__PANDO_PUBLIC_URL__"

PAPER = (0xF3, 0xED, 0xE2)
INK = (0x2A, 0x26, 0x22)
LEAF = (0x6B, 0x8F, 0x4E)


def share_card(path: Path) -> None:
    """1200 x 630 card: the mascot on paper, "Pando" and a short line."""
    card = Image.new("RGB", (1200, 630), PAPER)
    draw = ImageDraw.Draw(card)
    draw.rounded_rectangle((24, 24, 1176, 606), radius=28, outline=INK, width=6)

    mascot = Image.open(APP / "assets/art/mascot/mascot_still.png").convert("RGBA")
    mascot.thumbnail((460, 460))
    card.paste(mascot, (80, (630 - mascot.height) // 2), mascot)

    fonts = APP / "assets/fonts"
    title = ImageFont.truetype(str(fonts / "Mulish-Bold.ttf"), 132)
    line = ImageFont.truetype(str(fonts / "Mulish-SemiBold.ttf"), 46)
    x = 580
    draw.text((x, 170), "Pando", font=title, fill=INK)
    draw.line((x + 6, 330, x + 330, 330), fill=LEAF, width=8)
    draw.text((x, 360), "A walk, replayed", font=line, fill=INK)
    draw.text((x, 418), "on the park.", font=line, fill=INK)
    card.save(path, optimize=True)


def main() -> None:
    url = (sys.argv[1] if len(sys.argv) > 1 else "http://localhost:8080").rstrip("/")
    subprocess.run(
        [
            "flutter", "build", "web",
            "-t", "lib/main_replay.dart",
            "--base-href", "/replay/",
            "--no-wasm-dry-run",
            "-o", str(OUT),
        ],
        cwd=APP,
        check=True,
    )
    share_card(OUT / "og.png")
    index = OUT / "index.html"
    index.write_text(index.read_text().replace(PLACEHOLDER, url))
    print(f"Replay page: {OUT} (link card for {url}/replay/)")


if __name__ == "__main__":
    main()
