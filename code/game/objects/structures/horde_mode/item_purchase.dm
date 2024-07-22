/obj/structure/item_purchase
	name = "item purchase"
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "case"
	var/obj/primary_purchase = /obj/item/weapon/gun/rifle/m41a
	var/obj/secondary_purchase
	var/obj/tertiary_purchase
	var/obj/quaternary_purchase
	var/primary_cost = 1000
	var/secondary_cost = 300
	var/tertiary_cost
	var/quaternary_cost
	var/has_post_purchase_effect = FALSE
	var/has_hover_effect = TRUE
	var/obj/effect/hovering_effect
	var/obj/custom_hovering_icon

/obj/structure/item_purchase/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to purchase \a <b>[primary_purchase.name]</b> for [primary_cost] points.")
	if(secondary_purchase)
		. += SPAN_NOTICE("Use <b>DISARM INTENT</b> to purchase \a <b>[secondary_purchase.name]</b> for [secondary_cost] points.")
	if(tertiary_purchase)
		. += SPAN_NOTICE("Use <b>GRAB INTENT</b> to purchase \a <b>[tertiary_purchase.name]</b> for [tertiary_cost] points.")
	if(quaternary_purchase)
		. += SPAN_NOTICE("Use <b>HARM INTENT</b> to purchase \a <b>[quaternary_purchase.name]</b> for [quaternary_cost] points.")

/obj/structure/item_purchase/Initialize(mapload, ...)
	. = ..()
	if(has_hover_effect)
		hovering_effect = new /obj/effect/item_purchase(loc)
		if(!custom_hovering_icon)
			hovering_effect.icon = primary_purchase.icon
			hovering_effect.icon_state = primary_purchase.icon_state
		else
			hovering_effect.icon = custom_hovering_icon.icon
			hovering_effect.icon_state = custom_hovering_icon.icon_state

/obj/structure/item_purchase/attack_hand(mob/user)
	var/obj/item/purchased_item

	if(user.a_intent == INTENT_HELP)
		if(!SShorde_mode.handle_purchase(user, primary_cost))
			return
		purchased_item = new primary_purchase(loc)

	if(user.a_intent == INTENT_DISARM && !isnull(secondary_purchase))
		if(!SShorde_mode.handle_purchase(user, secondary_cost))
			return
		purchased_item = new secondary_purchase(loc)

	if(user.a_intent == INTENT_GRAB && !isnull(tertiary_purchase))
		if(!SShorde_mode.handle_purchase(user, tertiary_cost))
			return
		purchased_item = new tertiary_purchase(loc)

	if(user.a_intent == INTENT_HARM && !isnull(quaternary_purchase))
		if(!SShorde_mode.handle_purchase(user, quaternary_cost))
			return
		purchased_item = new quaternary_purchase(loc)

	if(isnull(purchased_item))
		return

	if(istype(purchased_item, /obj/item/weapon/gun))
		playsound(user.loc, 'sound/effects/horde_mode/purchase_weapon.ogg')
	else
		playsound(user.loc, 'sound/effects/horde_mode/purchase_successful.ogg')
	if(has_post_purchase_effect)
		post_purchase_effect(purchased_item)
	user.put_in_hands(purchased_item)

/obj/structure/item_purchase/proc/post_purchase_effect(purchased_item)
	return


////////////////////
// ITEM PURCHASES //
////////////////////
/obj/structure/item_purchase/m41a
	name = "M41A pulse rifle MK2 case"
	secondary_purchase = /obj/item/ammo_magazine/rifle


/obj/structure/item_purchase/abr40
	name = "ABR-40 hunting rifle case"
	primary_purchase = /obj/item/weapon/gun/rifle/l42a/abr40
	secondary_purchase = /obj/item/ammo_magazine/rifle/l42a/abr40
	primary_cost = 350
	secondary_cost = 100

/obj/structure/item_purchase/m39
	name = "M39 submachinegun case"
	primary_purchase = /obj/item/weapon/gun/smg/m39
	secondary_purchase = /obj/item/ammo_magazine/smg/m39
	primary_cost = 700
	secondary_cost = 200


/obj/structure/item_purchase/machete
	name = "M2132 machete case"
	custom_hovering_icon = /obj/item/weapon/sword/machete
	primary_purchase = /obj/item/storage/large_holster/machete/full
	secondary_purchase = /obj/item/storage/pouch/machete/full
	primary_cost = 800
	secondary_cost = 1200
	has_post_purchase_effect = TRUE

/obj/structure/item_purchase/machete/post_purchase_effect(obj/item/purchased_item)
	for(var/obj/item/weapon/machete in purchased_item.contents)
		machete.force += MELEE_FORCE_WEAK

/obj/structure/item_purchase/sentry
	name = "disposable UA 571-C sentry gun case"
	desc = "A deployable, disposable, semi-automated turret with AI targeting capabilities. Hits hard, but only contains 150 rounds of ammo. Once it runs dry, say goodbye."
	primary_purchase = /obj/item/defenses/handheld/sentry/horde_mode
	primary_cost = 2000

/obj/structure/item_purchase/sentry/attack_hand(mob/user)
	if(SShorde_mode.sentries_active >= SShorde_mode.max_sentries)
		to_chat(user, SPAN_WARNING("There are too many sentries in action!"))
		return
	. = ..()

/obj/structure/item_purchase/sentry/get_examine_text(mob/user)
	. = ..()
	. += SPAN_DANGER("Purchase limit: <b>[SShorde_mode.sentries_active]/[SShorde_mode.max_sentries]</b>")

/obj/structure/item_purchase/hedp
	name = "M40 HEDP grenade crate"
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "nade_placeholder"
	primary_purchase = /obj/item/explosive/grenade/high_explosive
	primary_cost = 200

/obj/structure/item_purchase/gear
	name = "gear case"
	icon_state = "closed_woodcrate"
	primary_purchase = /obj/item/clothing/accessory/storage/droppouch
	secondary_purchase = /obj/item/storage/pouch/magazine
	tertiary_purchase = /obj/item/storage/belt/marine
	quaternary_purchase = /obj/item/storage/pouch/shotgun
	primary_cost = 600
	secondary_cost = 400
	tertiary_cost = 600
	quaternary_cost = 500

/obj/structure/item_purchase/firstaid
	name = "basic medical equipment"
	icon_state = "closed_medical"
	custom_hovering_icon = /obj/item/storage/firstaid
	primary_purchase = /obj/item/stack/medical/bruise_pack
	secondary_purchase = /obj/item/stack/medical/ointment
	tertiary_purchase = /obj/item/stack/medical/splint
	primary_cost = 200
	secondary_cost = 200
	tertiary_cost = 200


///////////////
// OBSTACLES //
///////////////
/obj/structure/item_purchase/door
	name = "obstacle"
	icon = 'icons/obj/structures/doors/personaldoor.dmi'
	icon_state = "door_closed"
	has_hover_effect = FALSE
	primary_purchase = null
	primary_cost = 500
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	var/door_id = 0

/obj/structure/item_purchase/door/attack_hand(mob/user)
	if(user.a_intent == INTENT_HELP)
		if(!SShorde_mode.handle_purchase(user, primary_cost))
			return

	for(var/obj/structure/item_purchase/door/doors_in_area in loc.loc)
		if(doors_in_area.door_id == door_id)
			qdel(doors_in_area)

	playsound(user.loc, 'sound/effects/horde_mode/purchase_successful.ogg')

/obj/structure/item_purchase/door/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, user)] That's \a [src]."
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to clear the way for [primary_cost] points.")


/////////////////////
// REFILL STATIONS //
/////////////////////
/obj/structure/item_purchase/injector_refill
	name = "weymed refill station"
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "wallmed"
	custom_hovering_icon = /obj/item/storage/firstaid
	primary_purchase = null
	primary_cost = 300
	has_hover_effect = FALSE

/obj/structure/item_purchase/injector_refill/attackby(obj/item/injector, mob/user)
	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector))
		to_chat(user, SPAN_WARNING("You can't refill this!"))
		return
	if(injector.reagents.total_volume == injector.reagents.maximum_volume)
		to_chat(user, SPAN_WARNING("[injector] is already full!"))
		return

	var/obj/item/purchased_item

	if(user.a_intent == INTENT_HELP)
		if(!SShorde_mode.handle_purchase(user, primary_cost))
			return
		purchased_item = new injector.type(loc)
		playsound(src, 'sound/effects/refill.ogg', 25, 1, 3)
		qdel(injector)

	user.put_in_hands(purchased_item)

/obj/structure/item_purchase/injector_refill/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, user)] That's \a [src]."
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to refill your autoinjector for [primary_cost] points	.")

/obj/structure/item_purchase/injector_refill/attack_hand(mob/user)
	return

/obj/structure/item_purchase/ammo_refill
	name = "ammo dump"
	desc = "There's a bunch of ammo sitting here. You could probably make use of it..."
	icon_state = "closed_green"
	custom_hovering_icon = /obj/item/ammo_box/rounds
	primary_purchase = null
	primary_cost = 1000 // RIFLES
	secondary_cost = 500 // SMGS
	tertiary_cost = 250 // PISTOLS
	quaternary_cost = 1500 // everything else

/obj/structure/item_purchase/ammo_refill/Initialize(mapload, ...)
	. = ..()
	hovering_effect.overlays += image(icon = 'icons/obj/items/weapons/guns/ammo_boxes/handfuls.dmi', icon_state = "rounds_reg")

/obj/structure/item_purchase/ammo_refill/attackby(obj/item/ammo_magazine/magazine, mob/user)
	if(!istype(magazine, /obj/item/ammo_magazine))
		to_chat(user, SPAN_WARNING("You can't refill this!"))
		return
	if(magazine.current_rounds == magazine.max_rounds)
		to_chat(user, SPAN_WARNING("[magazine] is already full!"))
		return

	var/magazine_type
	if(istype(magazine, /obj/item/ammo_magazine/pistol))
		magazine_type = "pistol"
	else if(istype(magazine, /obj/item/ammo_magazine/rifle))
		magazine_type = "rifle"
	else if(istype(magazine, /obj/item/ammo_magazine/smg))
		magazine_type = "smg"
	else
		magazine_type = "other"

	var/actual_cost
	switch(magazine_type)
		if("rifle")
			actual_cost = primary_cost
		if("smg")
			actual_cost = secondary_cost
		if("pistol")
			actual_cost = tertiary_cost
		if("other")
			actual_cost = quaternary_cost

	var/obj/item/purchased_item
	if(user.a_intent == INTENT_HELP)
		if(!SShorde_mode.handle_purchase(user, actual_cost))
			return
		purchased_item = new magazine.type(loc)
		playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)
		qdel(magazine)

	user.put_in_hands(purchased_item)

/obj/structure/item_purchase/ammo_refill/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, user)] That's \a [src]."
	. += desc
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to refill your magazine: \n<b>rifle magazine</b> - [primary_cost] points\n<b>SMG magazine</b> - [secondary_cost]points\n<b>pistol magazine</b> - [tertiary_cost] points\n<b>other magazines</b> - [quaternary_cost] points.")


///////////////////
// PERK MACHINES //
///////////////////
/obj/structure/item_purchase/perk_machine
	name = "Juggernaut Souto machine"
	desc = "This drink is infused with special protein chains that decrease prostaglandin production, along with enhancing the downstream of nitric oxide pathways inside the body. This ultimately leads to a weaker pain response and a stronger blood flow, allowing for the user to stay standing for a longer period of time. It's cranberry flavour, too!"
	primary_cost = 3500
	primary_purchase = /obj/item/perk_bottle

/obj/item/perk_bottle
	name = "\improper Juggernaut Souto"
	desc = "When you need some help to get by, something to make you big and strong..."
	icon = 'icons/obj/items/drinkcans.dmi'
	icon_state = "souto_cranberry"
	var/perk_trait = TRAIT_PERK_JUGGERNAUT

/obj/item/perk_bottle/attack_self(mob/user)
	. = ..()
	drink(user)

/obj/item/perk_bottle/attack(mob/attacked_mob, mob/user)
	. = ..()
	if(attacked_mob == user)
		drink(user)

/obj/item/perk_bottle/interact(mob/user)
	. = ..()
	drink(user)

/obj/item/perk_bottle/proc/drink(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, perk_trait))
		to_chat(user, SPAN_WARNING("You've already drank this Souto!"))
		return

	playsound(user.loc, 'sound/effects/canopen.ogg', 25, 1)
	to_chat(user, SPAN_NOTICE("You start gulping down [src]..."))
	if(!do_after(user, 4 SECONDS, INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC))
		return

	playsound(user.loc, 'sound/items/drink.ogg', 15, 1)
	ADD_TRAIT(user, perk_trait, src)
	to_chat(user, SPAN_NOTICE("You douse your thirst with [src]. That hits the spot!"))
	qdel(src)

/obj/structure/item_purchase/perk_machine/speed
	name = "Speed Souto machine"
	desc = "This drink is infused with chemicals that put the body's adrenal glands into overdrive, making them constantly pump out small amounts of adrenaline at a steady pace. The adrenal medulla is enhanced, allowing it to regulate epinephrine's effect on the body even more-so than before, which helps the heart handle the increased rush. It's pineapple flavour, too!"
	primary_cost = 3000
	primary_purchase = /obj/item/perk_bottle/speed

/obj/item/perk_bottle/speed
	name = "\improper Speed Souto"
	desc = "When you need some extra running, when you need some extra time..."
	icon = 'icons/obj/items/drinkcans.dmi'
	icon_state = "souto_pineapple"
	perk_trait = TRAIT_PERK_SPEED

/obj/structure/item_purchase/perk_machine/explosive_resistance
	name = "Boom Souto machine"
	desc = "This drink is infused with specialized myoblasts, which heighten the framework of connective tissue found around the muscles of the body. This leads to a strengthened muscle tissue, especially against shockwaves and blasts."
	primary_cost = 2500
	primary_purchase = /obj/item/perk_bottle/explosive_resistance

/obj/item/perk_bottle/explosive_resistance
	name = "\improper Boom Souto"
	desc = "Everybody needs some more, of your lovin', your explosive lovin'..."
	icon = 'icons/obj/items/drinkcans.dmi'
	icon_state = "souto_grape"
	perk_trait = TRAIT_PERK_EXPLOSIVE_RESISTANCE

/////////////////
// MYSTERY BOX //
/////////////////
/obj/structure/mystery_purchase
	name = "mystery box"
	icon = 'icons/obj/structures/crates.dmi'
	desc = "Do you feel lucky?"
	icon_state = "closed_woodcrate"
	var/obj/effect/hovering_effect
	var/list/high_tier_gear = list(/obj/item/weapon/gun/flamer, /obj/item/weapon/gun/rifle/m46c/mk1_ammo, /obj/item/weapon/gun/shotgun/combat/marsoc, /obj/item/weapon/gun/rifle/m41aMK1)
	var/list/med_tier_gear = list(/obj/item/weapon/gun/shotgun/combat/buckshot, /obj/item/weapon/gun/rifle/mar40/lmg, /obj/item/weapon/gun/rifle/m41a, /obj/item/weapon/gun/rifle/type71/carbine, /obj/item/weapon/gun/rifle/lmg, /obj/item/weapon/gun/rifle/xm177)
	var/list/low_tier_gear = list(/obj/item/weapon/gun/rifle/m4ra, /obj/item/weapon/gun/smg/mp5, /obj/item/weapon/gun/smg/fp9000, /obj/item/weapon/gun/rifle/m16, /obj/item/weapon/gun/rifle/mar40/lmg, /obj/item/weapon/gun/rifle/mar40/carbine, /obj/item/weapon/gun/rifle/mar40, )
	var/cost = 750
	var/obj/item/picked_item
	var/mob/living/last_used_by
	var/is_spinning = FALSE

/obj/structure/mystery_purchase/Initialize(mapload, ...)
	. = ..()
	hovering_effect = new /obj/effect/item_purchase(loc)
	hovering_effect.icon = 'icons/effects/techtree/tech.dmi'
	hovering_effect.icon_state = "unknown"

/obj/structure/mystery_purchase/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to get a random weapon for [cost] points.")
	. += SPAN_NOTICE("Don't like the item? Use <b>DISARM INTENT</b> to get half of your points back.")

/obj/structure/mystery_purchase/attack_hand(mob/user)
	if(user.a_intent != INTENT_HELP || is_spinning)
		return

	if(picked_item)
		if(user.a_intent == INTENT_HELP)
			pick_up_item(user)
			return
		if(user.a_intent == INTENT_DISARM)
			refund_item(user)
			return

	if(!SShorde_mode.handle_purchase(user, cost))
		return

	last_used_by = user
	picked_item = handle_mystery_item()
	mystery_purchase_effect()
	blink_effect()

/obj/structure/mystery_purchase/proc/mystery_purchase_effect()
	is_spinning = TRUE
	playsound(loc, 'sound/effects/horde_mode/mystery_purchase.ogg')
	sleep(0.25 SECONDS)
	icon_state = "open_woodcrate"
	sleep(0.25 SECONDS)
	for(var/i = 0, i < 17, i++)
		var/obj/item/random_item = pick(pick(low_tier_gear), pick(med_tier_gear), pick(high_tier_gear))
		hovering_effect.icon = random_item.icon
		hovering_effect.icon_state = random_item.icon_state
		sleep(0.3 SECONDS)

	hovering_effect.icon = picked_item.icon
	hovering_effect.icon_state = picked_item.icon_state
	is_spinning = FALSE

/obj/structure/mystery_purchase/proc/pick_up_item(mob/user)
	if(last_used_by != user)
		to_chat(user, SPAN_WARNING("That's not yours!"))
		return

	if(ispath(picked_item, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/purchased_gun = new picked_item(loc)
		var/ammo_to_give
		if(istype(purchased_gun, /obj/item/weapon/gun/shotgun))
			//Buff shotguns so they're actually useable.
			ammo_to_give = /obj/item/ammo_magazine/shotgun/buckshot
			purchased_gun.set_fire_delay(purchased_gun.get_fire_delay() * 0.6)
		else
			ammo_to_give = purchased_gun.current_mag.type
		for(var/i = 0, i <= 2, i++)
			new ammo_to_give(loc)
		user.put_in_hands(purchased_gun)
	else
		var/obj/item/purchased_item = new picked_item(loc)
		user.put_in_hands(purchased_item)

	reset_hovering_effect()
	picked_item = null

/obj/structure/mystery_purchase/proc/refund_item(mob/user)
	if(last_used_by != user)
		to_chat(user, SPAN_WARNING("That's not yours!"))
		return

	SShorde_mode.handle_purchase(user, -(cost/2))
	playsound(loc, 'sound/effects/horde_mode/purchase_weapon.ogg')
	reset_hovering_effect()
	picked_item = null

/obj/structure/mystery_purchase/proc/blink_effect()
	sleep(4 SECONDS)
	for(var/i = 0, i < 20, i++)
		if(!picked_item)
			return
		hovering_effect.alpha = 0
		sleep((0.5 - i / 10) SECONDS)
		hovering_effect.alpha = 255
		sleep((0.5 - i / 10) SECONDS)
	picked_item = null
	reset_hovering_effect()

/obj/structure/mystery_purchase/proc/reset_hovering_effect()
	hovering_effect.icon = 'icons/effects/techtree/tech.dmi'
	hovering_effect.icon_state = "unknown"
	hovering_effect.alpha = 255
	icon_state = "closed_woodcrate"

/obj/structure/mystery_purchase/proc/handle_mystery_item()
	if(prob(10))
		return pick(high_tier_gear)
	if(prob(30))
		return pick(med_tier_gear)
	return pick(low_tier_gear)


/////////////////////
// HOVERING EFFECT //
/////////////////////
/obj/effect/item_purchase
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m41a"
	pixel_y = 14

/obj/effect/item_purchase/Initialize(mapload, ...)
	. = ..()
	add_filter("outline", 1, outline_filter(size = 1, color = COLOR_WHITE, flags = OUTLINE_SHARP))
