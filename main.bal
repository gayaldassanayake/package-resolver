import ballerina/io;

import ballerinacentral/semver;

Resolved resolved = {};
semver:Version ballerinaVersion = check new ("2201.7.0");

// STEPS
// Distribution version check
// LATEST, SOFT, MEDIUM, HARD
// Major version compatibility checks
// Platform
// Introduce testOnly, provided scopes
// Introduce Dependencies.toml
// Sub module resolution
// Repositories Distribution/Central/(FileSystem)/Local/Custom

public function main() returns error? {
    Index index = check loadIndex();

    // TODO: read this also from a file.
    PackageDesc child1 = {org: "ballerina", name: "file", version: "0.0.0"};
    PackageDesc child2 = {org: "ballerina", name: "os", version: "0.0.0"};
    // Node rootNode = {package: mypkg};
    // Graph graph = {rootNode: {package: mypkg, children: []}};

    Queue queue = []; // BFS
    queue.push(child1, child2);

    while queue.length() != 0 {
        PackageDesc package = queue.shift();
        string key = pkgDescKey(package);
        IndexPackage[]? indexPkgs = index[key];
        if indexPkgs == () {
            return error(string `${key} dependency missing in the index`);
        }
        if indexPkgs.length() == 0 {
            return error(string `No available versions for in the index: ${key}`);
        }
        // TODO: pass the currently set version here.
        IndexPackage? latest = check updateLatestVersion(indexPkgs);
        if latest == () {
            return error(string `No matching versions for in the index: ${key}`);
        }
        resolved[key] = latest.version;

        queue.push(...latest.dependencies);
    }
    io:println(resolved);
}

function updateLatestVersion(IndexPackage[] indexPkgs) returns IndexPackage?|error {
    IndexPackage? latestPkg = ();

    foreach IndexPackage pkg in indexPkgs {
        semver:Version packageBalVersion = check new (pkg.ballerinaVersion);
        if !isDistCompatible(packageBalVersion) {
            continue;
        }
        if latestPkg == () {
            latestPkg = pkg;
            continue;
        }
        semver:Version version = check new (pkg.version);
        semver:Version latest = check new (latestPkg.version);
        if latest.lessThan(version) {
            latestPkg = pkg;
        }
    }
    return latestPkg;
}

function loadIndex() returns Index|error {
    json indexJson = check io:fileReadJson("./resources/index.json");
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

function isDistCompatible(semver:Version packageBalVersion) returns boolean =>
    ballerinaVersion.getMajorVersion() == packageBalVersion.getMajorVersion()
    && ballerinaVersion.getMinorVersion() >= packageBalVersion.getMinorVersion();

function pkgKey(IndexPackage package) returns string => string `${package.org}/${package.name}`;

function pkgDescKey(PackageDesc package) returns string => string `${package.org}/${package.name}`;
