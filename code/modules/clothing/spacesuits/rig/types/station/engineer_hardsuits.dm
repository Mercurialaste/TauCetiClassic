
//Engineering rig
/obj/item/clothing/head/helmet/space/rig/engineering
	name = "engineering hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "rig0-engineering"
	item_state = "eng_helm"
	armor = list(melee = 50, bullet = 5, laser = 10,energy = 5, bomb = 65, bio = 100, rad = 80)
	siemens_coefficient = 0

/obj/item/clothing/suit/space/rig/engineering
	name = "engineering hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding. Heavy insulation layer adds additional weight"
	icon_state = "rig-engineering"
	item_state = "eng_hardsuit"
	slowdown = 1.5
	armor = list(melee = 50, bullet = 5, laser = 10,energy = 5, bomb = 65, bio = 100, rad = 80)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/bag/ore,/obj/item/weapon/storage/bag/holding,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)
	siemens_coefficient = 0
	max_mounted_devices = 4
	initial_modules = list(/obj/item/rig_module/simple_ai, /obj/item/rig_module/device/extinguisher, /obj/item/rig_module/cooling_unit, /obj/item/rig_module/metalfoam_spray)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/engineering

//Chief Engineer's rig
/obj/item/clothing/head/helmet/space/rig/engineering/chief
	name = "advanced hardsuit helmet"
	desc = "An advanced helmet designed for work in a hazardous, low pressure environment. Shines with a high polish."
	icon_state = "rig0-chief"
	item_state = "ce_helm"
	rig_variant = "chief"
	armor = list(melee = 55, bullet = 5, laser = 15,energy = 10, bomb = 65, bio = 100, rad = 90)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/rig/engineering/chief
	icon_state = "rig-chief"
	name = "advanced hardsuit"
	desc = "An advanced suit that protects against hazardous, low pressure environments. Shines with a high polish."
	item_state = "ce_hardsuit"
	slowdown = 0.5
	armor = list(melee = 55, bullet = 5, laser = 15,energy = 10, bomb = 65, bio = 100, rad = 90)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_mounted_devices = 7
	initial_modules = list(/obj/item/rig_module/simple_ai/advanced, /obj/item/rig_module/selfrepair, /obj/item/rig_module/device/rcd, /obj/item/rig_module/nuclear_generator, /obj/item/rig_module/device/extinguisher, /obj/item/rig_module/cooling_unit, /obj/item/rig_module/emp_shield)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/engineering/chief

//Atmospherics Rig (BS12)
/obj/item/clothing/head/helmet/space/rig/atmos
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	name = "atmospherics hardsuit helmet"
	icon_state = "rig0-atmos"
	item_state = "atmos_helm"
	rig_variant = "atmos"
	armor = list(melee = 40, bullet = 5, laser = 10,energy = 5, bomb = 65, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/rig/atmos
	desc = "A special suit that protects against hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	icon_state = "rig-atmos"
	name = "atmos hardsuit"
	item_state = "atmos_hardsuit"
	armor = list(melee = 40, bullet = 5, laser = 10,energy = 5, bomb = 65, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_mounted_devices = 4
	initial_modules = list(/obj/item/rig_module/simple_ai, /obj/item/rig_module/device/extinguisher, /obj/item/rig_module/cooling_unit, /obj/item/rig_module/metalfoam_spray)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/atmos
