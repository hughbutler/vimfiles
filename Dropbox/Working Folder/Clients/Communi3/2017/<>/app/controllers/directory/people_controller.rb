class Directory::PeopleController < Directory::AuthController

  def index

    @people = current_community.people.members.order('last_name asc, first_name asc')
    alphabet = params[:alpha] ? params[:alpha] : 'a'

    if params[:q]
      query = params[:q]
      @people = current_community.people.where("last_name ILIKE ? or first_name ILIKE ?", '%' + query + '%', '%' + query + '%')
      @people = @people.where("gender = ? OR is_clergy = TRUE", params[:gender])
      @people = @people.collect{ |person| "'#{person.first_name} #{person.last_name}#{' (Clergy)' if person.is_clergy}'|#{person.id}" }.join(",\n")
    else
      @people = current_community.people
    end

    @people = @people.where('last_name ILIKE ?', "#{alphabet}%")

    respond_to do |wants|
      wants.html
      wants.js { render :text => @people }
    end
  end

  def show
    @person = current_community.people.find(params[:id])
    # @login = @person.login
    # @attributes = Attribute.by_community(community_id)
    # @attributes.each do |attribute|
    #   AttributeAnswer.find_or_create_by_attribute_id_and_attributable_id_and_attributable_type( attribute.id, @person.id, 'person' )
    # end
    @attribute_answers = @person.attribute_answers.where(:attributable_id => @person.id, :attributable_type => 'person')
    5.times { @person.outside_position_logs.build }

    respond_to do |wants|
      wants.html
      wants.js { render :json => @person }
    end
  end

  def experience
  end

  def remove
  end

  def new
    @person = Person.new
    @current_page = 'top_add_member'
  end

  def create
    @person = Person.new( params[:person] )

    respond_to do |wants|
      if @person.save
        password = @person.generate_login! # converts candidate to full member and creates login if email present
        if password.present?
          Internal.welcome( @person, password ).deliver
        end

        wants.html { redirect_to @person, :notice => 'Created Pescadore profile. If email was present, password was emailed.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def toggle_sd
    @person = Person.find( params[:id] )
    spiritual_director = !@person.spiritual_director
    @person.update_attribute( 'spiritual_director', spiritual_director )
  end

  def update
    @person = Person.find( params[:id] )
    @person.update_attributes( params[:person] )
    respond_to do |wants|
      wants.html { redirect_to @person, :notice => 'Saved changes successfully' }
      wants.js   { render :json => @person }
    end
  end

  def destroy
    @person = Person.find( params[:id] )
    @person.destroy
    respond_to do |wants|
      wants.html { redirect_to filter_people_url('member'), :notice => 'Saved changes successfully' }
      wants.js   { render :json => @person }
    end
  end

  def filter
    @people = Person.members.by_community(community_id).order('last_name asc, first_name asc')
    @people = @people.where('lower(last_name) LIKE ?', params[:alpha].present? ? "#{params[:alpha].downcase}%" : "a%")
    @current_page = 'top_member'
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