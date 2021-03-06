//-------------------------------------------------------
//SNIPER RIFLES
//Keyword rifles. They are subtype of rifles, but still contained here as a specialist weapon.

/obj/item/ammo_magazine/sniper
	name = "M42A marksman magazine (10x28mm Caseless)"
	desc = "A magazine of sniper rifle ammo."
	caliber = "10x28mm"
	icon_state = "m42c" //PLACEHOLDER
	w_class = 3
	max_rounds = 15
	default_ammo = /datum/ammo/bullet/sniper
	gun_type = /obj/item/weapon/gun/rifle/sniper/M42A

	New()
		..()
		reload_delay = config.low_fire_delay

/obj/item/ammo_magazine/sniper/incendiary
	name = "M42A incendiary magazine (10x28mm)"
	default_ammo = /datum/ammo/bullet/sniper/incendiary

/obj/item/ammo_magazine/sniper/flak
	name = "M42A flak magazine (10x28mm)"
	default_ammo = /datum/ammo/bullet/sniper/flak


//M42C magazine

/obj/item/ammo_magazine/sniper/elite
	name = "M42C marksman magazine (10x99mm)"
	default_ammo = /datum/ammo/bullet/sniper/elite
	gun_type = /obj/item/weapon/gun/rifle/sniper/elite
	caliber = "10x99mm"
	icon_state = "m42c"
	max_rounds = 6


//SVD //Based on the actual Dragunov sniper rifle.

/obj/item/ammo_magazine/sniper/svd
	name = "SVD magazine (7.62x54mmR)"
	desc = "A large caliber magazine for the SVD sniper rifle."
	caliber = "7.62x54mmR"
	icon_state = "svd003"
	default_ammo = /datum/ammo/bullet/sniper/svd
	max_rounds = 10
	gun_type = /obj/item/weapon/gun/rifle/sniper/svd



//M4RA magazines

/obj/item/ammo_magazine/rifle/m4ra
	name = "A19 high velocity magazine (10x24mm)"
	desc = "A magazine of A19 high velocity rounds for use in the M4RA battle rifle. The M4RA battle rifle is the only gun that can chamber these rounds."
	icon_state = "m4ra"
	default_ammo = /datum/ammo/bullet/rifle/m4ra
	max_rounds = 15
	gun_type = /obj/item/weapon/gun/rifle/m4ra

/obj/item/ammo_magazine/rifle/m4ra/incendiary
	name = "A19 high velocity incendiary magazine (10x24mm)"
	desc = "A magazine of A19 high velocity incendiary rounds for use in the M4RA battle rifle. The M4RA battle rifle is the only gun that can chamber these rounds."
	icon_state = "m4ra_incendiary"
	default_ammo = /datum/ammo/bullet/rifle/m4ra/incendiary
	max_rounds = 15
	gun_type = /obj/item/weapon/gun/rifle/m4ra

/obj/item/ammo_magazine/rifle/m4ra/impact
	name = "A19 high velocity impact magazine (10x24mm)"
	desc = "A magazine of A19 high velocity impact rounds for use in the M4RA battle rifle. The M4RA battle rifle is the only gun that can chamber these rounds."
	icon_state = "m4ra_impact"
	default_ammo = /datum/ammo/bullet/rifle/m4ra/impact
	max_rounds = 15
	gun_type = /obj/item/weapon/gun/rifle/m4ra




//-------------------------------------------------------
//SMARTGUN
/obj/item/ammo_magazine/internal/smartgun
	name = "integrated smartgun belt"
	caliber = "10x28mm"
	max_rounds = 100
	default_ammo = /datum/ammo/bullet/smartgun


/obj/item/ammo_magazine/internal/smartgun/dirty
	default_ammo = /datum/ammo/bullet/smartgun/dirty
	gun_type = /obj/item/weapon/gun/smartgun/dirty


//-------------------------------------------------------
//M5 RPG

/obj/item/ammo_magazine/rocket
	name = "84mm high-explosive rocket"
	desc = "A rocket tube for an M5 RPG rocket."
	caliber = "rocket"
	icon_state = "rocket"
	origin_tech = "combat=3;materials=3"
	matter = list("metal" = 10000)
	w_class = 3.0
	max_rounds = 1
	default_ammo = /datum/ammo/rocket
	gun_type = /obj/item/weapon/gun/launcher/rocket
	flags_magazine = NOFLAGS

	attack_self(mob/user)
		if(current_rounds <= 0)
			to_chat(user, "<span class='notice'>You begin taking apart the empty tube frame...</span>")
			if(do_after(user,10, TRUE, 5, BUSY_ICON_BUILD))
				user.visible_message("[user] deconstructs the rocket tube frame.","<span class='notice'>You take apart the empty frame.</span>")
				var/obj/item/stack/sheet/metal/M = new(get_turf(user))
				M.amount = 2
				user.drop_held_item()
				cdel(src)
		else
			to_chat(user, "Not with a missile inside!")


	attack(mob/living/carbon/human/M, mob/living/carbon/human/user, def_zone)

		var/obj/item/weapon/gun/launcher/in_hand
		if(!istype(M) || get_dist(user, M) > 1)
			return
		if(!M.mind || !M.mind.cm_skills || M.mind.cm_skills.firearms < SKILL_FIREARMS_DEFAULT)
			to_chat(user, "<span class='warning'>You were never trained to reload [in_hand].</span>")
			return
		in_hand = M.get_active_hand()
		if(!in_hand || !istype(in_hand) || in_hand.name != "M5 RPG (Wielded)")
			in_hand = M.get_inactive_hand()
			if(!in_hand || !istype(in_hand) || in_hand.name != "M5 RPG (Wielded)")
				to_chat(user, "<span class='warning'>RPG operator should wield RPG in both hands in order to reload.</span>")
				return
		if(M.dir != user.dir || M.loc != get_step(user, user.dir))
			to_chat(user, "<span class='warning'>You should be right behind [M] in order to reload.</span>")
			return

		if(in_hand.current_mag.current_rounds > 0)
			to_chat(user, "<span class='warning'>[in_hand] is already loaded!</span>")
			return

		if(user)
			to_chat(user, "<span class='notice'>You begin reloading [M]'s [in_hand]. Hold still...</span>")
			if(do_after(user,(in_hand.current_mag.reload_delay / 2), TRUE, 5, BUSY_ICON_FRIENDLY))
				if(get_dist(user, M) > 1)
					return
				if(M.dir != user.dir || M.loc != get_step(user, user.dir))
					to_chat(user, "<span class='warning'>You should be right behind [M] in order to reload.</span>")
					return
				user.drop_inv_item_on_ground(src)
				in_hand.replace_ammo(user,src)
				in_hand.current_mag.current_rounds = in_hand.current_mag.max_rounds
				src.current_rounds = 0
				to_chat(user, "<span class='notice'>You load [src] into [M]'s [in_hand].</span>")
				if(in_hand.reload_sound) playsound(M, in_hand.reload_sound, 25, 1)
				else playsound(M,'sound/machines/click.ogg', 25, 1)
			else
				to_chat(user, "<span class='warning'>Your reload was interrupted!</span>")
				return
		else
			src.loc = get_turf(in_hand)
			in_hand.replace_ammo(,src)
			in_hand.current_mag.current_rounds = in_hand.current_mag.max_rounds
			src.current_rounds = 0
		src.update_icon()
		return 1

	update_icon()
		overlays.Cut()
		if(current_rounds <= 0)
			name = "empty rocket frame"
			desc = "A spent rocket rube. Activate it to deconstruct it and receive some materials."
			icon_state = type == /obj/item/ammo_magazine/rocket/m57a4? "quad_rocket_e" : "rocket_e"

/obj/item/ammo_magazine/rocket/ap
	name = "84mm anti-armor rocket"
	icon_state = "ap_rocket"
	default_ammo = /datum/ammo/rocket/ap
	desc = "A tube for an AP rocket, the warhead of which is extremely dense and turns molten on impact. When empty, use this frame to deconstruct it."

/obj/item/ammo_magazine/rocket/wp
	name = "84mm white-phosphorus rocket"
	icon_state = "wp_rocket"
	default_ammo = /datum/ammo/rocket/wp
	desc = "A highly destructive warhead that bursts into deadly flames on impact. Use this in hand to deconstruct it."

/obj/item/ammo_magazine/internal/launcher/rocket
	name = "84mm internal tube"
	desc = "The internal tube of a M5 RPG."
	caliber = "rocket"
	default_ammo = /datum/ammo/rocket
	max_rounds = 1
	reload_delay = 60


//-------------------------------------------------------
//M5 RPG'S MEAN FUCKING COUSIN

/obj/item/ammo_magazine/rocket/m57a4
	name = "84mm thermobaric rocket array"
	desc = "A thermobaric rocket tube for an M83AM quad launcher. Activate in hand to receive some metal when it's used up."
	caliber = "rocket array"
	icon_state = "quad_rocket"
	origin_tech = "combat=4;materials=4"
	max_rounds = 4
	default_ammo = /datum/ammo/rocket/wp/quad
	gun_type = /obj/item/weapon/gun/launcher/rocket/m57a4
	reload_delay = 200

/obj/item/ammo_magazine/internal/launcher/rocket/m57a4
	desc = "The internal tube of an M83AM Thermobaric Launcher."
	caliber = "rocket array"
	default_ammo = /datum/ammo/rocket/wp/quad
	max_rounds = 4

