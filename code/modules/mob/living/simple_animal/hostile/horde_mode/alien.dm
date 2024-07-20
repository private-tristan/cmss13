/mob/living/simple_animal/hostile/alien/horde_mode
	var/mob/living/last_hit_by

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
	if(last_hit_by.stat != DEAD)
		SShorde_mode.update_points(last_hit_by, 100)
		balloon_alert(last_hit_by, "+100")

	SShorde_mode.current_xenos -= src

/mob/living/simple_animal/hostile/alien/horde_mode/bullet_act(obj/projectile/bullet)
	. = ..()
	if(bullet.weapon_cause_data && bullet.weapon_cause_data.cause_name)
		var/mob/player_mob = bullet.weapon_cause_data.resolve_mob()
		last_hit_by = player_mob
		if(istype(player_mob))
			player_mob.track_shot_hit(bullet.weapon_cause_data.cause_name, src)
			if(stat != DEAD)
				SShorde_mode.update_points(player_mob, 10)
				balloon_alert(player_mob, "+10")

/mob/living/simple_animal/hostile/alien/horde_mode/lesser_drone
	name = "Lesser Drone"
	icon = 'icons/mob/xenos/lesser_drone.dmi'
	icon_state = "Lesser Drone Walking"
	health = XENO_HEALTH_LESSER_DRONE
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_1
	speed = XENO_SPEED_TIER_6
	pixel_x = 0

/mob/living/simple_animal/hostile/alien/horde_mode/lesser_drone/update_wounds()
	return
