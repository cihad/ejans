require 'spec_helper'

describe ViewRenderer do

  it "does render" do
    template = "Hello from <%= @foo %>!"
    context = { foo: "Turkey" }
    expect(ViewRenderer.new(template, context).evaluate).to eq "Hello from Turkey!"
  end

end