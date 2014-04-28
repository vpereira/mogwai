DEPLOY LIKE A BOSS
==================

The idea is to provide virtual machines and vagrant boxes to be used by our maintenance team.

dependencies:

* ruby (just tested with 2.x)
* gem bundler (gem bundler install)
* curl 
* Vagrant 1.5 (tested with 1.5.2)
* Virtualbox (tested witth 4.3.x)
* Veewee

Important:

I'm using rvm (http://rvm.io) as ruby env. Didn't test with system ruby or rbenv.
I just tested with Virtualbox. However it should work as well with kvm and libvirt (if it works, please tell me)

Instructions
------------

To build the vm (check if you are able to resolve suse.de addresses)

     bundle install

     bundle exec veewee vbox build sles12_beta1 --force

it will download the iso and will prepare a VM. if you dont want to use Vagrant, 
then you are done. the new VM will be available in your Virtualbox

if you want to use the VM with Vagrant and everything goes well, then you will have to pack it as:

    bundle exec veewee vbox export sles12_beta1 #you will have a sles12_beta1.box in the current directory

or

    vagrant package --base sles12_beta1 --output sles12_beta1.box # to generate the base box, sles12_beta1.box in the current directory.
 
then we will have to import it. in the current directory, do:

    vagrant box add sles12 sles12_beta1.box 


VMs available
-------------

* SLES-12-SP1 
* SLES-13-SP3

How do i use it
---------------

if i have to maintain a project a normally do:

    osc co PROJECT:package
    cd PROJECT:package
    # cp the Vagrantfile into the current directory
    vagrant up
    # now you have a VM running, wit the host current directory, as shared folder, /vagrant on guest. 
    # you can develop it locally now, and test it on VM transparently. 


