
#define FIRE_LAYER 1
/mob/living/simple_animal/hostile/alien/horde_mode
	health = XENO_HEALTH_TIER_3
	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_damage_multiplier = 3
	move_to_delay = 4
	icon_size = 48
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
	target_mob = SShorde_mode.return_random_player()
	MoveToTarget()

/mob/living/simple_animal/hostile/alien/horde_mode/Life(delta_time)
	handle_fire()
	. = ..()

/mob/living/simple_animal/hostile/alien/horde_mode/IgniteMob()
	. = ..()
	if (. & IGNITE_IGNITED)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "roar")

/mob/living/simple_animal/hostile/alien/horde_mode/handle_fire()
	if(..())
		return

	health -= fire_reagent.intensityfire * 0.5
	var/mob/player_mob = last_damage_data.resolve_mob()
	last_hit_by = player_mob
	if(stat != DEAD)
		SShorde_mode.update_points(player_mob, 10)
		balloon_alert(player_mob, "+10")

/mob/living/simple_animal/hostile/alien/horde_mode/update_fire()
	if(on_fire && fire_reagent)
		var/image/I
		if(mob_size >= MOB_SIZE_BIG)
			if((!initial(pixel_y) || body_position != LYING_DOWN)) // what's that pixel_y doing here???
				I = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state"="alien_fire", "layer"=-FIRE_LAYER)
			else
				I = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state"="alien_fire_lying", "layer"=-FIRE_LAYER)
		else
			I = image("icon" = 'icons/mob/xenos/effects.dmi', "icon_state"="alien_fire", "layer"=-FIRE_LAYER)

		I.appearance_flags |= RESET_COLOR|RESET_ALPHA
		I.color = fire_reagent.burncolor
		overlays += I
	if(!on_fire)
		for(var/image/fire_overlay in overlays)
			if(fire_overlay.icon_state == "alien_fire" || fire_overlay.icon_state == "alien_fire_lying")
				overlays -= fire_overlay


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
	desc = "An alien drone. Looks... smaller."
	health = XENO_HEALTH_LESSER_DRONE
	move_to_delay = 3.5
	pixel_x = 0
	icon_size = 32
	kill_reward = 50

/mob/living/simple_animal/hostile/alien/horde_mode/lesser_drone/update_wounds()
	return

/mob/living/simple_animal/hostile/alien/horde_mode/runner
	name = "Runner"
	desc = "A fast, four-legged terror, but weak in sustained combat."
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

/mob/living/simple_animal/hostile/alien/horde_mode/lurker
	name = "Lurker"
	desc = "A beefy, fast alien with sharp claws."
	icon = 'icons/mob/xenos/lurker.dmi'
	alpha = 60
	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_4
	health = XENO_HEALTH_TIER_5
	move_to_delay = 3.8
	kill_reward = 150

/mob/living/simple_animal/hostile/alien/horde_mode/boss
	name = "Praetorian"
	desc = "A huge, looming beast of an alien."
	icon = 'icons/mob/xenos/praetorian.dmi'
	icon_size = 64
	pixel_x = -16
	old_x = -16
	melee_damage_lower = XENO_DAMAGE_TIER_5
	melee_damage_upper = XENO_DAMAGE_TIER_5
	health = XENO_HEALTH_QUEEN * 2
	move_to_delay = 4.5
	kill_reward = 1000
	mob_size = MOB_SIZE_BIG
	COOLDOWN_DECLARE(shared_ability)
	COOLDOWN_DECLARE(first_ability)
	COOLDOWN_DECLARE(second_ability)

/mob/living/simple_animal/hostile/alien/horde_mode/boss/Life(delta_time)
	if(target_mob && (target_mob in ListTargets(10)))
		if(COOLDOWN_FINISHED(src, first_ability) && COOLDOWN_FINISHED(src, shared_ability) && prob(75))
			INVOKE_ASYNC(src, PROC_REF(first_ability))
		if(COOLDOWN_FINISHED(src, second_ability) && COOLDOWN_FINISHED(src, shared_ability) && prob(50))
			INVOKE_ASYNC(src, PROC_REF(second_ability))

	. = ..()

/mob/living/simple_animal/hostile/alien/horde_mode/boss/proc/first_ability()
	COOLDOWN_START(src, first_ability, 8 SECONDS)
	COOLDOWN_START(src, shared_ability, 2 SECONDS)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "roar")
	visible_message(SPAN_HIGHDANGER("[src] begins to dash forward!"))
	move_to_delay = 3
	MoveToTarget()
	AddComponent(/datum/component/footstep, 2 , 35, 11, 4, "alien_footstep_large")
	sleep(3 SECONDS)
	move_to_delay = 4.5
	MoveToTarget()
	GetExactComponent(/datum/component/footstep).RemoveComponent()

/mob/living/simple_animal/hostile/alien/horde_mode/boss/proc/second_ability()
	COOLDOWN_START(src, second_ability, 8 SECONDS)
	COOLDOWN_START(src, shared_ability, 2 SECONDS)
	playsound(loc, 'sound/effects/refill.ogg', 30, 1)
	visible_message(SPAN_XENOWARNING("[src] vomits a flood of acid!"))
	do_acid_spray_line(get_line(src, target_mob, include_start_atom = FALSE), /obj/effect/xenomorph/spray/strong/no_stun, 7)

/mob/living/simple_animal/hostile/alien/proc/do_acid_spray_line(list/turflist, spray_path = /obj/effect/xenomorph/spray, distance_max = 5)
	if(isnull(turflist))
		return
	var/turf/prev_turf = loc

	var/distance = 0
	for(var/turf/T in turflist)
		distance++

		if(!prev_turf && length(turflist) > 1)
			prev_turf = get_turf(src)
			continue //So we don't burn the tile we be standin on

		if(T.density || istype(T, /turf/open/space))
			break
		if(distance > distance_max)
			break

		var/atom/movable/temp = new spray_path()
		var/atom/movable/AM = LinkBlocked(temp, prev_turf, T)
		qdel(temp)
		if(AM)
			if(istype(AM, /mob/living/simple_animal/hostile/alien/horde_mode))
				var/mob/living/simple_animal/hostile/alien/horde_mode/alien = AM
				if(alien.faction != src.faction)
					AM.acid_spray_act(src)
					break
			else
				AM.acid_spray_act(src)
				break

		prev_turf = T
		new spray_path(T, create_cause_data(src))
		sleep(1)

/mob/living/simple_animal/hostile/alien/horde_mode/boss/death(cause, gibbed, deathmessage)
	. = ..()
	var/list/all_players
	for(var/list/player_in_list as anything in SShorde_mode.current_players)
		var/player_mob = player_in_list["mob"]
		all_players += player_mob
	for(var/mob/player in all_players)
		SShorde_mode.update_points(player, kill_reward / length(all_players))
		balloon_alert_to_viewers("+[kill_reward]")


#undef FIRE_LAYER
