extends Node
@warning_ignore_start("shadowed_variable")


class CharacterStats:
	var health: int
	var damage: int
	var attack_cooldown: float
	var speed: int
	var jump_force: int


	func _init(
		health: int,
		damage: int,
		attack_cooldown: float,
		speed: int,
		jump_force: int,
	) -> void:
		self.health = health
		self.damage = damage
		self.attack_cooldown = attack_cooldown
		self.speed = speed
		self.jump_force = jump_force


var player := CharacterStats.new(80, 15, 1.0, 170, 320)
var ghost := CharacterStats.new(70, 20, 1, 50, 200)
var mage := CharacterStats.new(50, 10, 1.2, 100, 200)
const GRAVITY := 1000
