extends Node3D  # 确保绑定到鱼的根节点
@onready var animation_player: AnimationPlayer = get_node_or_null("AnimationPlayer")  # 动画播放器
# 移动属性
@export var speed: float = 10.0  # 鱼的移动速度
var velocity = Vector3.ZERO  # 初始速度
func _ready():
	# 初始化速度为随机方向
	velocity = Vector3(randf_range(-1, 1), randf_range(-0.1, 0.1), randf_range(-1, 1)).normalized() * speed
	# 播放游动动画
	if animation_player:
		animation_player.play("li_move")
	# 确保鱼的模型面朝其移动方向
	align_to_velocity()
func _process(delta):
	# 使用速度移动鱼
	global_position += velocity * delta
	# 确保鱼的模型始终面朝其移动方向
	align_to_velocity()
# 确保鱼面朝其移动方向
func align_to_velocity():
	# 如果速度接近零，不调整朝向
	if velocity.length() > 0.01:
		var target_transform = Transform3D().looking_at(global_position + velocity, Vector3.UP)
		global_transform.basis = target_transform.basis
func _on_area_3d_body_entered(body: Node3D) -> void:
	print("hahah" + body.name)
	# 检测碰撞的是否是鱼缸壁
	if body.name in ["StaticBody3D"]:  # 检查所有浴缸壁的名字
		var collision_normal = (global_position - body.global_position).normalized()	
		# 立即翻转鱼的朝向
		var target_transform = Transform3D().looking_at(global_position - collision_normal, Vector3.UP)
		global_transform.basis = target_transform.basis
		# 只反转水平方向的速度分量
		if abs(collision_normal.x) > abs(collision_normal.z):
			velocity.x = -velocity.x
		else:
			velocity.z = -velocity.z		
		# 确保鱼的速度方向立即更新
		velocity = velocity.normalized() * speed		
		# 添加一个小的时间间隔，防止鱼立即再次碰撞
		#await get_tree().create_timer(0.1).timeout
