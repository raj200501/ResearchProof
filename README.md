# ResearchProof

**ResearchProof** is a proof verification tool inspired by Idris. Researchers write
proof scripts (`.rp` files) and ResearchProof checks them with a lightweight, deterministic
proof checker implemented in Python. The repository also contains Idris reference modules
(`src/Proof`) for readers who want to compare the library to Idris syntax.

## Features

- Verifies mathematical proofs using a deterministic, Idris-inspired checker.
- Provides a growing library of reusable proof lemmas.
- Includes example proof scripts in `examples/`.
- Offers a single verification entrypoint (`scripts/verify.sh`).

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ResearchProof.git
   cd ResearchProof
   ```

2. (Optional) Install Idris if you want to cross-check proofs with the Idris compiler:
   ```bash
   ./scripts/bootstrap_idris.sh
   ```

3. Build the Python checker:
   ```bash
   ./build/build.sh
   ```

## Usage

### Verify the default quickstart script

```bash
./scripts/run.sh
```

### Verify your own proof script

```bash
./scripts/run.sh examples/quickstart.rp
```

You can also call the CLI directly:

```bash
python3 -m researchproof.cli verify examples/quickstart.rp
```

## Verified Quickstart

These are the exact commands used to verify the repo works end-to-end:

```bash
./build/build.sh
./scripts/run.sh examples/quickstart.rp
```

## Verification (tests + smoke checks)

Use the canonical verification command:

```bash
./scripts/verify.sh
```

This command builds the Python checker, runs unit tests for the proof script parser and
proof checker, and verifies two proof scripts as smoke tests.

## Proof language reference

See `docs/PROOF_LANGUAGE.md` for the formal proof script format and
`docs/PROOF_LIBRARY.md` for the proof library catalog.

## Troubleshooting

If you run into issues, check `docs/TROUBLESHOOTING.md`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
