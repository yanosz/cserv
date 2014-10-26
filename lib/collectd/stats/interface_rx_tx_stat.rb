class Collectd::Stats::InterfaceRxTxStat 
  include SimpleRRD
  attr_accessor :collectd_node

  attr_accessor :graph_name
  attr_accessor :interface_name
  attr_accessor :rrd_file


  GRAPH_NAMES = %w(octets packets)

  LABELS = {
    'octets' => {rx: 'Empfangen (Bytes / Sekunde)', tx: 'Gesendet (Bytes / Sekunde)'},
    'packets' => {rx: 'Empfangen (Pakete / Sekunde)', tx: 'Gesendet (Pakete / Sekunde)'}
  }

  def initialize(rtt_rrd)
    self.rrd_file = rtt_rrd
    self.graph_name = "octets"
    #if_octets-mesh-vpn.rrd
    md = rtt_rrd.match("if_octets-(.+).rrd")
    self.interface_name = md[1]

  end
  

    
  
  def create_graph(w,h,end_time,no_summary)
      graph_name = self.graph_name
      interface_name = self.interface_name
      rrd_file = self.rrd_file
      graph = FancyGraph.build do
       width    w
        height   h
        end_at   Time.now
        start_at start_at Time.now - end_time
        title   "Interface: #{interface_name}"
        # TX
         tx_data = Def.new(:rrdfile => rrd_file, :ds_name=>'tx', :cf => 'AVERAGE')

         tx_color = "33A02C" #Green
         tx_line = Line.new(:data => tx_data, :text => Collectd::Stats::InterfaceRxTxStat::LABELS[graph_name][:tx], :width => 1, :color => tx_color)
         tx_area = Area.new(:data => tx_data, :color => tx_color, :alpha => '66')
         add_element(tx_line)
         add_element(tx_area)
         summary_elements(tx_data).each { |e| add_element(e) } unless no_summary
 
         add_element(line_break) unless no_summary
 
        # RX
        rx_data = Def.new(:rrdfile => rrd_file, :ds_name=>'rx', :cf => 'AVERAGE')
        rx_color = "1F78B4" #Blue

        rx_minus = CDef.new(:rpn_expression => [-1, rx_data, '*'])
        rx_line = Line.new(:data => rx_minus, :text => Collectd::Stats::InterfaceRxTxStat::LABELS[graph_name][:rx], :width => 1, :color => rx_color)
        rx_area = Area.new(:data => rx_minus, :color => rx_color, :alpha => '66')
        add_element(rx_line)
        add_element(rx_area)
        summary_elements(rx_data).each { |e| add_element(e) } unless no_summary
 
        
 
      end
      graph.generate
  end
end
