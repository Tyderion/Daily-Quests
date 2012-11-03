require 'spec_helper'

before :each do
  @quest = FactoryGirl.create(:quest)
  @questseries = FactoryGirl.create(:questseries)
end
describe "states" do
  describe ":active" do
    it "should respond to active?" do
      expect { @quest.active? }.to_not raise_error
    end
    it "should respond to active?" do
      expect { @questseries.active? }.to_not raise_error
    end
  end
  describe ":inactive" do
    it "should respond to inactive?" do
      expect { @quest.inactive? }.to_not raise_error
    end
    it "should respond to inactive?" do
      expect { @questseries.inactive? }.to_not raise_error
    end
  end

  describe ":recurring" do
    it "should respond to recurring?" do
      expect { @quest.recurring? }.to_not raise_error
    end
    it "should respond to recurring?" do
      expect { @questseries.recurring? }.to_not raise_error
    end
  end
end
