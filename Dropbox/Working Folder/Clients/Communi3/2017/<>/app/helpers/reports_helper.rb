module ReportsHelper
  def current_category(num)
    if params[:category].present?
      params[:category].include?(num.to_s)
    else
      false
    end
  end

  def render_positions( num )
    #eval( "current_community.positions.category_#{num}.map(&:title).join(', ')" )
    current_community.positions.send("category_#{num}").map(&:title).join(', ')
  end

  def experience_groups
    options = Community.find(community_id).events.collect{ |e| ["#{e.title} (#{e.gender})", e.id] }
    options.unshift( ['--Outside Experience--', -1] )
    options.unshift( ['--All Weekends--', 0] )
  end
end
