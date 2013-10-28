module SearchesHelper
  def rating_percentage(likes, dislikes)
    total = likes + dislikes
    if total != 0 then
      percentage = likes.to_f/total.to_f * 100
      percentage.round(0).to_s + "%"
    else
      "None"
    end
  end
end
