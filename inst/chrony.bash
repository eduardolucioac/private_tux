#!/bin/bash

# NOTE: Install Chrony. By Questor
f_inst_chrony() {
    f_log_manager "Installation of Chrony has started." "$SCRIPTDIR_V/installation.log" 0 "" 1
    case "$DISTRO_TYPE" in
        RH)

            # NOTE: Checks whether the feature has already been installed to avoid
            # errors. By Questor
            f_pack_is_inst "chrony" "yum"
            if [ ${F_PACK_IS_INST_R} -eq 1 ] ; then
                f_open_section
                f_div_section
                f_yes_no "Apparently Chrony has already been installed and configured. Do you want to proceed?
 * If you never used this installer or never configured Chrony on this server answer \"y\"."
                if [ ${YES_NO_R} -eq 0 ] ; then
                    return 0
                fi
                f_close_section
            fi
            yum -y install chrony
            clear
            f_enter_to_cont "Now we are going to LIST ALL TIMEZONES AVAILABLE for your system.
 * MAKE A NOTE OF YOUR TIMEZONE as it will be needed in the next step."
            f_print_long_str "$(timedatectl list-timezones)"
            QUESTION_F="Inform your TIMEZONE (e.g. \"America/Sao_Paulo\")."
            f_div_section
            f_get_usr_input "$QUESTION_F"
            QUESTION_F=""
            timedatectl set-timezone $GET_USR_INPUT_R
            firewall-cmd --add-service=ntp --permanent
            firewall-cmd --reload
            systemctl enable chronyd.service
            systemctl start chronyd.service
            chronyc -a "burst 3/5"
            chronyc makestep 1 -1
        ;;
        *)
            f_log_manager "ERROR: Not implemented to your OS." "$SCRIPTDIR_V/installation.log" 0 "" 0
            f_error_exit "Not implemented to your OS."
        ;;
    esac
    f_log_manager "Chrony has been installed and your system clock is synchronized." "$SCRIPTDIR_V/installation.log" 0 "" 1
}
