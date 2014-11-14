class StatsController < ApplicationController
 
  def show
    @node = Node.find(params[:node_id].to_i)
    # Sanity check - does the rrd-file (target) exist for this host?
    stat = @node.stat_template(params[:id],params[:target])
    secs = (params[:secs] || 3600).to_i
    name = params[:name]
    type = params[:type]
    id = params[:id] || params[:type]
    width = params[:width] || 600
    height = params[:height] || 200
    no_summary = params[:no_summary]
    respond_to do |format|
      format.png do 
        send_data stat.create_graph(width,height,secs,no_summary), :type => 'image/png',:disposition => 'inline'
      end
    end
  end
end
