/obj/item/horde_mode
	name = "horde mode item"
	desc = "you should not be seeing this."
	w_class = SIZE_SMALL
	var/throw_away = FALSE

/obj/item/horde_mode/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(throw_away))

/obj/item/horde_mode/proc/throw_away(mob/user)
	SIGNAL_HANDLER

	if(!throw_away || !isturf(loc))
		return

	UnregisterSignal(src, COMSIG_ITEM_DROPPED)
	to_chat(user, SPAN_NOTICE("You throw away [src]."))
	QDEL_IN(src, 3 SECONDS)
	animate(src, 3 SECONDS, alpha = 0, easing = CUBIC_EASING)


//STIM BASE
///////////
/obj/item/horde_mode/stim
	name = "stim"
	icon = 'icons/obj/items/syringe.dmi'
	icon_state = "empty_ez"
	var/image/reagent_image
	var/reagent_image_fill = "custom_ez_1"
	var/reagent_color = "#80ff80"

/obj/item/horde_mode/stim/Initialize(mapload, ...)
	. = ..()
	reagent_image = image(icon, icon_state = reagent_image_fill)
	reagent_image.color = reagent_color
	overlays += reagent_image

//HEALING STIM
/////////////
/obj/item/horde_mode/stim/healing
	name = "\improper disposable healing stimulant autoinjector"
	desc = "An one-use auto-injector loaded with a mix of advanced healing chemicals, used for treating various types of damage extremely rapidly. Doesn't require any training to use. <b>Designed to be disposed after use.</b>"
	reagent_color = COLOR_MODERATE_BLUE

/obj/item/horde_mode/stim/healing/attack_self(mob/user)
	. = ..()
	inject(user, user)

/obj/item/horde_mode/stim/healing/attack(mob/attacked_mob, mob/user)
	. = ..()
	if(attacked_mob == user)
		inject(user, user)
	if(istype(attacked_mob, /mob/living/carbon/human))
		inject(attacked_mob, user)

/obj/item/horde_mode/stim/healing/interact(mob/user)
	. = ..()
	inject(user, user)

/obj/item/horde_mode/stim/healing/proc/inject(mob/living/carbon/human/target, mob/living/user)
	if(throw_away)
		to_chat(user, SPAN_WARNING("[src] is expended!"))
		return

	var/total_health = target.species.total_health
	target.heal_overall_damage(total_health * 0.33, total_health * 0.33)
	playsound(loc, 'sound/items/air_release.ogg', 70)
	overlays = null
	if(user == target)
		to_chat(user, SPAN_NOTICE("You inject yourself with [src]. Your heart immediately starts beating faster."))
	else
		to_chat(user, SPAN_NOTICE("You inject [target] with [src]."))
		to_chat(target, SPAN_WARNING("You feel a tiny prick, and your heart immediately starts beating faster."))
	throw_away = TRUE

//HEALING STIM
/////////////
/obj/item/horde_mode/stim/healing/speed
	name = "\improper disposable speed stimulant autoinjector"
	desc = "An one-use auto-injector loaded with musclestimulating chemicals, used for giving the user a rush of speed. Doesn't require any training to use. <b>Designed to be disposed after use.</b>"
	reagent_color = COLOR_STRONG_VIOLET

/obj/item/horde_mode/stim/healing/speed/get_examine_text(mob/user)
	. = ..()
	. += SPAN_DANGER("WARNING: LETHAL OVERDOSE IS POSSIBLE. DO NOT INJECT MORE THAN ONE DOSE IN A SHORT PERIOD OF TIME.")

/obj/item/horde_mode/stim/healing/speed/inject(mob/living/carbon/human/target, mob/living/user)
	if(throw_away)
		to_chat(user, SPAN_WARNING("[src] is expended!"))
		return

	target.reagents.add_reagent("speed_stimulant", 15)
	playsound(loc, 'sound/items/air_release.ogg', 70)
	overlays = null
	if(user == target)
		to_chat(user, SPAN_NOTICE("You inject yourself with [src]. Your legs immediately start burning up."))
	else
		to_chat(user, SPAN_NOTICE("You inject [target] with [src]."))
		to_chat(target, SPAN_WARNING("You feel a tiny prick, and your legs immediately start burning up."))
	throw_away = TRUE

//CIPHER STIM
/////////////
/obj/item/horde_mode/stim/cipher
	name = "cipher stim"
	desc = "A product of shady and questionable research, this stimulant is designed to be used on xenomorphs. It modifies their genetic makeup and neural pathways in order to make them more accommodating to humans."
	icon = 'icons/obj/items/syringe.dmi'
	icon_state = "stimpack"
	reagent_image_fill = "+stimpack_custom"

/obj/item/horde_mode/stim/cipher/get_examine_text(mob/user)
	. = ..()
	. += SPAN_DANGER("Weaker specimens will not be able to handle the transformation process and will die due to it!")

/obj/item/horde_mode/stim/cipher/attack(mob/living/target, mob/living/user)
	if(throw_away)
		to_chat(user, SPAN_WARNING("[src] is expended!"))
		return

	if(!istype(target, /mob/living/simple_animal/hostile/alien/horde_mode))
		to_chat(user, SPAN_WARNING("That wouldn't work..."))
		return

	if(istype(target, /mob/living/simple_animal/hostile/alien/horde_mode/boss) && target.health > target.maxHealth * 0.5)
		to_chat(user, SPAN_DANGER("[target] is too strong and rejects [src]! You need to wound them more."))
		return

	to_chat(user, SPAN_DANGER("You inject [target] with [src]!"))
	var/mob/living/simple_animal/hostile/alien/horde_mode/boss/xeno = target
	playsound(loc, 'sound/items/air_release.ogg', 75)
	overlays = null
	icon_state = "stimpack0"
	name = "expended [name]"
	xeno.turn_corrupt()
	throw_away = TRUE
