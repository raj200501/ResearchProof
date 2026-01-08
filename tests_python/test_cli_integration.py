import subprocess
import sys
import unittest
from pathlib import Path


class CliIntegrationTests(unittest.TestCase):
    def test_verify_quickstart_script(self) -> None:
        repo_root = Path(__file__).resolve().parents[1]
        proof_path = repo_root / "examples" / "quickstart.rp"
        result = subprocess.run(
            [sys.executable, "-m", "researchproof.cli", "verify", str(proof_path)],
            capture_output=True,
            text=True,
            check=False,
        )
        if result.returncode != 0:
            raise AssertionError(
                "CLI verification failed:\n"
                f"stdout:\n{result.stdout}\n"
                f"stderr:\n{result.stderr}"
            )


if __name__ == "__main__":
    unittest.main()
