rm -rf ./artifact/ && mkdir -p ./artifact/
mv friendlywrt-*/out/*img* ./artifact/
cp friendlywrt-*/friendlywrt/.config ./artifact/
cd ./artifact/
md5sum *img* > md5sum.txt
cd ..
zip -r artifact.zip ./artifact/
