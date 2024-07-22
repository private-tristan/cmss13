SUBSYSTEM_DEF(horde_mode)
	name  = "Horde Mode"
	wait  = 5 SECONDS
	flags = SS_KEEP_TIMING | SS_NO_INIT
	init_order = SS_INIT_HORDE_MODE

	var/list/mob/living/carbon/human/current_players = list()
	var/list/obj/effect/landmark/horde_mode/marinespawn/marine_spawns = list()
	var/list/obj/effect/landmark/horde_mode/xenospawn/xeno_spawns = list()
	var/list/mob/living/simple_animal/hostile/alien/horde_mode/current_xenos = list()
	var/list/spawnable_xenos = list(
		/mob/living/simple_animal/hostile/alien/horde_mode/lesser_drone
	)
	var/spawn_max = 2
	var/amount_to_spawn = 5
	var/round = 1
	var/round_ended = FALSE
	var/xeno_health_mod = 0.35
	var/xeno_damage_mod = 0.5
	var/intro_played = TRUE
	var/round_checked = TRUE
	var/spawn_wave = 2
	var/max_sentries = 2
	var/sentries_active = 0
	var/list/new_round_sound = list('sound/voice/alien_distantroar_3.ogg','sound/voice/xenos_roaring.ogg', 'sound/voice/4_xeno_roars.ogg')
	COOLDOWN_DECLARE(round_cooldown)

/datum/controller/subsystem/horde_mode/fire(resumed = FALSE)
	if(!length(current_players) || !COOLDOWN_FINISHED(src, round_cooldown))
		return

	if(round == 1 && !intro_played)
		intro_played = TRUE
		sleep(4 SECONDS)
		send_player_message(SPAN_HIGHDANGER("You feel like there are a thousand eyes upon you."))
		sleep(6 SECONDS)
		send_player_message(SPAN_HIGHDANGER("A gust of wind passes by, the sound being interrupted by a distant roar. Soon enough it is followed up by a chorus of screeches and howls."))
		sleep(6 SECONDS)
		send_player_message(SPAN_HIGHDANGER("To your disdain, the sounds seem to be getting closer and closer..."))
		sleep(8 SECONDS)
		send_player_message(SPAN_HIGHDANGER("You know nothing good can come out of this. You steel yourself for what's about to come."))
		sleep(8 SECONDS)
		send_player_message(SPAN_HIGHDANGER("A cacophany of horrific screeches echo in the distance. They're here!"))
		world << sound(new_round_sound)

	if(!amount_to_spawn && !length(current_xenos) && !round_ended)
		COOLDOWN_START(src, round_cooldown, (12 + round) SECONDS)
		round_ended = TRUE
		send_player_message(SPAN_HIGHDANGER("Seems like the horde has died down... Take a breather and ready yourself for the next one."))

	if(!amount_to_spawn && !length(current_xenos) && COOLDOWN_FINISHED(src, round_cooldown))
		send_player_message(SPAN_HIGHDANGER("A cacophany of horrific screeches echo in the distance. They're here!"))
		world << sound(new_round_sound)
		round++
		xeno_health_mod += 0.05
		xeno_damage_mod += 0.025
		amount_to_spawn = 3*round+2
		if(spawn_max < spawn_max + 2 + length(current_players))
			spawn_max++
		round_ended = FALSE
		round_checked = FALSE

	if(!round_checked)
		round_checked = TRUE
		handle_new_xenos()

	for(spawn_wave, spawn_wave > 0, spawn_wave--)
		if(length(current_xenos) < spawn_max && amount_to_spawn != 0)
			var/spawn_loc = SAFEPICK(xeno_spawns)
			var/mob_type = pick(spawnable_xenos)
			if(isnull(spawn_loc))
				return
			new mob_type(spawn_loc)
			amount_to_spawn--
	spawn_wave = clamp(round, 1, 6)

/datum/controller/subsystem/horde_mode/proc/handle_new_xenos()
	if(round == 2)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode)
	if(round == 4)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/runner)
		send_player_message(SPAN_XENOHIGHDANGER("You catch a glimpse of something red in the distance... it's moving so fast!"))
	if(round == 6)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/lurker)
		spawnable_xenos.Remove(/mob/living/simple_animal/hostile/alien/horde_mode/lesser_drone)
		send_player_message(SPAN_XENOHIGHDANGER("The air seems to shimmer around you... or is it just your imagination?"))

/datum/controller/subsystem/horde_mode/proc/update_points(mob/living/player_mob, point_amount)
	for(var/list/player as anything in current_players)
		if(player["mob"] == player_mob)
			player["points"] += point_amount

/datum/controller/subsystem/horde_mode/proc/send_player_message(message)
	for(var/list/player_in_list as anything in current_players)
		var/player_mob = player_in_list["mob"]
		to_chat(player_mob, message)

/datum/controller/subsystem/horde_mode/proc/handle_purchase(mob/living/player_mob, cost)
	for(var/list/player as anything in current_players)
		if(player["mob"] == player_mob)
			if(player["points"] >= cost)
				player["points"] -= cost
				return TRUE
			else
				playsound(player_mob.loc, 'sound/effects/horde_mode/purchase_denied.ogg')
				to_chat(player_mob, SPAN_WARNING("You don't have enough points to buy this!"))
				return FALSE

	to_chat(player_mob, SPAN_WARNING("This doesn't seem to be for you..."))
