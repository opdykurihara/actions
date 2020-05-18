#!/bin/sh -l

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"

# windowsの場合コミット時に以下のコマンドが必要
# git add --chmod=+x -- entrypoint.sh
