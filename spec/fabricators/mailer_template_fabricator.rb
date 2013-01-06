Fabricator :mailer_template do
  title { Faker::Name.title }
  subject { Faker::Name.title }
  template %q{
    <%= m.block do %>
      <%= m.block_title Faker::Name.title %>
      <%= m.block_content do %>
        <%= Faker::Lorem.paragraph %>
      <% end %>
    <% end %>}
end