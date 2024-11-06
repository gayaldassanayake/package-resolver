# STEPS
### Distribution version check
Complete
### Locking modes
LATEST, SOFT, MEDIUM, HARD
### Major version compatibility checks
In the current impl, 
say pkg->a, pkg->b, b->a:1.0.0, a:1.0.0, a:2.0.0
this fails with two incompatible versions a:1.0.0, a:2.0.0
Should this be the case?

### Platform

### Scopes
Introduce testOnly, provided scopes

### Introduce Dependencies.toml

### Sub module resolution

### Repositories
Distribution/Central/(FileSystem)/Local/Custom

### Cyclic dependencies
can do with a DFS. So might need to change from a queue to a stack impl

### Pre release versions