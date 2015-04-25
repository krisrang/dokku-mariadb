#!/usr/bin/env bash

. test/test_helper.bash

if [[ ! -d $PLUGIN_PATH ]]; then
  git clone https://github.com/progrium/dokku.git test/dokku > /dev/null
fi

cd test/dokku
echo "Dokku version $DOKKU_VERSION"
git checkout $DOKKU_VERSION > /dev/null
cd -

rm -r test/dokku/plugins/mariadbkr
mkdir -p test/dokku/plugins/mariadbkr
find ./ -maxdepth 1 -type f | xargs -I {} cp {} test/dokku/plugins/mariadbkr
