extends Image

class_name Canvas

var _brush_size

func _init(width,height,brush_size):
	create(width,height,false,Image.FORMAT_RGB8)
	_brush_size = brush_size
	fill(Color.white)

func is_inside(x,y):
	if x<0 or x>=get_width():
		return false
	if y<0 or y>=get_height():
		return false
	return true

func draw_point(pos):
	var mask = []
	var half_size = _brush_size/2.0
	var area = 0
	for y in range(-int(half_size),int(half_size)+1):
		var row = []
		for x in range(-int(half_size),int(half_size)+1):
			row.append(int((pow(x,2)+pow(y,2))<pow(int(half_size),2)))
		mask.append(row)
	lock()
	for i in range(_brush_size):
		for j in range(_brush_size):
			var position = Vector2(
				pos.x+(i-int(half_size))*mask[i][j],
				pos.y+(j-int(half_size))*mask[i][j])
			if is_inside(position.x,position.y):
				if get_pixelv(position)==Color.white:
					area += 1
				set_pixelv(position,Color.black)
	unlock()
	return area

func draw_line(p1:Vector2,p2:Vector2):
	var tmp_p = p1
	var area = 0
	while tmp_p.distance_to(p2)!=0:
		tmp_p = tmp_p.move_toward(p2,1)
		area += draw_point(tmp_p)
	return area

func span_fill(position,new_color,target_color):
	if target_color == new_color: return
	if target_color == Color.black: return
	var stack = [position]
	var border_points = []
	var area = 0
	while not stack.empty():
		var a = stack.pop_back()
		var xLeft = a.x
		lock()
		while is_inside(xLeft-1,a.y) and get_pixel(xLeft-1,a.y)==target_color:
			xLeft-=1
			set_pixel(xLeft,a.y,new_color)
			_find_borders(xLeft,a.y,border_points)
		while is_inside(a.x+1,a.y) and get_pixel(a.x+1,a.y)==target_color:
			a.x+=1
			set_pixel(a.x,a.y,new_color)
			_find_borders(a.x,a.y,border_points)
		unlock()
		area+=(a.x-xLeft)
		for x in range(xLeft,a.x):
			if is_inside(x,a.y + 1):
				stack.append(Vector2(x,a.y + 1))
			if is_inside(x,a.y - 1):
				stack.append(Vector2(x,a.y - 1))
	return {"border":border_points,"color":new_color,"area":area}

func _find_borders(x,y,s):
	if not is_inside(x+1,y):
		s.append(Vector2(x,y))
	elif get_pixel(x+1,y) == Color.black:
		s.append(Vector2(x+1,y))
		
	if not is_inside(x,y+1):
		s.append(Vector2(x,y)) 
	elif get_pixel(x,y+1) == Color.black: 
		s.append(Vector2(x,y+1))
		
	if not is_inside(x-1,y): 
		s.append(Vector2(x,y))
	elif get_pixel(x-1,y) == Color.black: 
		s.append(Vector2(x-1,y))
		
	if not is_inside(x,y-1): 
		s.append(Vector2(x,y))
	elif get_pixel(x,y-1) == Color.black: 
		s.append(Vector2(x,y-1))
