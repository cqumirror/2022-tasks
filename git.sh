#! /bin/bash
lastUpdate= "there is no file"
INIT(){
    if[-d /home/git];then
        echo "git 目录存在,初始化git"
        git init /home/git
    else
        echo "git 目录不存在，创建目录"
        mkdir /home/git
        git init /home/git
    fi
    echo "初始化完成"
    cd /home/git
    if[-d /home/git/test];then
        echo "rust 目录存在,pass"
    else
        echo "rust 目录不存在，首次同步"
        git clone --mirror https://github.com/Cloudrideryx/test.git
        if [$?=0];then
            echo "拉取正常"
            flagSuc=1
        else
            echo "拉取不正常"
            int=1
            while(($int<=3))
            do
                git clone --mirror https://github.com/Cloudrideryx/test.git
                if [$?=0];then
                    echo "重试 $int 次，成功"
                    touch ./config.txt
                    flagSuc=1
                    break
                else
                    echo "重试 $int/3 次，失败"
                    $int++
                    flagSuc=0
                    

            done
    fi
    if[$flagSuc==1];then

}

UPDATE(){
    echo "开始更新"
}