#!/bin/bash

# [Ref.: https://github.com/juliojsb/my-tux/blob/master/linux_security_checks.sh ]

# NOTE: Avoid problems with relative paths! By Questor
SCRIPTDIR_V="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# NOTE: Load main library. By Questor
. $SCRIPTDIR_V/lib/ez_i.bash

# NOTE: Load configuration. By Questor
. $SCRIPTDIR_V/conf/conf.bash

# NOTE: Other useful scripts. By Questor
. $SCRIPTDIR_V/resrc/other.bash

# NOTE: Load Chkrootkit intallation functionalities. By Questor
. $SCRIPTDIR_V/inst/chkrootkit.bash

# NOTE: It will send an email through a relay previously configured in Sendmail. By Questor
LOG_FILE_NM_NOW=""
f_sendmail() {
    # [Refs.: https://linuxhint.com/trim_string_bash/ , 
    # https://stackoverflow.com/a/16623897/3223785 ]
    GENERICSTABLE="/etc/mail/genericstable"

    # NOTE: Retrieves the sender email from the file defined in "$GENERICSTABLE"
    # (Sendmail). By Questor
    MAIL_FROM=$(cat $GENERICSTABLE | grep "root")
    MAIL_FROM=${MAIL_FROM#"root"}
    MAIL_FROM=$(echo $MAIL_FROM | sed 's/ *$//g')

    MAIL_CONTENT="From: $MAIL_FROM
To: $SEND_MAIL_DEST_C
Subject: Private_tux security routine results ($(hostname))

$LOG_FILE_NM_NOW output:

$(cat "$LOG_FILE_NM_NOW")

[]'s

$(hostname)
Free software! Embrace that idea!
https://github.com/eduardolucioac/private_tux
"
    f_log_manager ">>> Send email notification. <<<" "$LOG_FILE_NM_NOW"
    echo -n "$MAIL_CONTENT" | sendmail -Am -d60.5 -v $SEND_MAIL_DEST_C > f_p_tux_op_to_log 2>&1
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"
}

# NOTE: The Security Routine (p_tux.bash) main function. Controls the entire process. By Questor
f_p_tux() {

    # NOTE: Change to the folder path that contains the running script. By Questor
    cd "$SCRIPTDIR_V"

    # NOTE: Create a directory for the Security Routine (p_tux.bash) logs if it does
    # not exist. By Questor
    f_chk_fd_fl "/var/log/p_tux" "d"
    if [ ${CHK_FD_FL_R} -eq 0 ] ; then
        mkdir "/var/log/p_tux"
    fi

    f_log_manager ">>> Security routine started. <<<" 0 "p_tux" "/var/log/p_tux"

    # NOTE: The value in "$LOG_FILE_NM_NOW" is returned by the f_log_manager function
    # and contains the path and name for the current log that was automatically generated
    # by the f_log_manager function. By Questor
    LOG_FILE_NM_NOW="$LOG_FILE_NAME"

    f_log_manager ">>> Checking distro compatibility. <<<" "$LOG_FILE_NM_NOW"

    # NOTE: This way I can execute the function by redirecting stderr and stdout to
    # a file at the same time that I allow the manipulation of variables external to
    # the function (case of "$DISTRO_TYPE"), otherwise ("F_CHK_DISTRO_OP=$(f_chk_distro)"
    # or "F_CHK_DISTRO_OP=`f_chk_distro`", for example) the function will being executed
    # in a "subshell" and the manipulation of these variables will not be possible.
    # By Questor
    f_chk_distro > f_p_tux_op_to_log 2>&1
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)

    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    # NOTE: Update system. By Questor
    f_log_manager ">>> System update started. <<<" "$LOG_FILE_NM_NOW"
    case "$DISTRO_TYPE" in
        RH)
            yum -y update > f_p_tux_op_to_log 2>&1
            F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
            f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"
        ;;
        *)
            f_log_manager "ERROR: Not implemented to your OS." "$LOG_FILE_NM_NOW"
        ;;
    esac

    # NOTE: Log current network connections. By Questor
    f_log_manager ">>> Log current network connections with netstat. <<<" "$LOG_FILE_NM_NOW"
    netstat -netaup > f_p_tux_op_to_log 2>&1
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    # NOTE: Log most recent logins. By Questor
    f_log_manager ">>> Log most recent logins with lastlog. <<<" "$LOG_FILE_NM_NOW"
    lastlog > f_p_tux_op_to_log 2>&1
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    # NOTE: Log last logged users. By Questor
    f_log_manager ">>> Log last logged users with last. <<<" "$LOG_FILE_NM_NOW"
    last > f_p_tux_op_to_log 2>&1
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    case "$DISTRO_TYPE" in
        RH)
            # [Ref.: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-viewing_current_status_and_settings_of_firewalld ]
            # NOTE: Log firewall service status. By Questor
            f_log_manager ">>> Firewall service status. <<<" "$LOG_FILE_NM_NOW"
            systemctl status firewalld > f_p_tux_op_to_log 2>&1
            F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
            f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

            # NOTE: Log firewall rules. By Questor
            f_log_manager ">>> Firewall rules. <<<" "$LOG_FILE_NM_NOW"
            firewall-cmd --list-all > f_p_tux_op_to_log 2>&1
            F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
            f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

            # NOTE: Log SELinux status. By Questor
            f_log_manager ">>> SELinux status. <<<" "$LOG_FILE_NM_NOW"
            sestatus > f_p_tux_op_to_log 2>&1
            F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
            f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"
        ;;
        *)
            f_log_manager "ERROR: Not implemented to your OS." "$LOG_FILE_NM_NOW"
        ;;
    esac

    # [Refs.: https://askubuntu.com/a/611646/134723 , 
    # https://serverfault.com/a/208355/276753 , 
    # https://unix.stackexchange.com/a/26639/61742 ]
    # NOTE: Log which users have root prerogative. By Questor
    # TIP: Only the root user can have this prerogative. By Questor
    f_log_manager ">>> Users with root prerogatives. <<<" "$LOG_FILE_NM_NOW"
    grep 'x:0:' /etc/passwd > f_p_tux_op_to_log 2>&1
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    # NOTE: Log users who can run commands as root. By Questor
    f_log_manager ">>> Users who can run commands as root. <<<" "$LOG_FILE_NM_NOW"

    # NOTE: The command "grep -v 'not allowed'" excludes all lines that contain the
    # value "not allowed" and the command "sed '$a\\'" adds an extra line break at
    # the end. By Questor
    # [Refs.: https://askubuntu.com/a/611607/134723 , 
    # https://askubuntu.com/a/611646/134723 , 
    # https://askubuntu.com/a/1208016/134723 , 
    # https://unix.stackexchange.com/a/26639/61742 ]
    if [ -z $(getent group sudo) ]; then printf "\n >>>>>>>>>>> NO ENTRIES <<<<<<<<<<<\n\n"; 
    else getent group sudo | 
    sed 's/.*://' | 
    sed 's/,/\n/g' | 
    xargs -L1 sudo -l -U | 
    grep -v 'not allowed' | 
    sed 's/Matching Defaults entries/\n >>>>>>>>>>> CAN RUN COMMANDS AS ROOT >>>>>>>>>>>\n\nMatching Defaults entries/g' | 
    sed '$a\\'; fi > f_p_tux_op_to_log 2>&1
    # cat f_p_tux_op_to_log
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    # NOTE: Log binaries that can be executed with root privileges. By Questor
    f_log_manager ">>> Binaries that can be executed with root privileges. <<<" "$LOG_FILE_NM_NOW"
    find / -path '/proc' -prune -o -perm -04000 -print > f_p_tux_op_to_log 2>&1
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    # NOTE: Update chkrootkit. By Questor
    f_log_manager ">>> Chkrootkit update started. <<<" "$LOG_FILE_NM_NOW"
    f_inst_or_up_chkrootkit 1 > f_p_tux_op_to_log 2>&1
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    # NOTE: Chkrootkit scan. By Questor
    f_log_manager ">>> Chkrootkit scan. <<<" "$LOG_FILE_NM_NOW"

    # NOTE: Avoid "not tested"/"can't exec" errors. By Questor
    cd /usr/local/chkrootkit

    # /usr/local/chkrootkit/chkrootkit -q
    /usr/local/chkrootkit/chkrootkit > $SCRIPTDIR_V/f_p_tux_op_to_log 2>&1
    cd "$SCRIPTDIR_V"

    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    # NOTE: Update Rkhunter signatures. By Questor
    f_log_manager ">>> Rkhunter signatures update started. <<<" "$LOG_FILE_NM_NOW"
    rkhunter --update --nocolors > f_p_tux_op_to_log 2>&1
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    # NOTE: Rkhunter scan. By Questor
    f_log_manager ">>> Rkhunter scan. <<<" "$LOG_FILE_NM_NOW"
    # rkhunter --check --nocolors --skip-keypress --report-warnings-only
    rkhunter --check --nocolors --skip-keypress > f_p_tux_op_to_log 2>&1
    F_P_TUX_OP_TO_LOG=$(cat f_p_tux_op_to_log)
    f_log_manager "$F_P_TUX_OP_TO_LOG" "$LOG_FILE_NM_NOW"

    # NOTE: Checks ended. By Questor
    f_log_manager ">>> Checks ended. <<<" "$LOG_FILE_NM_NOW"

    # NOTE: Send email notification with information. By Questor
    if [ ${SEND_MAIL_NOTIF_C} -eq 1 ] ; then
        f_sendmail
    fi

    # NOTE: Remove output file for stdout and stderr. By Questor
    rm -f "$SCRIPTDIR_V/f_p_tux_op_to_log"

    # NOTE: Delete all log files but the most recent "LOGS_KEEP_C" files. By Questor
    # [Ref.: https://stackoverflow.com/a/34862475/3223785 ]
    ls -tp /var/log/p_tux | grep -v '/$' | tail -n +$((LOGS_KEEP_C+1)) | xargs -d '\n' -r rm --

    # NOTE: Security routine ended. By Questor
    f_log_manager ">>> Security routine ended. <<<" "$LOG_FILE_NM_NOW"

}

# NOTE: Call p_tux (security routine) main function. By Questor
f_p_tux

exit 0
