import os
import requests
import json
from pathlib import Path
from jsonschema import validate

KICS_PR_NUMBER = os.getenv('KICS_PR_NUMBER')
KICS_GITHUB_TOKEN = os.getenv('KICS_GITHUB_TOKEN')
QUERIES_PATH = 'assets/queries'
QUERIES_METADATA = 'metadata.json'

def exit_with_error(message):
    print(message)
    exit(1)

def exit_success():
    print('Successfully execution!')
    exit(0)

def fetch(page=1, max_items=100):
    print('Fetching PR #{} files... #page{}'.format(KICS_PR_NUMBER, page))
    headers = {'Authorization': 'token {}'.format(KICS_GITHUB_TOKEN)}
    url = 'https://api.github.com/repos/checkmarx/kics/pulls/{}/files?per_page={}page={}'.format(KICS_PR_NUMBER, max_items, page)
    response = requests.get(url, headers=headers)
    return { "data": response.json(), "status": response.status_code }

def fetch_pr_files():
    files = []
    page = 1
    max_items = 100

    while page < 50:
        response = fetch(page, max_items)
        if response['status'] != 200:
            return exit_with_error('Failed to fetch PR files\n- status code: {}'.format(response['status']))

        for obj in response['data']:
            if obj['status'] != 'removed':
                files.append(obj['filename'])

        if len(response['data']) < max_items:
            return files

        page += 1

    return exit_with_error('Failed to fetch PR files\n- too many pages')

def find_queries_in_files(files):
    queries = []
    for file in files:
        if file.endswith(QUERIES_METADATA) and file.startswith(QUERIES_PATH):
            queries.append(file)
    return queries

def validate_queries_metadata(queries):
    errors = []

    with open('metadata-schema.json') as fileSchema:
        schema = json.load(fileSchema)
        for i, query in enumerate(queries):
            print('[{}] Validating "{}" ...'.format(i,query))

            complete_path = os.path.abspath(os.path.join('..', '..', '..', Path(query)))

            with open(complete_path) as f:
                try:
                    data = json.load(f)
                except json.decoder.JSONDecodeError:
                    errors.append('Failed to parse {}'.format(query))
                try:
                    validate(instance=data, schema=schema)
                except Exception as e:
                    errors.append('Failed to validate {}: {}'.format(query, e))

    if len(errors) > 0:
        for error in errors:
            print(error)
        exit_with_error('There are metadata files with errors ({} files)'.format(len(errors)))

def fetch_all_metadata_files():
    complete_path = os.path.abspath(os.path.join('..', '..', '..', 'assets', 'queries'))

    queries_list = []
    for root, _, files in os.walk(complete_path):
        for file in files:
            if file.endswith(QUERIES_METADATA):
                queries_list.append(os.path.join(root, file))
    return queries_list

def validate_all_queries():
    queries_list = fetch_all_metadata_files()
    validate_queries_metadata(queries_list)
    exit_success()

def validate_pr_queries():
    changed_files = fetch_pr_files()
    queries = find_queries_in_files(changed_files)
    validate_queries_metadata(queries)
    exit_success()

if __name__ == '__main__':
    validate_pr_queries()
    #validate_all_queries()
