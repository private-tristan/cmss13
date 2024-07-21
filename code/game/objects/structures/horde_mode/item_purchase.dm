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
		. += SPAN_NOTICE("Use <b>GRAB INTENT</b> to purchase \a <b>[tertiary_purchase.name]</b> for [tertiary_cost] points.")

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
	user.put_in_hands(purchased_item)

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
	primary_cost = 300
	secondary_cost = 500

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
	primary_cost = 600
	secondary_cost = 400
	tertiary_cost = 600

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

/obj/structure/item_purchase/injector_refill
	name = "weymed refill station"
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "wallmed"
	custom_hovering_icon = /obj/item/storage/firstaid
	primary_purchase = null
	primary_cost = 300
	has_hover_effect = FALSE
	var/emergency_injector_cost = 700

/obj/structure/item_purchase/injector_refill/attackby(obj/item/injector, mob/user)
	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector))
		to_chat(user, SPAN_WARNING("You can't refill this!"))
		return
	if(injector.reagents.total_volume == injector.reagents.maximum_volume)
		to_chat(user, SPAN_WARNING("[injector] is already full!"))
		return

	var/obj/item/purchased_item
	var/extra_cost = 0
	if(istype(injector,/obj/item/reagent_container/hypospray/autoinjector/emergency))
		extra_cost += emergency_injector_cost

	if(user.a_intent == INTENT_HELP)
		if(!SShorde_mode.handle_purchase(user, primary_cost + extra_cost))
			return
		purchased_item = new injector.type(loc)
		playsound(src, 'sound/effects/refill.ogg', 10, 1, 3)
		qdel(injector)

	playsound(user.loc, 'sound/effects/horde_mode/purchase_successful.ogg')
	user.put_in_hands(purchased_item)

/obj/structure/item_purchase/injector_refill/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, user)] That's \a [src]."
	. += SPAN_NOTICE("Use <b>HELP INTENT</b> to refill your autoinjector for [primary_cost] points	.")
	. += SPAN_NOTICE("<b>EMERGENCY AUTOINJECTORS</b> incur an extra [emergency_injector_cost] cost.")

/obj/structure/item_purchase/injector_refill/attack_hand(mob/user)
	return

/obj/structure/item_purchase/perk_machine
	name = "Juggernaut Souto machine"
	desc = "This drink is infused with special protein chains that decrease prostaglandin production, along with enhancing the downstream of nitric oxide pathways inside the body. This ultimately leads to a weaker pain response and a stronger blood flow, allowing for the user to stay standing for a longer period of time. It's cranberry flavour, too!"
	primary_cost = 2000
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
	primary_cost = 1500
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
	primary_cost = 1750
	primary_purchase = /obj/item/perk_bottle/explosive_resistance

/obj/item/perk_bottle/explosive_resistance
	name = "\improper Boom Souto"
	desc = "Everybody needs some more, of your lovin', your explosive lovin'..."
	icon = 'icons/obj/items/drinkcans.dmi'
	icon_state = "souto_grape"
	perk_trait = TRAIT_PERK_EXPLOSIVE_RESISTANCE

/obj/effect/item_purchase
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m41a"
	pixel_y = 14

/obj/effect/item_purchase/Initialize(mapload, ...)
	. = ..()
	add_filter("outline", 1, outline_filter(size = 1, color = COLOR_WHITE, flags = OUTLINE_SHARP))
