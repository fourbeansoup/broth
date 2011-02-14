require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::EmailsController do
  include Devise::TestHelpers
  fixtures :users
  
  before(:each) do
    sign_out :user
    sign_in Factory(:admin_user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      EmailTemplate.should_receive(:find).with(:all, {:order => "name asc"})
      get 'index'
      response.should be_success
    end
    
    it "should sort on the ascending by default" do
      EmailTemplate.should_receive(:find).with(:all, {:order => "subject asc"})
      get 'index', :sort => "subject"
      response.should be_success
    end
    
    it "should sort descending if asked to" do
      EmailTemplate.should_receive(:find).with(:all, {:order => "subject desc"})
      get 'index', :sort => "subject", :direction => "desc"
      response.should be_success
    end
    
    it "should not accept column names that don't exist and order gracefully by name instead" do
      EmailTemplate.should_receive(:find).with(:all, {:order => "name desc"})
      get 'index', :sort => "this_is_not_a_column", :direction => "desc"
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      EmailTemplate.should_receive(:find).with('1')
      get 'edit', :id => '1'
      response.should be_success
    end
    
  end

  describe "GET 'show'" do
    it "should be successful" do
      EmailTemplate.should_receive(:find).with('1')
      get 'show', :id => '1'
      response.should be_success
    end
  end

  describe "POST 'update'" do
    before do
      @email = Factory(:email_template)
    end
    
    it "should be successful" do
      post :update, :id => @email.id, :email_template => { :body => 'abc', :name => 'booohoo' }
      response.should redirect_to(admin_emails_url)
    end
    
    it "not update email name" do
      post :update, :id => @email.id, :email_template => { :body => 'abc', :name => 'booohoo' }

      @email.reload
      @email.name.should_not == 'booohoo'
      @email.body.should == 'abc'

      flash[:notice].should == "Successfully updated email template"
      response.should redirect_to(admin_emails_url)
    end
    
    it "should handle error in email update" do
      post :update, :id => @email.id, :email_template => { :body => '', :name => 'booohoo' }

      flash[:error].should == "Unable to update email template"
      response.should render_template('edit')
    end
  end
end
