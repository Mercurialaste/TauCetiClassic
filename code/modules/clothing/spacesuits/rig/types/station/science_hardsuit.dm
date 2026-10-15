//Science rig
/obj/item/clothing/head/helmet/space/rig/science
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has low weight and improved module management system."
	name = "science hardsuit helmet"
	icon_state = "rig0-science"
	item_state = "sceince_helm"
	rig_variant = "science"
	unacidable = TRUE
	armor = list(melee = 5, bullet = 5, laser = 10, energy = 5, bomb = 50, bio = 100, rad = 60)

/obj/item/clothing/suit/space/rig/science
	desc = "A special suit that protects against hazardous, low pressure environments. Has low weight and improved module management system."
	icon_state = "rig-science"
	name = "science hardsuit"
	item_state = "science_hardsuit"
	armor = list(melee = 5, bullet = 5, laser = 10, energy = 5, bomb = 50, bio = 100, rad = 60)
	unacidable = TRUE
	max_mounted_devices = 6
	slowdown = 0.2
	offline_slowdown = 3.5
	initial_modules = list( /obj/item/rig_module/teleporter_stabilizer , /obj/item/rig_module/cooling_unit, /obj/item/rig_module/device/science_tool, /obj/item/rig_module/device/analyzer , /obj/item/rig_module/simple_ai, /obj/item/rig_module/device/anomaly_scanner)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/science

/obj/item/clothing/head/helmet/space/rig/science/rd
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has low weight and integrated HUD."
	name = "advanced science hardsuit helmet"
	icon_state = "rig0-rd"
	item_state = "rd_helm"
	rig_variant = "rd"
	armor = list(melee = 10, bullet = 10, laser = 15, energy = 10, bomb = 55, bio = 100, rad = 70)

/obj/item/clothing/head/helmet/space/rig/science/rd/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot != SLOT_HEAD)
		return
	var/datum/atom_hud/data/diagnostic/diag_hud = global.huds[DATA_HUD_DIAGNOSTIC]
	diag_hud.add_hud_to(user)

/obj/item/clothing/head/helmet/space/rig/science/rd/dropped(mob/user)
	. = ..()
	if(!istype(user))
		return
	var/datum/atom_hud/data/diagnostic/diag_hud = global.huds[DATA_HUD_DIAGNOSTIC]
	diag_hud.remove_hud_from(user)

/obj/item/clothing/suit/space/rig/science/rd
	desc = "A special suit that protects against hazardous, low pressure environments. Has low weight and improved module management system."
	icon_state = "rig-rd"
	name = "advanced science hardsuit"
	item_state = "rd_hardsuit"
	armor = list(melee = 10, bullet = 10, laser = 15, energy = 10, bomb = 55, bio = 100, rad = 70)
	max_mounted_devices = 8
	slowdown = 0.2
	offline_slowdown = 4
	initial_modules = list(/obj/item/rig_module/mounted_relay, /obj/item/rig_module/teleporter_stabilizer, /obj/item/rig_module/simple_ai/advanced, /obj/item/rig_module/selfrepair, /obj/item/rig_module/cooling_unit, /obj/item/rig_module/device/science_tool, /obj/item/rig_module/device/analyzer, /obj/item/rig_module/device/anomaly_scanner)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/science/rd
