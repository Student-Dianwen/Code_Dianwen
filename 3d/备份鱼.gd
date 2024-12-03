#extends Node3D  # 确保绑定到鱼的根节点（如 fishClown）
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
#
#var velocity = Vector3(0, 0, 0) # 初始速度
#var acceleration = Vector3(0, 0, 0) # 初始加速度
#
#func init(window_width,window_height,movement_depth):
	## 随机生成初始位置
	##position = Vector3(randf_range(-window_width, window_width),randf_range(-window_height, window_height),randf_range(-movement_depth, movement_depth))
	#global_position = Vector3(0, 0, 0) # 设置为中心位置
	## 随机生成初始速度
	#velocity = Vector3(randf_range(0, 1),randf_range(0, 1)/8, randf_range(0, 1))
	#
	## 计算旋转角度，使鱼朝向初始速度方向
	##var angle : float = Vector3(0,0,-1).angle_to(velocity)
	##var axis  : Vector3 = Vector3(0,0,-1).cross(velocity).normalized()
	##transform.basis = transform.basis.rotated(axis, angle)
	#
	#if animation_player:
		#animation_player.play("li_move")  # 确保动画名称正确
		#
#func _process(delta):
	## 让鱼沿着速度方向移动
	#global_position += velocity * delta
