module ApplicationHelper
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : nil 

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end
  
  def shallow_args(parent, child)
    child.try(:new_record?) ? [parent, child] : child
  end
end
