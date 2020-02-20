Private_Tux - Linux Security Utility
=============

What is Private_Tux?
-----

<img border="0" alt="Private_Tux" src="https://helpdev.com.br/wp-content/uploads/2013/06/hard-tux.png" height="30%" width="30%"/>Private_Tux

Private_Tux is a Linux security utility that aims to facilitate the installation, configuration and use of some useful components for security and/or auditing, facilitating the investigation and detection of possible threats and risks.

Private_Tux is basically composed of two parts. The first is intended to prepare the OS and install and configure some components for security and/or auditing and the second is intended to update the OS and automate the use of security and/or auditing components through a security routine (bash).

After installed and configured ("install.bash"), Private_Tux will be run daily using a security routine ("p_tux.bash") that will do several checks on your OS and generate various security and/or audit information to be sent via e-mail and recorded in log files. In addition, the log file for each daily operation is sent as a compressed attachment.

The entire scheme of installation, configuration and use of components for security and/or auditing is automatic, friendly and configurable.

Currently Private_Tux is only compatible with CentOS 7, however adjusting it to work with other distros will be simple.

Here are some components used by Private_Tux...

 * Fail2ban - Intrusion prevention software structure that protects servers against brute force attacks (URL: https://www.fail2ban.org/wiki/index.php/Main_Page );
 * Chkrootkit - Unix-based program designed to help system administrators check their system for known rootkits (URL: http://www.chkrootkit.org/ );
 * Rkhunter - Unix-based tool that checks for rootkits, backdoors and possible local exploits (URL: https://sourceforge.net/projects/rkhunter/ );
 * Ez_i - A library (in fact, a bash script) that provides several interesting features for creating interactive bash scripts (URL: https://github.com/eduardolucioac/ez_i ).

... in addition to chrony, sendmail, netstat, lastlog, last, firewalld, status (SELinux), getent and other interesting components and techniques.

Install Private Tux on CentOS 7 (example/demo)
-----

Download and start the Private_Tux installer...

```
yum -y install git-core
cd /usr/local/src
git clone https://github.com/eduardolucioac/private_tux.git
cd private_tux
bash install.bash
```

In the excerpt...

```
[ NAVIGATE: ↓ down arrow | ↑ up arrow | ⇟ page down | ⇞ page up | ↕ mouse wheel ]
[ CONTINUE: q ]
> ------------------------------------------------
Private Tux Installer (0.0.1.0)
----------------------------------

  > ABOUT:

    This script will install Private Tux!
    
      .~.  Have fun! =D
      /V\  
     // \\ Tux
    /(   )\
     ^`~'^ 

  > WARNINGS:

    - This installer is compatible with Centos 7.
[...]
```

... read the introductions and proceed by pressing "q".

In the excerpt...

```
[ NAVIGATE: ↓ down arrow | ↑ up arrow | ⇟ page down | ⇞ page up | ↕ mouse wheel ]
[ CONTINUE: q ]
> ------------------------------------------------
LICENSE/TERMS:
----------------------------------

  BSD 3-Clause License
  
  Copyright (c) 2019, Eduardo Lúcio Amorim Costa
  All rights reserved.
  
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  
  1. Redistributions of source code must retain the above copyright notice, this
     list of conditions and the following disclaimer.
  
  2. Redistributions in binary form must reproduce the above copyright notice,
     this list of conditions and the following disclaimer in the documentation
[...]
```

... read the license (BSD 3-Clause License) and proceed by pressing "q".

In the excerpt...

```
[...]
----------------------------------
BY ANSWERING YES (y) YOU WILL AGREE WITH TERMS AND CONDITIONS PRESENTED! PROCEED? (y/n) 
[...]
```

... inform that you have read and accepted the license by pressing "y" (if you agree with the license, of course).

In the excerpt...

```
[ NAVIGATE: ↓ down arrow | ↑ up arrow | ⇟ page down | ⇞ page up | ↕ mouse wheel ]
[ CONTINUE: q ]
> ------------------------------------------------
INSTRUCTIONS:
----------------------------------

  Private_Tux consists of two parts an INSTALLER and a SECURITY ROUTINE.
  
  The INSTALLER will prepare the server and will install and/or configure some components include these:
  
   . Chrony - Chrony is a versatile implementation of the Network Time Protocol (NTP);
      URL: https://chrony.tuxfamily.org/
   . Sendmail - E-mail routing feature for general purpose networks;
      URL: https://www.proofpoint.com/us/products/open-source-email-solution
   . Fail2ban - Intrusion prevention software framework that protects servers against brute force attacks;
      URL: https://www.fail2ban.org/wiki/index.php/Main_Page
[...]
```

... read the instructions and proceed by pressing "q".

In the excerpt...

```
> ------------------------------------------------
----------------------------------
Install Private_Tux?
 * Your system will be updated and some dependencies will be installed and/or configured. (y/n) 
```

... enter "y" to start the installation.

**Enter a specific name for the server**
  
  In the excerpt...

```
[...]
> ------------------------------------------------
----------------------------------
Apparently there is no defined a specific name for this server.
(your server name: "localhost.localdomain")
 * A specific name is important, among other things, for automatic e-mail notifications. (y/n)
```

... enter "y" to define a specific name for your server.

Enter a specific name for your server...

```
[...]
----------------------------------
Inform a new server name (e.g. "my_server.my_domain.com").
 (use enter to confirm): 
```

**TIPS:** In general, server names can be defined following these rules/guidelines...
 * 64 characters maximum length;
 * Be an FQDN;
 * Consist only of the following characters a-z, A-Z, 0-9, '-', '_' and '.'.
 
**Chrony installation**

Install Chrony to keep your server's clock set and synchronized...

```
> ------------------------------------------------
----------------------------------
Install Chrony and synchronise (NTP servers) the system clock ("y" recommended)? (y/n) 
```

... by entering "y".

In the excerpt...

```
----------------------------------
Now we are going to LIST ALL TIMEZONES AVAILABLE for your system.
 * MAKE A NOTE OF YOUR TIMEZONE as it will be needed in the next step.
----------------------------------
Press enter to continue...
```

... press "Enter".

In the excerpt...

```
[ NAVIGATE: ↓ down arrow | ↑ up arrow | ⇟ page down | ⇞ page up | ↕ mouse wheel ]
[ CONTINUE: q ]
Africa/Abidjan
Africa/Accra
Africa/Addis_Ababa
Africa/Algiers
Africa/Asmara
[...]
```

... choose your time zone (take zone) and proceed by pressing "q".

In the excerpt...

```
[...]
----------------------------------
Inform your TIMEZONE (e.g. "America/Sao_Paulo").
 (use enter to confirm): 
```

... inform your TIMEZONE that you have chosen.

**Inform a recipient/destinatary for email notifications**

In the excerpt...

```
[...]
----------------------------------
Inform the destinatary of the e-mail notifications (e.g. "my_dest@my_domain.com").
 * E-mail that will receive notifications of Private_Tux's components.
 (use enter to confirm):
```

... inform the recipient/destinatary for the email notifications.

**Sendmail installation**

Install Sendmail to make e-mail notifications possible...

```
[...]
> ------------------------------------------------
----------------------------------
Install Sendmail ("y" recommended)? (y/n)
```

... by entering "y".

In the excerpt...

```
[...]
----------------------------------
Inform your smtp SERVER (e.g. "smtp.my_domain.com").
 (use enter to confirm):
```

... inform the smtp server.

For...

```
----------------------------------
Inform your smtp server PORT.
Use empty for "587".
 (use enter to confirm):
```

... use the "default" port by pressing "Enter".

In the excerpt...

```
[...]
----------------------------------
Inform your smtp server USER/SENDER (e.g. "my_user@my_domain.com").
 (use enter to confirm):
```

... inform the user/sender for the smtp server.

In the excerpt...

```
[...]
----------------------------------
Inform your smtp server user/sender PASSWORD.
 (use enter to confirm):
```

... enter the password for the smtp user/sender.

In the excerpt...

```
[...]
----------------------------------
Inform your domain (e.g. "my_domain.com").
Use empty for "my_domain.com".
 (use enter to confirm):
```

... enter the domain for the smtp server or just press enter (if applicable).

**Fail2ban installation**

Install Fail2ban to prevent brute force attacks at the "sshd" (ssh) service...

```
[...]
> ------------------------------------------------
----------------------------------
Install Fail2ban ("y" recommended)? (y/n)
```

... by entering "y".

For the period of banishment...

```
[...]
----------------------------------
Inform default "bantime" value (seconds).
Use empty for "7200" (two hours).
 * Time that a given IP will be banned (sshd "jail").
 (use enter to confirm):
```

... choose the default value by pressing "Enter".

For the period for possible attacks...

```
[...]
----------------------------------
Inform default "findtime" value (seconds).
Use empty for "600" (ten minutes).
 * Time that login attempts (sshd "jail") must take place for an IP be banned.
 (use enter to confirm):
```

... choose the default value by pressing "Enter".

For maximum possible "attack attempts"...

```
----------------------------------
Inform default "maxretry" value.
Use empty for "6".
 * How many login attempts (sshd "jail") must occur for an IP to be banned.
 (use enter to confirm):
```

... choose the default value by pressing "Enter".

For standard action in case of "attacks"...

```
----------------------------------
Default action when a "jail" (ban action) is triggered.
 * Recommended: use "action_" or empty for "Ban only". 
(select your option and press enter: action_ - Ban only | action_mw - Ban and send an email reporting "whois" to the recipient at "destemail" | action_mwl - Ban and send an email reporting "whois" and relevant log lines to the recipient in "destemail"):
```

NOTE: Except for critical servers or if necessary we recomend you choose "action_", otherwise a "flood" of notification emails may occur compromising your email servers unnecessarily.

... use "action_mwl".

In the excerpt...

```
[...]
> ------------------------------------------------
----------------------------------
Use "my_dest@my_domain.com" email as sender ("sender")?
 * If you chose to configure Sendmail using this installer answer "y". (y/n)
```

... enter "y".

In the excerpt...

```
[...]
> ------------------------------------------------
----------------------------------
Use "my_dest@my_domain.com" email as destinatary ("destemail") ("y" recommended)? (y/n)
```

... enter "y".

For the period of banishment (recidive)...

```
[...]
----------------------------------
Inform recidive "bantime" value (seconds).
Use empty for "2w" (2 weeks).
 * Time that a given IP will be banned for a long time.
 (use enter to confirm):
```

NOTE: Recidive banishes for a longer time.

... choose the default value by pressing "Enter".

For the period for possible attacks (recidive)...

```
[...]
----------------------------------
Inform recidive "findtime" value (seconds).
Use empty for "1d" (one day).
 * Time that attempts against a "jail" must take place for an IP be banned for a long time.
 (use enter to confirm):
```

... choose the default value by pressing "Enter".

For maximum possible "attack attempts" (recidive)...

```
----------------------------------
Inform recidive "maxretry" value.
Use empty for "2".
 * How many attempts against a "jail" must occur for an IP to be banned for a long time.
 (use enter to confirm):
```

... choose the default value by pressing "Enter".

**Chkrootkit installation**

Install Chkrootkit to detect rootkis and other malware...

```
[...]
> ------------------------------------------------
----------------------------------
Install Chkrootkit ("y" recommended)? (y/n)
```

... by entering "y".

**Rkhunter installation**

Install Chkrootkit to detect rootkis and other malware...

```
[...]
> ------------------------------------------------
----------------------------------
Install Rkhunter ("y" recommended)? (y/n)
```

... by entering "y".

**Scheduling (Crontab) for the Security Routine**

Make an schedule for the Security Routine (p_tux.bash)...

```
[...]
> ------------------------------------------------
----------------------------------
Set a Crontab schedule for the Security Routine (p_tux.bash) ("y" recommended)?
 * The routine will be executed daily once at the time that will be defined.
 * If you choose not, you will have to set the schedule (crontab or other) later. (y/n)
```

... by entering "y".

In the excerpt...

```
----------------------------------
Now we are going to schedule (job) your Security Routine (p_tux.bash):
 I - The routine will be executed daily once at the time that will be defined in the next step;
 II - If you have many servers on your network and/or hypervisors it may be interesting for you to choose the option "r" in the next step, so that the installer will choose a random time value for you between 00:00 AM and 04:59 AM. In this way, we use probability to prevent all servers from starting the security routine at the same time.
----------------------------------
Press enter to continue...
```

... press "Enter".

In the excerpt...

```
[...]
----------------------------------
How will you define your schedule (job)? 
(select your option and press enter: i - I will set the schedule (job). | r - I will let the installer automatically schedule (job) for me (randomly).):
```

NOTE: The random option is good for infrastructures with many servers and to avoid major concerns with scheduling. So we will not have several servers starting the Security Routine at the same time avoiding possible overloads.

... choose the "r" option to choose a "random schedule".

In the excerpt...

```
[...]
----------------------------------
Is this scheduling time (job) good for you (03:00)? (y/n)
```

... press "y" when scheduling is convenient.

In the excerpt...

```
[ NAVIGATE: ↓ down arrow | ↑ up arrow | ⇟ page down | ⇞ page up | ↕ mouse wheel 
]
[ CONTINUE: q ]
> ------------------------------------------------
Installer finished! Thanks!
----------------------------------

  > USEFUL INFORMATION:

    To configure the security routine (p_tux.bash)...
        vi /usr/local/private_tux/conf/conf..bash
    
    Installation Log...
        vi /usr/local/src/private_tux/installation.log
```

... press "q" and the installation will be complete.

About
-----

Private_Tux 🄯 BSD-3-Clause  
Eduardo Lúcio Amorim Costa  
Brazil-DF

<img border="0" alt="Brazil-DF" src="http://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Map_of_Brazil_with_flag.svg/180px-Map_of_Brazil_with_flag.svg.png" height="15%" width="15%"/>
