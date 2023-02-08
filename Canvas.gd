extends Image

class_name Canvas

const background_color = Color.white

func _init(width,height):
	create(width,height,false,Image.FORMAT_RGB8)
	fill(background_color)

func is_insidev(position):
	if position.x<0 or position.x>=get_width():
		return false
	if position.y<0 or position.y>=get_height():
		return false
	return true

func is_inside(x,y):
	if x<0 or x>=get_width():
		return false
	if y<0 or y>=get_height():
		return false
	return true

func getColor(x,y):
	lock()
	var color = get_pixel(x,y)
	unlock()
	return color

func setColor(x,y,color):
	lock()
	set_pixel(x,y,color)
	unlock()

func getColorv(pos):
	lock()
	var color = get_pixelv(pos)
	unlock()
	return color

func setColorv(pos,color):
	lock()
	set_pixelv(pos,color)
	unlock()

func clear():
	fill(background_color)

func draw_by_pencil(mouse_pos,new_color):
	var size = 25
	var mask = []
	for y in range(-size/2,size/2+1):
		var row = []
		for x in range(-size/2,size/2+1):
			row.append(int((pow(x,2)+pow(y,2))<pow(size/2.0,2)))
		mask.append(row)
	
	for i in range(size):
		for j in range(size):
			var position = Vector2(
				mouse_pos.x+(i-size/2)*mask[i][j],
				mouse_pos.y+(j-size/2)*mask[i][j])
			if is_insidev(position):
				setColorv(position,new_color)
	
func fill_by_bucket(position,new_color):
	var target_color = getColorv(position)
	if target_color == new_color: return
	
	var pos_sum = Vector2(0,0)
	var pos_count = 0
	
	var stack = [position]
	while not stack.empty():
		var a = stack.pop_back()
		var xLeft = a.x
		while is_inside(xLeft-1,a.y) and getColor(xLeft-1,a.y)==target_color:
			xLeft-=1
			setColor(xLeft,a.y,new_color)
			pos_sum+=Vector2(xLeft,a.y)
			pos_count+=1
		while is_inside(a.x+1,a.y) and getColor(a.x+1,a.y)==target_color:
			a.x+=1
			setColor(a.x,a.y,new_color)
			pos_sum+=Vector2(a.x,a.y)
			pos_count+=1
		scan(xLeft,a.x - 1,a.y + 1,stack)
		scan(xLeft,a.x - 1,a.y - 1,stack)
	return {"position":pos_sum/pos_count,"color":new_color}
func scan(lx, rx, y, s):
	for x in range(lx,rx):
		if is_inside(x,y):
			s.append(Vector2(x,y))

