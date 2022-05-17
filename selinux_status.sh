#!/bin/bash

GET=$(getenforce)
CONF=$(cat /etc/selinux/config | grep -w "SELINUX" | grep -v "#" | awk 'BEGIN{FIELDWIDTHS="8 11"}{print $2}')
SET1=$(echo setenforce 1)
SET0=$(echo setenforce 0)
#CFG0=$(sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config)
#CFG1=$(sed -i 's/SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config)


# Help how to use the script
[ "$1" = "-h" -o  "$1" =  "--help" ] && echo "

./selinux_status.sh

NAME
        selinux_status.sh - used to check and update SELinux file configuration and status.

SYNOPSIS
        ./selinux_status.sh [OPTION]

DESCRIPTION
        -h, --help
                 manual entry for selinux_status.sh
        
        -set0
                disable selinux
                
        -set1
                enable selinux

        -cfg0
                change SELinux status in config file to 'permissive' (not active)

        -cfg1
                change SELinux status in config file to 'enforcing' (active)

EXAMPLES
        
                ./selinux_status.sh -set1
                        run 'setenforce 1' command, output SELinux is activated.

                ./selinux_status.sh -cfg1
                        run 'sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config' command, output SELinux changed to enforcing.


" && exit


# This command will enable SELinux using the setenforce 1 command.

if [ "$1" = "-set1" ]; then

        echo "

##############SESTATUS##############

-- SELinux is activated --"

$SET1

        echo "Current status: " 
getenforce

echo "###############################"

exit 0

# This command will disable SELinux using the setenforce 0 command.

elif [ "$1" = "-set0" ]; then

        echo "

##############SESTATUS##############

-- SELinux is deactivated --"


$SET0

        echo "Current status: "
getenforce


echo "###############################"


exit 0


fi

# This command will change SELinux status in the config file (/etc/selinux/config) to enforcing using the sed command.
if [ "$1" = "-cfg1" ]; then

        echo "

#########/etc/selinux/config########

-- SELinux changed to enforcing --"

#$CFG1
sed -i 's/SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config

echo "###############################"

exit 0

# This command will change SELinux status in the confi file (/etc/selinux/config) to permissive using the sed command.

elif [ "$1" = "-cfg0" ]; then

        echo "

#########/etc/selinux/config########

-- SELinux changed to  permissive --"

#$CFG0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config


echo "###############################"


exit 0


fi

# Show sestatus output
if [ "$GET" = "Enforcing" ]; then

        echo "

##############SESTATUS##############

-- SELinux is working ($GET)."
echo "To DISABLE SELinux run the following command ./selinux_status.sh -set0

###############################"

else
        echo "
##############SESTATUS##############

-- SELinux is not working ($GET)."

echo "To ENABLE SELinux run the following command ./selinux_status.sh -set1

###############################"

fi

# Shows SELinux value in config file /etc/selinux/config

if [ "$CONF" = "enforcing" ]; then

        echo "
#########/etc/selinux/config########

-- SELinux is active in conf file ($CONF).
To DISABLE SELinux in /etc/selinux/config run the following command ./selinux_status.sh -cfg0

##################################"

echo "

----------------------- This script can manage SELinux settings -----------------------
-------------------For more information please run ./selinux_status.sh --help-------------------

"


else
        echo "
#########/etc/selinux/config########

-- SELinux is not active in conf file ($CONF).
To ENABLE SELinux in /etc/selinux/config run the following command ./selinux_status.sh -cfg1

##################################"

echo "

----------------------- This script can manage SELinux settings -----------------------
-------------------For more information please run ./selinux_status.sh --help-------------------

"


fi