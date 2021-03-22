#!/usr/bin/env python3
"""
usage: validate-syntax.py [-h] -p LINTER_PATH [-e OPTIONS] [-s FILE_LIST] [-t]
                          [-r] [-d CHANGES_PATH] [-v]
                          FILES [FILES ...]

Execute linter against sample files

positional arguments:
  FILES                 List of files to check, supports glob, should be
                        quoted

optional arguments:
  -h, --help            show this help message and exit
  -p LINTER_PATH, --linter LINTER_PATH
                        Path to the linter's binary
  -e OPTIONS, --extra OPTIONS
                        Extra linter options
  -s FILE_LIST, --skip FILE_LIST
                        Skip files list
  -t, --tmp             Copy to tmp directory before executing
  -r, --redirect        Redirect linter subprocess stderr to stdout
  -d CHANGES_PATH, --diff CHANGES_PATH
                        Run only on provided changed samples list
  -v, --verbose         Increase verbosity, default:ERROR v:INFO vv:DEBUG
"""
import argparse
import glob
import json
import os
import shutil
import subprocess
import tempfile
from subprocess import CalledProcessError

parser = argparse.ArgumentParser(
    description='Execute linter against sample files')
parser.add_argument('files', metavar='FILES',
                    type=str, nargs='+', help='List of files to check, supports glob, should be quoted')
parser.add_argument('-p', '--linter', metavar='LINTER_PATH',
                    type=str, required=True, help='Path to the linter\'s binary')
parser.add_argument('-e', '--extra', metavar='OPTIONS',
                    type=str, default='', help='Extra linter options')
parser.add_argument('-s', '--skip', metavar='FILE_LIST',
                    type=str, default='', help='Skip files list')
parser.add_argument('-t', '--tmp', default=False, action='store_true',
                    help='Copy to tmp directory before executing')
parser.add_argument('-r', '--redirect', default=False, action='store_true',
                    help='Redirect linter subprocess stderr to stdout')
parser.add_argument('-d', '--diff', type=str, metavar='CHANGES_PATH', default='',
                    help='Run only on provided changed samples list')
parser.add_argument('-v', '--verbose', action='count', default=0,
                    help='Increase verbosity, default:ERROR v:INFO vv:DEBUG')

args = parser.parse_args()


def summary(files, error_files):
    """ Show summary and exit with code 1 if errors > 0 """
    print('\n')
    print('>>------------------------------------------------')
    print(f'found {len(error_files)} issues in {len(files)} file checked')
    print('>>------------------------------------------------')
    if len(error_files) > 0:
        exit(1)
    else:
        exit(0)


def create_temporary_copy(path):
    """ Copy sample to a temporary directory """
    tmp_dir = tempfile.mkdtemp(prefix="validate-syntax-")
    tmp_path = os.path.join(tmp_dir, os.path.basename(path))
    if args.verbose > 1:
        print('creating temporary copy', tmp_path)
    copy_r = shutil.copy2(path, tmp_path)
    return copy_r


def expand_files():
    """ Expand globs provided in file list """
    all_files = []
    for file_entry in args.files:
        all_files.extend(glob.glob(file_entry))
    return all_files


def changed_sample_files(all_files):
    if args.verbose:
        print("--diff option enabled... filtering changed samples")

    with open(args.diff, 'r') as fp:
        changes_list = json.load(fp)
    if args.verbose > 1:
      print('detected git commit changes:')
      print(changes_list)

    changed_samples = [file for file in all_files if file in changes_list]
    if args.verbose > 1:
      print('changed samples:')
      print(changed_samples)

    return changed_samples


def read_skip_list():
    """ Read skip list """
    ignore_list = []
    if args.skip:
        with open(args.skip, 'r') as reader:
            ignore_list = [line.rstrip() for line in reader]
    return ignore_list


def run_linter(file):
    """ Run linter """
    result = ''
    tmp_copy = ''
    cmds = []
    try:
        if args.verbose > 0:
            print(f'Validating {file}')
        else:
            print('.', end='')

        if args.tmp:
            tmp_copy = create_temporary_copy(file)
            cmds = [args.linter, tmp_copy]
        else:
            cmds = [args.linter, file]

        if args.extra:
            cmds = [*cmds[:1], *args.extra.strip().split(' '), *cmds[1:]]

        if args.redirect:
            output = subprocess.check_output(
                cmds, shell=False, stderr=subprocess.STDOUT)
        else:
            output = subprocess.check_output(cmds, shell=False)

        result = output.decode('utf-8').rstrip()
    finally:
        if args.verbose > 1:
            print(f'removing {tmp_copy}')
        if args.tmp:
            shutil.rmtree(os.path.dirname(tmp_copy))
    return result


def main():
    print('starting validator')

    skip_list = read_skip_list()

    if args.verbose:
        print(f"Ignore list is:{os.linesep}{os.linesep.join(skip_list)}\n")

    ############################################
    #  filter out test files and ignored files #
    ############################################
    files = [
        file for file in expand_files()
        if file not in skip_list
        and 'positive_expected_result.json' not in file
    ]
    if args.verbose:
      print(f'found {len(files)} samples in glob pattern')

    if args.diff:
        files = changed_sample_files(files)

    error_files = []

    print(f'found {len(files)} files to check')

    ###########################################
    #                run linter               #
    ###########################################
    for file in files:
        result = ''
        try:
            result = run_linter(file)
        except CalledProcessError as e:
            error_files.append({'err': e, 'file': file})
        if result:
            for line in result.split('\n'):
                if line and args.verbose:
                    print(f"{line}")

    ###########################################
    #                list errors              #
    ###########################################
    if len(error_files) > 0:
        print("\n###### ERRORS #######")
        for error_obj in error_files:
            print(error_obj)
            error_result = error_obj['err'].output.decode('utf-8').rstrip()
            for line in error_result.split('\n'):
                print(line)
            print('----\n')

    summary(files, error_files)


if __name__ == "__main__":
    main()
