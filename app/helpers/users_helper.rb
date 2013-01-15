module UsersHelper
  def user_navigation
    content_tag(:ul, class: "nav pull-right") { render 'users/nav' }
  end
end