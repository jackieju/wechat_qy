class RegappsController < ApplicationController
  # GET /regapps
  # GET /regapps.xml
  def index
    @regapps = Regapp.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @regapps }
    end
  end

  # GET /regapps/1
  # GET /regapps/1.xml
  def show
    @regapp = Regapp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @regapp }
    end
  end

  # GET /regapps/new
  # GET /regapps/new.xml
  def new
    @regapp = Regapp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @regapp }
    end
  end

  # GET /regapps/1/edit
  def edit
    @regapp = Regapp.find(params[:id])
  end

  # POST /regapps
  # POST /regapps.xml
  def create
    @regapp = Regapp.new(params[:regapp])

    respond_to do |format|
      if @regapp.save
        flash[:notice] = 'Regapp was successfully created.'
        format.html { redirect_to(@regapp) }
        format.xml  { render :xml => @regapp, :status => :created, :location => @regapp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @regapp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /regapps/1
  # PUT /regapps/1.xml
  def update
    @regapp = Regapp.find(params[:id])

    respond_to do |format|
      if @regapp.update_attributes(params[:regapp])
        flash[:notice] = 'Regapp was successfully updated.'
        format.html { redirect_to(@regapp) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @regapp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /regapps/1
  # DELETE /regapps/1.xml
  def destroy
    @regapp = Regapp.find(params[:id])
    @regapp.destroy

    respond_to do |format|
      format.html { redirect_to(regapps_url) }
      format.xml  { head :ok }
    end
  end
end
