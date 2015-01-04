class SupernodesController < ApplicationController
  before_action :set_supernode, only: [:show, :edit, :update, :destroy]

  # GET /supernodes
  # GET /supernodes.json
  def index
    @supernodes = Supernode.all
    
  end
end
