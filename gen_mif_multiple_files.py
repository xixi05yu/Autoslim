import argparse
import os
import pandas as pd

def generate_mif(data, width, output_path):
    depth = len(data)

    with open(output_path, 'w') as f:
        f.write(f"WIDTH={width};\n")
        f.write(f"DEPTH={depth};\n")
        f.write("ADDRESS_RADIX=UNS;\n")
        f.write("DATA_RADIX=UNS;\n")
        f.write("CONTENT BEGIN\n")

        for i, value in enumerate(data):
            f.write(f"{i} : {int(value)};\n")

        f.write("END;\n")

def main():
    parser = argparse.ArgumentParser(description="Convert CSV files to MIF files using 'Score' column.")
    parser.add_argument("startFileNum", type=int, help="Start file number")
    parser.add_argument("endFileNum", type=int, help="End file number")
    parser.add_argument("inputFolder", type=str, help="Input folder with CSV files")
    parser.add_argument("outputFolder", type=str, help="Output folder for MIF files")
    parser.add_argument("--width", type=int, default=8, help="Bit width of the memory")
    args = parser.parse_args()

    os.makedirs(args.outputFolder, exist_ok=True)

    for fileNum in range(args.startFileNum, args.endFileNum + 1):
        # Try both file name patterns
        file_patterns = [
            f"state_transitions{fileNum}.csv",
            f"pruned_csv_file{fileNum}.csv"
        ]

        csv_path = None
        for name in file_patterns:
            potential_path = os.path.join(args.inputFolder, name)
            if os.path.exists(potential_path):
                csv_path = potential_path
                break

        if csv_path is None:
            print(f"Skipping file {fileNum}: no matching CSV found.")
            continue

        mif_path = os.path.join(args.outputFolder, f"MIF_File{fileNum}.mif")

        try:
            df = pd.read_csv(csv_path)

            if "Score" not in df.columns:
                raise ValueError("CSV file must contain a 'Score' column.")

            values = df["Score"].values
            generate_mif(values, args.width, mif_path)
            print(f"Created {mif_path}")

        except Exception as e:
            print(f"Error processing {csv_path}: {e}")

if __name__ == "__main__":
    main()

