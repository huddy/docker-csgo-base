FROM centos:7

MAINTAINER bhoward <billy@osg.me>

#steamcmd shit
ENV STEAM_CMD_BASE_DIR=/opt/steamcmd
ENV STEAM_CMD_FILE_NAME=steamcmd.sh
ENV STEAM_CMD_FILE=${STEAM_CMD_BASE_DIR}/${STEAM_CMD_FILE_NAME}
ENV STEAM_CMD_LOGIN=anonymous
ENV CSGO_INSTALL_PATH=/csgo-server
ENV CSGO_APP_ID=740
ENV STEAM_CMD_BASE_EXEC="${STEAM_CMD_FILE} +login ${STEAM_CMD_LOGIN} +force_install_dir ${CSGO_INSTALL_PATH}"

#cs server launch/config options
ENV GAME_LOGIN_TOKEN=""
ENV CSGO_GAME_TYPE=1
ENV CSGO_GAME_MODE=0
ENV CSGO_PORT=27015
ENV CSGO_IP=0.0.0.0
ENV CSGO_MAP_GROUP=mg_bomb
ENV CSGO_MAP=de_dust2

#mm config
ENV METAMOD_MAJOR_VERSION=1.10

#sm config
ENV SOURCEMOD_MAJOR_VERSION=1.8

#scripts
ADD scripts /opt/scripts
RUN chmod -R +x /opt/scripts 

#download steamcmd and install.
RUN yum update -y && yum -y install glibc.i686 libstdc++.i686 net-tools wget && \
    mkdir -p $STEAM_CMD_BASE_DIR && \
    cd $STEAM_CMD_BASE_DIR && \
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -vxz && \
    chmod +x ${STEAM_CMD_FILE} && \
    mkdir -p /root/.steam/sdk32 && \ 
    ln -s ${STEAM_CMD_BASE_DIR}/linux32/steamclient.so /root/.steam/sdk32/steamclient.so
    
#install csgo 
RUN ${STEAM_CMD_BASE_EXEC} +app_update "${CSGO_APP_ID} validate" +quit

#install metamod
RUN export METAMOD_FILE=$(curl -s https://mms.alliedmods.net/mmsdrop/1.10/mmsource-latest-linux) && \
    cd $CSGO_INSTALL_PATH/csgo && \
    curl -s https://mms.alliedmods.net/mmsdrop/1.10/${METAMOD_FILE} | tar -vxz 

#install sourcemod
RUN cd $CSGO_INSTALL_PATH/csgo && \
    curl -s https://sm.alliedmods.net/smdrop/${SOURCEMOD_MAJOR_VERSION}/$(curl -s https://sm.alliedmods.net/smdrop/${SOURCEMOD_MAJOR_VERSION}/sourcemod-latest-linux) | tar -vzx
