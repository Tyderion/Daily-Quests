# == Schema Information
#
# Table name: subtasks
#
#  id               :integer          not null, primary key
#  subtask_id       :integer
#  task_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  position_in_task :integer
#

require 'spec_helper'

describe Subtask do
  pending "add some examples to (or delete) #{__FILE__}"
end
