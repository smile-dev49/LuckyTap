from PIL import Image, ImageDraw, ImageEnhance
from pathlib import Path
import json

root = Path(r"D:\Working\Mobile App Development\LuckyTap")
icon_path = root / "DesignReferences" / "icon.jpg"
ui_path = root / "DesignReferences" / "ui_reference.png"
assets = root / "LuckyTap" / "Assets.xcassets"

icon = Image.open(icon_path).convert("RGBA")
print("icon size", icon.size)


def make_square(img, size=1024):
    w, h = img.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    cropped = img.crop((left, top, left + side, top + side))
    return cropped.resize((size, size), Image.Resampling.LANCZOS)


def write_imageset(name, filespecs):
    d = assets / f"{name}.imageset"
    d.mkdir(parents=True, exist_ok=True)
    images = []
    for fname, scale in filespecs:
        images.append({"filename": fname, "idiom": "universal", "scale": scale})
    (d / "Contents.json").write_text(
        json.dumps({"images": images, "info": {"author": "xcode", "version": 1}}, indent=2),
        encoding="utf-8",
    )


def save_square_imageset(name, img, base=200):
    d = assets / f"{name}.imageset"
    d.mkdir(parents=True, exist_ok=True)
    files = []
    for scale, suffix in [(1, ""), (2, "@2x"), (3, "@3x")]:
        px = base * scale
        fitted = Image.new("RGBA", (px, px), (0, 0, 0, 0))
        ratio = min(px / img.size[0], px / img.size[1])
        nw, nh = int(img.size[0] * ratio), int(img.size[1] * ratio)
        resized = img.resize((nw, nh), Image.Resampling.LANCZOS)
        if resized.mode != "RGBA":
            resized = resized.convert("RGBA")
        fitted.paste(resized, ((px - nw) // 2, (px - nh) // 2), resized)
        fname = f"{name}{suffix}.png"
        fitted.save(d / fname, "PNG")
        files.append((fname, f"{scale}x"))
    write_imageset(name, files)
    print("saved imageset", name)


# App Icon
app_icon = make_square(icon, 1024).convert("RGB")
appicon_dir = assets / "AppIcon.appiconset"
appicon_dir.mkdir(parents=True, exist_ok=True)
app_icon.save(appicon_dir / "AppIcon.png", "PNG")
(appicon_dir / "Contents.json").write_text(
    json.dumps(
        {
            "images": [
                {
                    "filename": "AppIcon.png",
                    "idiom": "universal",
                    "platform": "ios",
                    "size": "1024x1024",
                }
            ],
            "info": {"author": "xcode", "version": 1},
        },
        indent=2,
    ),
    encoding="utf-8",
)
print("saved AppIcon.png")

square_icon = make_square(icon, 1024)
save_square_imageset("lucky_tap_logo", square_icon, base=200)
save_square_imageset("branding_hero", square_icon, base=360)

# Background
bg = icon.resize((750, 1334), Image.Resampling.LANCZOS)
bg_dark = ImageEnhance.Brightness(bg).enhance(0.42)
bg_dir = assets / "game_background.imageset"
bg_dir.mkdir(parents=True, exist_ok=True)
bg_dark.save(bg_dir / "game_background.png", "PNG")
bg_dark.resize((1500, 2668), Image.Resampling.LANCZOS).save(bg_dir / "game_background@2x.png", "PNG")
bg_dark.resize((2250, 4002), Image.Resampling.LANCZOS).save(bg_dir / "game_background@3x.png", "PNG")
write_imageset(
    "game_background",
    [
        ("game_background.png", "1x"),
        ("game_background@2x.png", "2x"),
        ("game_background@3x.png", "3x"),
    ],
)
print("saved game_background")

# Coin icon
coin = Image.new("RGBA", (192, 192), (0, 0, 0, 0))
draw = ImageDraw.Draw(coin)
draw.ellipse((8, 8, 184, 184), fill=(255, 200, 40, 255), outline=(180, 120, 20, 255), width=6)
draw.ellipse((40, 40, 152, 152), fill=(255, 220, 80, 255))
draw.ellipse((60, 60, 132, 132), outline=(160, 100, 15, 255), width=5)
coin_dir = assets / "coin_icon.imageset"
coin_dir.mkdir(parents=True, exist_ok=True)
for fname, sz in [("coin_icon.png", 64), ("coin_icon@2x.png", 128), ("coin_icon@3x.png", 192)]:
    coin.resize((sz, sz), Image.Resampling.LANCZOS).save(coin_dir / fname, "PNG")
write_imageset(
    "coin_icon",
    [
        ("coin_icon.png", "1x"),
        ("coin_icon@2x.png", "2x"),
        ("coin_icon@3x.png", "3x"),
    ],
)

# UI reference panels (2x2)
ui = Image.open(ui_path).convert("RGBA")
print("ui size", ui.size)
w, h = ui.size
panels = {
    "ui_home_ref": (0, 0, w // 2, h // 2),
    "ui_game_ref": (w // 2, 0, w, h // 2),
    "ui_rewards_ref": (0, h // 2, w // 2, h),
}
for name, box in panels.items():
    panel = ui.crop(box)
    d = assets / f"{name}.imageset"
    d.mkdir(parents=True, exist_ok=True)
    panel.save(d / f"{name}@3x.png", "PNG")
    panel.resize((panel.size[0] // 2, panel.size[1] // 2), Image.Resampling.LANCZOS).save(
        d / f"{name}@2x.png", "PNG"
    )
    panel.resize((max(1, panel.size[0] // 3), max(1, panel.size[1] // 3)), Image.Resampling.LANCZOS).save(
        d / f"{name}.png", "PNG"
    )
    write_imageset(
        name,
        [
            (f"{name}.png", "1x"),
            (f"{name}@2x.png", "2x"),
            (f"{name}@3x.png", "3x"),
        ],
    )
    print("saved panel", name, panel.size)

print("DONE")
