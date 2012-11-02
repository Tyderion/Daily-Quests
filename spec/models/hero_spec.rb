require 'spec_helper'

describe Hero do
  it "should have a first name" do
    should respond_to :first_name
  end
  it "should have a name" do
    should respond_to :name
  end
  it "should validate the presence of the name" do
    should validate_presence_of :name
  end

  it "should have an email" do
    should respond_to :email
  end
  it "should validate the presence of the email" do
    should validate_presence_of :email
  end
end
