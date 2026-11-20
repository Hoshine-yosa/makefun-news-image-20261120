#!/bin/bash
# Shoot the Nov 20 news-image poster (1024x1024) via headless Chrome for Testing + CDP.
set -u
cd ~/workspace/makefun/news-image-20261120 || exit 1
URL="file:///home/hatch/workspace/makefun/news-image-20261120/poster.html"
CHROME="$HOME/.cache/chrome-for-testing/chrome-linux64/chrome"

pkill -f 'remote-debugging-port=9222' 2>/dev/null; sleep 1
rm -rf /tmp/chrome-news20

"$CHROME" --headless=new --remote-debugging-port=9222 \
  --allow-file-access-from-files --window-size=1024,1224 --no-sandbox \
  --user-data-dir=/tmp/chrome-news20 --no-first-run --disable-dev-shm-usage \
  --no-default-browser-check --force-device-scale-factor=1 "${URL}" >/tmp/chrome-news20.log 2>&1 &
for i in $(seq 1 40); do curl -s http://localhost:9222/json/list >/dev/null 2>&1 && break; sleep 0.5; done
node ~/workspace/makefun/shoot.mjs - "/home/hatch/workspace/makefun/news-image-20261120/entry.png" 1024 1024
pkill -f 'remote-debugging-port=9222' 2>/dev/null; sleep 1
ls -la /home/hatch/workspace/makefun/news-image-20261120/entry.png
python3 -c "from PIL import Image; im=Image.open('/home/hatch/workspace/makefun/news-image-20261120/entry.png'); print('size:', im.size, 'mode:', im.mode)"
