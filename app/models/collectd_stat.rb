class CollectdStat
	attr_accessor :base_dir
	def name
		self.base_dir.split('/').last
	end

	def data_files
		Dir["#{base_dir}/*"].map do |file|
			File.new(file)
		end
	end
end