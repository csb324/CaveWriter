require 'nokogiri'
require_relative 'project'

class XmlWriter

  def initialize(project)
    @project = project
    @objects = project.objects.uniq
    @timelines = project.timelines
    @groups = project.groups
    @global = project.global
    @walls = project.walls
  end

  def written_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.Story(version: 8, last_xpath: "/Story") {

        # ADDING OBJECTS
        xml.ObjectRoot {
          @objects.each do |obj|
            xml.Object(name: obj.name) {
              xml.Color obj.color
              xml.Visible obj.visible
              xml.Scale obj.scale
              xml.Lighting obj.lighting
              xml.ClickThrough obj.clickthrough
              xml.AroundSelfAxis obj.aroundselfaxis

              placement(xml, obj)

              xml.Content {
                if obj.is_text?
                  xml.Text({
                    "horiz-align" => obj.horiz_align,
                    "vert-align" => obj.vert_align,
                    "font" => obj.font,
                    "depth" => obj.depth}
                  ) {
                    xml.text_ obj.text_content
                  }
                elsif obj.is_light?
                  xml.Light({diffuse: obj.diffuse, specular: obj.specular, const_atten: obj.const_atten, lin_atten: obj.lin_atten, quad_atten: obj.quad_atten}) {
                    case obj.type
                    when :point
                      xml.Point
                    when :directional
                      xml.Directional
                    when :spot
                      xml.Spot({angle: obj.angle})
                    end
                  }
                end
              }
            }
          end
        } # END OF ADDING OBJECTS

        # ADDING GROUPS
        xml.GroupRoot {
          @groups.each do |group|
            xml.Group(name: group.name) {
              group.members.each do |member|
                if member.is_object
                  xml.Objects(name: member.name)
                else
                  xml.Groups(name: member.name)
                end
              end
            }
          end
        } # end of groups

        # ADDING TIMELINES
        xml.TimelineRoot {

          if @timelines
            @timelines.each do |timeline|
              xml.Timeline({"name" => timeline.name, "start-immediately" => timeline.start_immediately}) {
                timeline.actions.each do |action|
                  xml.TimedActions({"seconds-time" => action.delay}) {
                    if action.object
                      xml.ObjectChange(name: action.object.name) {
                        action_script(xml, action)
                      }
                    elsif action.group
                      xml.GroupRef(name: action.group.name) {
                        action_script(xml, action)
                      }
                    elsif action.timeline
                      xml.TimerChange(name: action.timeline.name) {
                        if action.type == "start_timer"
                          xml.start
                        end
                      }
                    end
                  }
                end
              }
            end
          end
        } # end of timelines

        # placement -- as far as I know, this is just the placement of the walls??
        xml.PlacementRoot {
          xml.Placement(name: "Center") {
            xml.RelativeTo "Center"
            xml.Position "(0.0, 0.0, 0.0)"
            xml.Axis(rotation: "(0.0, 1.0, 0.0)", angle: "0.0")
          }

          @walls.each do |wall|
            xml.Placement(name: wall.name) {
              xml.RelativeTo "Center"
              xml.Position wall.position
              xml.LookAt(target: "(0.0, 0.0, 0.0)", up: wall.look_up)
            }
          end
        }

        # ADDING GLOBAL STUFF
        xml.Global {
          xml.CameraPos({"far-clip" => "100.0"}) {
            xml.Placement {
              xml.RelativeTo "Center"
              xml.Position @global[:preview_start_position]
            }
          }
          xml.CaveCameraPos({"far-clip" => "100.0"}) {
            xml.Placement {
              xml.RelativeTo "Center"
              xml.Position @global[:cave_start_position]
            }
          }
          xml.Background(color: @global[:color])
          xml.WandNavigation({
            "allow-rotation" => @global[:wand_navigation][:allow_rotation],
            "allow-movement" => @global[:wand_navigation][:allow_movement]
            })

        } # end of global
      }
    end

    metadata = "<?xml version='1.0' encoding='UTF-8'?><?jaxfront version=2.1;time=2014-09-22 19:52:31.415;xui=jar:file:/Users/clarabeyer/Documents/fall14/CaveWriting/CWEditor.jar!/schema/caveschema.xui;xsd=caveschema.xsd?>"
    file = metadata + " " + builder.doc.root.to_s
    file
  end

  def action_script(xml, action)
    xml.Transition(duration: action.duration) {
      if action.type == "move_rel"
        xml.MoveRel {
          placement(xml, action)
        }
      elsif action.type == "move_abs"
        xml.Movement {
          placement(xml, action)
        }
      elsif action.type == "fade"
        xml.Visible action.visible
      end
    }
  end

  def placement(xml, thing)
    xml.Placement {
      if thing.respond_to?(:relative_to) && thing.relative_to != nil
        xml.RelativeTo thing.relative_to
      else
        xml.RelativeTo "Center"
      end
      xml.Position thing.position
      if thing.rotation
        xml.Axis(rotation: thing.rotation[:axis], angle: thing.rotation[:angle])
      end
    }
  end

  def save
    Dir.mkdir(@project.name) unless File.exists?(@project.name)

    timestamp = "#{Time.now.month}-#{Time.now.day}-#{Time.now.hour}-#{Time.now.min}"
    filename = @project.name + "/" + @project.name + timestamp + ".xml"

    File.open(filename, 'w') do |file|
      file.write(written_xml)
    end

  end

end
