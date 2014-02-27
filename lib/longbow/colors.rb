module Longbow
  # Main Colorize Functions
  def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  # Specific Colors
  def red(text); colorize(text, 31); end
  def green(text); colorize(text, 32); end
  def blue(text); colorize(text, 36); end
end