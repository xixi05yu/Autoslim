# Autoslim

Autoslim is a framework for AI graph pruning. It generates synthetic state-transition graphs, converts them into structured CSVs, prunes edges based on score thresholds and machine learning, and exports results for analysis or hardware simulation.

## Features
- Generate random XML graphs with configurable size and fan-out.
- Convert XML → CSV with state transitions and scores.
- Prune graphs using thresholds and Random Forest models.
- Export results to plots, logs, and Memory Initialization Files (MIF).

## Makefile Overview
The Makefile automates the full workflow:
  make → compiles the C++ tools (gen_xml_multiple_files4, generate_csv_multiple).
  make genFolder → creates experiment folders for different dataset sizes (1K–64K).
  make run → generates graphs, converts to CSV, and runs pruning for all dataset sizes.
  make beforemif → generate MIF files from raw CSVs.
  make prunedmif → generate MIF files from pruned CSVs.
  make clean → remove generated binaries and results.

## Usage
Typical workflow:
### Compile tools
```
make
```
### Create experiment folders
```
make genFolder
```
### Run full pipeline (generate, convert, prune) for 1K–64K graphs
```
make run
```
### Export MIF files (before or after pruning)
```
make beforemif
make prunedmif
```

**Results are organized in folders like 1A_xmlFiles, 1A_csvFiles, 1A_prunedResults, etc.**
