# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'pathname'

#If your Vagrant version is lower than 1.5, you can still use this provisioning
#by commenting or removing the line below and providing the config.vm.box_url parameter,
#if it's not already defined in this Vagrantfile. Keep in mind that you won't be able
#to use the Vagrant Cloud and other newer Vagrant features.
Vagrant.require_version ">= 1.5"

# Windows / Linux or mac ?
module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end

#is_windows_host = "#{OS.windows?}"
#puts "is_windows_host: #{OS.windows?}"
if OS.windows?
    puts "Vagrant launched from windows."
elsif OS.mac?
    puts "Vagrant launched from mac."
elsif OS.unix?
    puts "Vagrant launched from unix."
elsif OS.linux?
    puts "Vagrant launched from linux."
else
    puts "Vagrant launched from unknown platform."
end


# Auto NetworkDefault Pool
# If you want to change the default pool you will need to manually clear the cache 
# rm ~/.vagrant.d/auto_network/pool.yaml
#AutoNetwork.default_pool = '10.20.1.2/24' 
AutoNetwork.default_pool = '150.150.150.2/24'

Vagrant.configure("2") do |config|

    # Check That plugins are installed properly
    [
        { :name => "vagrant-hostmanager", :version => ">= 1.8.6" },
        { :name => "vagrant-triggers", :version => ">= 0.0.1" },
        { :name => "vagrant-auto_network", :version => ">= 1.0.2" }
    ].each do |plugin|

        if not Vagrant.has_plugin?(plugin[:name], plugin[:version])
          raise "#{plugin[:name]} #{plugin[:version]} is required. Please run `vagrant plugin install #{plugin[:name]}`"
        end
    end 


    config.ssh.forward_agent    = true
    
    # SSH KEYS
    config.ssh.insert_key       = false
   
    # sync folders - default
    config.vm.synced_folder "./provisioners", "/vagrant_provisioners", id: "provisioners", type: "nfs"
    
    # host manager default settings.
    # ==============================
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    Dir.glob('./machines/*.yml').each do |setting_file|
        #print setting_file + "\n"

        settings = YAML::load_file(setting_file);
        boxName = settings['name'] ?  settings['name'] : File.basename(setting_file)
        
        if settings['enabled'] === false 
            next
        end

        config.vm.define boxName do |node|
            node.vm.box = settings['box']
            node.vm.network :private_network, :auto_network => true
                        
            # Hostnames
            # ============
            hostname = settings['hostname'];
            aliases = settings['aliases'];
            
            node.vm.hostname = hostname 
            if aliases.kind_of?(Array) and !aliases.empty?()
                node.hostmanager.aliases = aliases
            else 
                aliases = Array.new
            end

            # Put Host Ip in the hostfile
            host_ip = 

            # SSH KEY
            # ==================
            node.ssh.private_key_path = [ settings['ssh_private'], "~/.vagrant.d/insecure_private_key"]
            node.vm.provision "file", source: settings['ssh_public'], destination: "~/.ssh/authorized_keys"

            node.vm.provision "shell", inline: <<-EOC
            sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
            sudo service ssh restart
EOC

            # Host Ip in /etc/hosts/
            node.vm.provision "shell", inline: <<-SCRIPT
            host_ip=`sudo netstat -rn | grep "^0.0.0.0 " | cut -d " " -f10`
            sudo sed -i '/vagrant-host #vagrant-host/d' /etc/hosts
            sudo echo "$host_ip vagrant-host \#vagrant-host" >> /etc/hosts 
SCRIPT
            
            # Virtual Box
            # ============
            node.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory" , settings['box_memory'] ? settings['box_memory'] : "2048"]
                vb.customize ["modifyvm", :id, "--name", boxName]
                vb.customize ["modifyvm", :id, "--cpus", settings['box_cpus'] ? settings['box_cpus'] : 2 ]
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
            end
            
            # Sync Folders
            # ============
            syncFolders = settings['sync'] ?  settings['sync'] : false
            if(syncFolders)
                syncFolders.each do |folder_info|
                    #print folder_info
                    node.vm.synced_folder folder_info['host'], folder_info['guest'], id: folder_info['id'], type: (OS.unix? ? "nfs" : "smb")
                end
            end

            # Provision 
            # ============
            
            # Provision Ansible.
            if settings['ansible']
                
                playbook =  settings['ansible_playbook'];
                if(!settings['ansible_playbook'])
                    # Look in the WWW folder see if we have an ansible file
                    ansibleFile = source_www + '/ansible-playbook.yml'
                    if File.file?(ansibleFile)
                        playbook = guest_www_folder + '/ansible-playbook.yml'
                    end
                end

                node.vm.provision "ansible_local" do |ansible|
                    #print "Playbook: " + playbook
                    ansible.playbook = playbook
                    ansible.provisioning_path = "/vagrant/provisioners/ansible"
                    ansible.extra_vars = { 
                        "ansible_ssh_user" => "vagrant",
                        "hostname" => hostname,
                        "aliases" => aliases
                    }
                end
            else 
                #raise "Cannot find ansible playbook file for #{node.vm.box} - " + ansibleFile
            end
              
        end
    end

end
