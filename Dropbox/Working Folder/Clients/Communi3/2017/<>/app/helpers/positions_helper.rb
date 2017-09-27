module PositionsHelper

    def positions
        @current_community.positions.collect { |e| [e.title, e.id] }
    end

    def show_categories(position)
        categories = []
        categories << '1' if position.category_1
        categories << '2' if position.category_2
        categories << '3' if position.category_3
        categories << '4' if position.category_4
        categories.join('+')
    end

    def community_positions( search_page = false )
        @options ||= current_community.positions.collect{ |e| [e.title, e.id] }

        unless search_page
            @options.unshift( ['--Candidate--', 0] )
            @options.unshift( ['--none--', nil] )
        else
            @options.unshift( ['--All Positions--', -1] )
        end
    end

end
