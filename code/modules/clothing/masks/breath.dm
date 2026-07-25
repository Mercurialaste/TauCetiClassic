/datum/action/item_action/hands_free/connect_tank
	name = "Adjust mask"
	button_icon_state = "internal"
	toggleable = TRUE
	action_type = AB_INNATE

/datum/action/item_action/hands_free/connect_tank/Activate()
	if(!owner.wear_mask && !owner.incapacitated())
		return
	var/obj/item/clothing/mask/breath/breath_mask = owner.wear_mask
	breath_mask.toggle_breath(owner)
	if(breath_mask.attached_tank) // check, we just hangling mask or activate it
		active = TRUE

	UpdateButtonIcon()

/datum/action/item_action/hands_free/connect_tank/Deactivate()
	if(!owner.wear_mask && !owner.incapacitated())
		return
	var/obj/item/clothing/mask/breath/breath_mask = owner.wear_mask
	breath_mask.toggle_breath(owner)
	if(!breath_mask.attached_tank)
		active = FALSE
	UpdateButtonIcon()

/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	item_state = "b_mask"
	flags = MASKCOVERSMOUTH | MASKINTERNALS
	body_parts_covered = 0
	w_class = SIZE_TINY
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	var/obj/item/weapon/tank/attached_tank = null
	var/active = FALSE
	var/adjustible = TRUE
	item_action_types = list(/datum/action/item_action/hands_free/connect_tank)

/obj/item/clothing/mask/breath/Destroy()
	. = ..()
	QDEL_NULL(attached_tank) // destriy attached

/obj/item/clothing/mask/breath/equipped(mob/user, slot)
	. = ..()
	if(src == user.wear_mask)
		toggle_breath(user)

/obj/item/clothing/mask/breath/dropped(mob/user)
	. = ..()
	if(active)
		toggle_breath(user)
		update_action_icons(user, FALSE)

/obj/item/clothing/mask/breath/proc/toggle_breath(mob/user = usr)
	if(!active)
		connect_tank(user)
	else
		detach_tank(src, user)
	if(adjustible)
		update_hanging()
	active = !active
	update_item_actions()

/obj/item/clothing/mask/breath/proc/update_hanging()
	if(!adjustible) // if mask on face but pushed down
		return

	if(!active)
		gas_transfer_coefficient = 0.10
		flags |= MASKCOVERSMOUTH | MASKINTERNALS
		icon_state = "[initial(icon_state)]_UP"
		to_chat(usr, "You pull the mask up to cover your face.")
	else
		gas_transfer_coefficient = 1 //gas is now escaping to the turf and vice versa
		flags &= ~(MASKCOVERSMOUTH | MASKINTERNALS)
		icon_state = initial(icon_state)
		to_chat(usr, "Your mask is now hanging on your neck.")

	update_inv_mob()

/obj/item/clothing/mask/breath/proc/connect_tank(mob/user)
	var/list/tanks = list()
	for(var/obj/item/I in user.contents)
		if(istank(I))
			tanks[I] += I.appearance

	if(!length(tanks))
		to_chat(user, "You didn`t have some tank.")
		return FALSE

	var/choose

	if(tanks.len == 1)
		choose = tanks[1]
	else
		choose = show_radial_menu(user, user, tanks)

	if(!choose)
		to_chat(user, "You didn`t choose some tank.")
		return FALSE

	attached_tank = choose
	attached_tank.toggle_internals()
	return TRUE

/obj/item/clothing/mask/breath/proc/detach_tank(source, mob/user)
	if(attached_tank)
		attached_tank.close_internals(src, user)
		return TRUE
	return FALSE

/obj/item/clothing/mask/breath/proc/update_action_icons(mob/user, status)
	for(var/datum/action/item_action/hands_free/connect_tank/CT in user.actions)
		CT.active = status
		CT.UpdateButtonIcon()
	user.update_action_buttons()

/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile mask that can be connected to an air supply."
	name = "medical mask"
	icon_state = "medical"
	item_state = "m_mask"
	permeability_coefficient = 0.01
