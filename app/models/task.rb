class Task < ActiveRecord::Base
  attr_accessible :title, :description, :private


  validates :title, presence: true
  validates :description, presence: true
  validates :private, presence: true






  def public?
    not private?
  end
end
