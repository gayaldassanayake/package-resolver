# STEPS
### Distribution version check
Complete
### Locking modes
LATEST, SOFT, MEDIUM, HARD

### Major version compatibility checks
Done

### Platform

### Scopes
Introduce testOnly, provided scopes

### Introduce Dependencies.toml
Done.

Filter out any dependencies that are not used. This might need maintaining an actual graph

### Sub module resolution

### Repositories
Distribution/Central/(FileSystem)/Local/Custom

### Cyclic dependencies
can do with a DFS. So might need to change from a queue to a stack impl

### Pre release versions

### Other

1. Move the cases into a DDT
2. Create different scenarios to be tested on.
2. Refactor and move into separate functions. Will help when we need to impl locking modes.
3. Allow configs like dist version, locking mode to be passed as args/ configs.
