# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal MATLAB utility library (no build system, no package/namespace) for electrophysiology and behavior analysis: reading Neuralynx/EDF/Kinect data, artifact handling, spectrograms, hypnograms/ethograms, stats, and plotting helpers. Every `.m` file is a standalone function on the MATLAB path; callers are expected to `addpath(genpath(...))` the repo root, so functions in different subfolders call each other freely (e.g. `plots/plotethogram.m` calls root-level `buildethomat.m`). Function names must stay globally unique across all subfolders.

## Running tests

There is no test runner config; tests are run from MATLAB (or the `matlab` MCP tools). Two styles coexist:

- **Script-based tests** (`nlynx/test*.m`): plain scripts with `%%` sections and `assert`. They load fixtures via relative paths like `'TestData\sampleCSC3-23'`, so the working directory must be `nlynx/`:
  ```matlab
  cd nlynx; results = runtests('testreadcsc')
  ```
- **Function-based tests** (`plots/testplotethogram.m`): `functiontests(localfunctions)` with `verify*` calls; figures are created with `'Visible','off'` and closed via `onCleanup`.
  ```matlab
  results = runtests('plots/testplotethogram.m')
  results = runtests('plots/testplotethogram.m', 'ProcedureName', 'testsinglerow')  % single test
  ```

Static analysis: `checkcode('file.m')` (or `mcp__matlab__check_matlab_code`).

## External dependencies (not in repo)

- `nlynx/` readers (and `specgramChunks`, `specgramLfp`) call Neuralynx's `Nlx2Mat*` MEX functions; `*.mexw64`/`*.mexa64` are gitignored, so these must be on the path separately. Test fixtures live in `nlynx/TestData/` (file-suffix 1/2/3 = Cheetah 5.4/5.6/5.7 header revisions; see its readme).
- `ffrmlinesc`, `specgramChunks`, `specgramLfp` use Chronux (`mtspecgramc`, etc.).
- `*.mat`, `*.fig`, `*.csv`, `*.asv`, `*.zip` are gitignored. Colormaps were deliberately converted from `.mat` to `.m` functions so they can be tracked — add new colormaps as `.m` functions (see `colormaps/hypnomap.m` for the pattern: `cmap()` returns all colors, `cmap(m)` returns the first `m`). Crameri maps are MIT-licensed; keep `colormaps/LICENSE_crameri.txt` and the attribution in `colormaps/README.txt` updated.

## Conventions

- Function names are all-lowercase, no underscores (`plotethogram`, `getepochidx`); older ones use an `ff` prefix. Variables are camelCase.
- Help block immediately after the `function` line: `% NAME short description.` followed by `Usage:`/`Syntax:`, `Input:`, `Output:` (and optionally `Description:`, `Examples:`, `Dependencies:`) sections. See `plots/flipyaxis.m`.
- Spaces inside parentheses and brackets: `size( x, 1 )`, `[ 1 2 3 ]`, `for i = 1 : n`. A blank line before `end`/`else` closing a block is common in newer code.
- Newer functions use an `arguments` block with name-value options (`opts.Name`); older ones use `nargin` checks.
- Line endings are mixed (no `.gitattributes`, `core.autocrlf=false`); recent commits normalize edited files to LF — write new files with LF.
- Commit messages: short, lowercase, imperative sentence ending in a period (e.g. `add flipyaxis to plot positive-down y axes.`).
- The working branch is `master`; it is pushed to three remotes (`github`, `mit`, `bb`).
