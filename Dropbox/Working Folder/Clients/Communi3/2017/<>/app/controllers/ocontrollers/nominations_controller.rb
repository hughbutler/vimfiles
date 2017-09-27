class NominationsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter lambda { current_page 'candidates top_candidate_queue' }

  def index
    @nominations = Nomination.by_community(community_id).where(:is_accepted => false).order('is_accepted, created_at desc')
  end
  def responsibilities
  end
  def activate
    @nomination = Nomination.find(params[:id])
    @nomination.is_accepted = true
    @nomination.save

    @nomination.explode_to_people

    redirect_to(nominations_url, :notice => 'This application has been accepted and transitioned into candidate(s).')
  end
  def new
    @nomination = Nomination.new
    #3.times { @nomination.attribute_answer.build }
    #@attributes = AttributeAnswer.by_community(community_id).by_position('attendee')
  end
  def create
    @nomination = Nomination.new(params[:nomination])
    @nomination.person_id = current_user.person.id
    @nomination.community_id = community_id
    @nomination.is_married = @nomination.is_married_couple? ? true : @nomination.is_married
    respond_to do |format|
      if @nomination.save
        format.html { redirect_to(dashboard_url, :notice => 'Your application was processed.') }
        format.xml  { render :xml => @nomination, :status => :created, :location => @attribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nomination.errors, :status => :unprocessable_entity }
      end
    end
  end
end
