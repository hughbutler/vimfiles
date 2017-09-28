module Lib::FormsHelper

    # Textfield
    def tf form, field, lbl = nil, *opts
        # binding.remote_pry
        lbl = field.to_s.titleize if lbl.nil?
        input = nil

        if opts.present?
            input = form.text_field field, opts[0]
        else
            input = form.text_field field
        end

        return form_row(lbl, input)
    end

    # Textarea
    def ta form, field, lbl = nil
        lbl = field.to_s.titleize if lbl.nil?
        input = form.text_area field

        return form_row(lbl, input)
    end

    # Select
    def s form, field, lbl = nil, opts
        lbl = field.to_s.titleize if lbl.nil?
        input = form.select field, options_for_select(opts, form.object[field])

        return form_row(lbl, input)
    end

    # Checkbox
    def cb form, field, lbl = nil, *opts
        lbl = field.to_s.titleize if lbl.nil?
        input = form.check_box field, opts[0]

        return form_row(lbl, input)
    end

    def form_row lbl, input
        return content_tag(:div, "#{lbl}<br/>#{input}".html_safe)
    end

    # Filter
    def filter_by field, lbl = nil, column_count = 12, *opts
        lbl = field.to_s.titleize if lbl.nil?
        input = nil

        preloaded_value = params['filter'] ? params['filter'][field] : ''

        if opts.present?
            input = text_field_tag "filter[#{field}]", preloaded_value, opts[0]
        else
            input = text_field_tag "filter[#{field}]", preloaded_value
        end

        return form_block(lbl, input, column_count)
    end


    # Textfield
    def textfield_block form, field, lbl = nil, column_count = 12, *opts
        lbl = field.to_s.titleize if lbl.nil?
        input = nil

        if opts.present?
            input = form.text_field field, opts[0]
        else
            input = form.text_field field
        end

        return form_block(lbl, input, column_count)
    end

    # Password
    def password_field_block form, field, lbl = nil, column_count = 12, *opts
        lbl = field.to_s.titleize if lbl.nil?
        input = nil

        if opts.present?
            input = form.text_field field, opts[0]
        else
            input = form.text_field field
        end

        return form_block(lbl, input, column_count)
    end

    def select_block form, field, lbl = nil, collection = [], column_count = 12, options = {}, html_options = {}
        lbl = field.to_s.titleize if lbl.nil?
        input = nil

        input = form.select field, options_for_select(collection, form.object[field]), options, html_options
        # else
        #     input = form.text_field field
        #     input = form.select field, options_for_select(collection, form.object[field])
        # end

        return form_block(lbl, input, column_count)
    end

    def checkbox_block form, field, lbl = nil, column_count = 12, *opts
        lbl = field.to_s.titleize if lbl.nil?
        input = nil

        if opts.present?
            input = form.check_box field, opts[0]
        else
            input = form.check_box field
        end

        return form_block(lbl, input, column_count, true) #true = nested_label
    end

    # Textarea
    def ta form, field, lbl = nil
        lbl = field.to_s.titleize if lbl.nil?
        input = form.text_area field

        return form_row(lbl, input)
    end

    # Select
    def s form, field, lbl = nil, opts
        lbl = field.to_s.titleize if lbl.nil?
        input = form.select field, options_for_select(opts, form.object[:field])

        return form_row(lbl, input)
    end

    # Checkbox
    def cb form, field, lbl = nil, *opts
        lbl = field.to_s.titleize if lbl.nil?
        input = form.check_box field, opts[0]

        return form_row(lbl, input)
    end

    # Textfield
    def textfield_tag_block field, lbl = nil, column_count = 12, *opts
        lbl = field.to_s.titleize if lbl.nil?
        input = nil

        if opts.present?
            input = text_field_tag field, opts[0]
        else
            input = text_field_tag field
        end

        return form_block(lbl, input, column_count)
    end


    # Textfield
    def password_tag_block field, lbl = nil, column_count = 12, *opts
        lbl = field.to_s.titleize if lbl.nil?
        input = nil

        if opts.present?
            input = password_field_tag field, opts[0]
        else
            input = password_field_tag field
        end

        return form_block(lbl, input, column_count)
    end


    def form_block lbl, input, column_count = 12, nested_label = false

        strings = %w(zero one two three four five six seven eight nine ten eleven twelve)
        klass = strings[column_count]

        if nested_label
            return content_tag(:div, "<label>#{input}#{lbl}</label>".html_safe, class: "columns #{klass}")
        else
            return content_tag(:div, "<label>#{lbl}</label>#{input}".html_safe, class: "columns #{klass}")
        end
    end

    def form_row lbl, input
        return content_tag(:div, "#{lbl}<br/>#{input}".html_safe)
    end

    def submit_button label = 'Save', css_classes = ''
        a = content_tag(:a, label, "data-module": "submit-button", class: "submit button #{css_classes}")
        content_tag(:div, a, class: 'actions')
    end

end
