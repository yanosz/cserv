class Node
	@@base_dir = Rails.configuration.database_configuration[Rails.env]["rrd_path"]
	@@default_ping_target = Rails.configuration.database_configuration[Rails.env]["rtt_target"]
	attr_accessor :id
	attr_accessor :name
	def self.all
		nodes = []
		Dir.entries(@@base_dir).each do |entry|
			# Ist das ein Node?
			if md = entry.match('^([a-fA-F0-9]{12})')
				n = Node.new
				n.id = md[0].to_i(16)
				n.name = entry
				nodes << n
			end
		end
		nodes.sort { |x,y| x.id <=> y.id }
	end

	def path
		id_str = id.to_s(16)
		Dir["#{@@base_dir}/#{id_str}*"][0]
	end

	def self.find(id)
		n = Node.new
		n.id = id
		dir_str = n.path
		n.name = dir_str[@@base_dir.size,dir_str.size].gsub('/','')
		n
	end

	def last_submitted_timestamp
		File.mtime(Dir["#{path}/**/*.rrd"].max_by {|f| File.mtime(f)})
	end	

	def collectd_stats
		Dir["#{path}/*"].map do |path|
			c = CollectdStat.new
			c.base_dir = path
			c
		end
	end

	def node_id 
		self.id.to_s(16)
	end

	def rtt_5_min
		self.stat_template("ping",@@default_ping_target).rtt_5_min

	end

	def loss_5_min
		self.stat_template("ping",@@default_ping_target).loss_5_min
	end

	@@plugins = {"ping" => Collectd::Stats::PingStat,
		"interface" => Collectd::Stats::InterfaceRxTxStat,
		"iwinfo" => Collectd::Stats::IwinfoStat}
	def stat_template(plugin_str,rrd_str)
		# Sanity: Check if plugin exists
		plugin = @@plugins[plugin_str]
		raise "Plugin #{plugin_str} unknown " if plugin.nil?
		
		#Create template with rrd-File to render
		plugin.new("#{path}/#{plugin_str}/#{rrd_str}")
	end

end
