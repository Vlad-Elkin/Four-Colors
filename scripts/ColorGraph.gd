extends Node

class_name ColorGraph

var _brush_size
var nodes = []
var edges = []

func _init(brush_size):
	print("initializing graph")
	_brush_size = brush_size

func add_node(node):
	nodes.append(node)

func find_edges():
	if nodes.size() >= 2:
		for j in range(nodes.size()):
			for i in range(j,nodes.size()):
				if i!=j:
					var exit_flag = false
					var a = nodes[j]
					var b = nodes[i]
					if a != null and b != null:
						for k in a["border"]:
							if exit_flag: break
							for l in b["border"]:
								var dist = k.distance_to(l)
								if dist <= _brush_size:
									edges.append([a["color"],b["color"]])
									exit_flag = true
									break

func check_edges():
	for edge in edges:
		if edge[0]==edge[1]: return true
		
func clear():
	nodes = []
	edges = []
