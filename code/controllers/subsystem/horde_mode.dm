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
	var/list/spawnable_specialists = list()
	var/list/spawnable_bosses = list()
	var/list/corrupted_xenos = list()
	var/spawn_max = 2
	var/amount_to_spawn = 5
	var/bosses_to_spawn = 0
	var/max_specialists = 0
	var/specialists_to_spawn = 0
	var/spawn_wave = 2

	var/round = 1
	var/round_ended = FALSE
	var/intro_played = TRUE

	var/xeno_health_mod = 0.35
	var/xeno_damage_mod = 0.5 // DOES NOT AFFECT RANGED ATTACKS


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
		COOLDOWN_START(src, round_cooldown, (20 + round) SECONDS)
		round_ended = TRUE
		send_player_message(SPAN_HIGHDANGER("Seems like the horde has died down... Take a breather and ready yourself for the next one."))

	if(!amount_to_spawn && !length(current_xenos) && COOLDOWN_FINISHED(src, round_cooldown))
		send_player_message(SPAN_HIGHDANGER("A cacophany of horrific screeches echo in the distance. They're here!"))
		world << sound(new_round_sound)
		increment_round()

	if(bosses_to_spawn > 0)
		spawn_xeno(spawnable_bosses)
		bosses_to_spawn--

	for(spawn_wave, spawn_wave > 0, spawn_wave--)
		if(length(current_xenos) < spawn_max && amount_to_spawn != 0)
			if(specialists_to_spawn != 0 && prob(33))
				spawn_xeno(spawnable_specialists)
				specialists_to_spawn--
			else
				spawn_xeno(spawnable_xenos)
				amount_to_spawn--

	spawn_wave = clamp(round, 1, 6)

/datum/controller/subsystem/horde_mode/proc/spawn_xeno(xeno_type)
	var/spawn_loc = SAFEPICK(xeno_spawns)
	var/mob_type = pick(xeno_type)
	if(isnull(spawn_loc))
		return
	new mob_type(spawn_loc)

/datum/controller/subsystem/horde_mode/proc/increment_round(times = 1)
	for(times, times > 0, times--)
		round++
		handle_new_xenos()
		xeno_health_mod += 0.025
		xeno_damage_mod += 0.025
		amount_to_spawn = 3*round+2
		specialists_to_spawn = max_specialists
		if(spawn_max < initial(spawn_max) + 3 + length(current_players))
			spawn_max++
		round_ended = FALSE

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
	if(round == 7)
		spawnable_specialists.Add(/mob/living/simple_animal/hostile/alien/horde_mode/ranged/sentinel)
		max_specialists = 3
		send_player_message(SPAN_XENOHIGHDANGER("A dizzying vapour overcomes you..."))
	if(round == 8)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/defender)
		send_player_message(SPAN_XENOHIGHDANGER("You start hearing loud thumps in the distance..."))
	if(round == 10)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/ranged/spitter)
		max_specialists = 4
		send_player_message(SPAN_XENOHIGHDANGER("Noxious fumes begin to assault your senses..."))
	if(round == 12)
		spawnable_xenos.Add(/mob/living/simple_animal/hostile/alien/horde_mode/warrior)
		max_specialists = 6
		send_player_message(SPAN_XENOHIGHDANGER("You start hearing bloodcurdling roars in the distance..."))
	if(round == 14)
		spawnable_bosses.Add(/mob/living/simple_animal/hostile/alien/horde_mode/boss)
		bosses_to_spawn++
		send_player_message(SPAN_XENOHIGHDANGER("You hear menacing stomps in the distance..."))

/datum/controller/subsystem/horde_mode/proc/update_points(mob/living/player_mob, point_amount)
	for(var/list/player as anything in current_players)
		if(player["mob"] == player_mob)
			player["points"] += point_amount

/datum/controller/subsystem/horde_mode/proc/send_player_message(message)
	for(var/list/player_in_list as anything in current_players)
		var/player_mob = player_in_list["mob"]
		to_chat(player_mob, message)


/datum/controller/subsystem/horde_mode/proc/return_random_player()
	var/list/all_players
	for(var/list/player_in_list as anything in current_players)
		var/mob/living/player_mob = player_in_list["mob"]
		if(player_mob.stat != DEAD)
			all_players += player_mob
	return pick(all_players)

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
