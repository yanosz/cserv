class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all
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
