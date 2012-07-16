Fabricator :list_fc, class_name: "Features::ListFeatureConfiguration" do
  maximum_select 1

  after_build do |list_fc|
    5.times do 
      list_fc.list_items << Fabricate(:list_item)
    end
  end
end

Fabricator :satilik_kiralik_fc, class_name: "Features::FeatureConfiguration" do
  label     "Satilik, kiralik"
  required  true
  help      ""
  filter    true

  after_build do |satilik_kiralik_fc|
    satilik_kiralik_fc.list_feature_configuration = Fabricate.build(:satilik_kiralik_list_fc)
  end
end

Fabricator :satilik_kiralik_list_fc, class_name: "Features::ListFeatureConfiguration" do
  maximum_select 1

  after_build do |satilik_kiralik_list_fc|
    satilik_kiralik_list_fc.list_items.push([
      Fabricate(:bir_arti_bir),
      Fabricate(:iki_arti_bir),
      Fabricate(:uc_arti_bir),
      Fabricate(:studyo)
    ])
  end
end
