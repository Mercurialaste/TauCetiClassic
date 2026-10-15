
//Security
/obj/item/clothing/head/helmet/space/rig/security
	name = "security hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-sec"
	item_state = "sec_helm"
	rig_variant = "sec"
	armor = list(melee = 45, bullet = 30, laser = 30, energy = 30, bomb = 65, bio = 100, rad = 10)

/obj/item/clothing/suit/space/rig/security
	icon_state = "rig-sec"
	name = "security hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "sec_hardsuit"
	armor = list(melee = 45, bullet = 30, laser = 30, energy = 30, bomb = 65, bio = 100, rad = 10)
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)
	breach_threshold = 20
	slowdown = 0.7
	max_mounted_devices = 4
	initial_modules = list(/obj/item/rig_module/simple_ai, /obj/item/rig_module/selfrepair, /obj/item/rig_module/device/flash)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/security

	var/brightness_on = 2 //luminosity when on
	var/on = 0

	light_color = "#ff00ff"
	item_action_types = list(/datum/action/item_action/hands_free/toggle_hardsuit_magboots, /datum/action/item_action/hands_free/toggle_hardsuit_helm,
	/datum/action/item_action/hands_free/toggle_hardsuit_light)

/datum/action/item_action/hands_free/toggle_hardsuit_light
	name = "Toggle Hardsuit Light"

/obj/item/clothing/suit/space/rig/security/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in this [user.loc]")//To prevent some lighting anomalities.
		return
	on = !on
	icon_state = "rig-sec[on ? "-light" : ""]"
	update_inv_mob()
	update_item_actions()

	if(on)	set_light(brightness_on)
	else	set_light(0)

//HoS Rig
/obj/item/clothing/head/helmet/space/rig/security/hos
	name = "advanced security hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-hos"
	item_state = "hos_helm"
	rig_variant = "hos"

/obj/item/clothing/suit/space/rig/security/hos
	icon_state = "rig-hos"
	name = "advanced security hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "hos_hardsuit"
	slowdown = 0.3
	max_mounted_devices = 6
	initial_modules = list(/obj/item/rig_module/simple_ai/advanced, /obj/item/rig_module/selfrepair, /obj/item/rig_module/mounted/taser, /obj/item/rig_module/med_teleport, /obj/item/rig_module/chem_dispenser/combat, /obj/item/rig_module/grenade_launcher/flashbang)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/security/hos
	item_action_types = list(/datum/action/item_action/hands_free/toggle_hardsuit_magboots, /datum/action/item_action/hands_free/toggle_hardsuit_helm)
