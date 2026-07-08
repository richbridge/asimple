#! /bin/bash

echo -e "-------------------- 开始部署 --------------------"

# git pull origin main

git submodule update --remote --merge content/posts
# git submodule update --remote --merge source/img
# git submodule update --remote --merge themes/stellar

echo -e "------------------- 子模块更新完成 -------------------"

# hexo bangumi -u && hexo algolia && hexo clean

for i in {1..2}; do echo -e "\n" ; done

echo -e "------------------- 番号页和搜索页完成 -------------------"

time=$(date "+%Y%m%d%H%M%S")

git add .
git commit -m "$time"
git push -u richfan main

echo -e "------------------- 上传完成 -------------------"

exec /bin/bash
