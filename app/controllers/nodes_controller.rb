class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all
    respond_to do |format|
      format.html # index.html.erb
      format.json do 
        data = {}
        @nodes.each do |n|
          loss_5_min = n.loss_5_min
          rtt_5_min = n.rtt_5_min 
          data[n.id] = {id_hex: n.node_id, 
            loss_5_min: (loss_5_min.nil? || loss_5_min.nan?) ? nil : loss_5_min, 
            rtt_5_min: (rtt_5_min.nil? || rtt_5_min.nan?) ? nil : rtt_5_min}
        end
        render json: data
      end
    end
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      id = params[:id].to_i
      @node = Node.find(id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def node_params
      params.require(:node).permit(:name)
    end
end
