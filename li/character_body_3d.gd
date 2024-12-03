extends CharacterBody3D

signal coin_collected

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var swim_speed = 5.0
@export var swim_acceleration = 2.0
@export var swim_dampening = 0.1

var swim_velocity := Vector3.ZERO
var target_direction := Vector3.ZERO

var coins = 0

@onready var particles_trail = $ParticlesTrail
@onready var model = $FishModel
@onready var animation = $FishModel/AnimationPlayer

# Functions

func _ready():
	randomize()  # 初始化随机数生成器
	target_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _physics_process(delta):

	# Handle functions

	handle_fish_movement(delta)

	handle_effects(delta)

	# Movement

	velocity = swim_velocity
	move_and_slide()

	# 碰撞检测和反弹
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision:
			swim_velocity = swim_velocity.bounce(collision.get_normal())
			target_direction = swim_velocity.normalized()
			# 确保鱼不会卡在障碍物上
			move_and_slide()

	# 应用减速效果
	swim_velocity *= 1.0 - (swim_dampening * delta)

	# 保持鱼在水面上方
	if position.y < 0:
		position.y = 0

	# 旋转鱼以面向移动方向
	if swim_velocity.length() > 0:
		var look_direction = Vector2(swim_velocity.z, swim_velocity.x).angle()
		rotation.y = lerp_angle(rotation.y, look_direction, delta * 5)

# Handle animation(s)

func handle_effects(delta):

	particles_trail.emitting = false

	if animation:
		var swim_factor = swim_velocity.length() / swim_speed / delta
		if swim_factor > 0.05:
			if animation.current_animation != "swim":
				animation.play("swim", 0.1)

			if swim_factor > 0.75:
				particles_trail.emitting = true
		else:
			if animation.current_animation != "idle":
				animation.play("idle", 0.1)

# Handle fish movement

func handle_fish_movement(delta):
	# 更新游动方向
	if randf() < 0.01:  # 以一定概率改变游动方向
		target_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()

	# 计算游动速度
	swim_velocity = swim_velocity.lerp(target_direction * swim_speed, delta * swim_acceleration)

# Collecting coins

func collect_coin():
	coins += 1

	coin_collected.emit(coins)



extends Node3D  # 确保绑定到鱼的根节点（如 fishClown）


@export var speed: float = 2.0  # 游动的速度
@export var boundary: Vector3 = Vector3(10, 5, 10)  # 浴缸的边界 (x, y, z 最大值)
@export var rotation_speed: float = 2.0  # 转向时的平滑程度
var direction: Vector3 = Vector3(1, 0, 0)  # 初始游动方向

func _process(delta):
	# 更新鱼的位置
	global_position += direction * speed * delta

	# 检查是否碰到边界并反弹
	if abs(global_position.x) > boundary.x:
		direction.x = -direction.x  # 反转 X 方向
		_rotate_to_direction(delta)

	if abs(global_position.y) > boundary.y:
		direction.y = -direction.y  # 反转 Y 方向
		_rotate_to_direction(delta)

	if abs(global_position.z) > boundary.z:
		direction.z = -direction.z  # 反转 Z 方向
		_rotate_to_direction(delta)

	# 平滑旋转鱼的方向
	_rotate_to_direction(delta)

func _rotate_to_direction(delta):
	# 根据当前方向计算目标旋转
	var target_transform = Transform3D().looking_at(global_position + direction, Vector3.UP)
	# 使用 Transform3D 的 basis 直接设置旋转
	var target_rotation = target_transform.basis
	# 平滑旋转鱼的方向
	global_transform.basis = global_transform.basis.slerp(target_rotation, rotation_speed * delta)
