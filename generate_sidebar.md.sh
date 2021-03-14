#!/bin/bash
# markdown目录生成 v1.2
# 作者：duan[cseve.com]
# 功能：生成目录

if [ -f _sidebar.md ] ; then
  rm _sidebar.md
fi

#记录当前所在的路径
myPath="$PWD"

#将会填充blank
sblank="  "

#blank将会填充在“└────”的前面

sblankblank="- "

# 获取当前目录
relPath=`pwd`

#tree函数，该函数实现tree的功能
tree()
{
    #for循环，搜索该目录下的所有文件和文件夹
    for file in *;
    do
        #if判断，判断是不是文件，如果是文件的话，将该文件名写入Content.txt
        if [ -f "$file" ] && [[ ${file} != *generateContents.sh* ]] && [[ ${file} == *.md ]]; then

            curPath=`readlink -f $file | sed "s#${relPath}#.#g"`
            #echo $curPath
            file=`ls $file | sed 's/\.md//g'`
            echo "${sblankblank}[$file]($curPath)" >> "${myPath}/_sidebar.md"
        fi

        #if判断，判断是不是文件夹，如果是文件夹的话，将该文件夹的名称写入Content.txt
        if [ -d "$file" ] && [[ ${file} != *generateContents.sh* ]] && [[ ${file} != *.assets ]] && [[ ${file} != *img* ]]; then
            #1、将该文件夹的名称写入Content.txt
            echo "${sblankblank}**$file**" >> "${myPath}/_sidebar.md"

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

get_char(){
    SAVEDSTTY=`stty -g`
    stty -echo
    stty raw
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}


echo "##############################################"
echo "####    Start generate _sidebar . . ."
echo "##############################################"
tree

echo ""
echo "##############################################"
echo "#### _sidebar generate successful!"
echo "#### "
echo "#### Press any key to continue git push"
echo "##############################################"
echo ""
char=`get_char`

# git add . && git commit -m "$(date)" && git push
# echo ""
# echo "##############################################"
# echo "### git push successful"
# echo "##############################################"
# echo ""
# echo "Press any key to exit..."
# char=`get_char`
