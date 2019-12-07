Extends Area2D

var r = 16  ## acceptable range within destination point to ask for new point###
var p = 8   ## acceptable y distance from player
var speedX = 100
var speedY = 50
var dirX = 1
var dirY = 1
var destination = Vector2(0,0)
var velocity = Vector2(0,0)
var timer = 0.25
var time = 0.0
var health = 5
var damage = 1
var state = ""
onready var bullet = load("res://scenes/bullettype1.tscn")

func _ready():
  getRandomDest()
  

  pass
func getRandomDest():
  destination.x = randi()%300
  destination.y = randi()%300
  var t = randi()%1
  if t == 1:
    dirX = 1
  else:
    dirX = -1
    var u = randi()%1
  if u == 1:
    dirY = 1
  else:
    dirY = -1
  destination.x = destination.x + (position.x*dirX) 
  destination.y = destination.y + (position.y*dirY)
  if destination.x > get_viewport().rect.x :
    destination.x = get_viewport().rect.x - 128
  elif destination.x < 0 :
    destination.x = 128
  if destination.y > get_viewport().rect.y :
    destination.y = get_viewport().rect.y - 128
  elif destination.y < 0 :
    destination.y =  128
  pass
func spawnBullet():
  if time > timer:
    var b = bullet.instance()
    b.setDamage(damage)
    add_child(b)
    get_node("Animatedsprite").animation = "fire"
    setState("firing")
    time = 0
  pass
func setVelocity():
  if abs(position.x - destination.x) < r or abs(position.y - destination.y) < r :
    if abs(position.y - PlayerVars.loc.y) < p:
      setState("idling")
  else:
    getRandomDest()
    setState("moving")
    if position.x  > destination.x:
      velocity.x = -speedX   
    elif position.x  < destination.x:
      velocity.x = speedX    

    if position.y  > destination.y:
      velocity.y = -speedY   
    elif position.x  < destination.x:
      velocity.y = speedY   
  pass
func setState(e):
  state = e
  pass
func _process(delta):
   
  time += delta
  
  if state == "moving":
    spawnBullet()
    setVelocity()
    get_node("Animatedsprite").animation = "move"
  elif state == "idling":
    spawnBullet()
    get_node("Animatedsprite").animation = "idle"
  elif state == "firing":
     get_node("Animatedsprite").animation = "fire"
  elif state == "dead":
    print("doing nothing")  

  pass
  
func _pyhsics_process(delta):
  move_and_slide(velocity)
  pass

func on_Area2D_entered(area):
  health -= area.getDamage()
  get_parent().spawnExplosion(position)
  if health <= 0 :
    setState("dead")
  pass
func on_animatedsprite_animation_finished(anim_name):
  match anim_name:
    "dead":
      get_parent().spawnCrashExplosion(position)
      queue_free
    "fire":
      setState("idling")
      get_node("Animatedsprite").animation = "idle"
    "move":
      setState("moving")
      get_node("Animatedsprite").animation = "move"
    "idle":
      setState("idling")
      get_node("Animatedsprite").animation = "idle"
        
  
