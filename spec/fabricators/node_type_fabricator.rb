Fabricator :node_type do
  name { Faker::Name.title }
  title_label { Faker::Lorem.words.join(' ').capitalize }
  description { Faker::Lorem.paragraph }
  node_expiration_day_limit 0
  commentable false
  signin_required false
  after_build do |nt|
    nt.super_administrator = Fabricate(:user)
  end
end

Fabricator :node_type_with_node, from: :node_type do
  after_create do |nt|
    nt.nodes.build.tap do |n|
      n.title = Fabricate.attributes_for(:node)[:title]
      n.author = Fabricate(:user)
      n.save(validate: false)
    end
  end
end

Fabricator :full_featured_node_type, from: :node_type do
  after_create do |nt|
    Fabricate(:belongs_to_field, node_type: nt)
    Fabricate(:boolean_field, node_type: nt)
    Fabricate(:date_field, node_type: nt)
    Fabricate(:image_field, node_type: nt)
    Fabricate(:integer_field, node_type: nt)
    Fabricate(:select_field, node_type: nt)
    Fabricate(:place_field, node_type: nt)
    Fabricate(:string_field, node_type: nt)
    Fabricate(:tag_field, node_type: nt)
    Fabricate(:tree_category_field, node_type: nt)
  end
end