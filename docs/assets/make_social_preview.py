#!/usr/bin/env python3
"""Render the GitHub social preview cards (1280x640 PNG).

    python3 docs/assets/make_social_preview.py

Outputs:
  docs/assets/social-preview.png             (default: the concrete claim)
  docs/assets/social-preview-vibecoding.png  (the vibe-coding hook)

Upload one at repo Settings -> General -> Social preview.
"""
import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

W, H = 1280, 640
M = 88  # left margin
HERE = os.path.dirname(os.path.abspath(__file__))
FONT_DIR = "/usr/share/fonts/truetype/dejavu"
BOLD = "DejaVuSans-Bold.ttf"
REG = "DejaVuSans.ttf"

ACCENT = (167, 139, 250)      # light purple
ACCENT2 = (192, 132, 252)     # brighter purple
WHITE = (245, 243, 255)
MUTED = (198, 205, 224)
KICKER = (183, 148, 246)


def font(name, size):
    return ImageFont.truetype(os.path.join(FONT_DIR, name), size)


def lerp(a, b, t):
    return int(a + (b - a) * t)


def background():
    top, bot = (34, 18, 62), (11, 7, 22)
    img = Image.new("RGB", (W, H))
    px = img.load()
    for y in range(H):
        t = y / H
        row = (lerp(top[0], bot[0], t), lerp(top[1], bot[1], t), lerp(top[2], bot[2], t))
        for x in range(W):
            px[x, y] = row
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(glow).ellipse([-200, -320, 760, 420], fill=(139, 92, 246, 70))
    glow = glow.filter(ImageFilter.GaussianBlur(150))
    img = Image.alpha_composite(img.convert("RGBA"), glow).convert("RGB")
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, 9, H], fill=(139, 92, 246))  # brand spine
    return img, d


def draw_spaced(draw, xy, text, fnt, fill, spacing):
    x, y = xy
    for ch in text:
        draw.text((x, y), ch, font=fnt, fill=fill)
        x += draw.textlength(ch, font=fnt) + spacing
    return x


def lightning(draw, x, y, h, fill):
    w = h * 0.55
    pts = [(x + w * 0.55, y), (x + w * 0.05, y + h * 0.58), (x + w * 0.45, y + h * 0.58),
           (x + w * 0.30, y + h), (x + w * 0.95, y + h * 0.38), (x + w * 0.52, y + h * 0.38)]
    draw.polygon(pts, fill=fill)


def melange_mark(d, baseline_y, size=30):
    label = "Powered by Melange"
    mf = font(BOLD, size)
    tw = d.textlength(label, font=mf)
    lightning(d, W - M - tw - 42, baseline_y + 2, size + 8, ACCENT2)
    d.text((W - M - tw, baseline_y), label, font=mf, fill=ACCENT)


def fit(d, text, name, start, minimum):
    size = start
    while size > minimum:
        f = font(name, size)
        if d.textlength(text, font=f) <= W - 2 * M:
            return f
        size -= 1
    return font(name, minimum)


def render_default():
    img, d = background()
    draw_spaced(d, (M, 92), "AWESOME ON-DEVICE AI APPS", font(BOLD, 27), KICKER, 6)
    hl = font(BOLD, 90)
    x = M
    d.text((x, 156), "36", font=hl, fill=ACCENT2)
    x += d.textlength("36", font=hl)
    d.text((x, 156), " AI apps that run", font=hl, fill=WHITE)
    d.text((M, 260), "100% on your phone.", font=hl, fill=WHITE)
    sub = "No cloud   ·   $0 to run   ·   Offline   ·   No compliance wall"
    d.text((M, 402), sub, font=fit(d, sub, REG, 34, 22), fill=MUTED)
    py, ph = 520, 58
    pf = font(BOLD, 30)
    x = M
    for label in ("Android", "iOS", "Flutter"):
        pw = d.textlength(label, font=pf) + 52
        d.rounded_rectangle([x, py, x + pw, py + ph], radius=ph // 2, outline=ACCENT, width=3)
        d.text((x + 26, py + 10), label, font=pf, fill=WHITE)
        x += pw + 20
    melange_mark(d, py + 12, 32)
    out = os.path.join(HERE, "social-preview.png")
    img.save(out)
    print("wrote", out)


def render_vibecoding():
    img, d = background()
    hook = font(BOLD, 62)
    d.text((M, 84), "Your AI coding agent", font=hook, fill=WHITE)
    x = M
    d.text((x, 160), "can't", font=hook, fill=ACCENT2)
    x += d.textlength("can't", font=hook)
    d.text((x, 160), " build on-device apps.", font=hook, fill=WHITE)

    d.rounded_rectangle([M, 286, M + 96, 292], radius=3, fill=ACCENT)  # beat

    turn = font(BOLD, 84)
    d.text((M, 322), "These 36 can.", font=turn, fill=ACCENT2)
    sub = "Real apps, running 100% on the phone.   Private · $0 · Offline."
    d.text((M, 430), sub, font=fit(d, sub, REG, 33, 22), fill=MUTED)

    draw_spaced(d, (M, 560), "AWESOME ON-DEVICE AI APPS", font(BOLD, 24), KICKER, 4)
    melange_mark(d, 558, 30)
    out = os.path.join(HERE, "social-preview-vibecoding.png")
    img.save(out)
    print("wrote", out)


def render_business():
    img, d = background()
    hook = font(BOLD, 64)
    d.text((M, 92), "Ship the AI features", font=hook, fill=WHITE)
    d.text((M, 168), "the cloud legally can't.", font=hook, fill=WHITE)

    d.rounded_rectangle([M, 292, M + 96, 298], radius=3, fill=ACCENT)  # beat

    turn = "No compliance wall.  $0 at scale."
    d.text((M, 326), turn, font=fit(d, turn, BOLD, 66, 40), fill=ACCENT2)
    sub = "36 on-device apps for health, fintech, and enterprise."
    d.text((M, 440), sub, font=fit(d, sub, REG, 33, 22), fill=MUTED)

    draw_spaced(d, (M, 560), "AWESOME ON-DEVICE AI APPS", font(BOLD, 24), KICKER, 4)
    melange_mark(d, 558, 30)
    out = os.path.join(HERE, "social-preview-business.png")
    img.save(out)
    print("wrote", out)


if __name__ == "__main__":
    render_default()
    render_vibecoding()
    render_business()
