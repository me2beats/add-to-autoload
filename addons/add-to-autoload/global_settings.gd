tool
extends Resource
# this script is a singleton to work with global settings, NOT related to any plugin.
# assumed the plugin stores some global settings in EditorSettings
# init() should be called from the plugin (for example in _enter_tree())

const section_category: = "me2beats_plugins"

var editor_settings:EditorSettings
#var default_settings:Dictionary
const section_name:String = "global"

#TODO? property like "if inited"

func init(plugin:EditorPlugin):
	editor_settings = plugin.get_editor_interface().get_editor_settings()

func get_prop_path(prop_group:String, prop:String):
	return section_category.plus_file(section_name).plus_file(prop_group).plus_file(prop)

func has_default_settings(property_group:String, default_settings:Dictionary)->bool:
	# check if has settings, set defaults if no
	var prop:String = default_settings.keys()[0]
	var prop_path = get_prop_path(property_group, prop)
	return editor_settings.has_setting(prop_path)


func set_default_settings(property_group:String, default_settings:Dictionary):
	
	for prop in default_settings:
		var v = default_settings[prop]

		var prop_path = get_prop_path(property_group, prop)		
		
		var prop_val = v[0]
		editor_settings.set(prop_path, prop_val)
		
		var property_info = {
			 "name": prop_path,
			 "type": v[1],
		}

		editor_settings.add_property_info(property_info)


#? it seems initial vals are removed when the editor reloaded ?
func set_initial_values(property_group:String, default_settings:Dictionary):
	for prop in default_settings:
		var v = default_settings[prop]

		var prop_path = get_prop_path(property_group, prop)		
		
		var prop_val = v[0]

		editor_settings.set_initial_value(prop_path, prop_val, false)



# may also be named: create_if_not_exist
func ensure_exist(property_group:String, default_settings:Dictionary):
	if !has_default_settings(property_group, default_settings):
		set_default_settings(property_group, default_settings)
	set_initial_values(property_group, default_settings)


func get_setting(prop_group:String, prop:String):
	var prop_path  = get_prop_path(prop_group, prop)	
	return editor_settings.get_setting(prop_path)

func set_setting(prop_group:String, prop:String, val):
	var prop_path  = get_prop_path(prop_group, prop)	
	return editor_settings.set_setting(prop_path, val)


# Danger zone!

func erase_settings(property_group:String, notify = false):
	if not section_name: return # we don't want erase ALL me2beats settings.
	var prop_start = section_category.plus_file(section_name).plus_file(property_group).plus_file("/")
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


	
