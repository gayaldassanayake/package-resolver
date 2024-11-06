import ballerina/io;

public function main() returns error? {
    string[] cases = ["case-001"];
    foreach string case in cases {
        io:println(string `** case ${case} **`);
        error? e = resolveDependencies(case);
        if e is error {
            io:println(e);
        }
        io:println();
    }
}
