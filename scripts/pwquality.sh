#!/usr/bin/bash
/usr/bin/mkdir -p /run/intune/0
/usr/bin/mkdir -p /run/intune/1000
/usr/bin/touch /run/intune/0/pwquality
/usr/bin/touch /run/intune/1000/pwquality
echo "password requisite pam_pwquality.so minlen=12 dcredit=-4 lcredit=-7 ocredit=0 ucredit=-1" | tee > /run/intune/0/pwquality /run/intune/1000/pwquality
