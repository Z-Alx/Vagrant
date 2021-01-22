#!/bin/bash

export ACCOUNT_ROOT='ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAjAjYgaBI4qFgy1E8K0Fyl218S+KtDv251JQX8bWXHJT8JXepA2f/dvTCUQPiPYYD7iQzgNTqRXXxdrqqCTLxzEgVL0DPCsSqzZ5bd3yx7J+wxmMo22Q5/V9UIJ3iJgEn99l/xb1DoQyMm/7A6w6bf9WhqXOozrRqyA5ltLlLZUU3Y9//Li1YVdVBdAbJNqg/8qO19KpTQjMdWEMHbjsh/ty9D1I1UM/cwcMbBzOL3CWYqpEXN3otNjMWW3sLMqbaLLczNG/Z2kAd/q6WxPjfbN8VZAp936MrklWKCtHjaEEiXpij0Ev61gU9R7ecxr1lS+dx4dANPqvo8uHuUqF3CZIFHrT4sD2eniYghz7SaZUbvXDcLAtH7NBV3Z9Hct0fcEOyZSQJKmsnyjXxEkQeyyAJmOfArTf4P2GR6AWcBjoBzy7DSHqEGaX7K31xTTbjWqrO5LyTUbEHU++/ZqiE4/btSFJ8DV1sFTUOCktippVbf1gUxbEGXnmmAqLbbXd7lQLcCKkmCUVHo/F4FHupQCa+EXjVjflUm4EsX+XP09D8UHtPn41v5mxUbBUta3TtyuZObV/z1gOofqT3f40sqZlN+g6JXPTMppSWvjPo5K377ytZmZpoeSItmhVL1sb5REVZYIa5H4hEbVIHi394+gpmtRBLlhLUkQpo0LzajyU= 76:df:90:29:44:92:bf:89:21:39:5a:f2:61:e0:ce:dd Emergency account <admin@codeinside.ru>'

#######

export ACCOUNT_MAINTENANCE='ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAq9T4yl4cUS6PWvKXkIafBQPmj6DmOPQTFEEHZUfuAYaCzTQq90caO3B4iBSQr0ps2aiE8KJ77h/6H/yb+7c1fCzpsOXBnTPWAXOLtAbZfrArgU1vM6IsbgQbNV7NJcaQr3waHze+BWDF5gZZH7E0OzKCw56hJigqLK2TWpAvZ4k4LYnFtuPDv1Uls+cc3q4baScapzjbYWU1+/jSXcDvehDutLHDVkuL6EA6KCPWN6T7qfG6YwL+jyh/FYacGP4Pe3pNSLRHnBlzz3PEduUXKHxHtYMJopXLpJIS5RLfaly2aP7aDtbvFyHtkpuaLJFdiwCxRwIOaNrh/FaBk+4a0wK2nEhy4egxd4Q5xMFWODoWx8UUU03NiCf2nxb1z2IRuMFQcx/mOTig4gUFLZXerCSuIntKD2JSUzMh4RiRt3OQKOAXX+9lZrCaWpjlkE0pOaQuv1IZF/OY/KX5NnhXSFd6KA/la5yNxEW7DjY3aM5eEHydoU4LicDDOlPC2YOUfoOPRmHevqrabH39gMadLaTaY/nZVooDmffirou+cg/sYsSlqR6v9iV/Bzp12zmK0M+A73U8vC9FtqtHmfxXu1V2YHFIKcvHBdi0rlBvi8kdLg/KPy2InUmLQdx9FHTcH5Yea1rfSzHohVlCcwJMMka0OqwSvKQyaPEVnb5Vhts= 4a:b1:be:df:1f:05:54:7e:be:47:9b:0f:05:a5:f6:c3 Maintenance account'
export MAINTENANCE_HOME='/var/opt/maintenance'

#################################################

chattr -i /root/.ssh 2> /dev/null
chattr -i /root/.ssh/authorized_keys 2> /dev/null
rm -rf /root/* /root/.* 2> /dev/null
cp -rT /etc/skel /root
mkdir -p /root/.ssh
echo "${ACCOUNT_ROOT}" > /root/.ssh/authorized_keys
chown -R root:root /root
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/authorized_keys
if [[ -n "$(which restorecon)" ]]; then restorecon -Rv /root/.ssh; fi
#chattr +i /root/.ssh/authorized_keys

#######

chattr -i "${MAINTENANCE_HOME}/.ssh" 2> /dev/null
chattr -i "${MAINTENANCE_HOME}/.ssh/authorized_keys" 2> /dev/null
userdel -rf maintenance 2> /dev/null
useradd --system -d "${MAINTENANCE_HOME}" -m -g nogroup -s /bin/bash -c "Maintenance account" -N maintenance 2> /dev/null
mkdir -p "${MAINTENANCE_HOME}/.ssh"
echo "${ACCOUNT_MAINTENANCE}" > "${MAINTENANCE_HOME}/.ssh/authorized_keys"
chown -R maintenance:nogroup "${MAINTENANCE_HOME}"
chmod -R 0700 "${MAINTENANCE_HOME}"
chmod 0600 "${MAINTENANCE_HOME}/.ssh/authorized_keys"
if [[ -n "$(which restorecon)" ]]; then restorecon -Rv "${MAINTENANCE_HOME}/.ssh"; fi
#chattr +i "${MAINTENANCE_HOME}/.ssh/authorized_keys"

if [[ -z "$(which sudo)" ]]; then (apt-get update -y && apt-get install sudo -y); fi
chattr -i /etc/sudoers.d/maintenance 2> /dev/null
echo 'maintenance  ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/maintenance
#chattr +i /etc/sudoers.d/maintenance

#################################################

echo "Done!"