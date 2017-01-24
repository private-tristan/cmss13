// Adding a special temporary (or permanent) M240A1 incinerator file as i work on it. ~Art
////////////////////////////////////////////////

/obj/item/ammo_magazine/flamer_tank
	name = "incinerator tank"
	desc = "A fuel tank of usually Ultra Thick Napthal Fuel,a sticky combustable liquid chemical, for use in the M240 Incinerator unit. Handle with care."
	icon_state = "flametank"
	default_ammo = /datum/ammo/flamethrower //doesn't actually need bullets. But we'll get null ammo error messages if we don't
	max_rounds = 150 //Actually the max amount of turfs it can light on fire. This should probably last for a while.
	current_rounds = 150
	w_class = 3.0 //making sure you can't sneak this onto your belt.
	gun_type = /obj/item/weapon/gun/flamer
	caliber = "UT-Napthal Fuel" //Ultra Thick Napthal Fuel, from the lore book.

	afterattack(obj/target, mob/user , flag) //refuel at fueltanks when we run out of ammo.
		if(istype(target, /obj/structure/reagent_dispensers/fueltank))
			var/obj/structure/reagent_dispensers/fueltank/FT = target
			if(!current_rounds)
				caliber = "Fuel"
				playsound(loc, 'sound/effects/refill.ogg', 50, 1, -6)
				var/fuel_amount = FT.reagents.get_reagent_amount("fuel") < 150 ? FT.reagents.get_reagent_amount("fuel") : 150
				FT.reagents.remove_reagent("fuel", fuel_amount)
				current_rounds = fuel_amount
				update_icon()
				return
			else
				user << "<span class='boldnotice'>You can't mix fuel mixtures!</span>"
				return
		else
			..()

	update_icon() //keep this simple.
		icon_state = "flametank"



//////////////////////////////////////////
//Actual Flamerthrower.

/*
Just a minor area to layout my plan for this. It'll be more deadly with the ability to catch mobs on fire. It'll also have a function with two
levels of heat generated by the fuel.
*/

/obj/item/weapon/gun/flamer
	name = "\improper M240A1 incinerator unit"
	desc = "M240A1 incinerator unit has proven to be one of the most effective weapons at clearing out soft-targets. This is a weapon to be feared and respective as it is quite deadly."
	origin_tech = "combat=4;materials=3"
	icon_state = "m240"
	item_state = "flamer"
	flags_equip_slot = SLOT_BACK
	w_class = 4
	force = 15
	flags_atom = FPRINT|CONDUCT|TWOHANDED
	aim_slowdown = SLOWDOWN_ADS_SCOPE //Makes it a bit more attractive, especially toward B18, etc.
	var/lit = 0 //Turn the flamer on/off
	current_mag = /obj/item/ammo_magazine/flamer_tank
	var/max_range = 5
	attachable_allowed = list( //give it some flexibility.
						/obj/item/attachable/flashlight,
						/obj/item/attachable/magnetic_harness)
	New()
		..()
		fire_delay = config.high_fire_delay //High is probably better.
		attachable_offset = list("rail_x" = 12, "rail_y" = 23)

	unique_action(mob/user)
		toggle_flame(user)

/obj/item/weapon/gun/flamer/able_to_fire(mob/user)
	. = ..()
	if(.)
		if(!current_mag || !current_mag.current_rounds) return 0

/obj/item/weapon/gun/flamer/Fire(atom/target, mob/living/user, params, reflex = 0)
	set waitfor = 0
	if(!able_to_fire(user)) return
	var/turf/curloc = get_turf(user) //In case the target or we are expired.
	var/turf/targloc = get_turf(target)
	if (!targloc || !curloc) return //Something has gone wrong...

	if(!lit)
		user << "<span class='alert'>The weapon isn't lit</span>"
		return

	unleash_flame(target, user)
	return

/obj/item/weapon/gun/flamer/proc/toggle_flame(mob/user)
	playsound(user,'sound/weapons/flipblade.ogg', 100, 1)
	lit = !lit
	var/image/reusable/I = rnew(/image/reusable, list('icons/obj/gun.dmi',src,"+lit",layer))
	I.pixel_x += 3
	if(lit)	overlays += I
	else
		overlays -= I
		cdel(I)
	return

/obj/item/weapon/gun/flamer/proc/unleash_flame(atom/target, mob/living/user)
	set waitfor = 0
	var/list/turf/turfs = getline2(user,target)
	var/distance = 0
	var/obj/structure/window/W
	var/turf/T
	var/burnlevel
	var/burntime
	switch(current_mag.caliber)
		if("UT-Napthal Fuel") //This isn't actually Napalm actually.
			burnlevel = 25
			burntime = 20
			max_range = 7
		if("Napalm B") //Also a nice middle ground between Napalm C (our future Napalm) and standard fuel for flamers.
			burnlevel = 35 //This was set before weakening and changing regular fuel name to UT-Napathal Fuel
			burntime = 50 //This was just always long.
			max_range = 7
		if("Napalm C") //Probably can end up as a spec fuel or DS flamer fuel. Also this was the original fueltype, the madman i am.
			burnlevel = 50
			burntime = 40
			max_range = 8
		if("Fuel") //This is welding fuel and thus pretty weak. Not ment to be exactly used for flamers either.
			burnlevel = 10
			burntime = 10
			max_range = 5
		else //Make sure nothing fucks up.
			burnlevel = 0
			burntime = 0
			max_range = 0
	playsound(user, 'sound/weapons/flamethrower_2.ogg', 80, 1)
	for(T in turfs)
		if(T == user.loc) 			continue
		if(T.density)				break
		if(!current_mag.current_rounds) 		break
		if(distance >= max_range) 	break
		if(DirBlocked(T,user.dir))  break
		else if(DirBlocked(T,turn(user.dir,180))) break
		if(locate(/obj/effect/alien/resin/wall,T) || locate(/obj/structure/mineral_door/resin,T) || locate(/obj/effect/alien/resin/membrane,T)) break
		W = locate() in T
		if(W)
			if(W.is_full_window()) 	break
			if(W.dir == user.dir) 	break
		current_mag.current_rounds--
		flame_turf(T,user, burntime, burnlevel)
		distance++
		sleep(1)

/obj/item/weapon/gun/flamer/proc/flame_turf(turf/T, mob/living/user, heat, burn)
	if(!istype(T)) return

	if(!locate(/obj/flamer_fire) in T) // No stacking flames!
		var/obj/flamer_fire/F =  new/obj/flamer_fire(T)
		F.firelevel = heat
		F.burnlevel = burn
		processing_objects.Add(F)
	else return

	for(var/mob/living/M in T) //Deal bonus damage if someone's caught directly in initial stream
		if(M.stat == DEAD)		continue

		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/X = M
			if(X.fire_immune) 	continue
		else if(ishuman(M))
			var/mob/living/carbon/human/H = M //fixed :s
			if(istype(H.wear_suit, /obj/item/clothing/suit/fire)) continue

		M.adjust_fire_stacks(1,(burn*2))
		M.IgniteMob()
		M.adjustFireLoss(rand(burn,(burn*2))) // Make it so its the amount of heat or twice it for the initial blast.
		M << "[isXeno(M)?"<span class='xenodanger'>":"<span class='highdanger'>"]Augh! You are roasted by the flames!"

//////////////////////////////////////////////////////////////////////////////////////////////////
//Time to redo part of abby's code.
//Create a flame sprite object. Doesn't work like regular fire, ie. does not affect atmos or heat
/obj/flamer_fire
	name = "Fire"
	desc = "Ouch!"
	anchored = 1
	mouse_opacity = 0
	icon = 'icons/effects/fire.dmi'
	icon_state = "2"
	layer = TURF_LAYER
	var/firelevel = 12 //Tracks how much "fire" there is. Basically the timer of how long the fire burns
	var/burnlevel = 10 //Tracks how HOT the fire is. This is basically the heat level of the fire and determines the temperature.

/obj/flamer_fire/Crossed(mob/living/M) //Only way to get it to reliable do it when you walk into it.
	if(ismob(M))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.wear_suit, /obj/item/clothing/suit/fire))
				H.show_message(text("Your suit protects you from the flames."),1)
				H.adjustFireLoss(burnlevel*0.25) //Does small burn damage to a person wearing one of the suits.
				return
		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/X = M
			if(X.fire_immune) 	return
		M.adjust_fire_stacks((burnlevel*0.5),burnlevel) //Make it possible to light them on fire later.
		M.adjustFireLoss(rand(10,burnlevel)) //This makes fire stronk.
		M.show_message(text("<span class='danger'>You are burned!</span>"),1)
		if(isXeno(M))
			M.updatehealth()
	else
		return

/obj/flamer_fire/process()
	var/turf/T = loc

	if (!istype(T)) //Is it a valid turf? Has to be on a floor
		processing_objects -= src
		cdel(src)
		return
	if(burnlevel < 15)
		color = "#c1c1c1" //make it darker to make show its weaker.
	switch(firelevel)
		if(25) //Change the icons and luminosity based on the fire's intensity
			icon_state = "3"
			SetLuminosity(7)
		if(10)
			icon_state = "2"
			SetLuminosity(5)
		if(5)
			icon_state = "1"
			SetLuminosity(2)
		if(0 to -10)  //Fire has burned out, firelevel is 0 or less. GET OUT. Shouldn't cause issues, unlike sleep() + Del
			SetLuminosity(0)
			processing_objects.Remove(src)
			cdel(src)
			return

	var/j = 0
	for(var/i in loc)
		if(++j >= 11) break
		if(ismob(i))
			var/mob/living/I = i
			if(istype(I,/mob/living/carbon/human))
				var/mob/living/carbon/human/M = I
				if(istype(M.wear_suit, /obj/item/clothing/suit/fire) || istype(M.wear_suit,/obj/item/clothing/suit/space/rig/atmos))
					M.show_message(text("Your suit protects you from the flames."),1)
					M.adjustFireLoss(rand(0 ,burnlevel*0.25)) //Does small burn damage to a person wearing one of the suits.
					continue
			if(istype(I,/mob/living/carbon/Xenomorph/Queen))
				var/mob/living/carbon/Xenomorph/Queen/X = I
				X.show_message(text("Your extra-thick exoskeleton protects you from the flames."),1)
				continue
			if(istype(I,/mob/living/carbon/Xenomorph/Ravager))
				var/mob/living/carbon/Xenomorph/Ravager/X = I
				X.storedplasma = X.maxplasma
				X.usedcharge = 0 //Reset charge cooldown
				X.show_message(text("<span class='danger'>The heat of the fire roars in your veins! KILL! CHARGE! DESTROY!</span>"),1)
				if(rand(1,100) < 70)
					X.emote("roar")
				continue
			I.adjust_fire_stacks(burnlevel,(burnlevel*2)) //If i stand in the fire i deserve all of this. Also Napalm stacks quickly.
			I.IgniteMob()
			I.adjustFireLoss(rand(10 ,burnlevel)) //Including the fire should be way stronger.
			I.show_message(text("<span class='warning'>You are burned!</span>"),1)
			if(isXeno(I)) //Have no fucken idea why the Xeno thing was there twice.
				var/mob/living/carbon/Xenomorph/X = I
				X.updatehealth()
		if(istype(i, /obj/))
			var/obj/O = i
			O.flamer_fire_act()

	//This has been made a simple loop, for the most part flamer_fire_act() just does return, but for specific items it'll cause other effects.
	firelevel -= 2 //reduce the intensity by 2 per tick
	return