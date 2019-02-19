import argparse
from pathlib import Path
import re
from shutil import copyfile

parser = argparse.ArgumentParser()
parser.add_argument("main_file")
args = parser.parse_args()


def main(args):

    main_file = Path(args.main_file)

    with open(main_file, "r") as script:
        lines = script.readlines()

    characters = {}
    for i, line in enumerate(lines):

        if line.startswith("\\begin{document}"):
            break

        if line.startswith("\\character"):
            characters[i] = line.split("{")[-1].split("}")[0].upper()

    dir_personalized_scripts = Path(f"{main_file.parent}/{main_file.stem}/")
    dir_personalized_scripts.mkdir(exist_ok=True)

    for i, character in characters.items():
        char_file = dir_personalized_scripts / f"{character}.tex"

        with open(char_file, "w") as char_script:
            for j, line in enumerate(lines):
                if i == j:
                    line = line.replace("character", "character*")
                char_script.write(line)

    for line in lines:
        for other_file in re.findall(r"(?<=\\input{)[^}]+(?=})", line):
            other_file = Path(other_file)
            if other_file.is_file():
                print(f"Copying {other_file.name} ...")
                copyfile(other_file, dir_personalized_scripts / other_file.name)
            else:
                print(f"I could not open this file: {other_file.name}")


if __name__ == "__main__":
    main(args)
