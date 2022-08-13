#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true  

bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
				+login anonymous \
				+app_update "${STEAMAPPID}" \
				+quit

# Is the config missing?
if [ ! -f "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg" ]; then
        # Download & extract the config
        wget -qO- "${DLURL}/master/etc/cfg.tar.gz" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"

        # Change hostname on first launch (you can comment this out if it has done its purpose)
        sed -i -e 's/{{SERVER_HOSTNAME}}/'"${SRCDS_HOSTNAME}"'/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"
fi

# Are we in a metamod container and is the metamod folder missing?
if  [ ! -z "$METAMOD_VERSION" ] && [ ! -d "${STEAMAPPDIR}/${STEAMAPP}/addons/metamod" ]; then
        LATESTMM=$(wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/mmsource-latest-linux)
        wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/"${LATESTMM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"
fi

# Are we in a sourcemod container and is the sourcemod folder missing?
if  [ ! -z "$SOURCEMOD_VERSION" ] && [ ! -d "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod" ]; then
        LATESTSM=$(wget -qO- https://sm.alliedmods.net/smdrop/"${SOURCEMOD_VERSION}"/sourcemod-latest-linux)
        wget -qO- https://sm.alliedmods.net/smdrop/"${SOURCEMOD_VERSION}"/"${LATESTSM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"
fi

# Believe it or not, if you don't do this srcds_run shits itself
cd "${STEAMAPPDIR}"

bash "${STEAMAPPDIR}/srcds_run" -game "${STEAMAPP}" -console -autoupdate \
                        -steam_dir "${STEAMCMDDIR}" \
                        -steamcmd_script "${HOMEDIR}/${STEAMAPP}_update.txt" \
                        -usercon \
                        -port "${SRCDS_PORT}" \
                        +clientport "${SRCDS_CLIENT_PORT}" \
                        +maxplayers "${SRCDS_MAXPLAYERS}" \
                        +map "${SRCDS_STARTMAP}" \
                        -ip "${SRCDS_IP}" \
                        -nohltv \
                        +servercfgfile "${SRCDS_CFG}" \
                        +mapcycle "${SRCDS_CYCLE}" \
                        -high \
                        -num_edicts "4096" \
                        -strictportbind