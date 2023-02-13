# kolle-ci

### github action usage
```

jobs:
  test:
    name: build and test
    runs-on: ubuntu-20.04
    container:
      image: ghcr.io/metaheed/kolle-ci:v0.0.2
      credentials:
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

```

### Build docker
```
docker build  -t metaheed/kolle-ci:latest --file Dockerfile .
```
### build local with kolle user
```
docker build  -t metaheed/kolle-ci-local:latest --file Dockerfilelocal .
```
### watch shadow-cljs app
```
docker run -it --rm --name kolle-ci -w "workspace" -p 3000:3000  -v spath:/home/kolle/workspace -v m2/repository:/home/kolle/.m2/repository metaheed/kolle-ci-local npx shadow-cljs watch app
```
### build shadow-cljs app
```
docker run -it --rm --name kolle-ci -w "workspace" -p 3000:3000  -v spath:/home/kolle/workspace -v m2/repository:/home/kolle/.m2/repository metaheed/kolle-ci-local npx shadow-cljs release app
```
### build clj app replace workspace and params before run
```
docker run -it --name kolle-ci --rm -w "workspace" -p 3000:3000  -v spath:/home/kolle/workspace -v m2/repository:/home/kolle/.m2/repository metaheed/kolle-ci-local clojure "params"
```
## License

Copyright © 2022-2023 Abdullah Mamun
Distributed under the MIT License. See LICENSE.