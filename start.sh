#!/bin/bash

APP_PID=
stopRunningProcess() {
    if test ! "${APP_PID}" = '' && ps -p ${APP_PID} > /dev/null ; then
        > /proc/1/fd/1 echo "Stopping ${COMMAND_PATH} which is running with process ID ${APP_ PID}"
        kill -TERM ${APP_PID}
        > /proc/1/fd/1 echo "Waiting for ${COMMAND_PATH} to process SIGTERM signal"
        wait ${APP_PID}
        > /proc/1/fd/1 echo "All processes have stopped running"
    else
        > /proc/1/fd/1 echo "${COMMAND_PATH} was not started when the signal was sent or it has already been stop"
    fi
}



trap stopRunningProcess EXIT TERM

source "${VIRTUAL_ENV}/bin/activate"
#sed -i "s/stl. secrets\['api secret '1J/'sk-token'/" "${HOME/main/AIAssistont/app.py}"
streamlit run "${HOME}/app.py" &
APP_PID=${!}

wait ${APP_PID}
