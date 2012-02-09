class TrajectoriesController < ApplicationController
  # GET /trajectories
  # GET /trajectories.json
  def index
    @trajectories = Trajectory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trajectories }
    end
  end

  # GET /trajectories/1
  # GET /trajectories/1.json
  def show
    @trajectory = Trajectory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trajectory }
    end
  end

  # GET /trajectories/new
  # GET /trajectories/new.json
  def new
    @trajectory = Trajectory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trajectory }
    end
  end

  # GET /trajectories/1/edit
  def edit
    @trajectory = Trajectory.find(params[:id])
  end

  # POST /trajectories
  # POST /trajectories.json
  def create
    @trajectory = Trajectory.new(params[:trajectory])

    respond_to do |format|
      if @trajectory.save
        format.html { redirect_to @trajectory, notice: 'Trajectory was successfully created.' }
        format.json { render json: @trajectory, status: :created, location: @trajectory }
      else
        format.html { render action: "new" }
        format.json { render json: @trajectory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trajectories/1
  # PUT /trajectories/1.json
  def update
    @trajectory = Trajectory.find(params[:id])

    respond_to do |format|
      if @trajectory.update_attributes(params[:trajectory])
        format.html { redirect_to @trajectory, notice: 'Trajectory was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @trajectory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trajectories/1
  # DELETE /trajectories/1.json
  def destroy
    @trajectory = Trajectory.find(params[:id])
    @trajectory.destroy

    respond_to do |format|
      format.html { redirect_to trajectories_url }
      format.json { head :ok }
    end
  end
end
