require 'erb'
# Serves as A FASCADE 
class Collectd::Collectd
  
  # For now, one collectd instance is supported, only
  # Empty Constructor, now settings for collectd
  def initialize()
  
  end
  
  # Factory-Method
  def stat(collectd_node,type,name,stat_params)
    g_class = ("Collectd::Stats::"+Collectd::Collectd.config['stats'][type]['type']).constantize
    stat = g_class.new(collectd_node,Collectd::Collectd.config['stats'][type],name,stat_params)
  end
 
  
  def set_ping_hosts(addresses)
    template_filename = Collectd::Collectd.config['ping']['template']
    config_filename = Collectd::Collectd.config['ping']['path']
    File.open(config_filename,'w') do |file|
      file.flock(File::LOCK_EX)
      File.open(template_filename, "r") do |t_f|
        str = t_f.read
        template = ERB.new str
        file.write template.result(binding)
      end
    end
    system Collectd.config['reload_cmd'] #Execute reload
  end



  # Hardwire all MACs in order to avoid NS-pacekts
  def write_mac_list(macs_by_ll)
    macs_by_ll.each_pair do |ll,mac|
      i_face = Collectd.config['ping']['interface']
      # ip -6 neigh add fec0::1 lladdr 02:01:02:03:04:05 dev eth0
      system "sudo /sbin/ip -6 neigh add #{ll} lladdr #{mac} dev #{i_face}"
      # May exists - try change
      system "sudo /sbin/ip -6 neigh change #{ll} lladdr #{mac} dev #{i_face}"

    end
  end

  def self.config
    @@config ||= YAML::load_file("#{Rails.root}/config/app.yml")['collectd']
  end
  
end