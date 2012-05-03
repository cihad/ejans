# == Schema Information
#
# Table name: accounts
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe Account do

  before { @account = FactoryGirl.build(:account) }
  subject { @account }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:encrypted_password) }
  it { should be_valid }

  it "should have a email name" do 
    @account = FactoryGirl.create(:account, email: "nick@example.com")
    @account.email_name.should == "nick"
  end

  describe "when email is not present" do
    before { @account.email = "" }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |invalid_address|
        @account.email = invalid_address
        @account.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @account.email = valid_address
        @account.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      account_with_same_email = @account.dup
      account_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @account.password = @account.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @account.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when save" do
    before { @account.save }
    it "should set the encrypted password attribute" do
      @account.encrypted_password.should_not be_blank
    end
  end

  describe "service associations" do
    before { @account.save }

    describe "own services" do
      let!(:older_service) do
        FactoryGirl.create(:service, owner: @account, created_at: 1.day.ago)
      end
      let!(:newer_service) do
        FactoryGirl.create(:service, owner: @account, created_at: 1.hour.ago)
      end

      it "should have the right service" do
        @account.own_services.should == [older_service, newer_service]
      end

      it "should destroy associated services" do
        own_services = @account.own_services
        @account.destroy
        own_services.each do |service|
          Service.find_by_id(service.id).should be_nil
        end
      end
    end

    describe "subscribing services" do 
      let!(:service) do
        FactoryGirl.create(:service)
      end

      before { @subscription = Subscription.create(service_id: service.id, account_id: @account.id) }

      it "should have the right services" do
        @account.services.should == [service]        
      end
    end
  end

  describe "subscription association" do
    before do 
      @account.save
      @service = FactoryGirl.create(:service)
      @other_service = FactoryGirl.create(:service)
      @subscription = FactoryGirl.create(:subscription, service: @service, account: @account)
    end

    it "should have the right subscription" do
      @account.subscriptions.should == [@subscription]
    end

    it "should have find the right subscription" do 
      @account.subscription(@service).should == @subscription
    end

    it "should have subscribing service" do
      @account.subscribing?(@service).should be_true
      @account.subscribing?(@other_service).should be_false
    end

    it "should destroy associated subscriptions" do
      subscriptions = @account.subscriptions
      @account.destroy
      subscriptions.each do |s|
        Subscription.find_by_id(s.id).should be_nil
      end
    end

    describe "notice" do
      before do
        @notification = FactoryGirl.create(:notification)
        @notice = FactoryGirl.create(:notice, notification: @notification)
        @notice.subscriptions << @subscription
      end

      it "should have the right notice" do
        @account.notices.should == [@notice]
      end

      it "should destroy notices" do
        notices = @account.notices
        @account.destroy
        notices.each do |n|
          Notice.find_by_id(n.id).should be_nil
        end
      end
    end
  end

  describe "notification association" do
    before do
      @account.save
      @notification = FactoryGirl.create(:notification, notificationable: @account)
    end

    it "should have the right notification" do
      @account.notifications.should == [@notification]
    end

    it "should destroy notifications after account destroy" do
      notifications = @account.notifications
      @account.destroy
      notifications.each do |n|
        Notification.find_by_id(n.id).should be_nil
      end
    end
  end

  describe "comments association" do 
    before do
      @account.save
      @comment = FactoryGirl.create(:comment, author: @account)
    end

    it "should have the right comment" do
      @account.comments.should == [@comment]
    end

    it "should destroy comment" do
      comments = @account.comments
      @account.destroy
      comments.each do |c|
        Comment.find_by_id(c.id).should be_nil
      end
    end
  end
end
