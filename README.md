DEPLOY LIKE A BOSS
==================

The idea is to provide vagrant boxes to be used by our maintenance team.

dependencies:

* Vagrant 1.5 (tested with 1.5.2)
* Virtualbox (tested witth 4.3.x)
* Veewee

To build the vm (check if you are able to resolve suse.de addresses)

     bundle install

     bundle exec veewee vbox build scc_sles12_beta1 --force

it will download the iso and will prepare a VM.
if everything goes well, then you will have to pack it as:

    bundle exec veewee vbox export sles12_beta1 #you will have a sles12_beta1.box in the current directory
or
    vagrant package --base sles12_beta1 --output sles12_beta1.box # to generate the base box, sles12_beta1.box in the current directory.
 
then we will have to import it. in the current directory, do:

    vagrant box add sles12 sles12_beta1.box 

How do i use it
---------------

if i have to maintain a project a normally do:

    osc co PROJECT:package
    cd PROJECT:package
    # cp the Vagrantfile into the current directory
    vagrant up
    # now you have a VM running, wit the host current directory, as shared folder, /vagrant on guest. 
    # you can develop it locally now, and test it on VM transparently. 


