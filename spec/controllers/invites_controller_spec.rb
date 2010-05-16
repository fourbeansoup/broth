require File.dirname(__FILE__) + '/../spec_helper'

describe InvitesController do
  include Devise::TestHelpers
  
  describe "GET 'new'" do
    it "should be successful" do
      Invite.should_receive(:new)
      get :new
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      lambda {
        post :create, :invite => {:email => "tom@test.com"}
      }.should change(Invite, :count)
      response.should redirect_to("/")
    end
    
    it "should render new invite action again when create failed" do
      invite = mock_model(Invite)
      Invite.should_receive(:new).and_return(invite)
      invite.should_receive(:save).and_return(false)
      post :create, :invite => {:email => "tom@test.com"}
      response.should render_template('new')
    end
    
    describe "while signed in" do
      
      before do
        @user = Factory(:valid_user)
        sign_out :user
        sign_in @user
      end
      
      it "should be successful when a logged in user sends an invite" do
        lambda {
          post :create, :invite => {:email => "tom@test.com"}
        }.should change(Invite, :count)
      end
      
      it "should add the inviter when a logged in user sends the invite" do
        post :create, :invite => {:email => "tom@test.com"}
        Invite.first.inviter.should == @user
      end
      
    end
    
  end
end
