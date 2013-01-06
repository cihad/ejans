require 'spec_helper'

describe Metadata do

  let(:node_type) { Fabricate(:node_type, title: "A Sample Node Type") }
  let(:metadata) { Fabricate(:metadata, text: "A Sample Node Type", document: node_type) }

  subject { metadata }

  it { should be_respond_to :text }
  it { should be_respond_to :document }
  it { should be_valid }

  it "#text validation" do
    subject.text = ""
    subject.should_not be_valid
  end

  it "fulltext_search" do
    ["A Sample", "A Sample Node", "A Sample Node Type", "Type", "Node Type", "Sample Node Type"].each do |str|
      subject.class.fulltext_search(str).should be_include metadata
    end
  end

end
