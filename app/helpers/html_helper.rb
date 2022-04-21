module HtmlHelper

  def controller_asset_exists?(controller_path, type)
    if Rails.env == "development"
      Klugsystem::Application.assets.find_asset(controller_asset(controller_path, type))
    else
      Rails.application.assets_manifest.find_sources(controller_asset(controller_path, type)).any?
    end
  end

  def controller_asset(controller_path, type)
    [controller_path.gsub("/", "_").to_s, ".", type].join("")
  end

  def navigation_vue_item(link_path, classes = [])
    id = link_path.split('/')
    id.shift
    id = id.join('.')

    case id
    when 'crm', 'finance', 'administration', 'inventory', 'hr', 'configurations'
      link_path = "#"
    end

    if current_user.can?(id)
      if link_path == "#"
        content_tag(:a, id: id, class: classes) do
          yield
        end
      else
        content_tag(:li, id: id) do
          content_tag("router-link", to: link_path, class: classes) do
            yield
          end
        end
      end
    end
  end
end
