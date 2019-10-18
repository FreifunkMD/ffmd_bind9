# Docker image for git-configured bind9

Arguments:
* GITREPO: Git reporistory URI
* GITREF:  Branch or tag in GITREPO, defaults to `master`

Build with as
```
  docker build --build-arg GITREPO=<git uri> --buildarg GITREF=<branch or tag>
```

