
from pathlib import Path

DATASET = "stefanoleone992/fifa-21-complete-player-dataset"
DATA_DIR = Path(__file__).parent / "data"
KEEP_FILE = "players_21.csv"


def main() -> None:
    from kaggle.api.kaggle_api_extended import KaggleApi

    DATA_DIR.mkdir(exist_ok=True)
    api = KaggleApi()
    api.authenticate()

    print(f"Downloading '{DATASET}' into {DATA_DIR}/ ...")
    api.dataset_download_files(DATASET, path=str(DATA_DIR), unzip=True)

    for f in DATA_DIR.iterdir():
        if f.name != KEEP_FILE:
            f.unlink()

    print(f"Done. Kept only {KEEP_FILE}:")
    for f in sorted(DATA_DIR.iterdir()):
        print(f"  - {f.name}")


if __name__ == "__main__":
    main()
