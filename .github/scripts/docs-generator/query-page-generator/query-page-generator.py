# Script created in Python 3.10.8 using only standard libraries
import argparse
import os
import json
import shutil
import time
from pathlib import Path

# Searches for "metadata.json" files within the inputed directory
# Returns a dictionary of dictionaries (output of function get_query_info)
def get_meta_data_and_tests(input_path : str, metadata_file = 'metadata.json'):
    all_metadata = Path(input_path).rglob(metadata_file)
    queries_data = {}

    for path in all_metadata:
        query_info = get_query_info(os.path.dirname(path), metadata_file)
        query_id = query_info.get('id')
        if not query_id: continue
        queries_data[query_id] = query_info

    return queries_data

# Creates a dictionary with the query information present in the "./metadata.json" file and the "./test" directory
def get_query_info(query_path : str, metadata_file = 'metadata.json'):
    metadata_file_path = os.path.join(query_path, metadata_file)

    if not os.path.exists(metadata_file_path):
        raise FileNotFoundError(f"\033[31mFile {metadata_file} doesn't exist in {query_path}\033[0m")

    # Get information inside the "./metadata.json" file
    with open(metadata_file_path, 'r') as f:
        query_metadata_content = json.loads(f.read())

    # Find the index of the folder name in the directory path
    folder_index = metadata_file_path.rfind('assets\queries')
    # If the folder name is found, return everything after it
    if folder_index != -1:
        path_after_folder = metadata_file_path[folder_index:]
    else:
        path_after_folder = metadata_file_path
    query_metadata_content['githubUrl'] = f'https://github.com/Checkmarx/kics/tree/master/{os.path.dirname(path_after_folder)}'.replace('\\', '/')

    test_folder_path = os.path.join(query_path, 'test')
    if not os.path.isdir(test_folder_path):
        raise FileNotFoundError(f"\033[31mFolder {test_folder_path} doesn't exist in {query_path}\033[0m")

    expected_result_file_path = os.path.join(test_folder_path, 'positive_expected_result.json')
    if not os.path.exists(expected_result_file_path):
        raise FileNotFoundError(f"\033[31mFile {expected_result_file_path} doesn't exist in {test_folder_path}\033[0m")

    with open(expected_result_file_path) as f:
        expected_results = json.loads(f.read())

    files = sorted(os.listdir(os.path.join(query_path, 'test')), key=str.casefold)
    positive_filenames = []
    negative_filenames = []

    for file in files:
        file_path = os.path.join(query_path, 'test', file)
        if not os.path.isfile(file_path):
          continue
        if file.lower().startswith('positive') and file != 'positive_expected_result.json':
            positive_filenames.append(file)
        elif file.lower().startswith('negative'):
            negative_filenames.append(file)

    true_positives = []
    true_negatives = []
    for p_filename in positive_filenames:
        positive_file_path = os.path.join(query_path, 'test', p_filename)
        if os.path.exists(positive_file_path):
            with open(positive_file_path, 'r') as f:
                test_content = f.read()

            # length == 1 or EDGE CASES
            if len(positive_filenames) == 1 or ('terraform/aws/certificate_has_expired' in query_path.replace('\\', '/') and p_filename == 'positive.tf'):
                test_results = expected_results
            else:
                test_results = [
                    f
                    for f in expected_results
                    if ((f.get('fileName')
                         or f.get('filename')
                         or f.get('file')) == p_filename)
                ]
            lines = list(set([item['line'] for item in test_results]))
            if lines != []:
                positive_test = dict(fileName=p_filename, lines=lines, code=test_content)
                true_positives.append(positive_test)

    for n_filename in negative_filenames:
        negative_file_path = os.path.join(query_path, 'test', n_filename)
        if os.path.exists(negative_file_path):
            with open(negative_file_path, 'r') as f:
                test_content = f.read()
            negative_test = dict(fileName=n_filename, code=test_content)
            true_negatives.append(negative_test)

    query_metadata_content['true_positives'] = true_positives
    query_metadata_content['true_negatives'] = true_negatives
    return query_metadata_content

# Utility for generate ".md" documentation
def format_negative_tests(format_negative_tests : dict) -> str:
    result = ''

    for idx, x in enumerate(format_negative_tests):
        filename = x.get('fileName')
        extension = filename.split('.')[-1]
        title = f'Negative test num. {idx + 1} - {extension} file'
        code = x.get('code')

        # If the query has more than 3 tests, the remaining tests are placed in a drop down
        if idx <= 2:
            result += f'```{extension} title="{title}"\n{code}\n```\n'
        else:
            result += f'<details><summary>{title}</summary>\n\n'
            result += f'```{extension}\n{code}\n```\n'
            result += '</details>\n'

    return result if result != '' else 'Tests Not Fround'

# Utility for generate ".md" documentation
def format_positive_tests(positive_tests : dict) -> str:
    result = ''

    for idx, x in enumerate(positive_tests):
        filename = x.get('fileName')
        extension = filename.split('.')[-1]
        title = f'Positive test num. {idx + 1} - {extension} file'
        code = x.get('code')

        results_lines = ''
        results_lines_arr = x.get('lines')
        results_lines_len = len(results_lines_arr)

        if results_lines_len > 0:
            results_lines += 'hl_lines="'
            for idy, y in enumerate(results_lines_arr):
                if idy + 1 >= results_lines_len:
                    results_lines += str(y)
                else:
                    results_lines += f'{str(y)} '
            results_lines += '"'

        # If the query has more than 3 tests, the remaining tests are placed in a drop down
        if idx <= 2:
            result += f'```{extension} title="{title}" {results_lines}\n{code}\n```\n'
        else:
            result += f'<details><summary>{title}</summary>\n\n'
            result += f'```{extension} {results_lines}\n{code}\n```\n'
            result += '</details>\n'

    return result if result != '' else 'Tests Not Fround'

# Utility for generate ".md" documentation
def format_severity(severity : str) -> str:
    colors = {'Critical': '#ff0000', 'High': '#bb2124', 'Medium': '#ff7213', 'Low': '#edd57e', 'Info': '#5bc0de', 'Trace': '#CCCCCC'}
    severity = severity.capitalize()
    color = colors.get(severity)
    return f'<span style="color:{color}">{severity}</span>'

# Generates a ".md" file for each query
def generate_md_docs(queries_database : str, output_path : str, template_file_path = 'template.md', delete_folders : bool = False):
    # Ensure that we are deleting old files generated by this script
    if (delete_folders):
        platforms = {f"{value.get('platform').lower()}-queries"
                     for value in queries_database.values()
                     if value.get('platform') is not None}

        # Get a list of all the folders in the path
        folders = [folder for folder in os.listdir(output_path) if os.path.isdir(os.path.join(output_path, folder))]

        # Iterate over each folder and check if its name matches any of the platforms
        for folder in folders:
            if folder.lower() in platforms:
                folder_path = os.path.join(output_path, folder)
                shutil.rmtree(folder_path)  # Delete the folder and all its contents

    if not os.path.exists(template_file_path):
        raise FileNotFoundError("\033[31mtemplate_path doesn't exist in the operating system\033[0m")

    with open(template_file_path, 'r') as f:
        doc_template = f.read()

    for key, query_data in queries_database.items():
        cwe = query_data.get('cwe', '')
        if cwe == '':
            cwe = 'Ongoing'
        else:
            cwe_url = f'https://cwe.mitre.org/data/definitions/{cwe}.html'
            cwe = f'<a href="{cwe_url}" onclick="newWindowOpenerSafe(event, \'{cwe_url}\')">{cwe}</a>'

        query_doc = doc_template
        query_doc = doc_template.replace('<QUERY_ID>', key).replace(
            '<QUERY_NAME>', query_data.get('queryName')).replace(
            '<PLATFORM>', query_data.get('platform')).replace(
            '<SEVERITY>', format_severity(query_data.get('severity'))).replace(
            '<CATEGORY>', query_data.get('category')).replace(
            '<CWE>', cwe).replace(
            '<GITHUB_URL>', query_data.get('githubUrl')).replace(
            '<DESCRIPTION_TEXT>', query_data.get('descriptionText')).replace(
            '<DESCRIPTION_URL>', query_data.get('descriptionUrl')).replace(
            '<POSITIVE_TESTS>', format_positive_tests(query_data.get('true_positives'))).replace(
            '<NEGATIVE_TESTS>', format_negative_tests(query_data.get('true_negatives')))

        cloud_provider = query_data.get('cloudProvider', '').lower()
        platform_folder_path = os.path.join(output_path,
                                            f"{query_data.get('platform').lower()}-queries",
                                            cloud_provider if cloud_provider != 'common' else '')
        if not os.path.exists(platform_folder_path):
            os.makedirs(platform_folder_path)

        # If you are having problems rendering the ".md" pages, try adding encoding='utf-8' as a parameter of "open" function invocation
        with open(f'{os.path.join(platform_folder_path, key)}.md', 'w') as f:
            f.write(query_doc)

# Export a dictionary to a "json" file
def export_to_json(queries_database : dict, output_path : str):
    with open(os.path.join(output_path, 'queries_database.json'), 'w') as f:
        json.dump(queries_database, f, indent=4)

def main():
    start_time = time.time()

    # Script arguments
    parser = argparse.ArgumentParser(description='Create/Update documentation page for each query')
    parser.add_argument('-p', type=Path, dest='input_path',
                        help='Folder path to read "metadata.json".', required=True)
    parser.add_argument('-o', type=Path, dest='output_path',
                        help='Folder path to output documentation files.', required=True)
    parser.add_argument('-f', type=str, dest='output_format', choices=['json', 'md'],
                        help='Documentation formats to be created, this script only supports "json" and "md".', required=True)
    parser.add_argument('--t', type=Path, dest='template_path',
                        help='Template file path.')
    parser.add_argument('--df', dest='delete_folders', action='store_true',
                        help='If specified, delete all folders in the specified output_path that match the platform names.')

    args = parser.parse_args()

    # Validating optional arguments
    output_format = args.output_format
    if output_format == 'md' and (args.template_path is None):
        parser.error('-f json requires --t')

    input_path = args.input_path
    if not input_path.exists(): raise FileNotFoundError("\033[31minput_path doesn't exist in the operating system\033[0m")

    output_path = args.output_path

    # Get queries information
    queries_database = get_meta_data_and_tests(str(input_path))

    # The output of this script depends on the output_format
    if output_format == 'json':
        export_to_json(queries_database, str(output_path))
        print("-->\033[32m JSON file with all queries information created/updated successfully\033[0m")

    elif output_format == 'md':
        template_path = args.template_path
        if not template_path.exists(): raise FileNotFoundError("\033[31mtemplate_path doesn't exist in the operating system\033[0m")

        generate_md_docs(queries_database, str(output_path), str(template_path), args.delete_folders)
        print("-->\033[32m Documentation .md pages for each query created/updated successfully\033[0m")

    end_time = time.time()
    elapsed_time = end_time - start_time
    print(f"-->\033[34m Elapsed time: {round(elapsed_time, 2)} seconds\033[0m")

if __name__ == '__main__':
    main()
