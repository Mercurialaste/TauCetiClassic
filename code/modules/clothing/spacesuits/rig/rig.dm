#define RIG_PASSIVE_ENERGY_USE 1
#define RIG_MOVE_ENERGY_USE = 1

//Regular rig suits
/obj/item/clothing/head/helmet/space/rig
	name = "hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	icon_state = "rig0-engineering"
	item_state = "eng_helm"
	armor = list(melee = 40, bullet = 5, laser = 10,energy = 5, bomb = 35, bio = 100, rad = 20)
	item_action_types = list(/datum/action/item_action/hands_free/toggle_helmet_light)

	allowed = list(/obj/item/device/flashlight)
	var/brightness_on = 4 //luminosity when on
	var/on = 0
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	var/obj/item/clothing/suit/space/rig/rig_connect
	can_be_modded = TRUE

	unacidable = TRUE //all helmets on rigs can be acidable

	//Species-specific stuff.
	species_restricted = list("exclude", UNATHI, TAJARAN, SKRELL, DIONA, VOX)
	species_restricted_locked = TRUE
	sprite_sheets_refit = list(
		UNATHI = 'icons/mob/species/unathi/helmet.dmi',
		TAJARAN = 'icons/mob/species/tajaran/helmet.dmi',
		SKRELL = 'icons/mob/species/skrell/helmet.dmi',
		VOX = 'icons/mob/species/vox/helmet.dmi',
		)
	sprite_sheets_obj = list(
		UNATHI = 'icons/obj/clothing/species/unathi/hats.dmi',
		TAJARAN = 'icons/obj/clothing/species/tajaran/hats.dmi',
		SKRELL = 'icons/obj/clothing/species/skrell/hats.dmi',
		VOX = 'icons/obj/clothing/species/vox/hats.dmi',
		)

	var/rig_variant = "engineering"

/datum/action/item_action/hands_free/toggle_helmet_light
	name = "Toggle Helmet Light"

/obj/item/clothing/head/helmet/space/rig/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in this [user.loc]")//To prevent some lighting anomalities.
		return
	on = !on
	icon_state = "rig[on]-[rig_variant]"
//	item_state = "rig[on]-[color]"
	update_inv_mob()
	update_item_actions()

	if(on)	set_light(brightness_on)
	else	set_light(0)

/obj/item/clothing/suit/space/rig
	name = "hardsuit"
	desc = "A special space suit for environments that might pose hazards beyond just the vacuum of space. Provides more protection than a standard space suit."
	icon_state = "rig-engineering"
	item_state = "eng_hardsuit"
	slowdown = 0.5
	var/magpulse = FALSE
	var/offline_slowdown = 2
	can_be_modded = TRUE
	armor = list(
		melee = 40,
		bullet = 5,
		laser = 10,
		energy = 5,
		bomb = 35,
		bio = 100,
		rad = 20
	)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/weapon/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/weapon/storage/bag/ore,
		/obj/item/weapon/storage/bag/holding,
		/obj/item/device/t_scanner,
		/obj/item/weapon/rcd
	)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted_locked = TRUE
	species_restricted = list("exclude" , UNATHI , TAJARAN , DIONA , VOX)
	sprite_sheets_refit = list(
		UNATHI = 'icons/mob/species/unathi/suit.dmi',
		TAJARAN = 'icons/mob/species/tajaran/suit.dmi',
		SKRELL = 'icons/mob/species/skrell/suit.dmi',
		VOX = 'icons/mob/species/vox/suit.dmi',
		)
	sprite_sheets_obj = list(
		UNATHI = 'icons/obj/clothing/species/unathi/suits.dmi',
		TAJARAN = 'icons/obj/clothing/species/tajaran/suits.dmi',
		SKRELL = 'icons/obj/clothing/species/skrell/suits.dmi',
		VOX = 'icons/obj/clothing/species/vox/suits.dmi',
		)
	//Breach thresholds, should ideally be inherited by most (if not all) hardsuits.
	breach_threshold = 18
	can_breach = 1

	//Component/device holders.
	var/obj/item/weapon/stock_parts/gloves = null               // Basic capacitor allows insulation, upgrades allow shock gloves etc.

	var/obj/item/clothing/shoes/magboots/boots = null           // Deployable boots, if any.
	var/boots_type = /obj/item/clothing/shoes/magboots
	var/obj/item/clothing/head/helmet/space/rig/helmet = null   // Deployable helmet, if any.
	var/helmet_type = null

	var/max_mounted_devices = 4                                 // Maximum devices. Easy.
	var/list/can_mount = null                                   // Types of device that can be hardpoint mounted.
	var/list/mounted_devices = null                             // Holder for the above device.
	var/obj/item/active_device = null                           // Currently deployed device, if any.

	var/mob/living/carbon/human/wearer                          // The person currently wearing the rig.
	var/offline = TRUE

	var/interface_title = "Hardsuit Controller"
	var/interface_path = "hardsuit.tmpl"
	var/obj/item/rig_module/selected_module = null // Primary system (used with middle-click)
	var/list/initial_modules
	var/list/installed_modules = list() // Power consumption/use bookkeeping.
	var/cell_type = /obj/item/weapon/stock_parts/cell/high
	var/obj/item/weapon/stock_parts/cell/cell // Power supply, if any.
	item_action_types = list(
		/datum/action/item_action/hands_free/toggle_hardsuit_magboots,
		/datum/action/item_action/hands_free/toggle_hardsuit_helm
	)

	var/rig_variant = "engineering"

/obj/item/clothing/suit/space/rig/atom_init()
	. = ..()
	if(helmet_type)
		helmet = new helmet_type(src)
		helmet.rig_connect = src
	if(boots_type)
		boots  = new boots_type(src)
	if(initial_modules && initial_modules.len)
		for(var/path in initial_modules)
			var/obj/item/rig_module/module = new path(src)
			module.installed(src)

	if(cell_type)
		cell = new cell_type(src)
		cell.update_icon()

/obj/item/clothing/suit/space/rig/Destroy()
	if(wearer) // remove overlays if rig gets deleted while wearing
		var/old_wearer = wearer
		wearer = null
		update_overlays(old_wearer)
		remove_actions(old_wearer)

	selected_module = null
	QDEL_NULL(cell)
	QDEL_NULL(helmet)
	QDEL_LIST(installed_modules)
	. = ..()

/mob/living/carbon/proc/handle_rig_move(NewLoc, Dir)
	if(!ishuman(src))
		return
	var/mob/living/carbon/human/H = src
	var/obj/item/clothing/suit/space/rig/rig = H.wear_suit
	if(!istype(rig))
		return
	if(!rig.offline)
		rig.cell.use(RIG_MOVE_ENERGY_USE)

/obj/item/clothing/suit/space/rig/attack_reaction(mob/living/L, reaction_type, mob/living/carbon/human/T = null)
	if(reaction_type == REACTION_ITEM_TAKE || reaction_type == REACTION_ITEM_TAKEOFF)
		return
	var/obj/item/rig_module/stealth/module = find_module(/obj/item/rig_module/stealth)
	if(module)
		module.deactivate()


/obj/item/clothing/suit/space/rig/proc/try_use(mob/living/user, cost, use_unconcious, use_stunned)

	if(!istype(user))
		return FALSE

	var/fail_msg

	var/mob/living/carbon/human/H = user
	if(istype(H) && H.wear_suit != src)
		fail_msg = "<span class='warning'>You must be wearing \the [src] to do this.</span>"
	else if((use_unconcious && user.stat == DEAD) || (!use_unconcious && user.stat != CONSCIOUS))
		fail_msg = "<span class='warning'>You are in no fit state to do that.</span>"
	else if(!use_stunned && user.incapacitated(NONE))
		fail_msg = "<span class='warning'>You cannot use the suit in this state.</span>"
	else if(!cell)
		fail_msg = "<span class='warning'>There is no cell installed in the suit.</span>"
	else if(cost && cell.charge < cost)
		fail_msg = "<span class='warning'>Not enough stored power.</span>"

	if(fail_msg)
		to_chat(user, "[fail_msg]")
		return FALSE

	if(cost > 0)
		return cell.use(cost)
	return TRUE

/obj/item/clothing/suit/space/rig/Topic(href,href_list)
	..()
	var/mob/living/carbon/human/user = usr
	if(offline || !istype(user) || user.wear_suit != src)
		return FALSE

	if(href_list["interact_module"])

		var/module_index = text2num(href_list["interact_module"])

		if(module_index > 0 && module_index <= installed_modules.len)
			var/obj/item/rig_module/module = installed_modules[module_index]
			switch(href_list["module_mode"])
				if("activate")
					module.activate()
				if("deactivate")
					module.deactivate()
				if("engage")
					module.engage()
				if("select")
					selected_module = module
					update_selected_action()
				if("deselect")
					selected_module = null
					update_selected_action()
				if("toggle")
					if(selected_module == module)
						selected_module = null
					else
						selected_module = module
					update_selected_action()
				if("select_charge_type")
					module.charge_selected = href_list["charge_type"]
		return TRUE
	return TRUE

/obj/item/clothing/suit/space/rig/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	if(!user)
		return

	var/list/data = list()

	if(selected_module)
		data["primarysystem"] = "[selected_module.interface_name]"

	data["seals"] =     "[src.offline]"
	data["charge"] =       cell ? round(cell.charge,1) : 0
	data["maxcharge"] =    cell ? cell.maxcharge : 0
	data["chargestatus"] = cell ? FLOOR(cell.percent()/2, 1) : 0

	var/list/module_list = list()
	var/i = 1
	for(var/obj/item/rig_module/module in installed_modules)
		var/list/module_data = list(
			"index" =             i,
			"name" =              "[module.interface_name]",
			"desc" =              "[module.interface_desc]",
			"can_use" =           "[module.usable]",
			"can_select" =        "[module.selectable]",
			"can_toggle" =        "[module.toggleable]",
			"is_active" =         "[module.active]",
			"engagecost" =        module.use_power_cost,
			"activecost" =        module.active_power_cost,
			"passivecost" =       module.passive_power_cost,
			"engagestring" =      module.engage_string,
			"activatestring" =    module.activate_string,
			"deactivatestring" =  module.deactivate_string,
			"damage" =            module.damage,
			"show_selected" =     (module.charges && module.charges.len > 1)
			)

		if(module.charges && module.charges.len)

			module_data["charges"] = list()
			var/datum/rig_charge/selected = module.charges[module.charge_selected]
			module_data["chargetype"] = selected ? "[selected.display_name]" : "none"

			for(var/chargetype in module.charges)
				var/datum/rig_charge/charge = module.charges[chargetype]
				module_data["charges"] += list(list("caption" = "[chargetype] ([charge.charges])", "index" = "[chargetype]"))

		module_list += list(module_data)
		i++

	if(module_list.len)
		data["modules"] = module_list

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, interface_path, interface_title, 480, 550)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

//offline should not change outside this proc
/obj/item/clothing/suit/space/rig/proc/update_offline()
	var/go_offline = (!istype(wearer) || loc != wearer || wearer.wear_suit != src || !cell || cell.charge <= 0)
	if(offline != go_offline)
		offline = go_offline
		return TRUE
	return FALSE

/obj/item/clothing/suit/space/rig/process()
	var/changed = update_offline()
	if(changed)
		if(offline)
			to_chat(wearer, "<span class='danger'>Your suit beeps stridently, and suddenly goes dead.</span>")

			for(var/obj/item/rig_module/module in installed_modules)
				module.deactivate()
		if(!offline)
			for(var/obj/item/rig_module/module in installed_modules)
				if(module.activate_on_start)
					module.activate()

		if(!offline)
			slowdown = initial(slowdown)
		else
			slowdown = offline_slowdown


	if(!offline)
		var/total_energy_use = RIG_PASSIVE_ENERGY_USE

		for(var/obj/item/rig_module/module in installed_modules)
			total_energy_use += module.process_module()
			if(!wearer) // module might unequip us
				break
		if(total_energy_use > 0)
			cell.use(total_energy_use)
		else if(total_energy_use < 0)
			cell.give(-total_energy_use)

/obj/item/clothing/suit/space/rig/proc/give_actions(mob/living/carbon/human/H)
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.selectable)
			var/datum/action/module_select/action = new(module)
			action.Grant(H)
		if(module.show_toggle_button)
			var/datum/action/module_toggle/action = new(module)
			action.Grant(H)

/obj/item/clothing/suit/space/rig/proc/remove_actions(mob/living/carbon/human/H)
	for(var/datum/action/module_select/action in H.actions)
		if(istype(action))
			action.Remove(H)
	for(var/datum/action/module_toggle/action in H.actions)
		if(istype(action))
			action.Remove(H)

/obj/item/clothing/suit/space/rig/proc/update_selected_action()
	if(!wearer)
		return

	var/mob/living/carbon/human/H = wearer
	for(var/datum/action/module_select/action in H.actions)
		if(istype(action))
			if(selected_module == action.target) // highlight selected module
				action.background_icon_state = "bg_spell"
			else
				action.background_icon_state = "bg_default"
	H.update_action_buttons()

/obj/item/clothing/suit/space/rig/proc/update_activated_actions()
	if(!wearer)
		return

	var/mob/living/carbon/human/H = wearer
	for(var/datum/action/module_toggle/action in H.actions)
		if(istype(action))
			var/obj/item/rig_module/module = action.target
			if(istype(module))
				if(module.active) // highlight active modules
					action.background_icon_state = "bg_active"
					action.name = module.deactivate_string
				else
					action.background_icon_state = "bg_default"
					action.name = module.activate_string
	H.update_action_buttons()

/obj/item/clothing/suit/space/rig/equipped(mob/M, slot)
	..()
	var/mob/living/carbon/human/H = M

	if(!istype(H))
		return

	if(slot == SLOT_WEAR_SUIT)
		wearer = H
		update_overlays(wearer)
		give_actions(wearer)
		if(helmet)
			toggle_helmet()

		if(!offline) // so rigs without cell are slow
			slowdown = initial(slowdown)
		else
			slowdown = offline_slowdown

	if(H.wear_suit != src)
		return

	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/space/rig/dropped(mob/user)
	..()
	var/mob/living/carbon/human/old_wearer = wearer
	wearer = null

	if(helmet && old_wearer?.head == helmet)
		move_helmet(old_wearer)

	if(boots)
		toggle_magboots()

	if(old_wearer)
		update_overlays(old_wearer)
		remove_actions(old_wearer)
		disable_magpulse(old_wearer)
		selected_module = null

		STOP_PROCESSING(SSobj, src)
		process() // process one last time so we can disable all modules and other stuff


/obj/item/clothing/suit/space/rig/proc/move_helmet(mob/living/carbon/human/H)
	if(H.head == helmet)
		helmet.canremove = 1
		H.drop_from_inventory(helmet, src)
		helmet.forceMove(src)
		to_chat(H, "<span class='notice'>[name] retract helmet.</span>")

	else if(H.equip_to_slot_if_possible(helmet, SLOT_HEAD))
		if(helmet.on)
			helmet.set_light(helmet.brightness_on)
		else
			helmet.set_light(0)
		helmet.canremove = 0
		to_chat(wearer, "<span class='notice'>[name] deploy helmet, sealing you off from the world.</span>")
		return

/obj/item/clothing/suit/space/rig/verb/toggle_helmet()
	set name = "Toggle Helmet"
	set category = "Object"
	set src in usr.loc

	if(!helmet)
		to_chat(usr, "There is no helmet installed.")
		return
	var/mob/living/carbon/human/H = usr
	if(!ishuman(H)) return
	if(H.incapacitated()) return
	if(H.wear_suit != src) return

	move_helmet(H)


/obj/item/clothing/suit/space/rig/verb/toggle_magboots()

	set name = "Toggle Space Suit Magboots"
	set category = "Object"
	set src in usr

	if(!isliving(src.loc)) return

	if(!boots)
		to_chat(usr, "\The [src] does not have any boots installed.")
		return

	var/mob/living/carbon/human/H = usr

	if(!ishuman(H)) return
	if(H.incapacitated())
		return
	if(H.wear_suit != src) return

	if(magpulse)
		disable_magpulse(H)
	else
		enable_magpulse(H)
	H.update_gravity(H.mob_has_gravity())

/obj/item/clothing/suit/space/rig/proc/enable_magpulse(mob/user)
		attach_clothing_traits(TRAIT_NOSLIP)
		flags |= AIR_FLOW_PROTECT
		slowdown += boots.slowdown_off
		magpulse = TRUE
		to_chat(user, "You enable \the [src] the mag-pulse traction system.")
		playsound(src, pick(SOUNDIN_MAGBOOTS_TOGGLE), VOL_EFFECTS_MASTER, 100)

/obj/item/clothing/suit/space/rig/proc/disable_magpulse(mob/user)
		detach_clothing_traits(TRAIT_NOSLIP)
		flags &= ~AIR_FLOW_PROTECT
		slowdown = initial(slowdown)
		magpulse = FALSE
		to_chat(user, "You disable \the [src] the mag-pulse traction system.")
		playsound(src, 'sound/effects/magb4.ogg', VOL_EFFECTS_MASTER, 100)

/obj/item/clothing/suit/space/rig/negates_gravity()
	return magpulse

/obj/item/clothing/suit/space/rig/examine(mob/user)
	..()
	to_chat(user, "Its mag-pulse traction system appears to be [magpulse ? "enabled" : "disabled"].")

/obj/item/clothing/suit/space/rig/emp_act(severity)
	for(var/obj/item/rig_module/installed_mod in installed_modules)
		if(installed_mod.type == /obj/item/rig_module/emp_shield)
			var/obj/item/rig_module/emp_shield/shield = installed_mod
			if(shield.uses > 0)
				shield.uses--
				shield.interface_desc = "Device for protecting the hardsuit from EMP. Can withstand [shield.uses] more EMPs."
				to_chat(wearer, "<span class='warning'>[installed_mod.name] absorbs EMP. [shield.uses] uses left!</span>")
				return

	//drain some charge
	if(cell)
		cell.emplode(severity + 1)

	//possibly damage some modules
	take_hit((100/severity), "electrical pulse", is_emp = TRUE)

/obj/item/clothing/suit/space/rig/proc/find_module(module_type)
	for(var/obj/item/rig_module/module in installed_modules)
		if(istype(module, module_type))
			return module
	return null

/obj/item/clothing/suit/space/rig/proc/can_install(obj/item/rig_module/new_module)
	if(installed_modules.len >= max_mounted_devices)
		to_chat(usr, "The hardsuit has a maximum amount of modules installed.")
		return FALSE

	if(new_module.redundant)
		return TRUE

	for(var/obj/item/rig_module/installed_mod in installed_modules)
		if(installed_mod.type == new_module.type)
			to_chat(usr, "The hardsuit already has a module of that class installed.")
			return FALSE
		if(installed_mod.mount_type & new_module.mount_type)
			to_chat(usr, "The hardsuit already has [installed_mod.name] installed in that mount spot.")
			return FALSE

	return TRUE

/obj/item/clothing/suit/space/rig/proc/take_hit(damage, source, is_emp = FALSE)

	if(!installed_modules.len)
		return

	var/chance
	if(!is_emp)
		var/damage_resistance = breach_threshold
		chance = 2*max(0, damage - damage_resistance)
	else
		//Want this to be roughly independant of the number of modules, meaning that X emp hits will disable Y% of the suit's modules on average.
		//that way people designing hardsuits don't have to worry (as much) about how adding that extra module will affect emp resiliance by 'soaking' hits for other modules
		chance = 2*max(0, damage)*min(installed_modules.len/15, 1)

	if(!prob(chance))
		return

	var/list/valid_modules = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.damage < MODULE_DESTROYED)
			valid_modules += module

	if(!valid_modules.len)
		return
	var/obj/item/rig_module/dam_module = pick(valid_modules)

	if(!dam_module)
		return

	dam_module.damage++

	if(!source)
		source = "hit"

	if(wearer)
		var/obj/item/rig_module/simple_ai/ai = find_module(/obj/item/rig_module/simple_ai)
		if(ai && ai.active)
			ai.handle_module_damage(source, dam_module)
		else
			to_chat(wearer, "<span class='danger'>The [source] has damaged one of your rig modules</span>")
	dam_module.deactivate()

/obj/item/clothing/suit/space/rig/proc/update_overlays(mob/user)
	var/equipped = (wearer == user)

	for(var/obj/item/rig_module/module in installed_modules)
		if(module.suit_overlay_image)
			user.cut_overlay(module.suit_overlay_image)
			if(equipped)
				user.add_overlay(module.suit_overlay_image)

/obj/item/clothing/suit/space/rig/proc/detach_cell(mob/user)
	to_chat(user, "You detach \the [cell] from \the [src]'s battery mount.")
	for(var/obj/item/rig_module/module in installed_modules)
		module.deactivate()
	cell.update_icon()
	user.put_in_hands(cell)
	cell = null

/obj/item/clothing/suit/space/rig/proc/detach_boots(mob/user)
	to_chat(user, "You detatch \the [boots] from \the [src]'s boot mounts.")
	user.put_in_hands(boots)
	boots = null

/obj/item/clothing/suit/space/rig/proc/detach_module(mob/user, list/current_mounts_modules, atom/anchor)
	var/list/modules = list()
	for(var/atom/module as anything in current_mounts_modules)
		modules[module] += image(icon = module.icon, icon_state = module.icon_state)

	var/removal_choice = show_radial_menu(user, anchor ? anchor : src, modules, require_near = TRUE, tooltips = TRUE)

	if(!removal_choice || wearer)
		return FALSE

	var/obj/item/rig_module/removed = removal_choice
	to_chat(user, "You detach \the [removed] from \the [src].")
	user.put_in_hands(removed)
	removed.removed()
	installed_modules -= removed

	return TRUE

// action buttons
/datum/action/item_action/hands_free/toggle_hardsuit_magboots
	name = "Toggle hardsuit magboots"
	button_icon_state = "toggle_rig_magboots"
	action_type = AB_INNATE

/datum/action/item_action/hands_free/toggle_hardsuit_magboots/Activate()
	var/obj/item/clothing/suit/space/rig/S = target
	S.toggle_magboots()

/datum/action/item_action/hands_free/toggle_hardsuit_helm
	name = "Toggle helmet"
	button_icon_state = "toggle_rig_helm"
	action_type = AB_INNATE

/datum/action/item_action/hands_free/toggle_hardsuit_helm/Activate()
	var/obj/item/clothing/suit/space/rig/S = target
	S.toggle_helmet()
