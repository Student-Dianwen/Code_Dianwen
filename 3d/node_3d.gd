extends Node3D  # 确保绑定在鱼模型的根节点上

@onready var animation_player = $AnimationPlayer  # 动画播放器节点

var speed = 2.0  # 鱼的移动速度
var direction = Vector3(1, 0, 0)  # 初始方向，沿 X 轴正方向
var boundary = 5.0  # 鱼的活动范围

func _ready():
	# 页面加载时播放静止动画
	animation_player.play("li_idle")

func _process(delta):
	# 更新鱼的位置
	position += direction * speed * delta

	# 检查边界并改变方向
	if position.x > boundary:
		direction.x = -1  # 改变移动方向为负方向
		rotation_degrees.y = 180  # 鱼头朝向左侧（反方向）
		animation_player.play("li_move")  # 播放游动动画
	elif position.x < -boundary:
		direction.x = 1  # 改变移动方向为正方向
		rotation_degrees.y = 0  # 鱼头朝向右侧（正方向）
		animation_player.play("li_move")  # 播放游动动画
