require 'spec_helper'

describe NodeType do

  let(:node_type) { Fabricate.build(:node_type) }

  subject { node_type }

  it { should respond_to :name }
  it { should respond_to :title_label }
  it { should respond_to :description }
  it { should respond_to :commentable }
  it { should respond_to :signin_required }
  it { should respond_to :node_expiration_day_limit }
  it { should respond_to :nodes_count }
  
  it "validation" do
    should be_valid
  end

  it "#name validation" do
    subject.name = ""
    subject.should_not be_valid
  end

  it "#title_label validation" do
    subject.title_label = ""
    subject.should_not be_valid
  end

  it "presents node_view association" do
    subject.node_view.should_not be_nil
  end

  it "#nodes_count" do
    subject.nodes_count.should eq(0)
  end

  it "#nodes_count" do
    node = Fabricate.build(:node, node_type: subject)
    subject.save
    subject.nodes_count.should == 0

    node.save
    subject.save
    subject.nodes_count.should == 1
  end

  it "#title_label default value" do
    subject.class.new.title_label.should eq(I18n.t('node_types.default_label'))
  end

  it ".search" do
    subject.save
    subject.class.search(subject.name).should == [subject]
  end

  it "#searchables" do
    subject.name = "Subject Name"
    select_field = Fabricate.build(:select_field, label: "Select Field", node_type: subject)
    select_field.options.build(name: "Option 1")

    ["Subject Name", "Select Field", "Option 1"].each do |key|
      subject.searchables.should be_include key
    end
  end

  it "#related_node_types" do
    subject.save
    belongs_to_field = Fabricate(:belongs_to_field, node_type: subject)
    related_node_type = subject.
                          class.
                          class_name_to_node_type(belongs_to_field.class_name)
    subject.related_node_types.should be_include related_node_type
  end

  it "#node_template_attrs" do
    subject.save
    Fabricate(:integer_field, label: "Integer Field", node_type: subject)
    %w(node node.integer_field integer_field).each do |key|
      subject.node_template_attrs.should be_include key
    end
  end

  it ".class_name_to_node_type" do
    subject.save
    subject.class.class_name_to_node_type("Node#{subject.id}").should == subject
  end

  it "#administrator_email" do
    user = Fabricate(:user, email: "foo@bar.com")
    subject.administrator_email = "foo@bar.com"
    subject.administrators.should be_include user
  end

  it ".sort_by_nodes_count" do
    Fabricate(:node, node_type: subject)
    subject.save

    node_type = Fabricate(:node_type)

    subject.class.sort_by_nodes_count.to_a.should == [subject, node_type]
    subject.class.sort_by_nodes_count(:asc).to_a.should == [node_type, subject]
  end

  describe "#nodes" do
    it "have 0 node" do
      subject.should have(0).nodes
    end

    it "have 1 node" do
      Fabricate(:node, node_type: subject)
      subject.should have(1).nodes
    end

    it "when node_type destroyed should be node destroyed too" do
      subject.save
      node = subject.nodes.build(valid_attributes_for(:node))
      node.save
      subject.destroy
      subject.should have(0).nodes
    end
  end

  describe "#administrators" do
    it "#administrator_ids" do
      should respond_to :administrator_ids
    end

    it "0 administrator" do
      subject.should have(0).administrator
    end

    it "1 administrator" do
      user = Fabricate(:user)
      subject.administrators << user
      subject.should have(1).administrator
    end
  end

  describe "#super_administrator" do
    it "#super_administrator_id" do
      should respond_to :super_administrator_id
    end

    it "#super_administrator" do
      subject.super_administrator = Fabricate(:user)
      subject.super_administrator.should_not be_nil
    end
  end

  describe "#node_type_views" do
    it "have 0 item" do
      subject.node_type_views.should have(0).items
    end

    it "have 1 item" do
      subject.save
      Fabricate(:node_type_view, node_type: subject)
      subject.node_type_views.should have(1).items
    end
  end

  describe "#node_view" do
    it "doesnt be blank" do
      subject.node_view.should_not be_nil
    end
  end

  describe "#mailer_templates" do
    it "have 0 item" do
      subject.mailer_templates.should have(0).items
    end

    it "have 1 item" do
      subject.save
      Fabricate(:mailer_template, node_type: subject)
      subject.mailer_templates.should have(1).items
    end
  end

  describe "#mailers" do
    it "have 0 item" do
      subject.mailers.should have(0).items
    end

    it "have 1 item" do
      mailer_template = Fabricate(:mailer_template, node_type: subject)
      potential_user = Fabricate(:potential_user)
      subject.potential_users << potential_user
      Mailer.new.tap do |mailer|
        mailer.mailer_template_id = mailer_template.id
        mailer.node_type = subject
        mailer.potential_user_ids = subject.potential_user_ids
      end.save

      subject.mailers.should have(1).items
    end
  end

  describe "#potential_users" do
    it "have 0 item" do
      subject.potential_users.should have(0).items
    end

    it "have 1 item" do
      pu = Fabricate(:potential_user)
      subject.potential_users << pu
      subject.potential_users.should have(1).items
    end
  end
end