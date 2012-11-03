require 'spec_helper'

describe Quest do
  before :each do
    @questseries = FactoryGirl.create(:questseries)
  end

  it "should have type quest"
    @quest.type should eql TaskType.id_for "Questseries"
  end





end
