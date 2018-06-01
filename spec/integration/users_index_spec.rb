require 'spec_helper'
require 'rails_helper'
require 'login_helper'

describe "Users_index_Test" , :type => :request do

  include LoginModule
  
  before do
    #@user = create(:michael)
    @admin     = create(:michael)
    @non_admin = create(:archer)
  end

  it "index including pagination" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  it "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end

    expect{
      delete user_path(@non_admin)
    }.to change{
      User.count
    }.by(-1)
  
  end

  it "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end

