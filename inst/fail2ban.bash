#!/bin/bash

# NOTE: Install and configure Fail2ban. By Questor
f_inst_fail2ban() {
    f_log_manager "Installation and configuration of Fail2ban has started." "$SCRIPTDIR_V/installation.log" 0 "" 1
    case "$DISTRO_TYPE" in
        RH)

            # NOTE: Checks whether the feature has already been installed to avoid
            # errors. By Questor
            f_pack_is_inst "fail2ban" "yum"
            if [ ${F_PACK_IS_INST_R} -eq 1 ] ; then
                f_open_section
                f_div_section
                f_yes_no "Apparently Fail2ban has already been installed and configured. Do you want to proceed?
 * If you never used this installer or never configured Fail2ban on this server answer \"y\"."
                if [ ${YES_NO_R} -eq 0 ] ; then
                    return 0
                fi
                f_close_section
            fi

            yum -y install epel-release
            yum -y install fail2ban
        ;;
        *)
            f_log_manager "ERROR: Not implemented to your OS." "$SCRIPTDIR_V/installation.log" 0 "" 0
            f_error_exit "Not implemented to your OS."
        ;;
    esac

    BANTIME_DEFAULT="3600"
    QUESTION_F="Inform default \"bantime\" value (seconds).
Use empty for \"$BANTIME_DEFAULT\" (one hour).
 * Time that a given IP will be banned (sshd \"jail\")."
    f_div_section
    f_get_usr_input "$QUESTION_F" 1
    QUESTION_F=""
    if [ -n "$GET_USR_INPUT_R" ] ; then
        BANTIME_DEFAULT=$GET_USR_INPUT_R
    fi

    FINDTIME_DEFAULT="600"
    QUESTION_F="Inform default \"findtime\" value (seconds).
Use empty for \"$FINDTIME_DEFAULT\" (ten minutes).
 * Time that login attempts (sshd \"jail\") must take place for an IP be banned."
    f_div_section
    f_get_usr_input "$QUESTION_F" 1
    QUESTION_F=""
    if [ -n "$GET_USR_INPUT_R" ] ; then
        FINDTIME_DEFAULT=$GET_USR_INPUT_R
    fi

    MAXRETRY_DEFAULT="6"
    QUESTION_F="Inform default \"maxretry\" value.
Use empty for \"$MAXRETRY_DEFAULT\".
 * How many login attempts (sshd \"jail\") must occur for an IP to be banned."
    f_div_section
    f_get_usr_input "$QUESTION_F" 1
    QUESTION_F=""
    if [ -n "$GET_USR_INPUT_R" ] ; then
        MAXRETRY_DEFAULT=$GET_USR_INPUT_R
    fi

    DEFAULT_ACTION="action_"
    OPT_ARR=("action_" "Ban only" "action_mw" "Ban and send an email reporting \"whois\" to the recipient at \"destemail\"" "action_mwl" "Ban and send an email reporting \"whois\" and relevant log lines to the recipient in \"destemail\"")
    f_div_section
    f_get_usr_input_mult "Default action when a \"jail\" (ban action) is triggered.
 * Recommended: use \"action_\" or empty for \"Ban only\"." OPT_ARR[@] 1
    if [ -n "$GET_USR_INPUT_MULT_R" ] ; then
        DEFAULT_ACTION=$GET_USR_INPUT_MULT_R
    fi

    if [[ "$DEFAULT_ACTION" != "action_" ]] ; then

        f_def_f2b_sender() {
            QUESTION_F="Inform \"sender\" (e.g. \"my_sender@my_domain.com\").
 * Email that will send the notification when a \"jail\" is triggered."
            f_div_section
            f_get_usr_input "$QUESTION_F"
            QUESTION_F=""
            SENDER=$GET_USR_INPUT_R
        }

        # NOTE: Retrieves the sender email from the file defined in "$GENERICSTABLE"
        # (Sendmail). Note that due to the way Sendmail is configured the Fail2ban
        # mail sender must be the same that was defined for Sendmail. If different
        # there is a risk of the email being rejected by the recipient. By Questor
        GENERICSTABLE="/etc/mail/genericstable"
        f_chk_fd_fl "$GENERICSTABLE" "f"
        if [ ${CHK_FD_FL_R} -eq 1 ] ; then
            MAIL_FROM=$(cat $GENERICSTABLE | grep "root ")
            MAIL_FROM=${MAIL_FROM#"root"}
            MAIL_FROM=$(echo $MAIL_FROM | sed 's/ *$//g')
            SENDER=$MAIL_FROM

            if [ ! -z "$SENDER" ]; then
            # NOTE: Check if de "$SENDER" value is empty. By Questor

                f_open_section
                f_div_section
                f_yes_no "Use \"$SENDER\" email as sender (\"sender\")?
 * If you chose to configure Sendmail using this installer answer \"y\"."
                if [ ${YES_NO_R} -eq 0 ] ; then
                    f_def_f2b_sender
                fi
                f_close_section
            fi

        else
            f_def_f2b_sender
        fi

        f_open_section
        f_div_section
        f_yes_no "Use \"$SEND_MAIL_DEST_C\" email as destinatary (\"destemail\") (\"y\" recommended)?"
        if [ ${YES_NO_R} -eq 1 ] ; then
            DESTEMAIL=$SEND_MAIL_DEST_C
        else
            QUESTION_F="Inform \"destemail\" (e.g. \"my_dest@my_domain.com\").
 * Email that will be notified when a \"jail\" is triggered."
            f_div_section
            f_get_usr_input "$QUESTION_F"
            QUESTION_F=""
            DESTEMAIL=$GET_USR_INPUT_R
        fi
        f_close_section

    else
        DESTEMAIL="my_dest@my_domain.com"
        SENDER="my_sender@my_domain.com"
    fi

    BANTIME_RECIDIVE="2w"
    QUESTION_F="Inform recidive \"bantime\" value (seconds).
Use empty for \"$BANTIME_RECIDIVE\" (2 weeks).
 * Time that a given IP will be banned for a long time."
    f_div_section
    f_get_usr_input "$QUESTION_F" 1
    QUESTION_F=""
    if [ -n "$GET_USR_INPUT_R" ] ; then
        BANTIME_RECIDIVE=$GET_USR_INPUT_R
    fi

    FINDTIME_RECIDIVE="1d"
    QUESTION_F="Inform recidive \"findtime\" value (seconds).
Use empty for \"$FINDTIME_RECIDIVE\" (one day).
 * Time that attempts against a \"jail\" must take place for an IP be banned for a long time."
    f_div_section
    f_get_usr_input "$QUESTION_F" 1
    QUESTION_F=""
    if [ -n "$GET_USR_INPUT_R" ] ; then
        FINDTIME_RECIDIVE=$GET_USR_INPUT_R
    fi

    MAXRETRY_RECIDIVE="3"
    QUESTION_F="Inform recidive \"maxretry\" value.
Use empty for \"$MAXRETRY_RECIDIVE\".
 * How many attempts against a \"jail\" must occur for an IP to be banned for a long time."
    f_div_section
    f_get_usr_input "$QUESTION_F" 1
    QUESTION_F=""
    if [ -n "$GET_USR_INPUT_R" ] ; then
        MAXRETRY_RECIDIVE=$GET_USR_INPUT_R
    fi

    f_ez_mv_bak "/etc/fail2ban/jail.local" "" 1 1 1
    echo "[DEFAULT]
bantime = $BANTIME_DEFAULT
findtime = $FINDTIME_DEFAULT
maxretry = $MAXRETRY_DEFAULT
destemail = $DESTEMAIL
sender = $SENDER
mta = sendmail
action = %($DEFAULT_ACTION)s

[sshd]
enabled = true

[recidive]
enabled = true
bantime = $BANTIME_RECIDIVE
findtime = $FINDTIME_RECIDIVE
maxretry = $MAXRETRY_RECIDIVE" > "/etc/fail2ban/jail.local"

    case "$DISTRO_TYPE" in
        RH)
            systemctl enable fail2ban.service
            systemctl restart fail2ban.service
        ;;
        *)
            f_log_manager "ERROR: Not implemented to your OS." "$SCRIPTDIR_V/installation.log" 0 "" 0
            f_error_exit "Not implemented to your OS."
        ;;
    esac

    f_log_manager "Fail2ban has been installed and configured." "$SCRIPTDIR_V/installation.log" 0 "" 1
}
