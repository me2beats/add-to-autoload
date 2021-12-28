tool
extends EditorPlugin

var autoload_item_id: = "autoload".hash()
var input_dialog:ConfirmationDialog = preload("input_dialog.tscn").instance()

var base = get_editor_interface().get_base_control()

const Utils = preload("utils.gd") #Utils script
const Settings = preload("settings.tres") #Settings singleton
const GlobalSettings = preload("global_settings.tres") #Settings singleton
const Message = preload("message.tres") #Message singleton



#func setup_input_dialog():
#	input_dialog.connect("resized", self, "on_input_dialog_resized")

func on_input_dialog_resized():
	Settings.set_setting('input_dialog_size', input_dialog.rect_size)



func _enter_tree():

	
	# problem I faced: I wanted to implement showing this in right-click menu only if the singleton is not added
	# but there is no methods for that currently.
	# (yes idk why but you can add multiple singletons with the same script and different names)
	
	var default_settings = {
		"input_dialog_size" : [input_dialog.rect_size, TYPE_VECTOR2],
	}
	
	Settings.init(self, default_settings, "add_to_autoload")
	input_dialog.rect_size = Settings.get_setting("input_dialog_size")
	
	input_dialog.connect("resized", self, "on_input_dialog_resized")

#	Settings.erase_settings(true)
#	Settings.set_default_settings() # force update



	Message.init(self)
	

	
	var fs_dock: = get_editor_interface().get_file_system_dock()

	Utils.add_replace_node(input_dialog, fs_dock)
	input_dialog.connect("text_entered", self, "on_input_dialog_text_entered")
	

	var menu: = Utils.get_fs_context_menu(fs_dock)

	if not menu: return
	menu.connect("about_to_show", self, "on_context_menu_show", [menu])
	menu.connect("id_pressed", self, "on_context_menu_id_pressed", [menu])



func _exit_tree():
	input_dialog.get_parent().remove_child(input_dialog)
	input_dialog.queue_free()


func on_input_dialog_text_entered(text:String):
	
	if Engine.has_singleton(text):
		Message.push(Message.WARNING, "Global scope already has singleton with this name: "+text)

		return
	
	var cur_path:String = get_editor_interface().get_current_path()
	add_autoload_singleton(text, cur_path)

	yield(get_tree(), "idle_frame") # is it needed?


	if ProjectSettings.has_setting("autoload/"+text):
		Message.push(Message.SUCCESS, "Singleton added: "+text)
	else:
		Message.push(Message.WARNING, "Error when adding a singleton: "+text)





func on_context_menu_show(menu:PopupMenu):
	var cur_path:String = get_editor_interface().get_current_path()
	if not cur_path: return
	
	var ext = cur_path.get_extension()
	if ext == "tscn" or ext == "gd":
		menu.add_separator()
		menu.add_item("Add To Autoload", autoload_item_id)


func on_context_menu_id_pressed(id:int, menu:PopupMenu):
	match id:
		autoload_item_id:
			
			var cur_path:String = get_editor_interface().get_current_path()
			
			input_dialog.popup_centered()






	
