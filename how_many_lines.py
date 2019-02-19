import argparse
from pathlib import Path
import re
import matplotlib.pyplot as plt

parser = argparse.ArgumentParser()
parser.add_argument("main_file")
args = parser.parse_args()


def main(args):

    with open(args.main_file, "r") as script:
        lines = script.readlines()
        lines = [line for line in lines if line.strip()]

    characters = []
    for line in lines:

        if line.startswith("\\begin{document}"):
            break

        if line.startswith("\\character"):
            c = line.split("{")[-1].split("}")[0]
            characters.append(f"\\{c}")

    other_files = []
    for line in lines:
        for input_file in re.findall(r"(?<=\\input{)[^}]+(?=})", line):
            if Path(input_file).is_file():
                # print(f"Adding {input_file} ...")
                other_files.append(input_file)
            else:
                print(f"I could not open this file: {input_file}")

    for input_file in other_files:
        with open(input_file, "r") as script_portion:
            more_lines = script_portion.readlines()
            more_lines = [line for line in more_lines if line.strip()]
            lines += more_lines

    hist_lines = {}
    hist_words = {}

    for line in lines:
        c = line.split()[0]
        if c in characters:
            line_len = len(line.split()) - 1
            hist_lines[c] = hist_lines.get(c, 0) + 1
            hist_words[c] = hist_words.get(c, 0) + line_len

    make_histogram(characters, hist_lines, "Lines per character")
    make_histogram(characters, hist_words, "Words per character")


def make_histogram(characters, histogram, title):
    plt.bar([c[1:] for c in characters], [histogram[c] for c in characters])
    plt.xticks(rotation=45)
    plt.title(title)

    fig = plt.gcf()
    fig.subplots_adjust(bottom=0.2)

    plt.savefig(fname=f"{title.replace(' ','_')}.png")
    plt.show()


if __name__ == "__main__":
    main(args)
