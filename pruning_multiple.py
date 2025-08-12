import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
import time
import argparse
import os

# Argument parser for file range and folders
parser = argparse.ArgumentParser(description="Train a pruned Random Forest regressor based on degree.")
parser.add_argument("startFileNum", type=int, help="Start file number")
parser.add_argument("endFileNum", type=int, help="End file number")
parser.add_argument("inputFolder", type=str, help="Folder containing CSV files")
parser.add_argument("outputFolder", type=str, help="Folder to save plots and logs")
parser.add_argument("CSVOutputFolder", type=str, help="Folder to save pruned CSV files")
parser.add_argument("--threshold", type=float, default=0.5, help="Threshold for pruning transitions based on score")
args = parser.parse_args()

# Create or clear the total results summary file
total_summary_path = os.path.join(args.outputFolder, "total_results.txt")
with open(total_summary_path, 'w') as total_file:
    total_file.write(f"Summary of Results for Files {args.startFileNum} to {args.endFileNum}\n")
    total_file.write(f"Threshold for pruning: {args.threshold}\n\n")

summary_records = []

# Loop through file numbers
for fileNum in range(args.startFileNum, args.endFileNum + 1):
    file_path = os.path.join(args.inputFolder, f"state_transitions{fileNum}.csv")
    if not os.path.exists(file_path):
        file_path = os.path.join(args.inputFolder, f"pruned_csv_file{fileNum}.csv")
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue

    print(f"\nProcessing file: {file_path}")
    df = pd.read_csv(file_path)

    if 'State' not in df.columns or 'Total Degree' not in df.columns or 'Score' not in df.columns:
        raise ValueError("Expected columns: 'State', 'Total Degree', 'Score'")

    pruned_df = df[df['Score'] >= args.threshold]
    pruned_csv_path = os.path.join(args.CSVOutputFolder, f"pruned_csv_file{fileNum}.csv")
    pruned_df.to_csv(pruned_csv_path, index=False)

    total_nodes = pruned_df['State'].nunique()
    total_transitions = len(df)
    kept_transitions = len(pruned_df)
    pruned_transitions = total_transitions - kept_transitions
    percentage_pruned = (pruned_transitions / total_transitions) * 100
    percentage_kept = (kept_transitions / total_transitions) * 100
    avg_transitions_per_node = pruned_df.groupby("State").size().mean()
    max_transitions_on_node = pruned_df.groupby("State").size().max()

    # Save bar plot
    plt.figure(figsize=(8, 5))
    sns.countplot(x='Total Degree', data=pruned_df)
    plt.title(f'Distribution of Total Degree - File {fileNum}')
    plt.xlabel('Total Degree')
    plt.ylabel('Count')
    plt.tight_layout()
    plt.savefig(os.path.join(args.outputFolder, f"{fileNum}degree_distribution.png"))
    plt.close()

    # Train model
    X = pruned_df[['Total Degree']]
    y = pruned_df['Score']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = RandomForestRegressor()
    start_time = time.time()
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)
    execution_time = time.time() - start_time
    mse = mean_squared_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)

    # Save feature importance plot
    plt.figure(figsize=(8, 5))
    sns.barplot(x=model.feature_importances_, y=X.columns)
    plt.title(f"Feature Importances - File {fileNum}")
    plt.tight_layout()
    plt.savefig(os.path.join(args.outputFolder, f"{fileNum}feature_importance.png"))
    plt.close()

    # Save per-file log
    log_path = os.path.join(args.outputFolder, f"{fileNum}results.txt")
    with open(log_path, 'w') as f:
        f.write(f"File: {os.path.basename(file_path)}\n")
        f.write(f"Threshold: {args.threshold}\n\n")
        f.write(f"Total nodes: {total_nodes}\n")
        f.write(f"Total transitions: {total_transitions}\n")
        f.write(f"Kept transitions: {kept_transitions} ({percentage_kept:.2f}%)\n")
        f.write(f"Pruned transitions: {pruned_transitions} ({percentage_pruned:.2f}%)\n")
        f.write(f"Average transitions per node: {avg_transitions_per_node:.2f}\n")
        f.write(f"Maximum transitions on one node: {max_transitions_on_node}\n\n")
        f.write(f"Mean Squared Error (MSE): {mse:.4f}\n")
        f.write(f"R-squared (R2): {r2:.4f}\n")
        f.write(f"Execution Time: {execution_time:.4f} seconds\n")

    # Text + Excel record
    lines = [
        ("--- File" + str(fileNum), ""),
        ("Total nodes", total_nodes),
        ("Total transitions", total_transitions),
        ("Kept transitions", f"{kept_transitions} ({percentage_kept:.2f}%)"),
        ("Pruned transitions", f"{pruned_transitions} ({percentage_pruned:.2f}%)"),
        ("Average transitions per node", f"{avg_transitions_per_node:.2f}"),
        ("Maximum transitions on one node", max_transitions_on_node),
        ("Mean Squared Error (MSE)", f"{mse:.4f}"),
        ("R-squared (R2)", f"{r2:.4f}"),
        ("Execution Time", f"{execution_time:.4f}"),
    ]
    with open(total_summary_path, 'a') as summary_file:
        for label, value in lines:
            summary_file.write(f"{label}: {value}\n")

    summary_records.extend(lines)

# Save Excel summary
summary_df = pd.DataFrame(summary_records, columns=["Label", "Value"])
excel_path = os.path.join(args.outputFolder, "total_results.xlsx")
summary_df.to_excel(excel_path, index=False)
print(f"\n✔️ Excel summary saved to: {excel_path}")

