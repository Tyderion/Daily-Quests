require 'cache/cache_shared_spec'

describe SubtaskCache do
  key_value = Proc.new do
    t = FactoryGirl.create(:task)
    [t.id, t]
    end
  it_should_behave_like "cache", key_value
  describe "store" do
      it "cannot store other things than tasks" do
        subject.store("no_task").should == nil
      end
    end
end
