tool
extends ConfirmationDialog

export(NodePath) var edit_path
onready var edit:LineEdit = get_node(edit_path)

signal text_entered(text)

func _on_InputDialog_about_to_show():
	yield(get_tree(), "idle_frame")
	edit.grab_focus()


func _on_LineEdit_text_entered(new_text):
	get_ok().emit_signal("pressed")





func _on_InputDialog_confirmed():
	emit_signal("text_entered", edit.text)

# could use hide signal as well?
func _on_InputDialog_visibility_changed():
	if not visible:
		yield(get_tree(), "idle_frame")
		edit.clear()
