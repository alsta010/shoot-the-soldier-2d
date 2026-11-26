extends CharacterBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var move_speed: float = 100.0
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

var dead = false

func _physics_process(delta):
	if dead:
		return
		
	var dir_to_player = global_position.direction_to(player.global_position)
	velocity = dir_to_player * move_speed
	move_and_slide()
	
	global_rotation = dir_to_player.angle() + PI/2.0
	
	if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider() == player:
		player.kill()
		
func kill():
		if dead:
			return
		dead = true
		$DeathSound.play()
		$Graphics/Dead.show()
		$Graphics/Alive.hide()
		$CollisionShape2D.disabled = true 
		$Graphics/Dead.visible = true
		
		remove_from_group("enemies")

		if get_tree().get_nodes_in_group("enemies").is_empty():
			await get_tree().create_timer(10.0).timeout
			get_tree().change_scene_to_file("res://main_menu.tscn")
