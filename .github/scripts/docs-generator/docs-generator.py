#!/usr/bin/env python3
from pathlib import Path
from jinja2 import Template
import os
import argparse
import json
import copy

severities = {'Critical': 'CRITICAL', 'High': 'HIGH', 'Medium': 'MEDIUM', 'Low': 'LOW', 'Info': 'INFO', 'Trace': 'TRACE'}
colors = {'Critical': '#ff0000', 'High': '#bb2124', 'Medium': '#ff7213', 'Low': '#edd57e', 'Info': '#5bc0de', 'Trace' : '#CCCCCC'}
template_dict = {}
platforms = []


def init_tree_path(dictionary, keys_per_level):
    if keys_per_level[0] not in dictionary:
        template_dict[keys_per_level[0]] = {}
    if keys_per_level[1] not in dictionary[keys_per_level[0]]:
        template_dict[keys_per_level[0]][keys_per_level[1]] = {}
    if keys_per_level[2] not in dictionary[keys_per_level[0]][keys_per_level[1]]:
        template_dict[keys_per_level[0]
                      ][keys_per_level[1]][keys_per_level[2]] = {}
    if keys_per_level[3] not in dictionary[keys_per_level[0]][keys_per_level[1]][keys_per_level[2]]:
        template_dict[keys_per_level[0]
                      ][keys_per_level[1]][keys_per_level[2]][keys_per_level[3]] = {}


def check_and_create_override_entry(meta_dict, template_dict):
    if 'override' in meta_dict:
        override = meta_dict['override']
        for _, over_meta in override.items():
            override_id = over_meta['id']
            if 'platform' in over_meta:
                over_platform = over_meta['platform']
            else:
                over_platform = platform
            if 'severity' in over_meta:
                over_severity = over_meta['severity']
            else:
                over_severity = severity
            if 'category' in over_meta:
                over_category = over_meta['category']
            else:
                over_category = category

            init_tree_path(template_dict, [
                over_platform, sub_platform, over_severity, over_category])

            template_dict[platform][sub_platform][severity][category][override_id] = copy.deepcopy(
                meta_dict)
            for key, value in over_meta.items():
                template_dict[platform][sub_platform][severity][category][override_id][key] = value


arg_parser = argparse.ArgumentParser(description='Create query docs')
arg_parser.add_argument('-p', nargs=1, type=Path,
                        dest='input_path', help='Path to read metadata.json')
arg_parser.add_argument('-o', nargs=1, type=Path, dest='output_path',
                        help='Path to output documentation files')
arg_parser.add_argument('-t', nargs=1, type=Path,
                        dest='templates_path', help='Path to template files')
arg_parser.add_argument('-f', nargs='+', type=str, dest='formats',
                        help='Documentation formats to be created, the extension must exists in the template folder')
parsed_args = vars(arg_parser.parse_args())

parsed_args['formats'] = ['.%s' %
                          f.lstrip('.') for f in parsed_args['formats']]
parsed_args['output_path'][0].mkdir(parents=True, exist_ok=True)
all_metadata = parsed_args['input_path'][0].rglob('metadata.json')
for path in all_metadata:
    if 'assets/queries/template/metadata.json' in str(path):
        continue
    with open(path) as file:
        content = file.read()
        meta_dict = json.loads(content)

        path_arr = str(path).split(os.sep)
        if len(path_arr) > 5:
            sub_platform = path_arr[3]
            if sub_platform == 'general':
                sub_platform = 'shared (v2/v3)'
        else:
            sub_platform = 'default'

        platform = meta_dict['platform']
        severity = meta_dict['severity']
        category = meta_dict['category']

        init_tree_path(template_dict, [
                       platform, sub_platform, severity, category])

        check_and_create_override_entry(meta_dict, template_dict)
        q_id = meta_dict['id']
        cloud_provider = meta_dict.get('cloudProvider', '').lower()
        query_page = os.path.join('..',
                                  f"{platform.lower()}-queries",
                                  cloud_provider if cloud_provider != 'common' else '',
                                  q_id).replace('\\', '/')
        meta_dict['descriptionText'] = f'<a href="{query_page}" onclick="newWindowOpenerSafe(event, \'{query_page}\')">Query details</a>'
        template_dict[platform][sub_platform][severity][category][q_id] = meta_dict
#
# template dict ex:
# {
#     "Terraform": {
#         "azure": {
#             "HIGH": {
#                 "Access Control": {
#                     "8e75e431-449f-49e9-b56a-c8f1378025cf": {
# ...
#         "gcp": {
#             "HIGH": {
#                 "Observability": {
#                     "89fe890f-b480-460c-8b6b-7d8b1468adb4": {
# ...
#     "Dockerfile": {
#         "default": {
#             "MEDIUM": {
#                 "Supply-Chain": {
#                     "b16e8501-ef3c-44e1-a543-a093238099c9": {
#
for file_format in parsed_args['formats']:
    general_data = {}
    for platform in sorted(template_dict.keys(), key=str.casefold):
        data = {}
        for sub_platform in sorted(template_dict[platform].keys(), key=str.casefold):
            data[sub_platform] = {}
            for severity in severities:
                if severities[severity] in template_dict[platform][sub_platform]:
                    data[sub_platform][severity] = {}
                    for category in sorted(template_dict[platform][sub_platform][severities[severity]].keys(), key=str.casefold):
                        metadata_info = template_dict[platform][sub_platform][severities[severity]][category]
                        sorted_metadata_info = dict(sorted(metadata_info.items(), key=lambda item: item[1]['queryName'].lower()))
                        data[sub_platform][severity] = {
                            **data[sub_platform][severity], **sorted_metadata_info}
        # create tables for each platform
        general_data[platform] = data

        template_path = os.path.join(
            parsed_args['templates_path'][0], 'platform_template' + file_format)
        with open(template_path) as template:
            template_string = template.read()
            template_jinja = Template(template_string)

            result = template_jinja.render({
                'platform': platform,
                'data': data,
                'colors': colors
            })
        output_filepath = os.path.join(
            parsed_args['output_path'][0], platform.lower() + '-queries' + file_format)
        with open(output_filepath, 'w') as output:
            print(result, file=output)
            print(f'wrote {output_filepath}')
        # create general table
    with open(os.path.join(parsed_args['templates_path'][0], 'general_template' + file_format)) as template:
        template_string = template.read()
        template_jinja = Template(template_string)
        result = template_jinja.render({
            'data': general_data,
            'colors': colors
        })
    output_filepath = os.path.join(
        parsed_args['output_path'][0], 'all-queries' + file_format)
    with open(output_filepath, 'w') as output:
        print(result, file=output)
        print(f'wrote {output_filepath}')
