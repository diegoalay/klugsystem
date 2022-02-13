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

  def navigation_vue_item(link_path)
    content_tag(:li) do
      content_tag("router-link", :to => link_path) do
        yield
      end
    end
  end
end
