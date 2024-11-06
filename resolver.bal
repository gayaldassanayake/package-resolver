import ballerina/io;

import ballerinacentral/semver;

Resolved resolved = {};
semver:Version ballerinaVersion = check new ("2201.7.0");

function resolveDependencies(string case) returns error? {
    Index index = check loadIndex(case);
    PackageDesc[] directDependencies = check loadDirectDependencies(case);

    Queue queue = []; // BFS
    queue.push(...directDependencies);

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

function isDistCompatible(semver:Version packageBalVersion) returns boolean =>
    ballerinaVersion.getMajorVersion() == packageBalVersion.getMajorVersion()
    && ballerinaVersion.getMinorVersion() >= packageBalVersion.getMinorVersion();

function pkgKey(IndexPackage package) returns string => string `${package.org}/${package.name}`;

function pkgDescKey(PackageDesc package) returns string => string `${package.org}/${package.name}`;
