#!/usr/bin/env python3
"""Minimal PDF text extractor (no external deps).

Enough for the AMD ISA PDFs: inflate every FlateDecode stream, then pull text out
of the content operators. This document encodes its text as identity-mapped hex
strings (``<48656c6c6f> Tj``), so no CMap handling is needed. Line breaks are
recovered from the Td/TD y-coordinate changing.
"""
import re
import sys
import zlib

STREAM = re.compile(rb"stream\r?\n", re.S)
# text-positioning and text-showing operators, in stream order
TOKEN = re.compile(
    rb"<([0-9A-Fa-f\s]*)>\s*(?:Tj|')"          # 1: hex string shown
    rb"|\[((?:[^\[\]]|\\.)*)\]\s*TJ"            # 2: array of pieces
    rb"|([-\d.]+)\s+([-\d.]+)\s+(?:Td|TD)"      # 3,4: move to x,y
    rb"|(T\*)",                                  # 5: next line
    re.S,
)
HEXPIECE = re.compile(rb"<([0-9A-Fa-f\s]*)>")
KERN = re.compile(rb"(-?\d+(?:\.\d+)?)")


def unhex(h: bytes) -> str:
    h = re.sub(rb"\s", b"", h)
    if len(h) % 2:
        h = h[:-1]
    try:
        return bytes.fromhex(h.decode("ascii")).decode("latin-1")
    except ValueError:
        return ""


def inflate_streams(data: bytes):
    out, pos = [], 0
    while True:
        m = STREAM.search(data, pos)
        if not m:
            break
        start = m.end()
        end = data.find(b"endstream", start)
        if end < 0:
            break
        raw = data[start:end]
        pos = end + 9
        for cand in (raw, raw.rstrip(b"\r\n")):
            try:
                out.append(zlib.decompress(cand))
                break
            except zlib.error:
                continue
    return out


def text_from_content(buf: bytes) -> str:
    parts, last_y = [], None
    for m in TOKEN.finditer(buf):
        if m.group(1) is not None:
            parts.append(unhex(m.group(1)))
        elif m.group(2) is not None:
            inner = m.group(2)
            # TJ array: hex pieces separated by kerning numbers; a big negative
            # kern is an inter-word space
            for tok in re.finditer(rb"<([0-9A-Fa-f\s]*)>|(-?\d+(?:\.\d+)?)", inner):
                if tok.group(1) is not None:
                    parts.append(unhex(tok.group(1)))
                elif float(tok.group(2)) < -120:
                    parts.append(" ")
        elif m.group(5) is not None:
            parts.append("\n")
        else:
            y = float(m.group(4))
            if last_y is not None and abs(y - last_y) > 0.5:
                parts.append("\n")
            last_y = y
    return "".join(parts)


def main():
    src, dst = sys.argv[1], sys.argv[2]
    data = open(src, "rb").read()
    streams = inflate_streams(data)
    texts = [
        text_from_content(s)
        for s in streams
        if b"Tj" in s or b"TJ" in s
    ]
    out = re.sub(r"[ \t]+\n", "\n", "\n".join(t for t in texts if t.strip()))
    out = re.sub(r"\n{3,}", "\n\n", out)
    open(dst, "w", encoding="utf-8", errors="replace").write(out)
    print(f"{len(streams)} streams -> {len(out)} chars -> {dst}")


if __name__ == "__main__":
    main()
