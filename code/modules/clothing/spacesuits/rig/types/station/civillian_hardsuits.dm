
//Mining rig
/obj/item/clothing/head/helmet/space/rig/mining
	name = "mining hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	icon_state = "rig0-mining"
	item_state = "mining_helm"
	slowdown = 0.6
	rig_variant = "mining"
	armor = list(melee = 60, bullet = 5, laser = 10,energy = 5, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/suit/space/rig/mining
	icon_state = "rig-mining"
	name = "mining hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	item_state = "mining_hardsuit"
	armor = list(melee = 90, bullet = 5, laser = 10,energy = 5, bomb = 55, bio = 100, rad = 20)
	breach_threshold = 26
	max_mounted_devices = 4
	initial_modules = list(/obj/item/rig_module/simple_ai, /obj/item/rig_module/device/orescanner, /obj/item/rig_module/device/drill)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/mining

//Red Faction mining rig
/obj/item/clothing/head/helmet/space/rig/RF_mining
	name = "Red mining helmet"
	desc = "A special mining helmet designed for work in a hazardous, low pressure environment."
	icon_state = "rig0-RedMiner"
	item_state = "RedMiner_helm"
	rig_variant = "RedMiner"
	armor = list(melee = 40, bullet = 10, laser = 10,energy = 5, bomb = 50, bio = 100, rad = 50)

/obj/item/clothing/suit/space/rig/RF_mining
	name = "Red mining hardsuit"
	desc = "A special suit that protects against hazardous, has reinforced plating."
	icon_state = "RedMiner"
	item_state = "RedMiner"
	rig_variant = "RedMiner"
	armor = list(melee = 40, bullet = 11, laser = 10,energy = 5, bomb = 50, bio = 100, rad = 50)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/storage/bag/ore,/obj/item/weapon/storage/bag/holding,/obj/item/weapon/pickaxe)
	helmet_type = /obj/item/clothing/head/helmet/space/rig/RF_mining

//Mime's Hardsuit
/obj/item/clothing/head/helmet/space/mime
	name = "mime hardsuit helmet"
	desc = "A hardsuit helmet specifically designed for the mime."
	icon_state = "mim"
	item_state = "mim"

/obj/item/clothing/suit/space/mime
	name = "mime hardsuit"
	desc = "A hardsuit specifically designed for the mime."
	icon_state = "mime"
	item_state = "mime"
	allowed = list(/obj/item/weapon/tank)

/obj/item/clothing/head/helmet/space/clown
	name = "clown hardsuit helmet"
	desc = "A hardsuit helmet specifically designed for the clown. SPESSHONK!"
	icon_state = "kluwne"
	item_state = "kluwne"

/obj/item/clothing/suit/space/clown
	name = "clown hardsuit"
	desc = "A hardsuit specifically designed for the clown. SPESSHONK!"
	icon_state = "clowan"
	item_state = "clowan"
	allowed = list(/obj/item/weapon/tank)
