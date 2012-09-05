Fabricator :place, class_name: "Place" do
  name { sequence(:name) { |i| "#{i}" } }
  hierarchy "level1, level2, level3, level4"
end

Fabricator :child_place, class_name: "Place" do
  name { sequence(:name) { |i| "#{i}" } }
end

Fabricator :turkiye, class_name: "Place" do
  name "Turkiye"
  hierarchy "sehir, ilce, mahalle"

  after_build do |turkiye|
    turkiye.children.push([
      Fabricate(:eskisehir)
    ])
  end
end

Fabricator :eskisehir, class_name: "Place" do
  name "Eskisehir"

  after_build do |esk|
    esk.children.push([
      Fabricate(:odunpazari)
    ])
  end
end

Fabricator :odunpazari, class_name: "Place" do
  name "Odunpazari"

  after_build do |odp|
    odp.children.push([
      Fabricate(:kurtulus)
    ])
  end
end

Fabricator :kurtulus, class_name: "Place" do
  name "Kurtulus Mah"
end