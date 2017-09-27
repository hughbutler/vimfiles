class AttributeAnswersController < ApplicationController
  # GET /attribute_answers
  # GET /attribute_answers.xml
  def index
    @attributable = find_attributable
    @attribute_answers = @attributable.attribute_answers

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attribute_answers }
    end
  end

  # GET /attribute_answers/1
  # GET /attribute_answers/1.xml
  def show
    @attribute_answer = AttributeAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attribute_answer }
    end
  end

  # GET /attribute_answers/new
  # GET /attribute_answers/new.xml
  def new
    @attribute_answer = AttributeAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attribute_answer }
    end
  end

  # GET /attribute_answers/1/edit
  def edit
    @attribute_answer = AttributeAnswer.find(params[:id])
  end

  # POST /attribute_answers
  # POST /attribute_answers.xml
  def create
    @attribute_answer = AttributeAnswer.new(params[:attribute_answer])

    respond_to do |format|
      if @attribute_answer.save
        format.html { redirect_to(@attribute_answer, :notice => 'Attribute answer was successfully created.') }
        format.xml  { render :xml => @attribute_answer, :status => :created, :location => @attribute_answer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attribute_answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attribute_answers/1
  # PUT /attribute_answers/1.xml
  def update
    @attribute_answer = AttributeAnswer.find(params[:id])

    respond_to do |format|
      if @attribute_answer.update_attributes(params[:attribute_answer])
        format.html { redirect_to(@attribute_answer, :notice => 'Attribute answer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attribute_answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attribute_answers/1
  # DELETE /attribute_answers/1.xml
  def destroy
    @attribute_answer = AttributeAnswer.find(params[:id])
    @attribute_answer.destroy

    respond_to do |format|
      format.html { redirect_to(attribute_answers_url) }
      format.xml  { head :ok }
    end
  end
  
  def update_individual
    @attribute_answers = AttributeAnswer.update(params[:attribute_answers].keys, params[:attribute_answers].values).reject { |p| p.errors.empty? }
    flash[:notice] = "Saved!"
  end
  
  private

  def find_attributable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
