class GameTheme < ApplicationRecord

  def theme_fields
    {
      url_suffix: "/game/index.html?theme="+payload["id"].to_s,
      logo: payload["gameLogo"]
    }
  end
end
