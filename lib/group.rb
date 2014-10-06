class Group

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


end
