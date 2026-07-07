#!/usr/bin/env python3
"""Render the GitHub social preview card (1280x640 PNG).

    python3 docs/assets/make_social_preview.py

Output: docs/assets/social-preview.png
Upload it at repo Settings -> General -> Social preview.
"""
import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

W, H = 1280, 640
M = 88  # left margin
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "social-preview.png")
FONT_DIR = "/usr/share/fonts/truetype/dejavu"


def font(name, size):
    return ImageFont.truetype(os.path.join(FONT_DIR, name), size)


BOLD = "DejaVuSans-Bold.ttf"
REG = "DejaVuSans.ttf"

ACCENT = (167, 139, 250)      # light purple
ACCENT2 = (192, 132, 252)     # brighter purple
WHITE = (245, 243, 255)
MUTED = (198, 205, 224)
KICKER = (183, 148, 246)


def lerp(a, b, t):
    return int(a + (b - a) * t)


def background():
    top = (34, 18, 62)
    bot = (11, 7, 22)
    img = Image.new("RGB", (W, H))
    px = img.load()
    for y in range(H):
        t = y / H
        row = (lerp(top[0], bot[0], t), lerp(top[1], bot[1], t), lerp(top[2], bot[2], t))
        for x in range(W):
            px[x, y] = row
    # soft purple glow, top-left light source
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse([-200, -320, 760, 420], fill=(139, 92, 246, 70))
    glow = glow.filter(ImageFilter.GaussianBlur(150))
    img = Image.alpha_composite(img.convert("RGBA"), glow).convert("RGB")
    return img


def draw_spaced(draw, xy, text, fnt, fill, spacing):
    x, y = xy
    for ch in text:
        draw.text((x, y), ch, font=fnt, fill=fill)
        x += draw.textlength(ch, font=fnt) + spacing
    return x


def lightning(draw, x, y, h, fill):
    # simple bolt, height h, anchored top-left at (x, y)
    w = h * 0.55
    pts = [
        (x + w * 0.55, y),
        (x + w * 0.05, y + h * 0.58),
        (x + w * 0.45, y + h * 0.58),
        (x + w * 0.30, y + h),
        (x + w * 0.95, y + h * 0.38),
        (x + w * 0.52, y + h * 0.38),
    ]
    draw.polygon(pts, fill=fill)
    return w


def main():
    img = background()
    d = ImageDraw.Draw(img)

    # left brand spine
    d.rectangle([0, 0, 9, H], fill=(139, 92, 246))

    # kicker
    draw_spaced(d, (M, 92), "AWESOME ON-DEVICE AI APPS", font(BOLD, 27), KICKER, 6)

    # headline
    hl = font(BOLD, 90)
    y1 = 156
    x = M
    d.text((x, y1), "36", font=hl, fill=ACCENT2)
    x += d.textlength("36", font=hl)
    d.text((x, y1), " AI apps that run", font=hl, fill=WHITE)
    d.text((M, y1 + 104), "100% on your phone.", font=hl, fill=WHITE)

    # subline, auto-fit width
    sub = "No cloud   ·   $0 to run   ·   Offline   ·   No compliance wall"
    size = 34
    while size > 22:
        f = font(REG, size)
        if d.textlength(sub, font=f) <= W - 2 * M:
            break
        size -= 1
    d.text((M, 402), sub, font=font(REG, size), fill=MUTED)

    # bottom: platform pills
    py, ph = 520, 58
    pf = font(BOLD, 30)
    x = M
    for label in ("Android", "iOS", "Flutter"):
        tw = d.textlength(label, font=pf)
        pw = tw + 52
        d.rounded_rectangle([x, py, x + pw, py + ph], radius=ph // 2,
                            outline=ACCENT, width=3)
        d.text((x + 26, py + (ph - 38) // 2), label, font=pf, fill=WHITE)
        x += pw + 20

    # bottom-right: powered by Melange
    mf = font(BOLD, 32)
    label = "Powered by Melange"
    tw = d.textlength(label, font=mf)
    bolt_w = lightning(d, W - M - tw - 44, py + 8, 42, ACCENT2)
    d.text((W - M - tw, py + (ph - 42) // 2), label, font=mf, fill=ACCENT)

    img.save(OUT)
    print("wrote", OUT, img.size)


if __name__ == "__main__":
    main()
