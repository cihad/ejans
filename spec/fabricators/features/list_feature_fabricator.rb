Fabricator :list_fc, from: :conf, class_name: "Features::ListFeatureConfiguration" do
  filter false
  maximum_select 1

  after_build do |list_fc|
    5.times do 
      list_fc.list_items << Fabricate(:list_item)
    end
  end
end

Fabricator :satilik_kiralik_fc, from: :conf, class_name: "Features::ListFeatureConfiguration" do
  filter false
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