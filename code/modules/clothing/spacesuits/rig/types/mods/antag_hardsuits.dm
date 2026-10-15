
//Syndicate rig
/obj/item/clothing/head/helmet/space/rig/syndi
	name = "blood-red hybrid helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon_state = "rig0-syndie"
	item_state = "syndie_helm"
	var/space_armor = list(melee = 60, bullet = 55, laser = 30,energy = 30, bomb = 50, bio = 100, rad = 60)
	var/combat_armor = list(melee = 60, bullet = 65, laser = 55,energy = 45, bomb = 50, bio = 100, rad = 60)
	var/obj/machinery/camera/camera
	var/combat_mode = FALSE
	species_restricted = list("exclude" , SKRELL , DIONA, VOX)
	var/image/lamp = null
	var/equipped_on_head = FALSE
	var/rig_type = "syndie"
	var/glowtype = "terror"
	flags = PHORONGUARD
	light_color = LIGHT_COLOR_NUKE_OPS

/obj/item/clothing/head/helmet/space/rig/syndi/atom_init()
	. = ..()
	armor = combat_mode ? combat_armor : space_armor // in case some child spawns with combat mode on

	holochip = new /obj/item/holochip/nuclear(src)
	holochip.holder = src

/obj/item/clothing/head/helmet/space/rig/syndi/AltClick(mob/user)
	var/mob/living/carbon/wearer = loc
	if(!istype(wearer) || wearer.head != src)
		to_chat(usr, "<span class='warning'>The helmet is not being worn.</span>")
		return
	toggle()

/obj/item/clothing/head/helmet/space/rig/syndi/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		equipped_on_head = TRUE
		update_icon(user)

/obj/item/clothing/head/helmet/space/rig/syndi/dropped(mob/user)
	. = ..()
	if(equipped_on_head)
		equipped_on_head = FALSE
		update_icon(user)

/obj/item/clothing/head/helmet/space/rig/syndi/proc/checklight()
	if(on)
		set_light(l_range = brightness_on, l_color = light_color)
	else if(combat_mode)
		set_light(l_range = 1.23) // Minimal possible light_range that'll make helm lights visible in full dark from distance. Most likely going to break if somebody will touch lightning formulae.
	else
		set_light(0)

/obj/item/clothing/head/helmet/space/rig/syndi/update_icon(mob/user)
	icon_state = "rig[on]-[rig_type][combat_mode ? "-combat" : ""]"
	if(user)
		user.cut_overlay(lamp)
		if(equipped_on_head && camera && on)
			lamp = image(icon = 'icons/mob/nuclear_helm_overlays.dmi', icon_state = "[glowtype][combat_mode ? "_combat" : ""]_glow")
			if(ishuman(user)) //Lets Update Lamps offset because human have height
				var/mob/living/carbon/human/H = user
				H.human_update_offset(lamp, TRUE)
			lamp.plane = LIGHTING_LAMPS_PLANE
			lamp.layer = ABOVE_LIGHTING_LAYER
			lamp.alpha = 255
			user.add_overlay(lamp)
		update_inv_mob()

/obj/item/clothing/head/helmet/space/rig/syndi/attack_self(mob/user)
	if(camera)
		on = !on
	else
		camera = new /obj/machinery/camera(src)
		camera.replace_networks(list("NUKE"))
		cameranet.removeCamera(camera)
		camera.c_tag = user.name
		to_chat(user, "<span class='notice'>User scanned as [camera.c_tag]. Camera activated.</span>")
	checklight()
	update_icon(user)

/obj/item/clothing/head/helmet/space/rig/syndi/verb/toggle()
	set category = "Object"
	set name = "Adjust helmet"
	set src in usr

	if(!usr.incapacitated())
		combat_mode = !combat_mode
		if(combat_mode)
			armor = combat_armor
			canremove = FALSE
			flags |= (HEADCOVERSEYES | HEADCOVERSMOUTH)
			flags_pressure &= ~STOPS_PRESSUREDMAGE
			usr.visible_message("<span class='notice'>[usr] moves faceplate of their helmet into combat position, covering their visor and extending cameras.</span>")
		else
			armor = space_armor
			canremove = TRUE
			flags &= ~(HEADCOVERSEYES | HEADCOVERSMOUTH)
			flags_pressure |= STOPS_PRESSUREDMAGE
			usr.visible_message("<span class='notice'>[usr] pulls up faceplate from helmet's visor, retracting cameras</span>")
		checklight()
		update_icon(usr)

/obj/item/clothing/head/helmet/space/rig/syndi/examine(mob/user)
	..()
	if(src in view(1, user))
		to_chat(user, "This helmet has a built-in camera. It's [camera ? "" : "in"]active.")

/obj/item/clothing/head/helmet/space/rig/syndi/attackby(obj/item/I, mob/user, params)
	var/mob/living/carbon/human/H = user
	if(!istype(H) || H.species.flags[IS_SYNTHETIC])
		return ..()
	if(!istype(I, /obj/item/weapon/reagent_containers/pill))
		return ..()
	if(!combat_mode && equipped_on_head)
		user.SetNextMove(CLICK_CD_RAPID)
		var/obj/item/weapon/reagent_containers/pill/P = I
		P.reagents.trans_to_ingest(user, I.reagents.total_volume)
		to_chat(user, "<span class='notice'>[src] consumes [I] and injects reagents to you!</span>")
		qdel(I)

/obj/item/clothing/suit/space/rig/syndi
	name = "blood-red hybrid suit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	icon_state = "rig-syndie-space"
	item_state = "syndie_hardsuit"
	rig_variant = "rig-syndie"
	slowdown = 0.9
	allowed = list(/obj/item/device/flashlight,
	               /obj/item/weapon/tank,
	               /obj/item/device/suit_cooling_unit,
	               /obj/item/weapon/gun,
	               /obj/item/ammo_box/magazine,
	               /obj/item/ammo_casing,
	               /obj/item/weapon/melee/baton,
	               /obj/item/weapon/melee/energy/sword,
	               /obj/item/weapon/handcuffs)
	species_restricted = list("exclude" , UNATHI , TAJARAN , DIONA, VOX)
	max_mounted_devices = 4
	initial_modules = list(/obj/item/rig_module/simple_ai/advanced, /obj/item/rig_module/selfrepair/adv, /obj/item/rig_module/emp_shield)
	cell_type = /obj/item/weapon/stock_parts/cell/super
	var/combat_mode = FALSE
	var/combat_armor = list(melee = 60, bullet = 65, laser = 55, energy = 45, bomb = 50, bio = 100, rad = 60)
	var/space_armor = list(melee = 30, bullet = 20, laser = 20, energy = 30, bomb = 50, bio = 100, rad = 60)
	var/combat_slowdown = 0
	item_action_types = list(/datum/action/item_action/hands_free/toggle_hardsuit_magboots, /datum/action/item_action/hands_free/toggle_hardsuit_helm,
	/datum/action/item_action/hands_free/toggle_space_suit_mode)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/syndi
	boots_type = /obj/item/clothing/shoes/magboots/syndie

/datum/action/item_action/hands_free/toggle_space_suit_mode
	name = "Toggle space suit mode"

/datum/action/item_action/hands_free/toggle_space_suit_mode/Activate()
	var/obj/item/clothing/suit/space/rig/syndi/S = target
	S.toggle_mode()

/obj/item/clothing/suit/space/rig/syndi/atom_init()
	. = ..()
	armor = combat_mode ? combat_armor : space_armor // in case some child spawns with combat mode on
	var/obj/item/clothing/shoes/magboots/syndie/SB = new(src)
	boots = SB

/obj/item/clothing/suit/space/rig/syndi/AltClick(mob/user)
	if(wearer?.wear_suit != src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return
	toggle_mode()

/obj/item/clothing/suit/space/rig/syndi/update_icon(mob/user)
	..()
	icon_state = "[rig_variant]-[combat_mode ? "combat" : "space"]"
	update_inv_mob()

/obj/item/clothing/suit/space/rig/syndi/verb/toggle_mode()
	set category = "Object"
	set name = "Adjust space suit"
	set src in usr

	if(!usr.incapacitated())
		combat_mode = !combat_mode
		var/obj/item/clothing/head/helmet/space/rig/syndi/H = helmet
		if(istype(H))
			if(H.combat_mode != combat_mode)
				H.toggle()
		if(combat_mode)
			canremove = FALSE
			can_breach = FALSE
			flags_pressure &= ~STOPS_PRESSUREDMAGE
			playsound(usr, 'sound/effects/air_release.ogg', VOL_EFFECTS_MASTER)
			slowdown = combat_slowdown
			usr.visible_message("<span class='notice'>[usr]'s suit depressurizes, exposing armor plates.</span>")
			armor = combat_armor
		else
			canremove = TRUE
			can_breach = TRUE
			flags_pressure |= STOPS_PRESSUREDMAGE
			playsound(usr, 'sound/effects/inflate.ogg', VOL_EFFECTS_MASTER, 30)
			slowdown = initial(slowdown)
			usr.visible_message("<span class='notice'>[usr]'s suit inflates and pressurizes.</span>")
			armor = space_armor
		if(magpulse)
			slowdown += boots.slowdown_off
		update_icon(usr)
		update_item_actions()

/obj/item/clothing/suit/space/rig/syndi/disable_magpulse(mob/user)
	detach_clothing_traits(TRAIT_NOSLIP)
	flags &= ~AIR_FLOW_PROTECT
	if(combat_mode)
		slowdown = combat_slowdown
	else
		slowdown = initial(slowdown)
	magpulse = FALSE
	to_chat(user, "You disable \the [src] the mag-pulse traction system.")

/obj/item/clothing/head/helmet/space/rig/syndi/heavy
	name = "heavy hybrid helmet"
	desc = "An advanced helmet designed for work in special operations. Created using older design of armored hardsuits."
	icon_state = "rig0-heavy"
	item_state = "syndie_helm"
	combat_armor = list(melee = 75, bullet = 80, laser = 70,energy = 55, bomb = 50, bio = 100, rad = 30)
	space_armor = list(melee = 60, bullet = 65, laser = 55, energy = 45, bomb = 50, bio = 100, rad = 60)
	rig_type = "heavy"

/obj/item/clothing/suit/space/rig/syndi/heavy
	name = "heavy hybrid suit"
	desc = "An advanced suit that protects against injuries during special operations. Heavily armored and rarely used aside from open combat conflicts."
	icon_state = "rig-heavy-space"
	item_state = "syndie_hardsuit"
	rig_variant = "rig-heavy"
	slowdown = 1.2
	initial_modules = list(/obj/item/rig_module/simple_ai/advanced, /obj/item/rig_module/selfrepair/adv, /obj/item/rig_module/chem_dispenser/combat, /obj/item/rig_module/emp_shield)
	combat_armor = list(melee = 75, bullet = 80, laser = 70,energy = 55, bomb = 50, bio = 100, rad = 30)
	space_armor = list(melee = 45, bullet = 30, laser = 30, energy = 45, bomb = 50, bio = 100, rad = 60)
	combat_slowdown = 0.5
	helmet_type = /obj/item/clothing/head/helmet/space/rig/syndi/heavy

/obj/item/clothing/head/helmet/space/rig/syndi/elite
	name = "Syndicate elite hybrid helmet"
	desc = "A hybrid helmet made by the best engineers and designers on special order for elite syndicate operatives"
	icon_state = "rig0-syndie_elit"
	rig_type = "syndie_elit"
	item_state = "syndicate-helm-elite"
	space_armor = list(melee = 65, bullet = 65, laser = 55,energy = 40, bomb = 50, bio = 100, rad = 70)
	combat_armor = list(melee = 85, bullet = 80, laser = 70,energy = 70, bomb = 75, bio = 75, rad = 70)
	glowtype = "terrorelit"
	light_color = "#e51a1a"
	can_be_modded = FALSE

/obj/item/clothing/head/helmet/space/rig/syndi/elite/comander
	name = "Syndicate elite hybrid helmet"
	desc = "A hybrid helmet made by the best engineers and designers on special order for elite syndicate operatives"
	icon_state = "rig0-syndie_elitcom"
	item_state = "syndicate-helm-commander"
	rig_type = "syndie_elitcom"

/obj/item/clothing/suit/space/rig/syndi/elite
	name = "Syndicate elite hybrid suit"
	desc = "A hybrid suit made by the best engineers and designers on special order for elite syndicate operatives"
	icon_state = "rig-syndie_elit-space"
	item_state = "syndicate-elite"
	rig_variant = "rig-syndie_elit"
	slowdown = 0.7
	combat_armor = list(melee = 80, bullet = 75, laser = 65, energy = 65, bomb = 70, bio = 70, rad = 70)
	space_armor = list(melee = 65, bullet = 60, laser = 50, energy = 35, bomb = 50, bio = 100, rad = 70)
	combat_slowdown = 0.2
	initial_modules = list(/obj/item/rig_module/simple_ai/advanced, /obj/item/rig_module/selfrepair/adv, /obj/item/rig_module/syndiemmessage, /obj/item/rig_module/emp_shield)
	can_be_modded = FALSE
	helmet_type = /obj/item/clothing/head/helmet/space/rig/syndi/elite

/obj/item/clothing/suit/space/rig/syndi/elite/comander
	name = "Syndicate elite hybrid suit"
	desc = "A hybrid suit made by the best engineers and designers on special order for elite syndicate operatives"
	icon_state = "rig-syndie_elitcom-space"
	item_state = "syndicate-commander"
	rig_variant = "rig-syndie_elitcom"
	helmet_type = /obj/item/clothing/head/helmet/space/rig/syndi/elite/comander

/obj/item/clothing/head/helmet/space/rig/syndi/hazmat
	name = "hazmat hybrid helmet"
	desc = "Anyone wearing this should not be considered human."
	icon_state = "rig0-hazmat"
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	combat_armor = list(melee = 55, bullet = 60, laser = 50, energy = 55, bomb = 100, bio = 100, rad = 100)
	space_armor = list(melee = 55, bullet = 50, laser = 40, energy = 45, bomb = 80, bio = 100, rad = 80)
	glowtype = "terrohazmat"
	rig_type = "hazmat"

/obj/item/clothing/suit/space/rig/syndi/hazmat
	name = "hazmat hybrid suit"
	desc = "Menacing space suit painted in blood-red colors resembling an outdated hazmat suit. Designed for chemical and psychological warfare."
	icon_state = "rig-hazmat-space"
	item_state = "syndie_hazmat"
	rig_variant = "rig-hazmat"
	slowdown = 0.7
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	unacidable = TRUE
	initial_modules = list(/obj/item/rig_module/simple_ai/advanced, /obj/item/rig_module/selfrepair/adv, /obj/item/rig_module/emp_shield, /obj/item/rig_module/cooling_unit/advanced)
	allowed = list(/obj/item/device/flashlight,
	               /obj/item/weapon/tank,
	               /obj/item/device/suit_cooling_unit,
	               /obj/item/weapon/gun,
	               /obj/item/ammo_box/magazine,
	               /obj/item/ammo_casing,
	               /obj/item/weapon/melee/baton,
	               /obj/item/weapon/melee/energy/sword,
	               /obj/item/weapon/handcuffs)
	combat_armor = list(melee = 55, bullet = 60, laser = 50, energy = 55, bomb = 100, bio = 100, rad = 100)
	space_armor = list(melee = 30, bullet = 20, laser = 20, energy = 45, bomb = 80, bio = 100, rad = 80)
	helmet_type = /obj/item/clothing/suit/space/rig/syndi/hazmat

//Wizard Rig
/obj/item/clothing/head/helmet/space/rig/wizard
	name = "gem-encrusted hardsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon_state = "rig0-wiz"
	item_state = "wiz_helm"
	rig_variant = "wiz"
	unacidable = 1 //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 25, bomb = 33, bio = 100, rad = 66)

/obj/item/clothing/head/helmet/space/rig/wizard/atom_init(mapload, ...)
	. = ..()
	AddComponent(/datum/component/magic_item/wizard)

/obj/item/clothing/suit/space/rig/wizard
	icon_state = "rig-wiz"
	name = "gem-encrusted hardsuit"
	desc = "A bizarre gem-encrusted suit that radiates magical energies."
	item_state = "wiz_hardsuit"
	slowdown = 0.5
	unacidable = 1
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 25, bomb = 33, bio = 100, rad = 66)
	max_mounted_devices = 4
	initial_modules = list(/obj/item/rig_module/simple_ai, /obj/item/rig_module/emp_shield/adv)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/wizard

/obj/item/clothing/suit/space/rig/wizard/atom_init(mapload, ...)
	. = ..()
	AddComponent(/datum/component/magic_item/wizard)
