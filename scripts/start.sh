#!/usr/bin/env bash
${STEAM_CMD_BASE_EXEC} +app_update "${CSGO_APP_ID} validate" +quit

cd $CSGO_INSTALL_PATH
./srcds_run -game csgo -usercon +game_type $CSGO_GAME_TYPE +game_mode $CSGO_GAME_MODE +mapgroup $CSGO_MAP_GROUP +map de_dust2 +sv_setsteamaccount ${GAME_LOGIN_TOKEN} -net_port_try 1
