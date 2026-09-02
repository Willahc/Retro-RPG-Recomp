#!/usr/bin/env python3
"""Read-only Gate 0 validator for the canonical Lacroan' Heroes ROM."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import zlib
from pathlib import Path

EXPECTED = {
    "title": "GB LACROANHERO 1",
    "size": 131_072,
    "cartridge_type": 0x06,
    "rom_size_code": 0x02,
    "ram_size_code": 0x00,
    "destination_code": 0x00,
    "revision": 0,
    "crc32": "c9dbba10",
    "md5": "5c815764df1d3c04d99a9bc5b298aa2c",
    "sha1": "bc598168a70bbbc1b89b3de13086ec89e8ce9ded",
    "sha256": "fdbf98df05d2af9f81b2ae09b06c651987d5eb92d222758c2281b631077c8f5a",
}


def header_checksum(data: bytes) -> int:
    value = 0
    for byte in data[0x134:0x14D]:
        value = (value - byte - 1) & 0xFF
    return value


def global_checksum(data: bytes) -> int:
    return (sum(data[:0x14E]) + sum(data[0x150:])) & 0xFFFF


def inspect_rom(path: Path) -> dict[str, object]:
    data = path.read_bytes()
    title = data[0x134:0x144].split(b"\0", 1)[0].decode("ascii", "replace") if len(data) >= 0x150 else ""
    result: dict[str, object] = {
        "path": str(path),
        "size": len(data),
        "title": title,
        "cartridge_type": data[0x147] if len(data) > 0x147 else None,
        "rom_size_code": data[0x148] if len(data) > 0x148 else None,
        "ram_size_code": data[0x149] if len(data) > 0x149 else None,
        "destination_code": data[0x14A] if len(data) > 0x14A else None,
        "revision": data[0x14C] if len(data) > 0x14C else None,
        "crc32": f"{zlib.crc32(data) & 0xFFFFFFFF:08x}",
        "md5": hashlib.md5(data).hexdigest(),
        "sha1": hashlib.sha1(data).hexdigest(),
        "sha256": hashlib.sha256(data).hexdigest(),
        "banks_16k": len(data) // 0x4000 if len(data) % 0x4000 == 0 else None,
    }
    if len(data) >= 0x150:
        stored_header = data[0x14D]
        stored_global = int.from_bytes(data[0x14E:0x150], "big")
        result.update(
            header_checksum_stored=stored_header,
            header_checksum_computed=header_checksum(data),
            header_checksum_valid=stored_header == header_checksum(data),
            global_checksum_stored=stored_global,
            global_checksum_computed=global_checksum(data),
            global_checksum_valid=stored_global == global_checksum(data),
        )
    result["canonical"] = all(result.get(key) == value for key, value in EXPECTED.items())
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("rom", type=Path)
    args = parser.parse_args()
    result = inspect_rom(args.rom)
    print(json.dumps(result, indent=2, ensure_ascii=False))
    return 0 if result["canonical"] else 1


if __name__ == "__main__":
    sys.exit(main())

