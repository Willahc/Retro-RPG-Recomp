from __future__ import annotations

import os
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

from rominfo import EXPECTED, global_checksum, header_checksum, inspect_rom


class ChecksumTests(unittest.TestCase):
    def test_header_algorithm_zero_fixture(self) -> None:
        data = bytearray(0x150)
        self.assertEqual(header_checksum(bytes(data)), 0xE7)

    def test_global_checksum_excludes_stored_checksum(self) -> None:
        data = bytearray(0x150)
        data[0x14E] = 0xAA
        data[0x14F] = 0x55
        self.assertEqual(global_checksum(bytes(data)), 0)

    def test_manifest_has_all_fingerprints(self) -> None:
        self.assertEqual(len(EXPECTED["sha1"]), 40)
        self.assertEqual(len(EXPECTED["sha256"]), 64)
        self.assertEqual(EXPECTED["size"], 8 * 0x4000)


class CanonicalRomIntegrationTests(unittest.TestCase):
    @unittest.skipUnless(os.environ.get("LACROAN_ROM"), "set LACROAN_ROM to run private ROM integration tests")
    def test_private_rom_is_canonical(self) -> None:
        result = inspect_rom(Path(os.environ["LACROAN_ROM"]))
        self.assertTrue(result["canonical"], result)
        self.assertTrue(result["header_checksum_valid"])
        self.assertTrue(result["global_checksum_valid"])
        self.assertEqual(result["banks_16k"], 8)


if __name__ == "__main__":
    unittest.main()

