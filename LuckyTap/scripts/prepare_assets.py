from PIL import Image
from pathlib import Path
import json

"""
Prepare ONLY the App Icon from DesignReferences/icon.jpg.

Do NOT dump reference art into in-app UI imagesets.
Screens must be built with SwiftUI (shapes/gradients/text/SF Symbols).
"""

root = Path(r"D:\Working\Mobile App Development\LuckyTap")
icon_path = root / "DesignReferences" / "icon.jpg"
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
print("saved AppIcon.png only — UI uses SwiftUI, not reference bitmaps")
