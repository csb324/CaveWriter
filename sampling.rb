require_relative 'lib/xml_writer'

@sample = Project.new("sample")

my_name = Text.new("my_name")
my_name.set_content("Clara", depth: 10)

@sample.add_object(my_name)

writer = XmlWriter.new(@sample)
writer.save
