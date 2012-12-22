require 'spec_helper'

Rspec::Matchers.define :allow do |*args|
  match do |permission|
    permission.allow?(*args).should be_true
  end
end

describe Permission, focus: true do
  let(:signin_required_node_type) { Fabricate(:node_type, signin_required: true) }
  let(:node_type) { Fabricate(:node_type, signin_required: false) }
  
  describe "as anonymous" do
    let(:signin_required_node) { Fabricate(:node, node_type: signin_required_node_type) }
    let(:node) { Fabricate(:node, node_type: node_type) }
    subject { Permission.new(nil, { token: node.token }) }

    describe "nodes" do
      it "with valid token" do
        should allow "nodes", "index"
        should_not allow "nodes", "new", signin_required_node
        should_not allow "nodes", "create", signin_required_node
        should allow "nodes", "new", node
        should allow "nodes", "create", node
        should allow "nodes", "show"
        should allow "nodes", "edit", node
        should allow "nodes", "update", node
        should allow "nodes", "destroy", node
      end

      it "with unvalid token" do
        subject.params[:token] = "thisisaunvalidtoken"
        should_not allow "nodes", "edit", node
        should_not allow "nodes", "update", node
        should_not allow "nodes", "destroy", node 
      end
    end

    describe "images" do
      it "with valid token" do
        should allow "images", "create", node
        should allow "images", "destroy", node
        should allow "images", "sort", node
      end

      it "with unvalid token" do
        subject.params[:token] = "thisisaunvalidtoken"
        should_not allow "images", "create", node
        should_not allow "images", "destroy", node
        should_not allow "images", "sort", node
      end
    end

    it "node_types" do
      should allow "node_types", "index"
      should_not allow "node_types", "new"
      should_not allow "node_types", "create"
      should_not allow "node_types", "show"
      should_not allow "node_types", "edit"
      should_not allow "node_types", "update"
      should_not allow "node_types", "destroy"
    end

    it "fields" do
      should_not allow "fields", "index"
      should_not allow "fields", "new"
      should_not allow "fields", "create"
      should_not allow "fields", "show"
      should_not allow "fields", "edit"
      should_not allow "fields", "update"
      should_not allow "fields", "destroy"
    end

    it "views" do
      should_not allow "views", "index"
      should_not allow "views", "new"
      should_not allow "views", "create"
      should_not allow "views", "show"
      should_not allow "views", "edit"
      should_not allow "views", "update"
      should_not allow "views", "destroy"
    end

    it "marketing" do
      should_not allow "marketing", "index"
      should_not allow "marketing", "new"
      should_not allow "marketing", "create"
      should_not allow "marketing", "show"
      should_not allow "marketing", "edit"
      should_not allow "marketing", "update"
      should_not allow "marketing", "destroy"
    end

    it "potential_users" do
      should_not allow "potential_users", "index"
      should_not allow "potential_users", "new"
      should_not allow "potential_users", "create"
      should_not allow "potential_users", "show"
      should_not allow "potential_users", "edit"
      should_not allow "potential_users", "update"
      should_not allow "potential_users", "destroy"
    end

    it "comments" do
      should allow "comments", "create"
      should_not allow "comments", "destroy"
    end
  end


  describe "as registered" do
    let(:user) { u = Fabricate(:user); u.make_registered!; u }
    let(:node) { Fabricate(:node, author: user) }
    let(:other_node) { Fabricate(:node) }
    let(:node_type) { Fabricate(:node_type) }
    subject { Permission.new(user) }

    it "nodes" do
      should allow "nodes", "index"
      should allow "nodes", "new"
      should allow "nodes", "create"
      should allow "nodes", "show"
      should allow "nodes", "edit", node
      should allow "nodes", "update", node
      should allow "nodes", "destroy", node
      should_not allow "nodes", "edit", other_node
      should_not allow "nodes", "update", other_node
      should_not allow "nodes", "destroy", other_node
    end
    
    it "images" do
      should allow "images", "create", node
      should allow "images", "destroy", node
      should allow "images", "sort", node
      should_not allow "images", "create", other_node
      should_not allow "images", "destroy", other_node
      should_not allow "images", "sort", other_node
    end

    context "node_types" do

      it "default actions" do
        should allow "node_types", "index"
        should_not allow "node_types", "new"
        should_not allow "node_types", "create"
      end

      it "when not an administrator" do
        should_not allow "node_types", "show", node_type
        should_not allow "node_types", "edit", node_type
        should_not allow "node_types", "update", node_type
        should_not allow "node_types", "destroy", node_type
      end

      it "when an administrator" do
        node_type.administrators << user
        should allow "node_types", "show", node_type
        should allow "node_types", "edit", node_type
        should allow "node_types", "update", node_type
        should_not allow "node_types", "destroy", node_type
      end

      it "when a super administrator" do
        permission = Permission.new(node_type.super_administrator)
        permission.should allow "node_types", "show", node_type
        permission.should allow "node_types", "edit", node_type
        permission.should allow "node_types", "update", node_type
        permission.should allow "node_types", "destroy", node_type
      end
    end

    context "node_type administrative page" do
      let(:super_administrator) { node_type.super_administrator }
      let(:administrator)  { Fabricate(:user) }

      before do
        node_type.administrators << administrator
      end

      context "as registered" do
        it "fields" do
          should_not allow "fields", "index", node_type
          should_not allow "fields", "new", node_type
          should_not allow "fields", "create", node_type
          should_not allow "fields", "update", node_type
          should_not allow "fields", "destroy",node_type
          should_not allow "fields", "sort", node_type
        end

        it "views" do
          should_not allow "views", "index", node_type
          should_not allow "views", "new", node_type
          should_not allow "views", "create", node_type
          should_not allow "views", "update", node_type
          should_not allow "views", "destroy",node_type
          should_not allow "views", "sort", node_type
        end

        it "marketing" do
          should_not allow "marketing", "index", node_type
          should_not allow "marketing", "new", node_type
          should_not allow "marketing", "create", node_type
          should_not allow "marketing", "show", node_type
          should_not allow "marketing", "edit", node_type
          should_not allow "marketing", "update", node_type
          should_not allow "marketing", "destroy", node_type
        end

        it "potential_users" do
          should_not allow "potential_users", "index", node_type
          should_not allow "potential_users", "new", node_type
          should_not allow "potential_users", "create", node_type
          should_not allow "potential_users", "destroy", node_type
        end        
      end

      context "as administrator" do
        subject { Permission.new(administrator) }

        it "fields" do
          should allow "fields", "index", node_type
          should allow "fields", "new", node_type
          should allow "fields", "create", node_type
          should allow "fields", "update", node_type
          should allow "fields", "destroy",node_type
          should allow "fields", "sort", node_type
        end

        it "views" do
          should allow "views", "index", node_type
          should_not allow "views", "new", node_type
          should_not allow "views", "create", node_type
          should_not allow "views", "update", node_type
          should_not allow "views", "destroy",node_type
          should allow "views", "sort", node_type
        end

        it "marketing" do
          should allow "marketing", "index", node_type
          should_not allow "marketing", "new", node_type
          should_not allow "marketing", "create", node_type
          should allow "marketing", "show", node_type
          should_not allow "marketing", "edit", node_type
          should_not allow "marketing", "update", node_type
          should allow "marketing", "destroy", node_type
        end

        it "potential_users" do
          should allow "potential_users", "index", node_type
          should allow "potential_users", "new", node_type
          should allow "potential_users", "create", node_type
          should allow "potential_users", "destroy", node_type
        end
      end

      context "as super administrator" do
        subject { Permission.new(super_administrator) }

        it "fields" do
          should allow "fields", "index", node_type
          should allow "fields", "new", node_type
          should allow "fields", "create", node_type
          should allow "fields", "update", node_type
          should allow "fields", "destroy",node_type
          should allow "fields", "sort", node_type
        end

        it "views" do
          should allow "views", "index", node_type
          should allow "views", "new", node_type
          should allow "views", "create", node_type
          should allow "views", "update", node_type
          should allow "views", "destroy",node_type
          should allow "views", "sort", node_type
        end

        it "marketing" do
          should allow "marketing", "index", node_type
          should allow "marketing", "new", node_type
          should allow "marketing", "create", node_type
          should allow "marketing", "show", node_type
          should allow "marketing", "edit", node_type
          should allow "marketing", "update", node_type
          should allow "marketing", "destroy", node_type
        end

        it "potential_users" do
          should allow "potential_users", "index", node_type
          should allow "potential_users", "new", node_type
          should allow "potential_users", "create", node_type
          should allow "potential_users", "destroy", node_type
        end
      end
    end

    context "comments" do
      let(:comment) { Fabricate(:comment, author: user, node: node)  }

      specify do 
        should allow "comments", "create"
        should allow "comments", "destroy", comment
      end
    end

  end

end