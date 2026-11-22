#!/usr/bin/env python3
"""Offline repository validation; requires only the Python standard library."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
THEME = ROOT / "config" / "apple-tv-jhsd200" / "config.json"
DEBLOAT = ROOT / "config" / "debloat-jhsd200.txt"

EXPECTED_DOCK = [
    "com.jio.media.jiotvplus",
    "com.jio.yt",
    "com.netflix.ninja",
    "in.startv.hotstar",
    "com.jiotv.sonyliv",
]

PROTECTED = {
    "android",
    "com.android.systemui",
    "com.android.shell",
    "com.android.phone",
    "com.android.settings",
    "com.android.tv.settings",
}


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def validate_theme() -> None:
    data = json.loads(THEME.read_text(encoding="utf-8"))
    if data.get("columns") != 5:
        fail("theme columns must remain 5")
    if data.get("dock_apps") != EXPECTED_DOCK:
        fail("dock order changed without updating the tested contract")
    if data.get("advanced_effects") is not False:
        fail("advanced effects must stay off for the 1 GB device")
    for entry in data.get("app_keys", []):
        if not re.fullmatch(r"scan:\d+:[A-Za-z_][A-Za-z0-9_.]+", entry):
            fail(f"invalid app_keys entry: {entry}")


def validate_debloat() -> None:
    packages = []
    for raw in DEBLOAT.read_text(encoding="utf-8").splitlines():
        line = raw.split("#", 1)[0].strip()
        if line:
            packages.append(line.split()[0])
    if len(packages) != 6:
        fail(f"expected six tested packages, found {len(packages)}")
    if len(packages) != len(set(packages)):
        fail("duplicate package in debloat list")
    for package in packages:
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z0-9_]+)+", package):
            fail(f"invalid package name: {package}")
        if package in PROTECTED or package.startswith("com.android.providers."):
            fail(f"protected Android package in debloat list: {package}")


def validate_no_sensitive_artifacts() -> None:
    forbidden_suffixes = {".apk", ".aab", ".pem", ".p12", ".pfx", ".jks", ".keystore", ".pcap", ".pcapng"}
    forbidden_names = {"adbkey", "adbkey.pub", ".env"}
    for path in ROOT.rglob("*"):
        if ".git" in path.parts or not path.is_file():
            continue
        if path.resolve() == Path(__file__).resolve():
            continue
        if path.name in forbidden_names or path.suffix.lower() in forbidden_suffixes:
            fail(f"sensitive or binary artifact committed: {path.relative_to(ROOT)}")
        if path.suffix.lower() in {".md", ".txt", ".json", ".ps1", ".py", ".yml", ".yaml"}:
            text = path.read_text(encoding="utf-8", errors="replace")
            if "BEGIN PRIVATE KEY" in text or "BEGIN RSA PRIVATE KEY" in text:
                fail(f"private key material in {path.relative_to(ROOT)}")


def validate_relative_markdown_links() -> None:
    for document in ROOT.rglob("*.md"):
        text = document.read_text(encoding="utf-8")
        for target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", text):
            target = target.strip().split("#", 1)[0]
            if not target or target.startswith(("http://", "https://", "mailto:")):
                continue
            candidate = (document.parent / target).resolve()
            if not candidate.exists():
                fail(f"broken link in {document.relative_to(ROOT)}: {target}")


if __name__ == "__main__":
    validate_theme()
    validate_debloat()
    validate_no_sensitive_artifacts()
    validate_relative_markdown_links()
    print("repository validation passed")
