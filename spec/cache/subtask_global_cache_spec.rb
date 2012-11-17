require 'cache/cache_shared_spec'

describe GlobalSubtaskCache do
  key_value_return = Proc.new do
    t = FactoryGirl.create(:task)
    #key, value, key_to_retrieve_with(abstraction), value_retrieved
    [t.id, t, t , [t, []]  ]
    end
  it_should_behave_like "global-cache", key_value_return
  describe "store" do
      it "cannot store other things than tasks" do
        subject.store("no_task").should == nil
      end
    end
end
