# gets platforms and cloud providers keywords from keywordd.yaml file and inserts into a map in shell script

import yaml

def load_keywords(file):
    with open(file, 'r') as stream:
        try:
            data = yaml.safe_load(stream)
            formatted = ' '.join([f'["{k}"]="{v}"' for k, v in data.items()])
            print(f"({formatted})")
        except yaml.YAMLError as exc:
            print(exc)

if __name__ == "__main__":
    load_keywords('.github/keywords.yaml')



