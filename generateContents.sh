#!/bin/bash
# markdown目录生成 v1.1

if [ -f Content.md ] ; then
  rm Content.md
fi

#记录当前所在的路径
myPath="$PWD"
#将会填充blank
sblank="    "
#blank将会填充在“└────”的前面
sblankblank="- "

#tree函数，该函数实现tree的功能
tree()
{
    #for循环，搜索该目录下的所有文件和文件夹
    for file in *;
    do
        #if判断，判断是不是文件，如果是文件的话，将该文件名写入Content.txt
        if [ -f "$file" ] && [[ ${file} != *generateContents.sh* ]]; then


            curPath=`readlink -f $file | sed 's/\/e\/Note/./g'`
            #echo $curPath
            echo "${sblankblank}[$file]($curPath)" >> "${myPath}/Content.md"
        fi

        #if判断，判断是不是文件夹，如果是文件夹的话，将该文件夹的名称写入Content.txt
        if [ -d "$file" ] && [[ ${file} != *generateContents.sh* ]]; then
            #1、将该文件夹的名称写入Content.txt
            echo "${sblankblank}**$file**" >> "${myPath}/Content.md"
            #2、在“└────”的前面填充“    ”
            sblankblank=${sblank}${sblankblank}
            #3、进入该文件夹
            cd "$file"
            #4、执行tree函数(这是递归)
            tree
            #5、从该文件夹里出来
            cd ..
            #6、从文件夹里出来之后，将在“└────”的前面填充的“    ”删除
            sblankblank=${sblankblank#${sblank}}
        fi
    done

}

tree


get_char()
{
SAVEDSTTY=`stty -g`
stty -echo
stty raw
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}



echo "Contents generate successful"
echo "Press any key to continue..."
char=`get_char` 

git add . && git commit -m "1" && git push

echo "git add . && git commit -m "1" && git push successful"
echo "Press any key to continue..."
char=`get_char` 