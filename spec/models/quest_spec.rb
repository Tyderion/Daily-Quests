require 'spec_helper'

describe Quest do
  before :each do
    @quest = FactoryGirl.create(:quest)
  end

  it "should have type quest"
    @quest.type should eql TaskType.id_for "Quest"
  end





end
