type PackageDesc record {|
    string org;
    string name;
    string version?;
|};

type PackageDescs PackageDesc[];

type IndexPackageVersion record {|
    string org;
    string name;
    string version;
|};

type IndexPackage record {|
    *IndexPackageVersion;
    string ballerinaVersion;
    record {|
        *IndexPackageVersion;
    |}[] dependencies;
|};

type Packages IndexPackage[];

type Index map<IndexPackage[]>;

// type Node PackageDesc;

// type Graph record {|
//     PackageDesc rootNode;
// |};

// type Stack PackageDesc[];

type Queue PackageDesc[];

type Resolved map<string>;
