#!/usr/bin/env python3
"""Regenerate the app catalog in README.md and apps/README.md from per-app meta.json.

Single source of truth: apps/<slug>/meta.json. Run this after adding or editing an
app so the catalog never rots. CI can run it with --check to fail on drift.

    python3 scripts/generate_catalog.py          # rewrite catalogs
    python3 scripts/generate_catalog.py --check   # exit 1 if catalogs are stale
"""
import glob
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Category display order + emoji. Apps in an unlisted category are appended last.
CATEGORY_ORDER = [
    ("Language & Text", "💬"),
    ("Vision", "👁️"),
    ("Health & Wellbeing", "❤️"),
    ("Audio", "🔊"),
    ("Forecasting", "📈"),
]

START = "<!-- CATALOG:START -->"
END = "<!-- CATALOG:END -->"


def load_apps():
    apps = []
    for path in sorted(glob.glob(os.path.join(ROOT, "apps", "*", "meta.json"))):
        with open(path) as f:
            meta = json.load(f)
        slug = meta.get("slug") or os.path.basename(os.path.dirname(path))
        meta["slug"] = slug
        # auto-detect platforms if not declared
        if not meta.get("platforms"):
            appdir = os.path.dirname(path)
            plats = [p for p in ("Android", "iOS", "Flutter") if os.path.isdir(os.path.join(appdir, p))]
            meta["platforms"] = plats
        apps.append(meta)
    return apps


def grouped(apps):
    order = {c: i for i, (c, _) in enumerate(CATEGORY_ORDER)}
    cats = {}
    for a in apps:
        cats.setdefault(a.get("category", "Other"), []).append(a)
    for c in cats:
        cats[c].sort(key=lambda a: a["name"].lower())
    return sorted(cats.items(), key=lambda kv: (order.get(kv[0], 999), kv[0]))


def emoji_for(cat):
    for c, e in CATEGORY_ORDER:
        if c == cat:
            return e
    return "📦"


def platform_badges(plats):
    icons = {"Android": "Android", "iOS": "iOS", "Flutter": "Flutter"}
    return " ".join(f"`{icons.get(p, p)}`" for p in plats) or "—"


def render_catalog(apps):
    lines = []
    for cat, items in grouped(apps):
        lines.append(f"### {emoji_for(cat)} {cat}")
        lines.append("")
        lines.append("| App | What it does | Model | Platforms | Try it |")
        lines.append("| :-- | :-- | :-- | :-- | :-- |")
        for a in items:
            name = f"[**{a['name']}**](apps/{a['slug']})"
            try_ = f"[Model ↗]({a['melange']})" if a.get("melange") else "—"
            lines.append(
                f"| {name} | {a['tagline']} | `{a['model']}` | {platform_badges(a['platforms'])} | {try_} |"
            )
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def render_apps_index(apps):
    out = ["# App Index", "", f"{len(apps)} on-device AI apps. Every one runs 100% on the phone.", ""]
    out.append(render_catalog(apps))
    out.append("> Generated from each app's `meta.json` by `scripts/generate_catalog.py`. Do not edit by hand.")
    return "\n".join(out) + "\n"


def splice(text, catalog):
    if START not in text or END not in text:
        raise SystemExit(f"markers {START} / {END} not found in README.md")
    pre = text.split(START)[0]
    post = text.split(END)[1]
    return f"{pre}{START}\n\n{catalog}\n{END}{post}"


def main():
    check = "--check" in sys.argv
    apps = load_apps()
    catalog = render_catalog(apps)

    readme_path = os.path.join(ROOT, "README.md")
    with open(readme_path) as f:
        readme = f.read()
    new_readme = splice(readme, catalog)

    index_path = os.path.join(ROOT, "apps", "README.md")
    new_index = render_apps_index(apps)
    old_index = open(index_path).read() if os.path.exists(index_path) else ""

    stale = (new_readme != readme) or (new_index != old_index)
    if check:
        if stale:
            print("Catalog is stale. Run: python3 scripts/generate_catalog.py")
            sys.exit(1)
        print(f"Catalog up to date ({len(apps)} apps).")
        return

    with open(readme_path, "w") as f:
        f.write(new_readme)
    with open(index_path, "w") as f:
        f.write(new_index)
    print(f"Regenerated catalog for {len(apps)} apps.")


if __name__ == "__main__":
    main()
