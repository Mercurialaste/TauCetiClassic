//Medical Rig
/obj/item/clothing/head/helmet/space/rig/medical
	name = "medical hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	icon_state = "rig0-medical"
	item_state = "medical_helm"
	rig_variant = "medical"
	armor = list(melee = 30, bullet = 5, laser = 10,energy = 5, bomb = 25, bio = 100, rad = 50)

/obj/item/clothing/suit/space/rig/medical
	icon_state = "rig-medical"
	name = "medical hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	item_state = "medical_hardsuit"
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical)
	armor = list(melee = 30, bullet = 5, laser = 10,energy = 5, bomb = 25, bio = 100, rad = 50)
	max_mounted_devices = 4
	initial_modules = list(/obj/item/rig_module/simple_ai, /obj/item/rig_module/device/healthscanner)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/medical

//CMO Rig
/obj/item/clothing/head/helmet/space/rig/medical/cmo
	name = "advanced medical hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	icon_state = "rig0-cmo"
	item_state = "cmo_helm"
	rig_variant = "cmo"

/obj/item/clothing/suit/space/rig/medical/cmo
	icon_state = "rig-cmo"
	name = "advanced medical hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	item_state = "cmo_hardsuit"
	slowdown = 0.2
	max_mounted_devices = 6
	initial_modules = list(/obj/item/rig_module/simple_ai/advanced, /obj/item/rig_module/selfrepair, /obj/item/rig_module/med_teleport, /obj/item/rig_module/chem_dispenser/medical, /obj/item/rig_module/device/healthscanner)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/medical/cmo
