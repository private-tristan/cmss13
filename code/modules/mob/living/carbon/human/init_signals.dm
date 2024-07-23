/mob/living/carbon/human/proc/register_human_init_signals()
	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PERK_JUGGERNAUT), PROC_REF(on_perk_juggernaut_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PERK_JUGGERNAUT), PROC_REF(on_perk_juggernaut_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PERK_SPEED), PROC_REF(on_perk_speed_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PERK_SPEED), PROC_REF(on_perk_speed_loss))

	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PERK_EXPLOSIVE_RESISTANCE), PROC_REF(on_perk_explosive_resistance_gain))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PERK_EXPLOSIVE_RESISTANCE), PROC_REF(on_perk_explosive_resistance_loss))

/mob/living/carbon/human/proc/on_perk_juggernaut_gain(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("You heartbeat seems stronger."))
	species.total_health += 75
	skills.set_skill(SKILL_ENDURANCE, skills.get_skill_level(SKILL_ENDURANCE) + 2)

/mob/living/carbon/human/proc/on_perk_juggernaut_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your heartbeat seems weaker."))
	species.total_health = initial(species.total_health)
	skills.set_skill(SKILL_ENDURANCE, skills.get_skill_level(SKILL_ENDURANCE) - 2)

/mob/living/carbon/human/proc/on_perk_speed_gain(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body feels much more tense."))
	extra_movement_delay_modifier -= 0.33

/mob/living/carbon/human/proc/on_perk_speed_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body seems to relax."))
	extra_movement_delay_modifier += 0.33

/mob/living/carbon/human/proc/on_perk_explosive_resistance_gain(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body feels much sturdier."))

/mob/living/carbon/human/proc/on_perk_explosive_resistance_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body feels squisher."))
