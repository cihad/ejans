Fabricator :node_type do
  name { Faker::Name.title }
  title_label { Faker::Lorem.word.capitalize }
  description { Faker::Lorem.paragraph }
  filters_position :left
  node_expiration_day_limit 0
  commentable false
  signin_required false
  after_build do |nt|
    nt.administrators << Fabricate(:user)
  end
end

Fabricator :node_type_with_node, from: :node_type do
  after_create do |nt|
    nt.nodes.push([
      Fabricate(:node)
    ])
  end
end

Fabricator :full_featured_node_type, from: :node_type do
  after_create do |nt|
    Fabricate(:belongs_to_config, node_type: nt)
    Fabricate(:boolean_config, node_type: nt)
    Fabricate(:date_config, node_type: nt)
    Fabricate(:has_many_config, node_type: nt)
    Fabricate(:image_config, node_type: nt)
    Fabricate(:integer_config, node_type: nt)
    Fabricate(:list_config, node_type: nt)
    Fabricate(:place_config, node_type: nt)
    Fabricate(:string_config, node_type: nt)
    Fabricate(:tag_config, node_type: nt)
    Fabricate(:tree_category_config, node_type: nt)
  end
end