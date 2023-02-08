extends Node

class_name ColorGraph

var vertices = []
var edges = []

func addVertex(value):
	var vertex = Vertex.new(vertices.size(),value)
	if vertices.size() < 3:
		for v in vertices: 
			edges.append(vertex.link_with(v))
	else:
		for v in vertices:
			pass
	vertices.append(vertex)
	for edge in edges:
		print(edge)
	for v in vertices:
		print(v)
		
class Vertex:
	var id:int
	var position:Vector2
	var color:Color
	func _init(number,value):
		print(number)
		id=number
		position = value["position"]
		color = value["color"]
	func link_with(other:Vertex):
		return Edge.new(self,other)
	func direction_to(other:Vertex):
		return position.direction_to(other.position)
	func distance_to(other:Vertex):
		return position.distance_to(other.position)
	func _to_string():
		return "v#"+str(id)

class Edge:
	var vertex1:Vertex
	var vertex2:Vertex
	var lenght
	var direction
	func _init(v1:Vertex,v2:Vertex):
		vertex1 = v1
		vertex2 = v2
		lenght = v1.distance_to(v2)
		direction = v1.direction_to(v2)
	func _to_string():
		return vertex1.to_string()+" -> "+vertex2.to_string()
