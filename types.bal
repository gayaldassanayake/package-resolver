type PackageDesc record {|
    string org;
    string name;
    string version;
|};

type IndexPackage record {|
    *PackageDesc;
    string ballerinaVersion;
    record {|
        *PackageDesc;
    |}[] dependencies;
|};

type Packages IndexPackage[];

type Index map<IndexPackage[]>;

// type Node PackageDesc;

type Graph record {|
    PackageDesc rootNode;
|};

type Stack PackageDesc[];

type Queue PackageDesc[];

type Resolved map<string>;
