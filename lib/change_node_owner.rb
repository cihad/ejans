class ChangeNodeOwner
  def initialize(node, email)
    @node = node
    @email = email
  end

  def new_author
    @new_author ||= User.find_by(email: @email)
  end

  def save
    @node.author = new_author
    @node.save
  end
end