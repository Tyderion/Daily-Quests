class Task < ActiveRecord::Base
  attr_accessible :title, :description, :private, :typ
  include RailsLookup
  lookup :task_type, as: :typ


  validates :title, presence: true
  validates :description, presence: true


  def visibility
    private? ? I18n.t('task.private') : I18n.t('task.public')
  end

  def not_visibility
    private? ?  I18n.t('task.public') : I18n.t('task.private')
  end


  def public?
    not private?
  end
end
