#!/bin/bash

pkill -f "katana --disable-fee"
pkill -f "torii -d indexer.db"
pkill -f "tee katana_output.txt"
pkill -f "tee sozo_output.txt"
pkill -f "tee touch_output.txt"
# 异步执行 katana 命令，将输出同时重定向到 katana_output.txt 和终端
katana --disable-fee 2>&1 | tee katana_output.txt &

# 等待 katana 输出文件中出现 "JSON-RPC server started"，然后注释 Scarb.toml 文件的第 22 行
while ! grep -q "JSON-RPC server started" katana_output.txt
do
    sleep 1
done

echo "正在加入 Scarb.toml 的 #注释..."

# 注释 Scarb.toml 文件的第 22 行
awk '{ if ($0 ~ /world_address/) { sub(/world_address/, "#world_address"); print; next } } 1' Scarb.toml > output_file && rm Scarb.toml
mv output_file Scarb.toml

# 异步执行 sozo 命令，将结果同时输出到 sozo_output.txt 和终端
sozo build 2>&1 | tee sozo_output.txt &

# 等待 "Finished" 出现在 sozo_output.txt 中
while ! grep -q "Finished" sozo_output.txt; do
    sleep 1
done

# 当 "Finished" 出现后，执行 sozo migrate --name test 命令
sozo migrate --name test 2>&1 | tee -a sozo_output.txt

# 等待 sozo 输出文件中出现 "Successfully migrated World on block"，然后取消注释 Scarb.toml 文件的第 22 行
while ! grep -q "Successfully" sozo_output.txt
do
    sleep 1
    echo "正在等待 sozo 完成..."
done

echo "正在恢复 Scarb.toml 的注释..."

# 取消注释 Scarb.toml 文件的第 22 行
awk '{ gsub(/#world_address/, "world_address"); print }' Scarb.toml > output_file && rm Scarb.toml
mv output_file Scarb.toml

echo "准备创建 indexer db"

# 检查当前目录下是否存在 indexer.db 文件，如果不存在则执行 touch
if [ ! -f "indexer.db" ]; then
    touch indexer.db
    echo "indexer.db 创建成功"
fi

# 异步执行 touch 命令，将结果同时输出到 touch_output.txt 和终端
echo "准备启动 Torii ..."

nohup torii -d indexer.db > torii_output.txt 2>&1 &

echo "Torii 启动成功"

echo "执行 权限设置 脚本"

./scripts/default_auth.sh
