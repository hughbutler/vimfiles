module Lib::TemplateHelper

    def side_column

        set_in_view = content_for? :aside
        set_in_controller = (defined?(path_to_side_column) && path_to_side_column.present?)

        html = ''

        if set_in_view
            # html = yield(:aside)
            html = content_for :aside

        elsif set_in_controller

            filepath = [ Rails.root, 'app', 'views', "#{path_to_side_column}.html.haml" ].join('/')

            # Does file exist in aside/*/controller_name/action_name.html.haml
            if File.file? filepath
                html = render file: filepath
            end

        else
            root = Rails.root.join('app', 'views', 'aside').to_s

            uri = request.path
            uri = uri[1..999] if uri[0] == '/'
            uri = uri.split('/').reject { |e| e.empty? }

            # figure out best way to offer
            # action-based
            filepath = [root, controller_name, "#{action_name}.html.haml"].join('/')


            if File.file? filepath
                html = render file: filepath
            else
                if uri.length > 0
                    i = uri.index(controller_name)

                    controller_based_path = uri.slice(0, i+1)
                    filepath = [root, controller_based_path, "layout.html.haml"].join('/')
                    if File.file? filepath
                        html = render file: filepath
                    end
                end
            end

            # if %w(show, edit).include? action_name
            #     uri = uri.split('/').reject { |e| e.empty? }
            #     uri.pop(2)
            #     # uri[uri.length-1] = 'show'
            #     uri = uri.join('/')
            # end
            #
            # filepath = [root, uri, "layout.html.haml"].join('/')

            # Does file exist in aside/*/controller_name/action_name.html.haml
            # if File.file? filepath
            #     html = render file: filepath
            # else
            #     filepath = [root, "#{uri}/#{action_name}.html.haml"].join('/')
            #     if File.file? filepath
            #         html = render file: filepath
            #     end
            # end
        end

        @side_column_content ||= html

        return @side_column_content
    end

end
