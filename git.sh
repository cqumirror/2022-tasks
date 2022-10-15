#! /bin/bash
lastUpdate="there is no file"
#初始化（第一次同步）
INIT(){
    touch ~/gitlog.txt || exit
    touch ~/update.log|| exit

    if [ -d ~/git ];then
        echo "git 目录存在,初始化git"
        git init ~/git
    else
        echo "git 目录不存在，创建目录"
        mkdir ~/git
        git init ~/git
    fi

    echo "初始化完成"
    echo "初始化完成on $(date) " >> ~/gitlog.txt 
    cd ~/git/test || exit

    if [ -d ~/git/test ];then

        echo "rust 目录存在,pass"
    
    else
        echo "rust 目录不存在，首次同步"
        timeout 2400s git clone --mirror https://github.com/Cloudrideryx/test.git
        cCode=$?
        if [ ${cCode} -eq 0 ];then
            echo "拉取正常"
            echo "首次拉取正常on$(date)" >> ~/gitlog.txt
            flagSuc=1
        else
            echo "拉取不正常"
            echo "首次拉取不正常on$(date)">> ~/gitlog.txt
            int=1
            while [ $int -le 5 ]
            do
                timeout 1800s git clone --mirror https://github.com/Cloudrideryx/test.git
                cCode=$?
                if [ ${cCode} -eq 0 ];then
                    echo "重试 $int 次，成功"
                    echo "首次拉取不正常on$(date)；重试 $int 次，成功"
                    flagSuc=1
                    break
                else
                    echo "首次拉取不正常on$(date)；重试 $int/3 次，失败"
                    int=$int+1
                    flagSuc=0
                fi    
            done
        fi
    fi

    if [ $flagSuc -eq 1 ];then
        lastUpdate=$(date)
        echo "${lastUpdate}" > ~/update.log
    fi

}

UPDATE(){
    lastUpdate=$( cat ~/update.log )
    echo "开始同步，上次同步时间$lastUpdate"
    git --git-dir=~/git/test.git remote update
    uCode=$?
    if [ $uCode -eq 0 ];then
        echo "更新正常"
        flagSuc=1
    else
            echo "更新不正常"
            int=1
            while [ $int -le 3 ]
            do
            git --git-dir=~/git/test.git remote update
                if [ $uCode -eq 0 ] ;then
                    echo "重试 $int 次，成功"
                    flagSuc=1
                    break
                else
                    echo "重试 $int/3 次，失败"
                    int=$((int+1))
                    flagSuc=0
                fi    
            done
    fi
    
    if [ ${flagSuc} == 1 ];then
        lastUpdate=$(date)
        echo "${lastUpdate}" >> ~/update.log
    fi


}
