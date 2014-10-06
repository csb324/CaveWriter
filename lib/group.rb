class Group

  attr_accessor :name, :members, :project

  def initialize(name)
    @name = name
    @members = []
    $project.add_group(self)
  end

  def add_member(object)
    @members << object
    project.add_object(object)
  end


end
