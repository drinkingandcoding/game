extends Area2D

signal hit

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var playerDisabled

func _ready():
	screen_size = get_viewport_rect().size
	playerDisabled = true
	hide()


func _process(delta):
	if not playerDisabled:
		var velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite.play()
		else:
			$AnimatedSprite.stop()

		position += velocity * delta
		# clamp() will lock the player to the screen size. We don't want dis
		# position.x = clamp(position.x, 0, screen_size.x)
		# position.y = clamp(position.y, 0, screen_size.y)

		if velocity.x != 0:
			$AnimatedSprite.animation = "move"
		elif velocity.y != 0:
			$AnimatedSprite.animation = "move"


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	playerDisabled = false


func update_player_name(playerName):
	$Label.text = playerName


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func scale_player(direction):
	print("scale player")
	
	var scaler
	
	if direction == "up":
		scaler = .3
	if direction == "down":
		scaler = -.3
	
	$AnimatedSprite.scale.x += scaler
	$AnimatedSprite.scale.y += scaler
	$CollisionShape2D.scale.x += scaler
	$CollisionShape2D.scale.y += scaler
	speed = speed*.75

func reset_scale_player():
	$AnimatedSprite.scale.x = 1
	$AnimatedSprite.scale.y = 1
	$CollisionShape2D.scale.x = 1
	$CollisionShape2D.scale.y = 1
	speed = 400
