Fabricator :node_type do
  name "Node Type Name"
  title_label "Title label"
  description "Description"
end

Fabricator :emlak, class_name: "NodeType" do
  name "Emlak Servisi"
  title_label "Ilan basligi"
  description "Talimatlar node form icin"

  after_build do |emlak|
    emlak.feature_configurations.push([
      Fabricate.build(:satilik_kiralik_fc),
      Fabricate.build(:aciklama_fc),
      Fabricate.build(:fiyat_fc),
      Fabricate.build(:metrekare_fc),
      Fabricate.build(:mahalle_fc),
      Fabricate.build(:adres_fc),
      Fabricate.build(:fotograflar_fc)
    ])
  end
end