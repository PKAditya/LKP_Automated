#!/bin/bash
 
touch /var/lib/change_ulimit.sh
echo "#!/bin/bash" > /var/lib/change_ulimit.sh
echo "sudo sysctl -w kernel.pid_max=131072" >> /var/lib/change_ulimit.sh
echo "sudo sysctl -w kernel.threads-max=131072" >> /var/lib/change_ulimit.sh
echo "sudo sysctl -w vm.max_map_count=2097152" >> /var/lib/change_ulimit.sh
echo "sudo systemctl set-property user-$(id -u).slice TasksMax=131072" >> /var/lib/change_ulimit.sh
echo "ulimit -u 65536" >> /var/lib/change_ulimit.sh
echo "ulimit -n 65536" >> /var/lib/change_ulimit.sh
chmod +x /var/lib/change_ulimit.sh
 
touch /etc/systemd/system/change-ulimit.service
echo "[Unit]" > /etc/systemd/system/change-ulimit.service
echo "Description=Change Ulimit Values" >> /etc/systemd/system/change-ulimit.service
echo "After=network.target" >> /etc/systemd/system/change-ulimit.service
echo "" >> /etc/systemd/system/change-ulimit.service
echo "[Service]" >> /etc/systemd/system/change-ulimit.service
echo "WorkingDirectory=/var/lib" >> /etc/systemd/system/change-ulimit.service
echo "ExecStart=/bin/bash /var/lib/change_ulimit.sh" >> /etc/systemd/system/change-ulimit.service
echo "" >> /etc/systemd/system/change-ulimit.service
echo "[Install]" >> /etc/systemd/system/change-ulimit.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/change-ulimit.service
 
systemctl daemon-reload
systemctl enable change-ulimit.service
systemctl start change-ulimit.service