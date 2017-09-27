module Lib::DisplayHelper

    def display( lbl, val = nil, false_text = nil, true_text = nil)

        begin
            if val.present?
                if true_text
                    val = send(true_text)
                end
                # val = true_text if true_text
            else
                val = false_text || 'N/A'
            end
        rescue
            val = 'N/A'
        end

        content = content_tag(:span, lbl) + val.html_safe
        content_tag(:li, content, class: 'data-row')

    end

    def svg(name)
        file_path = "#{Rails.root}/app/assets/svgs/#{name}.svg"
        return File.read(file_path).html_safe if File.exists?(file_path)
        fallback_path = "#{Rails.root}/app/assets/images/png/#{name}.png"
        return image_tag("png/#{name}.png") if File.exists?(fallback_path)
        '(not found)'
    end

    def nomination_count
        Nomination.by_community(session[:community_id]).where(:is_accepted => false).order('is_accepted, created_at desc').count
    end

    def page_title
        if session[:community_id].present?
            com = Community.find(session[:community_id])
            if com.present?
                "#{com.title} | "
            end
        end
    end

    def current_page_matches(keys)

        kontroller = controller_name
        action = action_name

        match = false

        keys.each do |key|

            break if match

            # Specific Match (expecting `controller#action` syntax)
            if key.index('#')
                cont_act = key.split('#')
                matches_controller = cont_act[0] == kontroller
                matches_action     = cont_act[1] == action

                match = matches_controller && matches_action

                # Any action on Controller
            else
                matches_controller = key == kontroller || @current_page == kontroller
                match = matches_controller
            end
        end

        return match
    end

    def link_for text, url, keys = [], opts = {}
        klass = 'active' if url == request.fullpath || current_page_matches(keys)

        opts[:class] ||= ''
        opts[:class] += " #{klass}"

        link_to text, url, opts
    end

    def format_date(date, format = :short)
        r = ''

        case format
        when :long
            r = date.strftime('%x at %X')
        when :short
            r = date.strftime("%b %e")
        end

        return r
    end

end
