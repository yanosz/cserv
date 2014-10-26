module NodesHelper
	def ping?(stat)
		stat.name.match("ping")
	end
	
	def interface?(stat)
		stat.name.match("interface")
	end
	
	def iwinfo?(stat)
		stat.name.match("iwinfo")
	end

	def ping_img(node,target)
		"<img />"
	end
	#Hack: Bei iwinfo wird der Plugin-Name um das Interface ergaenzt :-/
	def iwinfo_dir(path)
		path.split('/')[-2..-1].join '/'
	end
end
