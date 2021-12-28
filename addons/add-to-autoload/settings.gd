tool
extends Resource
# this script is a singleton to work with settings related to the plugin.
# assumed the plugin stores some global settings in EditorSettings
# init() should be called from the plugin (for example in _enter_tree())

#TODO? make messages optional? (using Settings)

const section_category: = "me2beats_plugins"

var editor_settings:EditorSettings
var default_settings:Dictionary
var section_name:String


# most likely should be refactored
func init(plugin:EditorPlugin, default_settings:Dictionary, section_name:String):
	editor_settings = plugin.get_editor_interface().get_editor_settings()
	self.section_name = section_name
	self.default_settings = default_settings

	# check if has settings, set defaults if no
	var prop:String = default_settings.keys()[0]
	var prop_path = section_category.plus_file(section_name).plus_file(prop)
	if !editor_settings.has_setting(prop_path):
		set_default_settings()

	set_initial_values()


func set_default_settings():
	
	for prop in default_settings:
		var v = default_settings[prop]

		var prop_path = section_category.plus_file(section_name).plus_file(prop)		
		
		var prop_val = v[0]
		editor_settings.set(prop_path, prop_val)
		
		var property_info = {
			 "name": prop_path,
			 "type": v[1],
		}

		editor_settings.add_property_info(property_info)


func set_initial_values():
	
	for prop in default_settings:
		var v = default_settings[prop]

		var prop_path = section_category.plus_file(section_name).plus_file(prop)		
		
		var prop_val = v[0]

		editor_settings.set_initial_value(prop_path, prop_val, false)



# just set value
func set_setting(prop:String, val):
	var prop_path = section_category.plus_file(section_name).plus_file(prop)
	return editor_settings.set_setting(prop_path, val)


func get_setting(prop:String):
	var prop_path = section_category.plus_file(section_name).plus_file(prop)
	return editor_settings.get_setting(prop_path)


func erase_settings(notify: = false):
	if not section_name: return # we don't want erase ALL me2beats settings.
	var prop_start = section_category.plus_file(section_name).plus_file("/")
	var props_to_erase = PoolStringArray()
	for i in editor_settings.get_property_list():
		var prop:String = i.name
		if prop.begins_with(prop_start):
			props_to_erase.push_back(prop)

	for p in props_to_erase:
		editor_settings.erase(p)

	if notify:
		# requires Message.tres in the same folder
		var Message = load(resource_path.get_base_dir().plus_file("message.tres"))
		Message.push(Message.SUCCESS, "Properties erased:\n"+props_to_erase.join("\n"))


	
