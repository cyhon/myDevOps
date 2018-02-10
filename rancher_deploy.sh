#!/bin/bash
set -e

declare -A project_repos=(
["_gateway_version_"]="https://git.finogeeks.club/finochat/gateway"
["_gateway_init_version_"]="https://git.finogeeks.club/finochat/gateway-init"
["_uac_server_version_"]="https://git.finogeeks.club/finochat/uac-server"
["_auth_center_version_"]="https://git.finogeeks.club/finochat/auth-center"
["_bot_center_version_"]="https://git.finogeeks.club/finochat/bot-center"
["_rcs_server_version_"]="https://git.finogeeks.club/finochat/rcs-server"
["_homeserver_version_"]="https://git.finogeeks.club/finochat/docker-homeserver"
["_push_service_version_"]="https://git.finogeeks.club/finochat/push-service"
["_platform_api_version_"]="https://git.finogeeks.club/finochat/platform-api"
["_init_server_version_"]="https://git.finogeeks.club/finochat/init-server"
)

catalog_repos=(
"https://git.finogeeks.club/catalog/geekthings"
"https://git.finogeeks.club/catalog/geekthings-online"
"https://git.finogeeks.club/catalog/gxsec"
"https://git.finogeeks.club/catalog/cgws"
"https://git.finogeeks.club/catalog/finochat"
"https://git.finogeeks.club/catalog/finochat-website"
"https://git.finogeeks.club/catalog/finogeeks"
)

catalog_names=(
"finochat"
)

auto_deploy_catalog_repo="finochat"
auto_deploy_catalog_name="finochat"

root_path=$(pwd)
cd ${root_path}

catalog_default_version=1.0.0
if [ $# -ge 1 ]
then
    catalog_version=$1
else
    catalog_version=$catalog_default_version
fi

for catalog_name in ${catalog_names[@]}
do
    cp templates/${catalog_name}/docker-compose.yml.template docker-compose.yml
    for i in "${!project_repos[@]}"
    do
        cur=${project_repos[$i]##*/}
        git clone ${project_repos[$i]}
        cd ${cur}
        version=`git describe --abbrev=0 --tags`
        cd ..
        rm -rf ${cur}
        sed -i "s/${i}/${version}/g" docker-compose.yml
    done

    for catalog_repo in ${catalog_repos[@]}
    do
        git clone ${catalog_repo}
        catalog_repo_name=${catalog_repo##*/}

        if [ ! -d ${catalog_repo_name}/templates/${catalog_name} ]
        then
            continue
        else
            if [ ! -d ${catalog_repo_name}/templates/${catalog_name}/${catalog_version} ]
            then
                mkdir ${catalog_repo_name}/templates/${catalog_name}/${catalog_version}
            fi
        fi

        cp docker-compose.yml ${catalog_repo_name}/templates/${catalog_name}/${catalog_version}/docker-compose.yml
        cp templates/${catalog_name}/README.md ${catalog_repo_name}/templates/${catalog_name}/${catalog_version}/README.md
        cp templates/${catalog_name}/rancher-compose.yml.${catalog_repo_name} ${catalog_repo_name}/templates/${catalog_name}/${catalog_version}/rancher-compose.yml

        if [ ${catalog_version} != $catalog_default_version ]
        then
            sed -i "s/\(^ *version:\).*/\1 ${catalog_version}/" ${catalog_repo_name}/templates/${catalog_name}/${catalog_version}/rancher-compose.yml
        fi

        cd ${catalog_repo_name}
        git config --global user.email "finogeeks-catalog@finogeeks.com"
        git config --global user.name "finogeeks-catalog"
        git status
        ls -l templates/${catalog_name}
        git add -A && git commit -m "[auto commit]${catalog_name} version: ${catalog_version}" || echo
        git push
        cd ..

        if [ ${catalog_repo_name} == ${auto_deploy_catalog_repo} -a ${catalog_name} == ${auto_deploy_catalog_name} ]
        then
            grep 'variable\|default' ${catalog_repo_name}/templates/${catalog_name}/${catalog_version}/rancher-compose.yml | awk -F ': ' '{ gsub(/^[ \t]+/, "", $2); print $2; }' |\
                sed '1~2 s/"$/=/' | sed 's/^"//' | sed 's/"$//' | sed 'N;s/\n//' > ${root_path}/rancher-compose.env
            cp ${catalog_repo_name}/templates/${catalog_name}/${catalog_version}/docker-compose.yml ${root_path}/
            cp ${catalog_repo_name}/templates/${catalog_name}/${catalog_version}/rancher-compose.yml ${root_path}/
        fi

        rm -rf ${catalog_repo_name}
    done
done
