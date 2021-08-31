#!/usr/bin/env python3
import argparse

arg_parser = argparse.ArgumentParser(description='Create query docs')
arg_parser.add_argument('-n', nargs='+', dest='new', help='New flags.json')
arg_parser.add_argument('-o', nargs='+', dest='old', help='Old flags.json')

parsed_args = vars(arg_parser.parse_args())
print(parsed_args['new'])
