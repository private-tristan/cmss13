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
	pain.threshold_mild += 15
	pain.threshold_discomforting += 15
	pain.threshold_moderate += 15
	pain.threshold_distressing += 15
	pain.threshold_severe += 15
	pain.threshold_horrible += 15
	skills.set_skill(SKILL_ENDURANCE, skills.get_skill_level(SKILL_ENDURANCE) + 2)

/mob/living/carbon/human/proc/on_perk_juggernaut_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your heartbeat seems weaker."))
	species.total_health = initial(species.total_health)
	pain.threshold_mild = initial(pain.threshold_mild)
	pain.threshold_discomforting = initial(pain.threshold_discomforting)
	pain.threshold_moderate = initial(pain.threshold_moderate)
	pain.threshold_distressing = initial(pain.threshold_distressing)
	pain.threshold_severe = initial(pain.threshold_severe)
	pain.threshold_horrible = initial(pain.threshold_horrible)
	skills.set_skill(SKILL_ENDURANCE, skills.get_skill_level(SKILL_ENDURANCE) - 2)

/mob/living/carbon/human/proc/on_perk_speed_gain(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body feels much more tense."))
	reagent_move_delay_modifier -= 0.33

/mob/living/carbon/human/proc/on_perk_speed_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body seems to relax."))
	reagent_move_delay_modifier += 0.33

/mob/living/carbon/human/proc/on_perk_explosive_resistance_gain(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body feels much sturdier."))

/mob/living/carbon/human/proc/on_perk_explosive_resistance_loss(datum/source)
	SIGNAL_HANDLER
	to_chat(src, SPAN_ALERTWARNING("Your body feels squisher."))
