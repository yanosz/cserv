require 'errand'
require "RRD"

class Collectd::Stats::IwinfoStat 
  include SimpleRRD
  
  attr_accessor :base_dir
  attr_accessor :stat_params
  attr_accessor :iface_name
  attr_accessor :stations_rrd
  
  def initialize(rrd_file)
    self.stations_rrd = rrd_file.gsub('/iwinfo/','/') # This is not part of the plugin
    self.iface_name = rrd_file.match("iwinfo-(.+)/")[1]
  end

  def summary
    {
      stations_now: self.stations_now,
      stations_1d: self.stations_1d,
      stations_30d: self.stations_30d
    }
  end


  def stations_now
    rrd = Errand.new(:filename => self.stations_rrd)
    result = rrd.fetch(:start => (Time.now - 60).to_i.to_s) #1 min back
    points = result[:data]["value"].select {|s| !s.nan?}
    points.inject{ |sum, el| sum + el }.to_f / points.size
  end
  
  def stations_1d
    rrd = Errand.new(:filename => self.stations_rrd)
    result = rrd.fetch(:start => (Time.now - 24*3600).to_i.to_s) #1d back (24 * 3600 secs)
    points = result[:data]["value"].select {|s| !s.nan?}
    points.inject{ |sum, el| sum + el }.to_f / points.size
  end
  
  def stations_30d
    rrd = Errand.new(:filename => self.stations_rrd)
    result = rrd.fetch(:start => (Time.now - 30*24*3600).to_i.to_s) #30d back (30 * 24 * 3600 secs)
    points = result[:data]["value"].select {|s| !s.nan?}
    points.inject{ |sum, el| sum + el }.to_f / points.size
  
  end
  
 def create_graph(width,height,end_time,no_summary)
      stations_rrd = self.stations_rrd
      ifname = self.iface_name
      graph = FancyGraph.build do
        title "Stations: #{ifname}"
        width width
        height height
        end_at Time.now
        start_at Time.now - end_time
        upper_limit 20
        lower_limit 0
        rigid true
        exponent 1
        y_label "#"
        
        stations = Def.new(:rrdfile => stations_rrd, :ds_name => 'value', :cf => 'AVERAGE')
        stations_pct = CDef.new(:rpn_expression => [100, stations, '*'])

	stations_color = "7FB37C" #Green
        stations_line = Line.new(:data => stations, :text => "Stations ", :width => 1, :color => stations_color)
        stations_area = Area.new(:data => stations, :color => stations_color, :alpha => '66')

   
	add_element(stations_line)
        add_element(stations_area)
        summary_elements(stations).each { |e| add_element(e) } unless no_summary
      end
      graph.generate
  end 
  def self.interfaces(node)
    base_dir = Collectd::Stats::GraphBase.conf_value_stat(['stats','iwinfo','dir'],node)
    Dir["#{base_dir}/iwinfo-*"].map do |str|
	   str.split('iwinfo-')[-1]
    end
  end
  
end
