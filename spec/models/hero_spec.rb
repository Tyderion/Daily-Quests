# == Schema Information
#
# Table name: heroes
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  last_name              :string(255)
#  first_name             :string(255)
#

require 'spec_helper'

describe Hero do

  it "has a valid factory" do
    FactoryGirl.create(:hero).should be_valid
  end


  it "has a first_name" do
    should respond_to :first_name
  end
  it "has a last_name" do
    should respond_to :last_name
  end
  it "has an email" do
    should respond_to :email
  end

  it "is invalid without a last_name" do
    FactoryGirl.build(:hero, last_name: nil).should_not be_valid
  end

  it "is invalid without an email" do
    FactoryGirl.build(:hero, email: nil).should_not be_valid
  end

  describe "name" do
    it "returns a heroes' full name as a string" do
    contact = FactoryGirl.create(:hero, first_name: "John", last_name: "Doe")
    contact.name.should == "John Doe"
  end
end


end
