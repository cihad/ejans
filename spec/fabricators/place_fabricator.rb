Fabricator :turkiye, class_name: "Place" do
  name "Turkiye"

  after_build do |turkiye|
    turkiye.child_places.push([
      Fabricate(:eskisehir)
    ])
  end
end

Fabricator :eskisehir, class_name: "Place" do
  name "Eskisehir"

  after_build do |esk|
    esk.child_places.push([
      Fabricate(:odunpazari)
    ])
  end
end

Fabricator :odunpazari, class_name: "Place" do
  name "Odunpazari"

  after_build do |odp|
    odp.child_places.push([
      Fabricate(:kurtulus)
    ])
  end
end

Fabricator :kurtulus, class_name: "Place" do
  name "Kurtulus Mah"
end