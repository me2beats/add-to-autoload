tool
extends Resource
const Utils = preload("utils.gd")
const GlobalSettings = preload("global_settings.tres")
# depends on GlobalSettings singleton

#todo? setting to open_on_warning

var output:RichTextLabel

var not_important_color:Color # undo etc
var print_color:Color
#TODO: add push_message()
enum {
	ERROR,
	WARNING,
	SUCCESS,
}

const props = {
	ERROR: "error_color",
	WARNING: "warning_color",
	SUCCESS: "success_color"
	
}

var default_settings:Dictionary


# this Singleton script uses data (colors) from editor settings via Settings singleton
# init should be called from the plugin

#func init(plugin:EditorPlugin, listen_to_message_request: = true):
func init(plugin:EditorPlugin):

	output = Utils.get_output(plugin.get_editor_interface().get_base_control())
	not_important_color = output.get_color("font_color", "Editor") * Color(1, 1, 1, 0.6)
	print_color = output.get_color("font_color", "Editor")

	var base = plugin.get_editor_interface().get_base_control()
	default_settings = {
		warning_color = [base.get_color("warning_color", "Editor"), TYPE_COLOR],
		error_color = [base.get_color("error_color", "Editor"), TYPE_COLOR],
		success_color = [Color(0.647059, 0.937255, 0.67451), TYPE_COLOR]
	}

	GlobalSettings.init(plugin)
	GlobalSettings.ensure_exist("messages", default_settings)


#	if listen_to_message_request:
#		Engine.connect("message_request", self, "on_message_request")

#func on_message_request(message:String, type:int, id: = ""):
#	if id == "message":
#		push(type, message)



func push(type:int, message:String):
	#TODO: if settings don't exist: use default ones.
	var color:Color = GlobalSettings.get_setting('messages', props[type])
	output.push_color(color)
	output.add_text(message+"\n")
	output.push_color(print_color)


