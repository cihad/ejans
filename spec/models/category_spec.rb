require 'spec_helper'

describe Category do
  
  let(:root_category) { Fabricate(:category) }
  let(:category) { root_category.children.first }
  let(:descendant_category) { category.children.first }

  subject { category }
  # - Top level                     LEVEL 0
  #   - child category 1              LEVEL 1 (<<-----SUBJECT-----<<<<<<<)
  #     - descendant category 1a        LEVEL 2
  #     - descendant category 1b        LEVEL 2
  #   - child category 2              LEVEL 1
  #     - descendant category 2a        LEVEL 2
  #     - descendant category 2b        LEVEL 2


  it { should respond_to :name }
  it { should be_valid }

  it "#name validation" do
    subject.name = ""
    subject.should_not be_valid
  end

  it "#level" do
    root_category.level.should == 0
    subject.level.should == 1
    descendant_category.level.should == 2
  end

  it "#child_nodes=" do
    subject.child_nodes = %q{
      A Sample Category
      Other Sample Category
    }

    subject.save

    ["A Sample Category", "Other Sample Category"].each do |category_name|
      subject.children.map(&:name).should be_include category_name
    end
  end

  it "#parent" do
    subject.parent.should == root_category
  end

  it "#children" do
    subject.children.should be_include descendant_category
  end

end