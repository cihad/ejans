require 'spec_helper'

Rspec::Matchers.define :allow do |*args|
  match do |permission|
    permission.allow?(*args).should be_true
  end
end

shared_examples "allow_for_everyone" do
  it "for errors"  do
    should allow "errors", "not_found"
  end
end

describe Permission, focus: true do
  let(:signin_required_node_type) { Fabricate(:node_type, signin_required: true) }
  let(:node_type) { Fabricate(:node_type, signin_required: false) }
  
  describe "as anonymous" do
    let(:signin_required_node) { Fabricate(:node, node_type: signin_required_node_type) }
    let(:node) { Fabricate(:node, node_type: node_type) }
    subject { Permission.new(nil, { token: node.token }) }

    it_behaves_like "allow_for_everyone"

    describe "for nodes" do
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
        should_not allow "nodes", "change_status", node
      end

      it "with unvalid token" do
        subject.params[:token] = "thisisaunvalidtoken"
        should_not allow "nodes", "edit", node
        should_not allow "nodes", "update", node
        should_not allow "nodes", "destroy", node
        should_not allow "nodes", "change_status", node
        should_not allow "nodes", "change_status", node_type
      end
    end

    describe "for images" do
      it "with valid token" do
        should allow "images", "update", node
        should allow "images", "destroy", node
        should allow "images", "sort", node
      end

      it "with unvalid token" do
        subject.params[:token] = "thisisaunvalidtoken"
        should_not allow "images", "update", node
        should_not allow "images", "destroy", node
        should_not allow "images", "sort", node
      end
    end

    it "for node_types" do
      should allow "node_types", "index"
      should_not allow "node_types", "new"
      should_not allow "node_types", "create"
      should_not allow "node_types", "show"
      should_not allow "node_types", "edit"
      should_not allow "node_types", "update"
      should_not allow "node_types", "destroy"
      should_not allow "node_types", "manage"
    end

    it "for custom_fields/fields" do
      should_not allow "custom_fields/fields", "index"
      should_not allow "custom_fields/fields", "new"
      should_not allow "custom_fields/fields", "create"
      should_not allow "custom_fields/fields", "show"
      should_not allow "custom_fields/fields", "edit"
      should_not allow "custom_fields/fields", "update"
      should_not allow "custom_fields/fields", "destroy"
    end

    it "for node_type_views" do
      should_not allow "node_type_views", "index"
      should_not allow "node_type_views", "new"
      should_not allow "node_type_views", "create"
      should_not allow "node_type_views", "show"
      should_not allow "node_type_views", "edit"
      should_not allow "node_type_views", "update"
      should_not allow "node_type_views", "destroy"
      should_not allow "node_type_views", "sort"
    end

    it "for mailers" do
      should_not allow "mailers", "index"
      should_not allow "mailers", "new"
      should_not allow "mailers", "create"
      should_not allow "mailers", "show"
      should_not allow "mailers", "edit"
      should_not allow "mailers", "update"
      should_not allow "mailers", "destroy"
    end

    it "for potential_users" do
      should_not allow "potential_users", "index"
      should_not allow "potential_users", "new"
      should_not allow "potential_users", "create"
      should_not allow "potential_users", "show"
      should_not allow "potential_users", "edit"
      should_not allow "potential_users", "update"
      should_not allow "potential_users", "destroy"
    end

    it "for comments" do
      should allow "comments", "create"
      should_not allow "comments", "destroy"
    end
  end


  describe "as registered" do
    let(:node_type)  { Fabricate(:node_type) }
    let(:user)       { Fabricate(:user) }
    let(:node)       { Fabricate(:node, node_type: node_type, author: user) }
    let(:other_node) { Fabricate(:node, node_type: node_type) }
    subject          { Permission.new(user) }

    it_behaves_like "allow_for_everyone"

    it "for nodes" do
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
      should_not allow "nodes", "change_status", node
      should_not allow "nodes", "manage", node
    end
    
    it "for images" do
      should allow "images", "update", node
      should allow "images", "destroy", node
      should allow "images", "sort", node
      should_not allow "images", "update", other_node
      should_not allow "images", "destroy", other_node
      should_not allow "images", "sort", other_node
    end

    context "node_types" do
      it "for default actions" do
        should allow "node_types", "index"
        should_not allow "node_types", "new"
        should_not allow "node_types", "create"
      end

      it "for when not an administrator" do
        should_not allow "node_types", "show", node_type
        should_not allow "node_types", "edit", node_type
        should_not allow "node_types", "update", node_type
        should_not allow "node_types", "destroy", node_type
        should_not allow "node_types", "manage", node_type
        should_not allow "nodes", "change_status", node
      end

      it "for when an administrator" do
        node_type.administrators << user
        should allow "node_types", "show", node_type
        should allow "node_types", "edit", node_type
        should allow "node_types", "update", node_type
        should_not allow "node_types", "destroy", node_type
        should allow "node_types", "manage", node_type
        should allow "nodes", "change_status", node
      end

      it "for when a super administrator" do
        permission = Permission.new(node_type.super_administrator)
        permission.should allow "node_types", "show", node_type
        permission.should allow "node_types", "edit", node_type
        permission.should allow "node_types", "update", node_type
        permission.should allow "node_types", "destroy", node_type
        permission.should allow "node_types", "manage", node_type
        permission.should allow "nodes", "change_status", node
      end
    end

    context "node_type administrative page" do
      let(:super_administrator) { node_type.super_administrator }
      let(:administrator)  { Fabricate(:user) }

      before do
        node_type.administrators << administrator
      end

      context "as registered" do
        it "for custom_fields/fields" do
          should_not allow "custom_fields/fields", "index", node_type
          should_not allow "custom_fields/fields", "new", node_type
          should_not allow "custom_fields/fields", "create", node_type
          should_not allow "custom_fields/fields", "update", node_type
          should_not allow "custom_fields/fields", "destroy",node_type
          should_not allow "custom_fields/fields", "sort", node_type
        end

        it "for node_type_views" do
          should_not allow "node_type_views", "index", node_type
          should_not allow "node_type_views", "new", node_type
          should_not allow "node_type_views", "create", node_type
          should_not allow "node_type_views", "update", node_type
          should_not allow "node_type_views", "destroy",node_type
          should_not allow "node_type_views", "sort", node_type
        end

        it "for mailers" do
          should_not allow "mailers", "index", node_type
          should_not allow "mailers", "new", node_type
          should_not allow "mailers", "create", node_type
          should_not allow "mailers", "show", node_type
          should_not allow "mailers", "edit", node_type
          should_not allow "mailers", "update", node_type
          should_not allow "mailers", "destroy", node_type
        end

        it "for potential_users" do
          should_not allow "potential_users", "index", node_type
          should_not allow "potential_users", "new", node_type
          should_not allow "potential_users", "create", node_type
          should_not allow "potential_users", "destroy", node_type
        end

        it "for manage" do
          should_not allow "nodes", "manage", node_type
        end
      end

      context "as administrator" do
        subject { Permission.new(administrator) }

        it "for custom_fields/fields" do
          should allow "custom_fields/fields", "index", node_type
          should allow "custom_fields/fields", "new", node_type
          should allow "custom_fields/fields", "create", node_type
          should allow "custom_fields/fields", "update", node_type
          should allow "custom_fields/fields", "destroy",node_type
          should allow "custom_fields/fields", "sort", node_type
        end

        it "for node_type_views" do
          should allow "node_type_views", "index", node_type
          should_not allow "node_type_views", "new", node_type
          should_not allow "node_type_views", "create", node_type
          should_not allow "node_type_views", "update", node_type
          should_not allow "node_type_views", "destroy",node_type
          should allow "node_type_views", "sort", node_type
        end

        it "for mailers" do
          should allow "mailers", "index", node_type
          should_not allow "mailers", "new", node_type
          should_not allow "mailers", "create", node_type
          should allow "mailers", "show", node_type
          should_not allow "mailers", "edit", node_type
          should_not allow "mailers", "update", node_type
          should allow "mailers", "destroy", node_type
        end

        it "for potential_users" do
          should allow "potential_users", "index", node_type
          should allow "potential_users", "new", node_type
          should allow "potential_users", "create", node_type
          should allow "potential_users", "destroy", node_type
        end

        it "for manage" do
          should allow "nodes", "manage", node_type
        end
      end

      context "as super administrator" do
        subject { Permission.new(super_administrator) }

        it "for custom_fields/fields" do
          should allow "custom_fields/fields", "index", node_type
          should allow "custom_fields/fields", "new", node_type
          should allow "custom_fields/fields", "create", node_type
          should allow "custom_fields/fields", "update", node_type
          should allow "custom_fields/fields", "destroy",node_type
          should allow "custom_fields/fields", "sort", node_type
        end

        it "for node_type_views" do
          should allow "node_type_views", "index", node_type
          should allow "node_type_views", "new", node_type
          should allow "node_type_views", "create", node_type
          should allow "node_type_views", "update", node_type
          should allow "node_type_views", "destroy",node_type
          should allow "node_type_views", "sort", node_type
        end

        it "for mailers" do
          should allow "mailers", "index", node_type
          should allow "mailers", "new", node_type
          should allow "mailers", "create", node_type
          should allow "mailers", "show", node_type
          should allow "mailers", "edit", node_type
          should allow "mailers", "update", node_type
          should allow "mailers", "destroy", node_type
        end

        it "for potential_users" do
          should allow "potential_users", "index", node_type
          should allow "potential_users", "new", node_type
          should allow "potential_users", "create", node_type
          should allow "potential_users", "destroy", node_type
        end

        it "for manage" do
          should_not allow "nodes", "manage", node_type
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