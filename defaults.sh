adduser lera
usermod -aG sudo lera

# Убрать запрос пароля
sudo visudo
lera ALL=(ALL) NOPASSWD:ALL

ssh-copy-id lera@81.163.30.82
ssh lera@81.163.30.82

# Настройка ssh на сервере
sudo nano /etc/ssh/sshd_config
sudo systemctl restart ssh
ssh lera@81.163.30.82 -p 8404

# Для работы докера
sudo mkdir /sys/fs/cgroup/systemd
sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd


sudo apt install nginx
service nginx status -- статус nginx
sudo systemctl restart nginx

sudo apt install fail2ban
systemctl status fail2ban.service
cd /etc/fail2ban
sudo cp jail.conf jail.local
sudo systemctl restart fail2ban