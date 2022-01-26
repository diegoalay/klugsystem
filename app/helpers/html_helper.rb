module HtmlHelper

  def controller_asset_exists?(controller_path, type)
    Klugsystem::Application.assets.find_asset(controller_asset(controller_path, type))
  end

  def controller_asset(controller_path, type)
    [controller_path.to_s, ".", type].join("")
  end
end
