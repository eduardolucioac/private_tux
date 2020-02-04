#!/bin/bash

# NOTE: Install Rkhunter. By Questor
f_inst_rkhunter() {
    f_log_manager "Installation of Rkhunter has started." "$SCRIPTDIR_V/installation.log" 0 "" 1
    case "$DISTRO_TYPE" in
        RH)

            # NOTE: Checks whether the feature has already been installed to avoid
            # errors. By Questor
            f_pack_is_inst "rkhunter" "yum"
            if [ ${F_PACK_IS_INST_R} -eq 1 ] ; then
                f_open_section
                f_div_section
                f_yes_no "Apparently Rkhunter has already been installed. Do you want to proceed?
 * If you never used this installer or never configured Rkhunter on this server answer \"y\"."
                if [ ${YES_NO_R} -eq 0 ] ; then
                    return 0
                fi
                f_close_section
            fi

            yum -y install epel-release
            yum -y install rkhunter

            # NOTE: Update your system file properties. By Questor
            rkhunter --update

            # NOTE: Looks for various data updates. By Questor
            rkhunter --propupd

            # [Ref.: https://sourceforge.net/p/rkhunter/wiki/propupd/ ]
        ;;
        *)
            f_log_manager "ERROR: Not implemented to your OS." "$SCRIPTDIR_V/installation.log" 0 "" 0
            f_error_exit "Not implemented to your OS."
        ;;
    esac
    f_log_manager "Rkhunter has been installed." "$SCRIPTDIR_V/installation.log" 0 "" 1
}
