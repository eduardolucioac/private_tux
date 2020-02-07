#!/bin/bash

# NOTE: Install and configure Sendmail. By Questor
f_inst_sendmail() {
    f_log_manager "Installation and configuration of Sendmail has started." "$SCRIPTDIR_V/installation.log" 0 "" 1
    SENDMAIL_MC=""
    ETC_MAIL=""
    AUTHINFO=""
    GENERICSTABLE=""
    case "$DISTRO_TYPE" in
        RH)

            # NOTE: Checks whether the feature has already been installed to avoid
            # errors. By Questor
            f_pack_is_inst "sendmail-cf" "yum"
            if [ ${F_PACK_IS_INST_R} -eq 1 ] ; then
                f_open_section
                f_div_section
                f_yes_no "Apparently Sendmail has already been installed and configured. Do you want to proceed?
 * If you never used this installer or never configured Sendmail on this server answer \"y\"."
                if [ ${YES_NO_R} -eq 0 ] ; then
                    return 0
                fi
                f_close_section
            fi

            SENDMAIL_MC="/etc/mail/sendmail.mc"
            ETC_MAIL="/etc/mail"
            AUTHINFO="/etc/mail/authinfo"
            GENERICSTABLE="/etc/mail/genericstable"
            yum -y install sendmail-cf
            yum -y install cyrus-sasl-plain
        ;;
        *)
            f_log_manager "ERROR: Not implemented to your OS." "$SCRIPTDIR_V/installation.log" 0 "" 0
            f_error_exit "Not implemented to your OS."
        ;;
    esac

    QUESTION_F="Inform your smtp SERVER (e.g. \"smtp.my_domain.com\")."
    f_div_section
    f_get_usr_input "$QUESTION_F"
    QUESTION_F=""
    SMTP_SERVER=$GET_USR_INPUT_R

    SMTP_PORT="587"
    QUESTION_F="Inform your smtp server PORT.
Use empty for \"$SMTP_PORT\"."
    f_div_section
    f_get_usr_input "$QUESTION_F" 1
    QUESTION_F=""
    if [ -n "$GET_USR_INPUT_R" ] ; then
        SMTP_PORT=$GET_USR_INPUT_R
    fi

    QUESTION_F="Inform your smtp server USER/SENDER (e.g. \"my_user@my_domain.com\")."
    f_div_section
    f_get_usr_input "$QUESTION_F"
    QUESTION_F=""
    SMTP_SRV_USR=$GET_USR_INPUT_R

    QUESTION_F="Inform your smtp server user/sender PASSWORD."
    f_div_section
    f_get_usr_input "$QUESTION_F" 0 1
    QUESTION_F=""
    SMTP_SRV_PWD=$GET_USR_INPUT_R

    # [Ref.: https://unix.stackexchange.com/a/473493/61742 ]
    # NOTE: Splitting string by the first occurrence of a delimiter. By Questor
    SMTP_DOMAIN=${SMTP_SERVER#*.}

    QUESTION_F="Inform your domain (e.g. \"my_domain.com\").
Use empty for \"$SMTP_DOMAIN\"."
    f_div_section
    f_get_usr_input "$QUESTION_F" 1
    QUESTION_F=""
    if [ -n "$GET_USR_INPUT_R" ] ; then
        SMTP_DOMAIN=$GET_USR_INPUT_R
    fi

    f_ez_mv_bak "$AUTHINFO" "" 1 1 1
    AUTHINFO_CONT="AuthInfo:$SMTP_SERVER \"U:root\" \"I:$SMTP_SRV_USR\" \"P:$SMTP_SRV_PWD\""
    eval "echo '$AUTHINFO_CONT' > $AUTHINFO"

    f_ez_mv_bak "$GENERICSTABLE" "" 1 1 1
    GENERICSTABLE_CONT="root           $SMTP_SRV_USR"
    eval "echo '$GENERICSTABLE_CONT' > $GENERICSTABLE"

    f_ez_mv_bak "$SENDMAIL_MC" "" 1 1 1
    # NOTE: The "\" before "`" and "$" will prevent shell execution and expansion
    # respectively. By Questor
    f_power_sed "MAILER(smtp)dnl" "define(\`SMART_HOST', \`$SMTP_SERVER')dnl
define(\`RELAY_MAILER_ARGS', \`TCP \$h $SMTP_PORT')dnl
define(\`ESMTP_MAILER_ARGS', \`TCP \$h $SMTP_PORT')dnl
define(\`confAUTH_OPTIONS', \`A p')dnl
TRUST_AUTH_MECH(\`EXTERNAL DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
define(\`confAUTH_MECHANISMS', \`EXTERNAL GSSAPI DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
FEATURE(\`authinfo', \`hash -o /etc/mail/authinfo.db')dnl
MASQUERADE_AS(lightbase.com.br)dnl
FEATURE(masquerade_envelope)dnl
FEATURE(masquerade_entire_domain)dnl
MASQUERADE_DOMAIN($SMTP_DOMAIN)dnl
FEATURE(\`genericstable',\`hash -o /etc/mail/genericstable.db')dnl
MAILER(smtp)dnl" "$SENDMAIL_MC"

    eval "make -C $ETC_MAIL"
    case "$DISTRO_TYPE" in
        RH)
            systemctl enable sendmail.service
            systemctl restart sendmail.service
        ;;
        *)
            f_log_manager "ERROR: Not implemented to your OS." "$SCRIPTDIR_V/installation.log" 0 "" 0
            f_error_exit "Not implemented to your OS."
        ;;
    esac
    f_log_manager "Sendmail has been installed and configured." "$SCRIPTDIR_V/installation.log" 0 "" 1
}
