module ApplicationHelper
  def add_to_cart(flight)
    cookies[:flights] ||= []
    cookies[:flights] << flight
  end
end
