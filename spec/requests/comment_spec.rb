require 'spec_helper'

describe "Comment" do
  let(:node_type) { Fabricate(:node_type) }
  let(:super_administrator) { node_type.super_administrator }
  let(:user) { Fabricate(:user) }
  let(:node) { make_node(node_type, user) }

  before do
    node.publish!
  end

  it "adds a comment", js: true do
    signin user

    visit node_type_node_path(node_type, node)

    comment_body = valid_attributes_for(:comment)[:body]

    fill_in "comment_body", with: comment_body
    click_button t('helpers.submit.create')

    page.should have_content comment_body
  end

  it "deletes a comment", js: true do
    signin user

    comment = Fabricate(:comment, node: node, author: user)

    visit node_type_node_path(node_type, node)

    within "#comment_#{comment.id}" do
      click_on t('actions.delete')
    end

    alert.accept

    sleep 1

    page.should_not have_content comment.body
  end

end