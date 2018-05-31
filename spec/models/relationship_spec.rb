require 'spec_helper'
require 'rails_helper'

describe 'relationship_models' do

  before do
    
   @relationship = Relationship.new(follower_id: create(:michael).id,
                                     followed_id: create(:archer).id)
  end

  it "should be valid" do
    expect(@relationship.valid?).to eq true
  end

  it "should require a follower_id" do
    @relationship.follower_id = nil
    expect(@relationship.valid?).to eq false
  end

  it "should require a followed_id" do
    @relationship.followed_id = nil
    expect(@relationship.valid?).to eq false
  end

  
end