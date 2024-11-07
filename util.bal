import ballerina/file;
import ballerina/io;

function loadIndex(string case) returns Index|error {
    string defaultIndexPath = "./resources/index.json";
    string indexPath = string `./resources/${case}/index.json`;
    if !check file:test(indexPath, file:EXISTS) {
        indexPath = defaultIndexPath;
    }
    json indexJson = check io:fileReadJson(indexPath);
    Packages packages = check indexJson.cloneWithType(Packages);
    Index index = {};
    foreach IndexPackage package in packages {
        string key = pkgKey(package);
        if index[key] == () {
            index[key] = [package];
        } else {
            (<Packages>index[key]).push(package);
        }
    }
    return index;
}

function loadDirectDependencies(string case) returns PackageDesc[]|error {
    string dependencyPath = string `./resources/${case}/app.json`;
    json dependencyJson = check io:fileReadJson(dependencyPath);
    PackageDesc[] dependencies = check dependencyJson.cloneWithType(PackageDescs);
    return dependencies;
}

function loadDependenciesToml(string case) returns PackageDesc[]|error {
    string depTomlPath = string `./resources/${case}/dependencies-toml.json`;
    json depTomlJson = check io:fileReadJson(depTomlPath);
    PackageDesc[] dependencies = check depTomlJson.cloneWithType(PackageDescs);
    return dependencies;
}
