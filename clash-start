#!/bin/bash

OLD_CONFIG="${HOME}/.config/clash/config.yaml"
NEW_CONFIG="${HOME}/.config/clash/config.new.yaml"

# save pid file
echo $$ > ${HOME}/.config/clash/clash.pid

curl -L -o ${NEW_CONFIG} ${CLASH_URL} --connect-timeout 10 -m 20 --noproxy '*'
diff ${NEW_CONFIG} ${OLD_CONFIG}
if [[ "$?" == 0 ]]
then
    # no difference between old config and new config
    echo "config.yaml is already the latest!"
    rm ${NEW_CONFIG}
elif [[ $(wc -l < ${NEW_CONFIG}) < 20 ]]
then
    # new config is broken
    echo "config.new.yaml is broken, end updating!"
    rm ${NEW_CONFIG}
else
    # use new config replace old config
    TIME=`date '+%Y-%m-%d %H:%M:%S'`
    echo "backup config.yaml to config.yaml.bak${TIME}"
    cp ${OLD_CONFIG} "${OLD_CONFIG}.bak${TIME}"
    echo "clean old backup"
    find ${HOME}/.config/clash -mtime +1 -name 'config.yaml.bak*' | tee delete_list.log | xargs rm -rf
    cat delete_list.log
    rm delete_list.log
    echo "clean complate"
    echo "rename config.new.yaml to config.yaml"
    mv ${NEW_CONFIG} ${OLD_CONFIG}
fi
echo "clash is starting..."
/usr/bin/clash
