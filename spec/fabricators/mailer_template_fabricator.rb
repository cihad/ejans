Fabricator :mailer_template do
  title { Faker::Name.title }
  subject { Faker::Name.title }
  template %Q{
    <%= m.block do %>
      <%= m.title "#{Faker::Name.title}" %>
      <%= m.block_content do %>
        <p>#{Faker::Lorem.paragraph}</p>
      <% end %>
    <% end %>}
end