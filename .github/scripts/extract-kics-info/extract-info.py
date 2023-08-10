import os
from fnmatch import fnmatch
import json
import zipfile


class Query:
    id: str
    queryName: str
    severityId: int
    categoryId: str
    descriptionText: str
    descriptionUrl: str
    platformId: int
    descriptionID: str
    aggregation: int
    asDDsa12Id: int

    def __init__(self, queryData):
        self.id = queryData['id']
        self.queryName = queryData['queryName']
        self.severityId = severities.getSeverityId(queryData['severity'])
        self.categoryId = categories.getCategoryId(queryData['category'])
        self.descriptionText = queryData['descriptionText']
        self.descriptionUrl = queryData['descriptionUrl']
        self.platformId = platforms.getPlatformId(queryData['platform'])
        self.descriptionID = queryData['descriptionID']
        if queryData.__contains__('asDDsa12'):
            self.asDDsa12Id = asDDsa123.getAsDDsa12Id(
                queryData['asDDsa12'])
        else:
            self.asDDsa12Id = None
        if queryData.__contains__('aggregation'):
            self.aggregation = queryData['aggregation']
        else:
            self.aggregation = 1

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Queries:
    queries = []

    def __init__(self):
        self.queries = []

    def addQuery(self, query):
        self.queries.append(query)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Platform:
    id: int
    platform: str

    def __init__(self, id, platform):
        self.id = id
        self.platform = platform

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Platforms:
    platforms = []

    def __init__(self):
        self.platforms = []

    def addPlatform(self, id, platform):
        p = Platform(id, platform)
        self.platforms.append(p)
        return p.id

    def getPlatformId(self, platform):
        found = False
        creationId = 1
        for plat in self.platforms:
            creationId = plat.id+1
            if plat.platform == platform:
                found = True
                return plat.id
        if not found:
            return self.addPlatform(creationId, platform)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class AsDDsa12:
    id: int
    asDDsa12: str

    def __init__(self, id, asDDsa12):
        self.id = id
        self.asDDsa12 = asDDsa12

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class AsDDsa123:
    asDDsa123 = []

    def __init__(self):
        self.asDDsa123 = []

    def addAsDDsa12(self, id, asDDsa12):
        c = AsDDsa12(id, asDDsa12)
        self.asDDsa123.append(c)
        return c.id

    def getAsDDsa12Id(self, asDDsa12):
        found = False
        creationId = 1
        for cp in self.asDDsa123:
            creationId = cp.id+1
            if cp.asDDsa12 == asDDsa12:
                found = True
                return cp.id
        if not found:
            return self.addAsDDsa12(creationId, asDDsa12)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Severity:
    id: int
    severity: str

    def __init__(self, id, severity):
        self.id = id
        self.severity = severity

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Severities:
    severities = []

    def __init__(self):
        self.severities = []

    def addSeverity(self, id, severity):
        c = Severity(id, severity)
        self.severities.append(c)
        return c.id

    def getSeverityId(self, severity):
        found = False
        creationId = 1
        for s in self.severities:
            creationId = s.id+1
            if s.severity == severity:
                found = True
                return s.id
        if not found:
            return self.addSeverity(creationId, severity)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Category:
    id: int
    category: str

    def __init__(self, id, category):
        self.id = id
        self.category = category

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Categories:
    categories = []

    def __init__(self):
        self.categories = []

    def addCategory(self, id, category):
        c = Category(id, category)
        self.categories.append(c)
        return c.id

    def getCategoryId(self, category):
        found = False
        creationId = 1
        for c in self.categories:
            creationId = c.id+1
            if c.category == category:
                found = True
                return c.id
        if not found:
            return self.addCategory(creationId, category)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


root = 'assets'
queriesRoot = root + "/queries"
pattern = "metadata.json"

queries = Queries()
categories = Categories()
severities = Severities()
asDDsa123 = AsDDsa123()
platforms = Platforms()


def getFramworks():
    frameworksList = next(os.walk(queriesRoot))[1]
    frameworksList.remove('common')
    return frameworksList


def loadQueriesData():
    for path, _, files in os.walk(root):
        assetsFolderPath = os.path.join(exportFolderPath,path)
        for name in files:
            lastPath = os.path.basename(os.path.normpath(assetsFolderPath))
            if not (lastPath == "test" or lastPath == ".git"):
                os.makedirs(assetsFolderPath, exist_ok=True)
                with open(os.path.join(assetsFolderPath,name), "w") as outfile:
                    file = open(os.path.join(path, name))
                    outfile.write(file.read())
            if fnmatch(name, pattern) and os.path.join("assets","queries") in assetsFolderPath: # make sure it is a metadata.json from the queries folder
                file = open(os.path.join(path, name))
                data = json.load(file)
                file.close()
                queries.addQuery(Query(data))
    #categoriesList.remove('Bill Of Materials')


exportFolderPath = ".github/scripts/extract-kics-info/"


def exportData():
    with open(exportFolderPath+"categories.json", "w") as outfile:
        outfile.write(categories.toJSON())

    with open(exportFolderPath+"platforms.json", "w") as outfile:
        outfile.write(platforms.toJSON())

    with open(exportFolderPath+"asDDsa123.json", "w") as outfile:
        outfile.write(asDDsa123.toJSON())

    with open(exportFolderPath+"severities.json", "w") as outfile:
        outfile.write(severities.toJSON())

    with open(exportFolderPath+"queries.json", "w") as outfile:
        outfile.write(queries.toJSON())

    with zipfile.ZipFile(exportFolderPath+"extracted-info.zip", mode="w") as archive:
        archive.write(exportFolderPath+"categories.json",
                      arcname="categories.json")
        archive.write(exportFolderPath+"platforms.json",
                      arcname="platforms.json")
        archive.write(exportFolderPath+"asDDsa123.json",
                      arcname="asDDsa123.json")
        archive.write(exportFolderPath+"severities.json",
                      arcname="severities.json")
        archive.write(exportFolderPath+"queries.json", arcname="queries.json")
        for dirname, _, files in os.walk(os.path.join(exportFolderPath,"assets")):
            archive.write(os.path.relpath(dirname,exportFolderPath))
            for filename in files:
                archive.write(os.path.join(os.path.relpath(dirname,exportFolderPath), filename))


if __name__ == "__main__":
    loadQueriesData()
    exportData()
