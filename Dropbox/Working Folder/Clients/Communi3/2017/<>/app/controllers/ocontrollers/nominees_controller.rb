class NomineesController < InheritedResources::Base
  before_filter :authenticate_user!
  def index
    @nominations = Nomination.by_community(community_id).order('is_accepted, created_at desc')
  end
  def create
    @nomination = Nomination.new(params[:nomination])
    @nomination.person_id = current_user.id
    respond_to do |format|
      if @nomination.save
        format.html { redirect_to(nominations_url, :notice => 'Your nomination was successfully created.') }
        format.xml  { render :xml => @nomination, :status => :created, :location => @attribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nomination.errors, :status => :unprocessable_entity }
      end
    end
  end
end
