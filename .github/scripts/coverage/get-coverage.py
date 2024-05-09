#!/usr/bin/env python3
import itertools
import os
import re
import sys
import typing
import glob
from argparse import ArgumentParser


class Arguments:
    coverage_file: str


class BaseItem:
    def __init__(self, **kw):
        """Inits the BaseItem object."""
        self.__dict__.update(kw)

    def __repr__(self):
        """Converts the BaseItem object to string."""
        return f"{self.__class__.__name__}(**{self.__dict__!r})"


class LineStats(BaseItem):
    filepath: str
    line_from: int
    line_to: int
    count_covered: int
    covered: bool


class FileStats(BaseItem):
    filepath: str
    total_lines: int
    covered_lines: int
    uncovered_lines: int

    @property
    def coverage(self) -> float:
        try:
            return 100*self.covered_lines/self.total_lines
        except ZeroDivisionError:
            return 100.


def parse_args() -> Arguments:
    args = ArgumentParser()
    args.add_argument("coverage_file")
    return typing.cast(Arguments, args.parse_args(sys.argv[1:]))


def load_coverage(args: Arguments) -> typing.List[LineStats]:
    pat = re.compile(
        r"([^:]*):"
        r"(\d+)\.\d*,(\d+)\.\d* (\d+) (\d+)"
    )

    out = []

    with open(args.coverage_file, "r") as fd:
        next(fd)

        for line in fd:
            attrs = dict(zip(
                ["filename", "line_from", "line_to", "count_covered", "covered"],
                pat.findall(line)[0]
            ))

            for col in ["line_from", "line_to", "count_covered"]:
                attrs[col] = int(attrs[col])

            attrs["covered"] = bool(int(attrs["covered"]))

            el = LineStats(**attrs)
            out.append(el)

    return out


def calc_file_stats(lines: typing.List[LineStats]) -> typing.List[FileStats]:
    lines = lines[:]
    def key(i): return i.filename
    lines.sort(key=key)

    out = []
    exclude = []

    with open(os.path.dirname(os.path.realpath(__file__)) + "/.coverageignore", "r") as fd:
        for line in fd.read().splitlines():
            for name in glob.glob(line):
                exclude.append(name)

    print("::group::Excluded paths")
    print('\n'.join(exclude))
    print("::endgroup::")

    for filename, group in itertools.groupby(lines, key=key):
        filename = filename.replace("github.com/Checkmarx/kics/v2/", "")
        if filename in exclude:
            continue
        group = list(group)
        group.sort(key=lambda i: i.line_to)

        f = FileStats(filepath=filename)
        f.total_lines = sum([
            i.count_covered
            for i in group
        ])
        f.covered_lines = sum([
            i.count_covered
            for i in group
            if i.covered
        ])
        f.uncovered_lines = sum([
            i.count_covered
            for i in group
            if not i.covered
        ])
        out.append(f)
    return out


def total_cov(data: typing.List[FileStats]) -> float:
    covered = 0
    total = 0
    for item in data:
        covered += item.covered_lines
        total += item.total_lines
    return 100*covered/total


def main():
    args = parse_args()
    lines = load_coverage(args)
    stats = calc_file_stats(lines)
    float_cov = total_cov(stats)
    print(float_cov)
    total = round(float_cov)
    if os.environ.get('GITHUB_RUN_ID'):
        if total >= 90:
            color = 'brightgreen'
        elif total >= 70:
            color = 'green'
        elif total >= 50:
            color = 'orange'
        else:
            color = 'red'
        print(f"::set-output name=coverage::{total}")
        print(f"::set-output name=color::{color}")
    print(f"Total coverage: {total}")


if __name__ == '__main__':
    main()
