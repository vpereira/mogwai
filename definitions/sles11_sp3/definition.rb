Veewee::Session.declare({
  :os_type_id  => 'OpenSUSE_64',
  :cpu_count   => '1',
  :memory_size => '1024',
  :disk_size   => '20480',
  :disk_format => 'VDI',
  :hostiocache => 'off',
  :iso_file => 'SLES-11-SP3-DVD-x86_64-GM-DVD1.iso',
  :iso_src  => 'http://download.suse.de/install/SLES-11-SP3/SLES-11-SP3-DVD-x86_64-GM-DVD1.iso',
  :iso_md5  => 'http://download.suse.de/install/SLES-11-SP3-GM/',
  :iso_download_timeout => '1000',
  :boot_wait         => '10',
  :boot_cmd_sequence => [
      '<Esc><Enter>',
      'linux netdevice=eth0 netsetup=dhcp install=cd:/',
      ' lang=en_US',
      ' autoyast=http://%IP%:8888/autoinst.xml',
      ' insecure=1 textmode=1',
      '<Enter>'
  ],
  :kickstart_port => "7122",
  :kickstart_timeout => "10000",
  :kickstart_file => "autoinst.xml",
  :ssh_login_timeout => '10000',
  :ssh_user          => 'vagrant',
  :ssh_password      => 'vagrant',
  :ssh_key           => '',
  :ssh_host_port     => '7222',
  :ssh_guest_port    => '22',
  :sudo_cmd     => "echo '%p'|sudo -S sh '%f'",
  :shutdown_cmd => 'halt',
  :postinstall_files   => ["postinstall.sh"],
  :postinstall_timeout => '10000',
  :hooks => {
      :before_create => Proc.new do
        puts "Assembly started at #{Time.now}"
        puts definition.box.name
        path = "#{Dir.pwd}/definitions/#{definition.box.name}"
        $webserver = Thread.new { WEBrick::HTTPServer.new(:Port => 8888, :DocumentRoot => path, :BindAddress=>"127.0.0.1").start }
      end,
      :after_boot_sequence => Proc.new do
         `/usr/bin/curl 'http://127.0.0.1:7122/autoinst.xml'` # we must fire it once, otherwise the process freezes
      end,
      :before_postinstall => Proc.new do
          $webserver.kill
      end,
      :after_postinstall => Proc.new do
          `/usr/bin/VBoxManage controlvm sles12_beta1 poweroff` # hardcoded name sucks!
      end
  }
})
