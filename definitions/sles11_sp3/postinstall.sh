date > /etc/vagrant_box_build_time
echo 'solver.allowVendorChange = true' >> /etc/zypp/zypp.conf
echo 'solver.onlyRequires = true' >> /etc/zypp/zypp.conf

#zypper --non-interactive rr SUSE-Linux-Enterprise-Server-12-12.0-

if [ -e /etc/zypp/locks ];then
    rm /etc/zypp/locks
fi
echo 'gem: --no-ri --no-rdoc' > /etc/gemrc
echo -e "\ninstall vagrant key ..."
mkdir -m 0700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate -O authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant.users /home/vagrant/.ssh

# update sudoers
echo -e "\nupdate sudoers ..."
echo -e "\n# added by veewee/postinstall.sh" >> /etc/sudoers
echo -e "vagrant ALL=(ALL) NOPASSWD: ALL\n" >> /etc/sudoers
sed -i -e 's/%sudo\s\+ALL=(ALL:ALL) ALL/%sudo   ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

# speed-up remote logins
echo -e "\nspeed-up remote logins ..."
echo -e "\n# added by veewee/postinstall.sh" >> /etc/ssh/sshd_config
echo -e "UseDNS no\n" >> /etc/ssh/sshd_config

zypper --non-interactive addrepo http://download.suse.de/ibs/SUSE:/SLE-11-SP3:/GA/standard/ sles11
zypper --non-interactive in nfs-client rsync

zypper --non-interactive refresh

echo -e "\nall done.\n"
exit
