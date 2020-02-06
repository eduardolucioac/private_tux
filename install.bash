#!/bin/bash

# NOTE: Avoid problems with relative paths. By Questor
SCRIPTDIR_V="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPTDIR_V"

# IMAGE! IMAGE! IMAGE! IMAGE! IMAGE! IMAGE! https://lh3.googleusercontent.com/proxy/qwNgMbTs--e0FOfl94gTF7R7Iu-KvgipFawjQBSnPGCcdfAav-f5nTttKWEZsFdBYnhJyOGf2ZyWNS3h02JZFGoXkvYWYK-AEgqdwNcTDjhsEgVdpH-hqpVLmBM9

# NOTE: Load main library. By Questor
. $SCRIPTDIR_V/lib/ez_i.bash

# NOTE: Load configuration. By Questor
. $SCRIPTDIR_V/conf/conf.bash

# NOTE: Other useful scripts. By Questor
. $SCRIPTDIR_V/resrc/other.bash

# NOTE: Load Chrony intallation functionalities. By Questor
. $SCRIPTDIR_V/inst/chrony.bash

# NOTE: Load Sendmail intallation functionalities. By Questor
. $SCRIPTDIR_V/inst/sendmail.bash

# NOTE: Load Fail2ban intallation functionalities. By Questor
. $SCRIPTDIR_V/inst/fail2ban.bash

# NOTE: Load Chkrootkit intallation functionalities. By Questor
. $SCRIPTDIR_V/inst/chkrootkit.bash

# NOTE: Load Rkhunter intallation functionalities. By Questor
. $SCRIPTDIR_V/inst/rkhunter.bash

# > --------------------------------------------------------------------------
# BEGIN
# --------------------------------------

read -d '' TITLE_F <<"EOF"
Private Tux Installer
EOF

# NOTE: For versioning use "MAJOR.MINOR.REVISION.BUILDNUMBER". By Questor
# [Ref.: http://programmers.stackexchange.com/questions/24987/what-exactly-is-the-build-number-in-major-minor-buildnumber-revision ]

read -d '' VERSION_F <<"EOF"
0.0.1.0
EOF

read -d '' ABOUT_F <<"EOF"
This script will install Private Tux!
EOF

read -d '' WARNINGS_F <<"EOF"
- This installer is compatible with Centos 7.

- We RECOMMEND you...
    Install all the components (answer yes to everything) and use the default 
        values. Except contrary guidance!
    Check for previous installations! If there is previous 
        installations consider this variant in the process!

- We NOTICE you...
    This installer assumes that the target distribution has a "standard 
    setup".

- We WARNING you...
    THIS INSTALLER AND RESULTING PRODUCTS COMES WITH ABSOLUTELY NO WARRANTY! 
    USE AT YOUR OWN RISK! WE ARE NOT RESPONSIBLE FOR ANY DAMAGE TO YOURSELF, 
    HARDWARE, OR CO-WORKERS.
EOF

read -d '' COMPANY_F <<"EOF"
Eduardo Lúcio Amorim Costa
https://github.com/eduardolucioac/private_tux - Brasil-DF
Free software! Embrace that idea!
EOF

TUX=$(cat $SCRIPTDIR_V/tux.txt)
f_begin "$TITLE_F" "$VERSION_F" "$ABOUT_F$TUX" "$WARNINGS_F" "$COMPANY_F"
ABOUT_F=""
WARNINGS_F=""
if [ ${F_BEGIN_R} -eq 0 ] ; then
    f_enter_to_cont
fi

# < --------------------------------------------------------------------------

# NOTE: Check if the user is root. By Questor
f_is_root 1
if [ ${F_IS_ROOT_R} -eq 0 ] ; then
    f_log_manager "ERROR: You need to be root!" 0 "" 0
    f_error_exit "You need to be root!"
fi

# > --------------------------------------------------------------------------
# TERMS AND LICENSE
# --------------------------------------

TERMS_LICEN_F=$(cat $SCRIPTDIR_V/LICENSE.txt)
f_terms_licen "$TERMS_LICEN_F"
TERMS_LICEN_F=""


# NOTE: Remove old logs. By Questor
rm -f "$SCRIPTDIR_V/installation.log"

f_log_manager "You have accepted the Private_Tux license." "$SCRIPTDIR_V/installation.log" 0 "" 1

# < --------------------------------------------------------------------------

# NOTE: Check distro name, version, etc... By Questor
f_chk_distro

# > --------------------------------------------------------------------------
# INSTRUCTIONS
# --------------------------------------

read -d '' INSTRUCT_F <<"EOF"

Private Tux consists of two parts an INSTALLER and a SECURITY ROUTINE.

The INSTALLER will prepare the server and will install and/or configure some components include these:

 . Chrony - Chrony is a versatile implementation of the Network Time Protocol (NTP);
    URL: https://chrony.tuxfamily.org/
 . Sendmail - E-mail routing feature for general purpose networks;
    URL: https://www.proofpoint.com/us/products/open-source-email-solution
 . Fail2ban - Intrusion prevention software framework that protects servers against brute force attacks;
    URL: https://www.fail2ban.org/wiki/index.php/Main_Page
 . Chkrootkit - Unix-based program intended to help system administrators check their system for known rootkits;
    URL: http://www.chkrootkit.org/
 . Rkhunter - Unix-based tool that scans for rootkits, backdoors and possible local exploits.
    URL: https://sourceforge.net/projects/rkhunter/

The SECURITY ROUTINE (p_tux.bash) must be scheduled in crontab (a time-based job scheduler, https://crontab.guru/ ) to run (preferably) once a day.

All installer and security routine settings are in the conf.bash file.

The Fail2ban component works independently (including e-mail notifications) and will be configured to monitor (\"jail\") "sshd" ( https://www.ssh.com/ssh/sshd ). The others components will be used by the security routine.

To cancel installation at any time use Ctrl+c.

EOF

f_instruct "$INSTRUCT_F"
INSTRUCT_F=""
if [ ${F_INSTRUCT_R} -eq 0 ] ; then
    f_enter_to_cont
fi

# < --------------------------------------------------------------------------

# > --------------------------------------------------------------------------
# INSTALL COMPONENTS
# > -----------------------------------------

# NOTE: Define a specific name for your server. By Questor
f_set_host_name() {
    if [[ "$(hostname)" == "localhost.localdomain" ]] ; then
        f_open_section
        f_div_section
        f_yes_no "Apparently there is no defined a specific name for this server.
(your server name: \"$(hostname)\")
 * A specific name is important, among other things, for automatic e-mail notifications."
        if [ ${YES_NO_R} -eq 1 ] ; then
            QUESTION_F="Inform a new server name (e.g. \"my_server.my_domain.com\")."
            f_div_section
            f_get_usr_input "$QUESTION_F"
            QUESTION_F=""
            case "$DISTRO_TYPE" in
                RH)
                    # Refs.: https://support.rackspace.com/how-to/centos-hostname-change/ , 
                    # https://phoenixnap.com/kb/how-to-set-or-change-a-hostname-in-centos-7 , 
                    # https://www.cyberciti.biz/faq/rhel-redhat-centos-7-change-hostname-command/ ]
                    echo "127.0.0.1   $GET_USR_INPUT_R" | tee -a /etc/hosts > /dev/null 2>&1
                    echo "HOSTNAME=$GET_USR_INPUT_R" | tee -a /etc/sysconfig/network > /dev/null 2>&1
                    hostnamectl set-hostname "$GET_USR_INPUT_R" --static
                    systemctl restart network.service
                ;;
                *)
                    f_log_manager "ERROR: Not implemented to your OS." "$SCRIPTDIR_V/installation.log" 0 "" 0
                    f_error_exit "Not implemented to your OS."
                ;;
            esac
        fi
        f_close_section
    fi
}

# NOTE: Configuration a crontab schedule (job) to the Security Routine (p_tux.bash). By Questor
f_set_crontab() {
    f_log_manager "Configuration of crontab schedule (job) to Security the Routine (p_tux.bash) has started." "$SCRIPTDIR_V/installation.log" 0 "" 1

    # NOTE: Check if there is already a schedule defined in Crontab for the Security Routine (p_tux.bash). By Questor
    if [[ "$(crontab -l)" == *"/usr/local/private_tux/p_tux.bash"* ]] ; then
        f_open_section
        f_div_section
        f_yes_no "Apparently there is already a schedule (job) for the Security Routine (p_tux.bash) in Crontab. Continue?"
        f_close_section
        if [ ${YES_NO_R} -eq 0 ] ; then
            return 0
        fi
    fi

    clear
    f_enter_to_cont "Now we are going to schedule (job) your Security Routine (p_tux.bash):
 I - The routine will be executed daily once at the time that will be defined in the next step;
 II - If you have many servers on your network and/or hypervisors it may be interesting for you to choose the option \"r\" in the next step, so that the installer will choose a random time value for you between 00:00 AM and 04:59 AM. In this way, we use probability to prevent all servers from starting the security routine at the same time."
    SCHEDULE_MODE=""
    OPT_ARR=("i" "I will set the schedule (job)." "r" "I will let the installer automatically schedule (job) for me (randomly).")
    f_div_section
    f_get_usr_input_mult "How will you define your schedule (job)?" OPT_ARR[@]
    if [ -n "$GET_USR_INPUT_MULT_R" ] ; then
        SCHEDULE_MODE=$GET_USR_INPUT_MULT_R
    fi
    SCHED_HOUR=""
    SCHED_MIN=""
    case "$SCHEDULE_MODE" in
        i)
            QUESTION_F="Enter the schedule (job) time (0~23, e.g. 23:47, 00:01, 02:13...)."
            f_div_section
            f_get_usr_input "$QUESTION_F"
            QUESTION_F=""
            # [Ref.: https://stackoverflow.com/a/29903172/3223785 ]
            SCHED_HOUR=$(echo "$GET_USR_INPUT_R" | cut -d ":" -f 1)
            SCHED_MIN=$(echo "$GET_USR_INPUT_R" | cut -d ":" -f 2)
        ;;
        r)

            # NOTE: Scheduling time (job) automatically (randomly). By Questor
            SCHED_HOUR="0$(( RANDOM % 5 ))"
            SCHED_HOUR=${SCHED_HOUR: -2}
            SCHED_MIN="0$(( RANDOM % 60 ))"
            SCHED_MIN=${SCHED_MIN: -2}
            f_open_section
            f_div_section
            f_set_r_schedule() {
                f_yes_no "Is this scheduling time (job) good for you ($SCHED_HOUR:$SCHED_MIN)?"
                if [ ${YES_NO_R} -eq 0 ] ; then
                    SCHED_HOUR="0$(( RANDOM % 5 ))"
                    SCHED_HOUR=${SCHED_HOUR: -2}
                    SCHED_MIN="0$(( RANDOM % 60 ))"
                    SCHED_MIN=${SCHED_MIN: -2}
                    f_set_r_schedule
                fi
            }
            f_set_r_schedule
            f_close_section

        ;;
        *)
            f_log_manager "ERROR: Not implemented to your OS." "$SCRIPTDIR_V/installation.log" 0 "" 0
            f_error_exit "Not implemented to your OS."
        ;;
    esac

    # [Refs.: https://stackoverflow.com/a/9625233/3223785 , 
    # https://unix.stackexchange.com/a/487604/61742 , 
    # https://linuxize.com/post/scheduling-cron-jobs-with-crontab/ , 
    # https://stackoverflow.com/q/2388087/3223785 ]
    (crontab -l 2>/dev/null; printf "PATH=$PATH\n$SCHED_MIN $SCHED_HOUR * * * /usr/local/private_tux/p_tux.bash\n") | crontab -
    f_log_manager "Configuration of crontab schedule has been done." "$SCRIPTDIR_V/installation.log" 0 "" 1

}

# NOTE: Set the destinatary of the e-mail notifications. By Questor
f_set_dest() {
    QUESTION_F="Inform the destinatary of the e-mail notifications (e.g. \"my_dest@my_domain.com\").
* E-mail that will receive notifications of Private_Tux's components."
    f_div_section
    f_get_usr_input "$QUESTION_F"
    QUESTION_F=""

    # NOTE: Updates the variable's value in memory! By Questor
    SEND_MAIL_DEST_C=$GET_USR_INPUT_R

    f_power_sed_ecp "\"$GET_USR_INPUT_R\"" 1
    TARGET_ITEM="SEND_MAIL_DEST_C=.*"
    REPLACE_ITEM="SEND_MAIL_DEST_C=$F_POWER_SED_ECP_R"

    # NOTE: Replace the entire line. By Questor
    SED_CMD="'0,/$TARGET_ITEM/s//$REPLACE_ITEM/g'"

    eval "sed -i $SED_CMD $SCRIPTDIR_V/conf/conf.bash"
    # [Ref.: https://stackoverflow.com/a/8822211/3223785 ]
    f_log_manager "The destinatary of the e-mail notifications has been set at \"./conf/conf.bash\" configuration file." "$SCRIPTDIR_V/installation.log" 0 "" 1
}

# NOTE: Update your system and install some dependencies. By Questor
f_update_n_inst_other() {
    f_chk_by_path_hlp "/usr/local/private_tux" "d"
    if [ ${F_CHK_BY_PATH_HLP_R} -eq 1 ] ; then
        f_open_section
        f_div_section
        f_yes_no "Private_Tux already installed in \"/usr/local/private_tux\". Reinstall it?
 * IMPORTANT: All Private_Tux settings (conf.bash) will be lost."
        f_close_section
        if [ ${YES_NO_R} -eq 0 ] ; then
            f_log_manager "Installation and configuration of Private_Tux has canceled." "$SCRIPTDIR_V/installation.log" 0 "" 1
            exit 0
        else
            rm -rf "/usr/local/private_tux"
        fi
    fi
    f_log_manager "Installation and configuration of Private_Tux has started." "$SCRIPTDIR_V/installation.log" 0 "" 1
    case "$DISTRO_TYPE" in
        RH)
            yum -y update
            yum -y install net-tools
        ;;
        *)
            f_log_manager "ERROR: Not implemented to your OS." "$SCRIPTDIR_V/installation.log" 0 "" 0
            f_error_exit "Not implemented to your OS."
        ;;
    esac

    f_set_host_name

    f_open_section
    f_div_section
    f_yes_no "Install Chrony and synchronise (NTP servers) the system clock (\"y\" recommended)?"
    if [ ${YES_NO_R} -eq 1 ] ; then
        f_inst_chrony
    fi
    f_close_section

    f_set_dest

    f_open_section
    f_div_section
    f_yes_no "Install Sendmail (\"y\" recommended)?"
    if [ ${YES_NO_R} -eq 1 ] ; then
        f_inst_sendmail
    fi
    f_close_section

    f_open_section
    f_div_section
    f_yes_no "Install Fail2ban (\"y\" recommended)?"
    if [ ${YES_NO_R} -eq 1 ] ; then
        f_inst_fail2ban
    fi
    f_close_section

    f_open_section
    f_div_section
    f_yes_no "Install Chkrootkit (\"y\" recommended)?"
    if [ ${YES_NO_R} -eq 1 ] ; then
        f_inst_or_up_chkrootkit 0
    fi
    f_close_section

    f_open_section
    f_div_section
    f_yes_no "Install Rkhunter (\"y\" recommended)?"
    if [ ${YES_NO_R} -eq 1 ] ; then
        f_inst_rkhunter
    fi
    f_close_section

    f_open_section
    f_div_section
    f_yes_no "Set a Crontab schedule for the Security Routine (p_tux.bash) (\"y\" recommended)?
 * The routine will be executed daily once at the time that will be defined.
 * If you choose not, you will have to set the schedule (crontab or other) later."
    if [ ${YES_NO_R} -eq 1 ] ; then
        f_set_crontab
    fi
    f_close_section

    # TODO: Copying Private_Tux's components to the \"/usr/local/private_tux\" folder. By Questor
    mkdir "/usr/local/private_tux"
    cp -v "$SCRIPTDIR_V/LICENSE.txt" "/usr/local/private_tux/"
    cp -v "$SCRIPTDIR_V/p_tux.bash" "/usr/local/private_tux/"
    cp -v "$SCRIPTDIR_V/README.md" "/usr/local/private_tux/"

    # NOTE: Check if the folder exists. Note that this folder will exist whenever
    # Chkrootkit is installed. By Questor
    f_chk_fd_fl "$SCRIPTDIR_V/pack" "d"
    if [ ${CHK_FD_FL_R} -eq 1 ] ; then
        cp -vr "$SCRIPTDIR_V/pack" "/usr/local/private_tux/"
    fi

    mkdir "/usr/local/private_tux/inst"
    cp -v "$SCRIPTDIR_V/inst/chkrootkit.bash" "/usr/local/private_tux/inst/"
    mkdir "/usr/local/private_tux/conf"
    cp -v "$SCRIPTDIR_V/conf/conf.bash" "/usr/local/private_tux/conf/"
    mkdir "/usr/local/private_tux/lib"
    cp -v "$SCRIPTDIR_V/lib/ez_i.bash" "/usr/local/private_tux/lib/"
    mkdir "/usr/local/private_tux/resrc"
    cp -v "$SCRIPTDIR_V/resrc/other.bash" "/usr/local/private_tux/resrc/"

    chmod u+x "/usr/local/private_tux/p_tux.bash"

    # NOTE: To improve aesthetics in the terminal output. By Questor
    echo ""

    f_open_section
    f_log_manager "The \"/usr/local/private_tux/p_tux.bash\" file is defined as executable." "$SCRIPTDIR_V/installation.log" 0 "" 1
    f_div_section
    f_log_manager "Private_Tux's components are installed in the \"/usr/local/private_tux\" folder." "$SCRIPTDIR_V/installation.log" 0 "" 1
}

f_open_section
f_div_section
f_yes_no "Install Private_Tux?
 * Your system will be updated and some dependencies will be installed and/or configured."
if [ ${YES_NO_R} -eq 1 ] ; then
    f_update_n_inst_other
else
    f_div_section
    f_log_manager "Installation canceled." "$SCRIPTDIR_V/installation.log" 0 "" 1
    f_close_section
    exit 0
fi
f_close_section

# < --------------------------------------------------------------------------

# > --------------------------------------------------------------------------
# FINAL
# --------------------------------------

read -d '' TITLE_F <<"EOF"
Installer finished! Thanks!
EOF

USEFUL_INFO_F="To configure the security routine (p_tux.bash)...
    vi $SCRIPTDIR_V/conf/conf.bash

Installation Log...
    vi $SCRIPTDIR_V/installation.log

Security routine (p_tux.bash)...
    /usr/local/private_tux/p_tux.bash

Security routine (p_tux.bash) logs...
    /var/log/p_tux/*"

f_end "$TITLE_F" "$USEFUL_INFO_F"
echo ""
TITLE_F=""
USEFUL_INFO_F=""

# < --------------------------------------------------------------------------

exit 0
