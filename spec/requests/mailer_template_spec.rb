require 'spec_helper'

describe MailerTemplate do

  let(:node_type) { Fabricate(:node_type) }
  let(:super_administrator) { node_type.super_administrator }

  it "creates a mailer template" do
    signin super_administrator

    visit new_node_type_mailer_template_path(node_type)

    attributes = valid_attributes_for(:mailer_template)

    fill_in "mailer_template_title", with: attributes[:title]
    fill_in "mailer_template_subject", with: attributes[:subject]
    fill_in "mailer_template_template", with: attributes[:template]

    click_button t('helpers.submit.create')

    page.should have_content attributes[:title]
  end


end