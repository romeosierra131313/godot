Extends Area2D

################################################################################
###Straight line or angle ######################################################
################################################################################
##TODO##
#add visibility notifier##


var m = 1
var speedX = 100
var speedY = 100
var destination = Vector2(0,0)
var velocity = Vector2(0,0)
var timer = 0.25
var time = 0.0
var health = 5
var damage = 1
var state = ""
onready var bullet = load("res://scenes/bullettype1.tscn")

func _ready():
  getDest()
  

  pass
func setGradiant(e):
  m = e
  pass
func setYintercept(e):
  c = e
  pass
func getDest():
  destination.x = position.x - speedX
  destination.y = destination.x * m

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
  setState("moving")
  if position.x  > destination.x:
    velocity.x = -speedX   
  elif position.x  < destination.x:
    velocity.x = speedX    

  if position.y  > destination.y:
    velocity.y = -speedY   * m
  elif position.x  < destination.x:
    velocity.y = speedY  * m 
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
      setState("moving")
      get_node("Animatedsprite").animation = "move"
    "move":
      setState("moving")
      get_node("Animatedsprite").animation = "move"
        
