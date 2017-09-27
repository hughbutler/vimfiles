class AttributesController < ApplicationController
  before_filter lambda{ current_page 'settings' }
  
  # GET /attributes
  # GET /attributes.xml
  def index
    @attributes = Attribute.by_community(community_id)
    @current_page += ' top_attributes'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attributes }
    end
  end

  # GET /attributes/1
  # GET /attributes/1.xml
  def show
    @attribute = Attribute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attribute }
    end
  end

  # GET /attributes/new
  # GET /attributes/new.xml
  def new
    @attribute = Attribute.new
    @current_page += ' top_create_attribute'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attribute }
    end
  end

  # GET /attributes/1/edit
  def edit
    @attribute = Attribute.find(params[:id])
  end

  # POST /attributes
  # POST /attributes.xml
  def create
    @attribute = Attribute.new(params[:attribute])
    @attribute.community_id = community_id
    respond_to do |format|
      if @attribute.save
        format.html { redirect_to(attributes_url, :notice => 'Attribute was successfully created.') }
        format.xml  { render :xml => @attribute, :status => :created, :location => @attribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attributes/1
  # PUT /attributes/1.xml
  def update
    @attribute = Attribute.find(params[:id])

    respond_to do |format|
      if @attribute.update_attributes(params[:attribute])
        format.html { redirect_to(attributes_url, :notice => 'Attribute was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attributes/1
  # DELETE /attributes/1.xml
  def destroy
    @attribute = Attribute.find(params[:id])
    @attribute.destroy

    respond_to do |format|
      format.html { redirect_to(attributes_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
end
