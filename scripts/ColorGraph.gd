extends Node

class_name ColorGraph

var _brush_size
var nodes = []
var edges = []
var area = 0
var used_area = 0

func _init(width,height,brush_size):
	_brush_size = brush_size
	area = height * width

func add_node(node):
	if node == null: return
	var count = nodes.size()
	if not nodes.empty():
		for i in range(count):
			var exit_flag = false
			var a = nodes[i]
			var b = node
			for k in a.border:
				if exit_flag: break
				for l in b.border:
					var dist = k.distance_to(l)
					if dist <= _brush_size:
						var edge = [i,count]
						edges.append(edge)
						exit_flag = true
						break
	used_area += node.area
	nodes.append(node)

func check_edges():
	if area-used_area <= 0:
		return "complete_fill"
	for edge in edges:
		var a = nodes[edge[0]]
		var b = nodes[edge[1]]
		if a.color==b.color:
			return "same_color"
