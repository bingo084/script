#!/bin/bash

# save pid file
echo $$ > ${HOME}/.config/clash/clash.pid

diff ${HOME}/.config/clash/config.yaml <(curl -s ${CLASH_URL} --connect-timeout 10 -m 20 --noproxy '*')
if [ "$?" == 0 ]
then
    /usr/bin/clash
else
    curl -L -o ${HOME}/.config/clash/config.new.yaml ${CLASH_URL} --connect-timeout 10 -m 20 --noproxy '*'
    if [[ $(wc -l < ${HOME}/.config/clash/config.new.yaml) < 20 ]]
    then
        rm -rf ${HOME}/.config/clash/config.new.yaml
    else
        TIME=`date '+%Y-%m-%d %H:%M:%S'`
        cp ${HOME}/.config/clash/config.yaml "${HOME}/.config/clash/config.yaml.bak${TIME}"
        find ${HOME}/.config/clash -mtime +1 -name 'config.yaml.bak*' -exec rm -rf {} \;
        mv {HOME}/.config/clash/config.new.yaml {HOME}/.config/clash/config.yaml
    fi
    /usr/bin/clash
fi
