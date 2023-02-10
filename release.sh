#/bin/bash

#git tag v0.0.1 HEAD
#git push origin --tags

#git checkout -b dev
#git push --set-upstream origin dev

release_version="v0.0.2"

#release_version="v$(date +'%Y.%m.%d.%H%M%S')"



echo "################# Check out main branch #######################"
git checkout main
git pull
git commit -m "release new version" -a
git push

git tag $release_version HEAD
git push origin --tags

