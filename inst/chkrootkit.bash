#!/bin/bash

# NOTE: Install or update Chkrootkit. By Questor
f_inst_or_up_chkrootkit() {

    # NOTE: Defines the mode in which the f_inst_or_up_chkrootkit will operate.
    # Interactive (0) or automatic (1). Automatic will be used by the Security
    # Routine (p_tux.bash). By Questor
    I_OR_UP_CHKR_MODE=$1

    if [ ${I_OR_UP_CHKR_MODE} -eq 0 ] ; then
        f_log_manager "Installation or update of Chkrootkit has started." "$SCRIPTDIR_V/installation.log" 0 "" 1
    else
        echo "Installation or update of Chkrootkit has started."
    fi
    CRKIT_INST_UPDT=0
    if [ ${I_OR_UP_CHKR_MODE} -eq 0 ] ; then
        f_log_manager "Downloading Chkrootkit from address $CRKIT_URL_C ." "$SCRIPTDIR_V/installation.log" 0 "" 1
    else
        echo "Downloading Chkrootkit from address $CRKIT_URL_C ."
    fi
    curl -Sso "/tmp/$CRKIT_FL_NM_C" "$CRKIT_URL_C"
    f_chk_fd_fl "/tmp/$CRKIT_FL_NM_C" "f"
    if [ ${CHK_FD_FL_R} -eq 0 ] ; then
        if [ ${I_OR_UP_CHKR_MODE} -eq 0 ] ; then
            f_log_manager "ERROR: Could not download Chkrootkit from address $CRKIT_URL_C ." "$SCRIPTDIR_V/installation.log" 0 "" 0
            f_error_exit "Could not download Chkrootkit from address $CRKIT_URL_C ."
        else
            # [Ref.: https://stackoverflow.com/a/18042300/3223785 ]
            echo "ERROR: Could not download Chkrootkit from address $CRKIT_URL_C ."
            return 1
        fi
    fi
    f_chk_fd_fl "$SCRIPTDIR_V/pack/$CRKIT_FL_NM_C" "f"
    if [ ${CHK_FD_FL_R} -eq 0 ] ; then
        if [ ${I_OR_UP_CHKR_MODE} -eq 0 ] ; then
            f_log_manager "Installing Chkrootkit." "$SCRIPTDIR_V/installation.log" 0 "" 1
        else
            echo "Installing Chkrootkit."
        fi
        CRKIT_INST_UPDT=1
    else
        CURRENT_MD5=$(eval "md5sum \"$SCRIPTDIR_V/pack/$CRKIT_FL_NM_C\" | cut -d ' ' -f 1")
        NEW_MD5=$(eval "md5sum \"/tmp/$CRKIT_FL_NM_C\" | cut -d ' ' -f 1")
        if [ "$NEW_MD5" != "$CURRENT_MD5" ]; then
            if [ ${I_OR_UP_CHKR_MODE} -eq 0 ] ; then
                f_log_manager "Updating Chkrootkit." "$SCRIPTDIR_V/installation.log" 0 "" 1
            else
                echo "Updating Chkrootkit."
            fi
            CRKIT_INST_UPDT=2
        else
            if [ ${I_OR_UP_CHKR_MODE} -eq 0 ] ; then
                f_log_manager "Chkrootkit is up to date." "$SCRIPTDIR_V/installation.log" 0 "" 1
            else
                echo "Chkrootkit is up to date."
            fi
            rm -f "/tmp/$CRKIT_FL_NM_C"
        fi
    fi
    if [ ${CRKIT_INST_UPDT} -gt 0 ] ; then
        case "$DISTRO_TYPE" in
            RH)
                if [ ${CRKIT_INST_UPDT} -eq 1 ] ; then
                    yum -y install gcc-c++
                    yum -y install glibc-static
                fi
            ;;
            *)
                rm -f "/tmp/$CRKIT_FL_NM_C"
                if [ ${I_OR_UP_CHKR_MODE} -eq 0 ] ; then
                    f_log_manager "ERROR: Not implemented to your OS." "$SCRIPTDIR_V/installation.log" 0 "" 0
                    f_error_exit "Not implemented to your OS."
                else
                    echo "ERROR: Not implemented to your OS."
                fi
            ;;
        esac
        if [ ${CRKIT_INST_UPDT} -gt 1 ] ; then
            rm -f "$SCRIPTDIR_V/pack/$CRKIT_FL_NM_C"
            rm -rf "/usr/local/chkrootkit"
        fi

        # NOTE: Check if the folder exists. Note that this folder will exist Whenever
        # Chkrootkit is being UPDATED. By Questor
        f_chk_fd_fl "$SCRIPTDIR_V/pack" "d"
        if [ ${CHK_FD_FL_R} -eq 0 ] ; then
            mkdir -p "$SCRIPTDIR_V/pack"
        fi

        mv "/tmp/$CRKIT_FL_NM_C" "$SCRIPTDIR_V/pack/$CRKIT_FL_NM_C"
        cd "$SCRIPTDIR_V/pack"
        tar -zxvf "$CRKIT_FL_NM_C"
        rm -rf "/usr/local/chkrootkit"
        mv "$SCRIPTDIR_V/pack/$CRKIT_FL_NM_PREF_C"* "/usr/local/chkrootkit"
        cd "/usr/local/chkrootkit"
        make sense
        cd "$SCRIPTDIR_V"
        if [ ${CRKIT_INST_UPDT} -gt 1 ] ; then
            if [ ${I_OR_UP_CHKR_MODE} -eq 0 ] ; then
                f_log_manager "Chkrootkit has been updated." "$SCRIPTDIR_V/installation.log" 0 "" 1
            else
                echo "Chkrootkit has been updated."
            fi
        else
            if [ ${I_OR_UP_CHKR_MODE} -eq 0 ] ; then
                f_log_manager "Chkrootkit has been installed." "$SCRIPTDIR_V/installation.log" 0 "" 1
            else
                echo "Chkrootkit has been installed."
            fi
        fi
    fi
    # [Ref.: https://askubuntu.com/a/685780/134723 ]
}
