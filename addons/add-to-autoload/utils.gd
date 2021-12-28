static func is_valid_singleton_name(name:String)->bool:
	var nodename = name.validate_node_name()
	if !nodename == name: return false
	
	return true




# Node Utils

static func get_children_by_type(node:Node, type)->Array:
	var res:=[]
	for n in node.get_children():
		if n is type:
			res.push_back(n)
	return res




static func add_replace_node(node:Node, parent:Node, keep_index:=false):
	var name = node.name
	var old_node = parent.get_node_or_null(name)

	var idx:int

	if old_node:
		if keep_index:
			idx = old_node.get_index()
		
		parent.remove_child(old_node)
		old_node.free()
		
	parent.add_child(node)
	if !idx==null:
		parent.move_child(node, idx)





static func get_child_by_class(node:Node, cls:String):
	for child in node.get_children():
		if child.get_class() == cls:
			return child




static func find_node_by_class_path(node:Node, class_path:Array)->Node:
	var res:Node

	var stack = []
	var depths = []

	var first = class_path[0]
	for c in node.get_children():
		if c.get_class() == first:
			stack.push_back(c)
			depths.push_back(0)

	if not stack: return res
	
	var max_ = class_path.size()-1

	while stack:
		var d = depths.pop_back()
		var n = stack.pop_back()

		if d>max_:
			continue
		if n.get_class() == class_path[d]:
			if d == max_:
				res = n
				return res

			for c in n.get_children():
				stack.push_back(c)
				depths.push_back(d+1)

	return res



# FileSystem Utils

static func get_fs_context_menu(fs_dock:Control)->PopupMenu:
	var menu:PopupMenu
	var popup_menus =  get_children_by_type(fs_dock, PopupMenu)
	return popup_menus[-1]
	
	for m in popup_menus:
		m = m as PopupMenu
		menu = m
		break

	return menu





# EditorLog utils

static func get_output(base:Control)->RichTextLabel:
	return get_output_by_log(get_log(base))

static func get_output_by_log(editor_log:VBoxContainer)->RichTextLabel:
	return get_child_by_class(editor_log, 'RichTextLabel') as RichTextLabel


static func get_log(base:Control)->VBoxContainer:
	var result: VBoxContainer = find_node_by_class_path(
		base, [
			'VBoxContainer', 
			'HSplitContainer',
			'HSplitContainer',
			'HSplitContainer',
			'VBoxContainer',
			'VSplitContainer',
			'PanelContainer',
			'VBoxContainer',
			'EditorLog'
		]
	)
	return result

