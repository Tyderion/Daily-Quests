class Task < ActiveRecord::Base
  attr_accessible :title, :description, :private, :typ
  include RailsLookup
  lookup :task_type, as: :typ


  validates :title, presence: true
  validates :description, presence: true






  def public?
    not private?
  end
end
