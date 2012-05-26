# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
1000.times do
  node_type = NodeType.all.sort_by { rand }.first
  node = node_type.nodes.build(title: Faker::Lorem.sentence)

  node_type.feature_configurations.each do |fea_conf|
    if node.features.map(&:feature_configuration_id).include?(fea_conf.id)
      feature = node.features.where(feature_configuration_id: fea_conf.id.to_s).first
    else
      feature = node.features.build
      feature.feature_configuration = fea_conf
      feature.send("build_#{fea_conf.feature_type}")
    end
    feature.feature_object.class.add_value(fea_conf.value_name)
    feature.feature_object.send("#{fea_conf.value_name}=", rand(1000))
  end
  node.save
end

