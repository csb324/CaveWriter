require_relative 'actionable'

class Group

  include Actionable

  attr_accessor :name, :members, :project

  def initialize(name)
    @name = name
    @members = []
    $project.add_group(self)
  end

  def add_member(something)
    @members << something
  end

  def is_object
    false
  end

  def is_group
    true
  end

end
