extends Camera3D  # 确保绑定到 Camera3D 节点

@export var target:Node3D  # 要跟随的目标节点（鱼模型）
@export var distance:float = 10.0  # 摄像机与目标之间的水平距离
@export var height:float = 5.0  # 摄像机与目标之间的垂直高度
@export var position_damping:float = 2.0  # 位置平滑过渡速度
@export var should_rotate:bool = true  # 是否让摄像机始终面向目标
@export var rotation_damping:float = 3.0  # 旋转平滑过渡速度

func _process(delta):
	# 确保目标节点已设置
	if target:
		_follow_target(delta)

func _follow_target(delta):
	# 计算摄像机的期望位置
	var offset = -target.global_transform.basis.z * distance  # 在目标的后方
	var desired_position = target.global_position + offset
	desired_position.y += height  # 调整高度

	# 平滑过渡到目标位置
	global_position = global_position.lerp(desired_position, position_damping * delta)

	# 平滑旋转以面对目标
	if should_rotate:
		var target_transform = Transform3D().looking_at(target.global_position, Vector3.UP)
		var target_rotation = target_transform.basis.to_quat()  # 转换为四元数
		global_rotation = global_rotation.slerp(target_rotation, rotation_damping * delta)
