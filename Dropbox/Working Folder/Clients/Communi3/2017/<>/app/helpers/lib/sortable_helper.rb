module Lib::SortableHelper

    def sortable(column, title = nil)
        uri = {}

        title ||= column.titleize
        uri[:state] = params[:state] ? params[:state] : nil
        uri[:sort] = column


        sort_direction = params[:direction] || 'desc'
        css_class = column == params[:sort] ? "current-sort #{sort_direction}" : nil
        uri[:direction] = column == params[:sort] && sort_direction == "asc" ? "desc" : "asc"

        link_to title, uri , class: css_class

    end
end
