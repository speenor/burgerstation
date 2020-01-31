/obj/structure/interactive/recycler
	name = "recycler"
	desc = "Oh god oh fuck."
	desc_extended = "Breaks down components into its most basic parts."
	icon = 'icons/obj/structure/recycling.dmi'
	icon_state = "base"

	var/turf/placing_turf

	var/list/stored_material = list()

	plane = PLANE_WALL_ATTACHMENTS

/obj/structure/interactive/recycler/New(var/desired_loc)

	var/image/I1b = new/image(icon,"grinder_bottom")
	I1b.pixel_x = -TILE_SIZE
	I1b.pixel_y = 0
	overlays += I1b

	var/image/I1 = new/image(icon,"grinder")
	I1.pixel_x = -TILE_SIZE
	I1.pixel_y = 6
	overlays += I1

	pixel_x = TILE_SIZE/2

	return ..()

/obj/structure/interactive/recycler/Initialize()
	placing_turf = get_step(src,EAST)
	return ..()

/obj/structure/interactive/recycler/Crossed(var/atom/movable/O)
	recycle(O)
	return ..()

/obj/structure/interactive/recycler/proc/recycle(var/atom/movable/O)

	if(is_item(O))
		var/obj/item/I = O
		for(var/material_type in I.material)
			stored_material[material_type] += I.material[material_type]
		process_material()
	qdel(O)

	return TRUE


/obj/structure/interactive/recycler/proc/process_material()

	for(var/material_type in stored_material)
		var/material_value = stored_material[material_type]
		var/material_to_make = floor(material_value/1000)
		if(material_to_make < 1)
			continue
		stored_material[material_type] -= material_to_make*1000
		var/obj/item/material/trash_cube/S = new(placing_turf)
		S.item_count_current = material_to_make
		S.material_id = material_type
		S.update_icon()

	return TRUE