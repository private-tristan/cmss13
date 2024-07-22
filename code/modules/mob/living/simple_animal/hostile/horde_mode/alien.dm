/mob/living/simple_animal/hostile/alien/horde_mode
	health = XENO_HEALTH_TIER_3
	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_damage_multiplier = 3
	move_to_delay = 4
	var/explosive_damage_multiplier = 2
	var/mob/living/last_hit_by
	var/death_bonus = 0
	var/kill_reward = 100

/mob/living/simple_animal/hostile/alien/horde_mode/Initialize()
	. = ..()
	SShorde_mode.current_xenos += src
	health *= SShorde_mode.xeno_health_mod
	melee_damage_upper *= SShorde_mode.xeno_damage_mod
	melee_damage_lower *= SShorde_mode.xeno_damage_mod
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
			SShorde_mode.update_points(last_hit_by, kill_reward + death_bonus)
			balloon_alert(last_hit_by, "+[kill_reward + death_bonus]")

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
		SShorde_mode.update_points(user, 20)
		balloon_alert(user, "+20")

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

	apply_damage(severity * explosive_damage_multiplier, BRUTE)
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
	health = XENO_HEALTH_LESSER_DRONE
	move_to_delay = 3.5
	pixel_x = 0
	kill_reward = 50

/mob/living/simple_animal/hostile/alien/horde_mode/lesser_drone/update_wounds()
	return

/mob/living/simple_animal/hostile/alien/horde_mode/runner
	name = "Runner"
	icon = 'icons/mob/xenos/runner.dmi'
	icon_size = 64
	pixel_x = -16  //Needed for 2x2
	old_x = -16
	base_pixel_x = 0
	base_pixel_y = -20
	move_to_delay = 2.5
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	health = XENO_HEALTH_RUNNER
	kill_reward = 125

/mob/living/simple_animal/hostile/alien/horde_mode/runner/AttackingTarget()
	visible_message(SPAN_DANGER("<B>[src]</B> tears into [target_mob] repeatedly!"))
	INVOKE_ASYNC(src, PROC_REF(multi_attack))

/mob/living/simple_animal/hostile/alien/horde_mode/runner/proc/multi_attack()
	for(var/times_to_attack = 3, times_to_attack > 0; times_to_attack--)
		if(Adjacent(target_mob) && stat == CONSCIOUS)
			var/damage = rand(melee_damage_lower, melee_damage_upper)
			target_mob.apply_damage(damage, BRUTE)
			animation_attack_on(target_mob)
			playsound(loc, get_sfx("alien_claw_flesh"), 25, 1)
			flick_attack_overlay(target_mob, "slash")
			sleep(0.25 SECONDS)

/mob/living/simple_animal/hostile/alien/horde_mode/lurker
	name = "Lurker"
	icon = 'icons/mob/xenos/lurker.dmi'
	alpha = 60
	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_4
	health = XENO_HEALTH_TIER_5
	speed = XENO_SPEED_TIER_6
	kill_reward = 150
