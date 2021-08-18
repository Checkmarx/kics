#!/usr/bin/env python3
import glob
import json
import os

from tabulate import tabulate

queries_basepath = 'assets/queries'
queries_path = {
    'ansible': os.path.join(queries_basepath, 'ansible', '**', '*'),
    'azureresourcemanager': os.path.join(queries_basepath, 'azureResourceManager', '*'),
    'cloudformation': os.path.join(queries_basepath, 'cloudFormation', '*'),
    'openapi': os.path.join(queries_basepath, 'openAPI', '**', '*'),
    'k8s': os.path.join(queries_basepath, 'k8s', '*'),
    'common': os.path.join(queries_basepath, 'common', '*'),
    'dockerfile': os.path.join(queries_basepath, 'dockerfile', '*'),
    'terraform': os.path.join(queries_basepath, 'terraform', '**', '*'),
}
samples_ext = {
    'azureresourcemanager': ['json'],
    'cloudformation': ['yaml', 'json'],
    'openapi': ['yaml', 'json'],
    'ansible': ['yaml'],
    'k8s': ['yaml'],
    'common': ['yaml', 'json', 'dockerfile', 'tf'],
    'dockerfile': ['dockerfile'],
    'terraform': ['tf'],
}
summary = {
    'total': 0,
}

rego_summary = {
    'total': 0
}

samples_summary = {
    'total': 0
}


def queries_count(path):
    rtn_count = 0
    with open(path) as fp:
        metadata_obj = json.load(fp)
        if 'aggregation' in metadata_obj:
            rtn_count = metadata_obj['aggregation']
        else:
            rtn_count = 1
    return rtn_count


for key, value in queries_path.items():
    metadata_path = os.path.join(value, 'metadata.json')
    platform_count = sum([queries_count(path)
                         for path in glob.glob(metadata_path)])
    summary[f'{key}_queries'] = platform_count
    summary['total'] += platform_count

    rego_path = os.path.join(value, 'query.rego')
    rego_summary[f'{key}_rego'] = len([path for path in glob.glob(rego_path)])
    rego_summary['total'] += len([path for path in glob.glob(rego_path)])

    for ext in samples_ext[key]:
        sample_path = os.path.join(value, 'test', f'*.{ext}')
        ext_samples = len([path for path in glob.glob(sample_path)])
        samples_summary[f'{key}_{ext}_samples'] = ext_samples
        samples_summary['total'] += ext_samples

print("::group::Queries Metrics")
print(tabulate([[key, value] for key, value in summary.items()], headers=[
      'Platform', 'Count'], tablefmt='orgtbl'))
print("::endgroup::")
print()
print(f"::set-output name=total_queries::{summary['total']}")
print()
print("::group::Rego File Metrics")
print(tabulate([[key, value] for key, value in rego_summary.items()], headers=[
      'Platform', 'Count'], tablefmt='orgtbl'))
print("::endgroup::")
print()
print(f"::set-output name=total_rego_files::{rego_summary['total']}")
print()
print("::group::Sample File Metrics")
print(tabulate([[key, value] for key, value in samples_summary.items()], headers=[
      'Samples', 'Count'], tablefmt='orgtbl'))
print("::endgroup::")
