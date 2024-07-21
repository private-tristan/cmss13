/mob/living/simple_animal/hostile/alien/horde_mode
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_1
	speed = XENO_SPEED_TIER_5
	melee_damage_multiplier = 4
	var/mob/living/last_hit_by
	var/death_bonus = 0

/mob/living/simple_animal/hostile/alien/horde_mode/Initialize()
	. = ..()
	SShorde_mode.current_xenos += src
	health *= SShorde_mode.xeno_health_mod
	FindTarget()
	MoveToTarget()

/mob/living/simple_animal/hostile/alien/horde_mode/Destroy()
	. = ..()
	SShorde_mode.current_xenos -= src

/mob/living/simple_animal/hostile/alien/horde_mode/ListTargets(dist = 128)
	var/list/L = orange(src, 128)
	return L

/mob/living/simple_animal/hostile/alien/horde_mode/death(cause, gibbed, deathmessage)
	. = ..()
	if(!isnull(last_hit_by))
		if(last_hit_by.stat != DEAD)
			SShorde_mode.update_points(last_hit_by, 100 + death_bonus)
			balloon_alert(last_hit_by, "+[100 + death_bonus]")

	SShorde_mode.current_xenos -= src

/mob/living/simple_animal/hostile/alien/horde_mode/bullet_act(obj/projectile/bullet)
	. = ..()
	death_bonus = 0
	if(bullet.weapon_cause_data && bullet.weapon_cause_data.cause_name)
		var/mob/player_mob = bullet.weapon_cause_data.resolve_mob()
		last_hit_by = player_mob
		if(istype(player_mob))
			if(stat != DEAD)
				SShorde_mode.update_points(player_mob, 10)
				balloon_alert(player_mob, "+10")

/mob/living/simple_animal/hostile/alien/horde_mode/attackby(obj/item/weapon, mob/user)
	. = ..()
	if(stat != DEAD && weapon.force >= MELEE_FORCE_NORMAL)
		if(istype(weapon, /obj/item/weapon/gun))
			var/obj/item/weapon/gun/weapon_gun = weapon
			if(weapon_gun.PB_fired)
				return
		last_hit_by = user
		death_bonus = 100
		SShorde_mode.update_points(user, 50)
		balloon_alert(user, "+50")

/mob/living/simple_animal/hostile/alien/horde_mode/ex_act(severity, direction, datum/cause_data/explosion_cause_data)
	if(severity >= 30)
		flash_eyes()

	if(severity >= health && severity >= EXPLOSION_THRESHOLD_GIB)
		gib()
		return

	var/mob/explosion_source_mob = explosion_cause_data?.resolve_mob()
	if(explosion_source_mob)
		last_hit_by = explosion_source_mob
		SShorde_mode.update_points(explosion_source_mob, 50)
		balloon_alert(explosion_source_mob, "+50")

	apply_damage(severity * 5, BRUTE)
	updatehealth()
	death_bonus = 0

	var/knock_value = min( round( severity*0.1 ,1) ,10)
	if(knock_value > 0)
		apply_effect(knock_value, WEAKEN)
		apply_effect(knock_value, PARALYZE)
		explosion_throw(severity, direction)


/mob/living/simple_animal/hostile/alien/horde_mode/lesser_drone
	name = "Lesser Drone"
	icon = 'icons/mob/xenos/lesser_drone.dmi'
	icon_state = "Lesser Drone Walking"
	health = XENO_HEALTH_LESSER_DRONE
	speed = XENO_SPEED_TIER_6
	pixel_x = 0

/mob/living/simple_animal/hostile/alien/horde_mode/lesser_drone/update_wounds()
	return
