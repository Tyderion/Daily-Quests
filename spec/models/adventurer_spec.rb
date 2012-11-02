# == Schema Information
#
# Table name: adventurers
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
#

require 'spec_helper'

describe Adventurer do
  before :each do
    @adv = Adventurer.new
  end

  it "should have a first name" do
    @adv.should respond_to :first_name
  end
  it "should have a last name" do
    @adv.should respond_to :last_name
  end
  it "should validate the presence of the last name" do
    @adv.should validate_presence_of :last_name
  end

end