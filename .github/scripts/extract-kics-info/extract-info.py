import os
from fnmatch import fnmatch
import json

root = '../../../assets/queries'
pattern = "metadata.json"

def getFramworks():
    frameworksList = next(os.walk(root))[1]
    frameworksList.remove('common')
    return frameworksList

def getQueries_and_Categories():
    categoriesList = []
    queriesList = []
    for path, subdirs, files in os.walk(root):
        for name in files:
            if fnmatch(name, pattern):
                file = open(os.path.join(path, name))
                data = json.load(file)
                if('category' in data and data['category'] not in categoriesList):
                    categoriesList.append(data['category'])
                queriesList.append(data['queryName'])
                file.close()
    categoriesList.remove('Bill Of Materials')
    return queriesList,categoriesList

if __name__ == "__main__":
    outputResult = {"categories": getQueries_and_Categories()[1], "frameworks": getFramworks()}

    with open("kics-info.json", "w") as outfile:
        json.dump(outputResult, outfile)