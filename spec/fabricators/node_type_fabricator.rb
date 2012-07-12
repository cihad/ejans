Fabricator :node_type do
  name { Faker::Lorem.words }
  title_label { Faker::Lorem.words(1) }
  title_description { Faker::Lorem.sentences }
  description { Faker::Lorem.paragraph }
end

Fabricator :emlak, class_name: "NodeType" do
  name "Emlak Servisi"
  title_label "Ilan basligi"
  title_description "Baslik icin aciklama"
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