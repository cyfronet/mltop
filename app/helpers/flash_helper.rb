module FlashHelper
  def flash_icon(type)
    case type.to_s
    when "notice"; then notice_icon("h-6 w-6 text-green-400")
    when "alert";  then error_icon("h-6 w-6 text-red-400")
    else;               alert_icon("h-6 w-6 text-yellow-400")
    end
  end
end
