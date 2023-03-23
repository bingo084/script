#!/bin/bash

# save pid file
echo $$ > ${HOME}/.config/clash/clash.pid

diff ${HOME}/.config/clash/config.yaml <(curl -s ${CLASH_URL} --connect-timeout 10 -m 20 --noproxy '*')
if [ "$?" == 0 ]
then
    /usr/bin/clash
else
    TIME=`date '+%Y-%m-%d %H:%M:%S'`
    cp ${HOME}/.config/clash/config.yaml "${HOME}/.config/clash/config.yaml.bak${TIME}"
    find ${HOME}/.config/clash -mmin +3 -name 'config.yaml.bak*' -exec rm -rf {} \;
    curl -L -o ${HOME}/.config/clash/config.yaml ${CLASH_URL} --connect-timeout 10 -m 20 --noproxy '*'
    /usr/bin/clash
fi
