class GameTheme < ApplicationRecord

  def theme_fields
    {
      url_suffix: "/game/?theme="+payload["id"].to_s,
      logo: payload["gameLogo"]
    }
  end
end
