/obj/structure/item_purchase
	name = "item purchase"
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "case"
	var/obj/primary_purchase = /obj/item/weapon/gun/rifle/m41a
	var/obj/secondary_purchase = /obj/item/ammo_magazine/rifle
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

	if(user.a_intent == INTENT_GRAB && !isnull(secondary_purchase))
		if(!SShorde_mode.handle_purchase(user, secondary_cost))
			return
		purchased_item = new secondary_purchase(loc)

	if(user.a_intent == INTENT_DISARM && !isnull(tertiary_purchase))
		if(!SShorde_mode.handle_purchase(user, tertiary_cost))
			return
		purchased_item = new tertiary_purchase(loc)

	if(user.a_intent == INTENT_HARM && !isnull(quaternary_purchase))
		if(!SShorde_mode.handle_purchase(user, quaternary_cost))
			return
		purchased_item = new quaternary_purchase(loc)

	if(istype(purchased_item, /obj/item/weapon/gun))
		playsound(user.loc, 'sound/effects/horde_mode/purchase_weapon.ogg')
	else
		playsound(user.loc, 'sound/effects/horde_mode/purchase_successful.ogg')
	user.put_in_hands(purchased_item)


/obj/structure/item_purchase/firstaid
	icon_state = "closed_medical"
	custom_hovering_icon = /obj/item/storage/firstaid
	primary_purchase = /obj/item/stack/medical/bruise_pack
	secondary_purchase = /obj/item/stack/medical/ointment
	tertiary_purchase = /obj/item/stack/medical/splint
	primary_cost = 200
	secondary_cost = 200
	tertiary_cost = 200

/obj/structure/item_purchase/perk_machine
	name = "perk machine"
	primary_cost = 2000
	primary_purchase = /obj/item/perk_bottle

/obj/item/perk_bottle
	name = "Juggernaut Souto"
	desc = "Makes you healthier!"
	icon = 'icons/obj/items/drinkcans.dmi'
	icon_state = "souto_cranberry"

/obj/item/perk_bottle/attack_self(mob/user)
	. = ..()
	drink(user)

/obj/item/perk_bottle/interact(mob/user)
	. = ..()
	drink(user)

/obj/item/perk_bottle/proc/drink(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_PERK_JUGGERNAUT))
		to_chat(SPAN_WARNING("You've already drank this Souto!"))

	if(!do_after(user, 4 SECONDS, INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC))
		return

	playsound(user.loc,'sound/items/drink.ogg', 15, 1)
	user.species.total_health += 75
	user.set_skill(SKILL_ENDURANCE, SKILL_ENDURANCE_MASTER)
	ADD_TRAIT(user, TRAIT_PERK_JUGGERNAUT, src)
	to_chat(user, SPAN_WARNING("You douse your thirst with [src]. That hits the spot!"))
	qdel(src)

/obj/effect/item_purchase
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m41a"
	pixel_y = 14

/obj/effect/item_purchase/Initialize(mapload, ...)
	. = ..()
	add_filter("outline", 1, outline_filter(size = 1, color = COLOR_WHITE, flags = OUTLINE_SHARP))
