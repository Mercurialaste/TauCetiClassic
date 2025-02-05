/obj/effect/proc_holder/changeling/revive
	name = "Regenerate"
	desc = "We regenerate, healing all damage from our form."
	req_stat = DEAD

//Revive from regenerative stasis
/obj/effect/proc_holder/changeling/revive/sting_action(mob/living/carbon/user)
	if(user.stat == DEAD)
		dead_mob_list -= user
		alive_mob_list += user
	if(HUSK in user.mutations)
		user.mutations.Remove(HUSK)
	user.fake_death = 0
	user.stat = CONSCIOUS
	user.tod = null
	user.timeofdeath = 0
	user.reagents.clear_reagents()
	user.rejuvenate()
	to_chat(user, "<span class='notice'>We have regenerated.</span>")
	feedback_add_details("changeling_powers","CR")

	var/datum/role/changeling/C = user.mind.GetRoleByType(/datum/role/changeling)
	var/obj/effect/proc_holder/changeling/fakedeath/A = locate(/obj/effect/proc_holder/changeling/fakedeath) in C.purchasedpowers
	A.action.button_icon_state = "fake_death"
	A.action.button.UpdateIcon()
	qdel(src)
	return TRUE

/obj/effect/proc_holder/changeling/revive/can_sting(mob/user)
	if(NOCLONE in user.mutations)
		to_chat(user, "<span class='notice'>We could not regenerate. Something wrong with our DNA.</span>")
		user.fake_death = 0
		qdel(src) //We dont need that power from now anyway.
		return FALSE
	if(user.stat != DEAD)//We are alive when using this... Why do we need to keep this ability and even rejuvenate, if revive must used from dead state?
		qdel(src)  //If we somehow acquired it, remove upon clicking, to prevent stasis breaking
		to_chat(user, "<span class='notice'>We need to stop any life activity in our body.</span>")
		return FALSE
	return ..()
