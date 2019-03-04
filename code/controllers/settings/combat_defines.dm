/datum/configuration
	var/proj_base_accuracy_mult = 0.01
	var/proj_base_damage_mult = 0.01

	var/proj_variance_high = 105
	var/proj_variance_low = 98

	var/critical_chance_low = 4
	var/critical_chance_high = 9
	var/base_armor_resist_low = 1.3
	var/base_armor_resist_high = 1.7
	var/xeno_armor_resist_low = 0.7
	var/xeno_armor_resist_high = 1.4

	var/min_hit_accuracy = 2
	var/low_hit_accuracy = 7
	var/med_hit_accuracy = 13
	var/hmed_hit_accuracy = 21
	var/high_hit_accuracy = 27
	var/max_hit_accuracy = 40

	var/base_hit_accuracy_mult = 1
	var/min_hit_accuracy_mult = 0.05
	var/low_hit_accuracy_mult = 0.13
	var/med_hit_accuracy_mult = 0.19
	var/hmed_hit_accuracy_mult = 0.24
	var/high_hit_accuracy_mult = 0.37
	var/max_hit_accuracy_mult = 0.50

	var/base_hit_damage = 10
	var/min_hit_damage = 16
	var/mlow_hit_damage = 22
	var/low_hit_damage = 29
	var/hlow_hit_damage = 31
	var/hlmed_hit_damage = 34
	var/lmed_hit_damage = 38
	var/med_hit_damage = 47
	var/hmed_hit_damage = 51
	var/high_hit_damage = 68
	var/mhigh_hit_damage = 76
	var/max_hit_damage = 88
	var/super_hit_damage = 121
	var/ultra_hit_damage = 153

	var/base_hit_damage_mult = 1
	var/min_hit_damage_mult = 0.06
	var/low_hit_damage_mult = 0.12
	var/med_hit_damage_mult = 0.21
	var/hmed_hit_damage_mult = 0.28
	var/high_hit_damage_mult = 0.35
	var/max_hit_damage_mult = 0.45

	var/tactical_damage_falloff = 0.8
	var/reg_damage_falloff = 1 //in config it was 0.89 but referenced wrong var
	var/buckshot_v2_damage_falloff = 3
	var/buckshot_damage_falloff = 5 //ditto but 18.3 (!!!)
	var/extra_damage_falloff = 10 //ditto but 9.75

	var/min_burst_value = 1
	var/low_burst_value = 2
	var/med_burst_value = 3
	var/high_burst_value = 4
	var/mhigh_burst_value = 5
	var/max_burst_value = 6

	var/min_fire_delay = 1
	var/mlow_fire_delay = 2
	var/low_fire_delay = 3
	var/med_fire_delay = 4
	var/high_fire_delay = 5
	var/mhigh_fire_delay = 6
	var/max_fire_delay = 7

	var/min_scatter_value = 1
	var/mlow_scatter_value = 2
	var/low_scatter_value = 3
	var/lmed_scatter_value = 4
	var/med_scatter_value = 5
	var/hmed_scatter_value = 6
	var/high_scatter_value = 7
	var/mhigh_scatter_value = 8
	var/max_scatter_value = 10
	var/super_scatter_value = 15
	var/ultra_scatter_value = 20

	var/min_recoil_value = 1
	var/low_recoil_value = 2
	var/med_recoil_value = 3
	var/high_recoil_value = 4
	var/max_recoil_value = 5

	var/min_shrapnel_chance = 3
	var/low_shrapnel_chance = 9
	var/med_shrapnel_chance = 24
	var/high_shrapnel_chance = 45
	var/max_shrapnel_chance = 75

	var/min_shell_range = 4
	var/close_shell_range = 5
	var/near_shell_range = 7
	var/short_shell_range = 11
	var/norm_shell_range = 22
	var/long_shell_range = 33
	var/max_shell_range = 44

	var/slow_shell_speed = 1
	var/reg_shell_speed = 2
	var/fast_shell_speed = 3
	var/super_shell_speed = 4
	var/ultra_shell_speed = 6

	var/min_armor_penetration = 5
	var/mlow_armor_penetration = 12
	var/low_armor_penetration = 23
	var/hlow_armor_penetration = 26
	var/med_armor_penetration = 31
	var/hmed_armor_penetration = 36
	var/high_armor_penetration = 48
	var/mhigh_armor_penetration = 66
	var/max_armor_penetration = 87

	var/min_proj_extra = 1
	var/low_proj_extra = 2
	var/med_proj_extra = 3
	var/high_proj_extra = 5
	var/max_proj_extra = 8

	var/min_proj_variance = 1
	var/low_proj_variance = 3
	var/med_proj_variance = 7
	var/high_proj_variance = 9
	var/max_proj_variance = 12
	
	//weapon settling multiplier
	var/weapon_settle_accuracy_multiplier = 4
	var/weapon_settle_scatter_multiplier = 2

	//roundstart stuff
	var/xeno_number_divider = 5
	var/surv_number_divider = 20

/datum/configuration/proc/initialize_combat_defines(name,value)
	value = text2num(value)
	switch(name)
		if("proj_base_accuracy_mult") proj_base_accuracy_mult = value
		if("proj_base_damage_mult") proj_base_damage_mult = value
		if("proj_variance_low") proj_variance_low = value
		if("proj_variance_high") proj_variance_high = value
		if("critical_chance_low") critical_chance_low = value
		if("critical_chance_high") critical_chance_high = value
		if("base_armor_resist_low") base_armor_resist_low = value
		if("base_armor_resist_high") base_armor_resist_high = value
		if("xeno_armor_resist_low") xeno_armor_resist_low = value
		if("xeno_armor_resist_high") xeno_armor_resist_high = value
		if("min_hit_accuracy") min_hit_accuracy = value
		if("low_hit_accuracy") low_hit_accuracy = value
		if("med_hit_accuracy") med_hit_accuracy = value
		if("hmed_hit_accuracy") hmed_hit_accuracy = value
		if("high_hit_accuracy") high_hit_accuracy = value
		if("max_hit_accuracy") max_hit_accuracy = value
		if("base_hit_accuracy_mult") base_hit_accuracy_mult = value
		if("min_hit_accuracy_mult") min_hit_accuracy_mult = value
		if("low_hit_accuracy_mult") low_hit_accuracy_mult = value
		if("med_hit_accuracy_mult") med_hit_accuracy_mult = value
		if("hmed_hit_accuracy_mult") hmed_hit_accuracy_mult = value
		if("high_hit_accuracy_mult") high_hit_accuracy_mult = value
		if("max_hit_accuracy_mult") max_hit_accuracy_mult = value
		if("base_hit_damage") base_hit_damage = value
		if("min_hit_damage") min_hit_damage = value
		if("mlow_hit_damage") mlow_hit_damage = value
		if("low_hit_damage") low_hit_damage = value
		if("lmed_hit_damage") lmed_hit_damage = value
		if("med_hit_damage") med_hit_damage = value
		if("hmed_hit_damage") hmed_hit_damage = value
		if("high_hit_damage") high_hit_damage = value
		if("mhigh_hit_damage") mhigh_hit_damage = value
		if("max_hit_damage") max_hit_damage = value
		if("super_hit_damage") super_hit_damage = value
		if("ultra_hit_damage") ultra_hit_damage = value
		if("base_hit_damage_mult") base_hit_damage_mult = value
		if("min_hit_damage_mult") min_hit_damage_mult = value
		if("low_hit_damage_mult") low_hit_damage_mult = value
		if("med_hit_damage_mult") med_hit_damage_mult = value
		if("hmed_hit_damage_mult") hmed_hit_damage_mult = value
		if("high_hit_damage_mult") high_hit_damage_mult = value
		if("max_hit_damage_mult") max_hit_damage_mult = value
		if("reg_damage_bleed") reg_damage_falloff = value
		if("buckshot_damage_bleed") buckshot_damage_falloff = value
		if("extra_damage_bleed") extra_damage_falloff = value
		if("min_burst_value") min_burst_value = value
		if("low_burst_value") low_burst_value = value
		if("med_burst_value") med_burst_value = value
		if("high_burst_value") high_burst_value = value
		if("max_burst_value") max_burst_value = value
		if("min_fire_delay") min_fire_delay = value
		if("mlow_fire_delay") mlow_fire_delay = value
		if("low_fire_delay") low_fire_delay = value
		if("med_fire_delay") med_fire_delay = value
		if("high_fire_delay") high_fire_delay = value
		if("mhigh_fire_delay") mhigh_fire_delay = value
		if("max_fire_delay")	max_fire_delay = value
		if("min_scatter_value") min_scatter_value = value
		if("mlow_scatter_value") mlow_scatter_value = value
		if("low_scatter_value") low_scatter_value = value
		if("lmed_scatter_value") lmed_scatter_value = value
		if("med_scatter_value") med_scatter_value = value
		if("hmed_scatter_value") hmed_scatter_value = value
		if("high_scatter_value") high_scatter_value = value
		if("mhigh_scatter_value") mhigh_scatter_value = value
		if("max_scatter_value") max_scatter_value = value
		if("super_scatter_value") super_scatter_value = value
		if("ultra_scatter_value") ultra_scatter_value = value
		if("min_recoil_value") min_recoil_value = value
		if("low_recoil_value") low_recoil_value = value
		if("med_recoil_value") med_recoil_value = value
		if("high_recoil_value") high_recoil_value = value
		if("max_recoil_value") max_recoil_value = value
		if("min_shrapnel_chance") min_shrapnel_chance = value
		if("low_shrapnel_chance") low_shrapnel_chance = value
		if("med_shrapnel_chance") med_shrapnel_chance = value
		if("high_shrapnel_chance") high_shrapnel_chance = value
		if("max_shrapnel_chance") max_shrapnel_chance = value
		if("min_shell_range") min_shell_range = value
		if("close_shell_range") close_shell_range = value
		if("short_shell_range") short_shell_range = value
		if("near_shell_range") near_shell_range = value
		if("norm_shell_range") norm_shell_range = value
		if("long_shell_range") long_shell_range = value
		if("max_shell_range") max_shell_range = value
		if("slow_shell_speed") slow_shell_speed = value
		if("reg_shell_speed") reg_shell_speed = value
		if("fast_shell_speed") fast_shell_speed = value
		if("super_shell_speed") super_shell_speed = value
		if("ultra_shell_speed") ultra_shell_speed = value
		if("min_armor_penetration") min_armor_penetration = value
		if("mlow_armor_penetration") mlow_armor_penetration = value
		if("low_armor_penetration") low_armor_penetration = value
		if("med_armor_penetration") med_armor_penetration = value
		if("high_armor_penetration") high_armor_penetration = value
		if("mhigh_armor_penetration") mhigh_armor_penetration = value
		if("max_armor_penetration") max_armor_penetration = value
		if("min_proj_extra") min_proj_extra = value
		if("low_proj_extra") low_proj_extra = value
		if("med_proj_extra") med_proj_extra = value
		if("high_proj_extra") high_proj_extra = value
		if("max_proj_extra") max_proj_extra = value
		if("min_proj_variance") min_proj_variance = value
		if("low_proj_variance") low_proj_variance = value
		if("med_proj_variance") med_proj_variance = value
		if("high_proj_variance") high_proj_variance = value
		if("max_proj_variance") max_proj_variance = value
		if("weapon_settle_accuracy_multiplier") weapon_settle_accuracy_multiplier = value
		if("weapon_settle_scatter_multiplier") weapon_settle_scatter_multiplier = value
		else
			log_misc("Unknown setting in combat defines: '[name]'")
