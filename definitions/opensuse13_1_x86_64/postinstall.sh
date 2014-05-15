date > /etc/vagrant_box_build_time
echo 'solver.allowVendorChange = true' >> /etc/zypp/zypp.conf
echo 'solver.onlyRequires = true' >> /etc/zypp/zypp.conf


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

# install required packages
packages=( gcc-c++ less make bison libtool ruby-devel vim nfs-client rsync)
zypper --non-interactive install --no-recommends --force-resolution ${packages[@]}

zypper --non-interactive refresh

echo -e "\nall done.\n"
exit
