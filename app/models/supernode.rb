class Supernode < Node

	@@base_dir = Rails.configuration.database_configuration[Rails.env]["rrd_path"]
	
	attr_accessor :name
	
	def self.all
		nodes = []
		Dir.entries(@@base_dir).each do |entry|
			# Ist das ein Node?
			if md = entry.match('^fastd(\d\d?).kbu.freifunk.net')
				n = Node.new
				n.name = entry
				nodes << n
			end
		end
		nodes.sort { |x,y| x.id <=> y.id }
	end

end
