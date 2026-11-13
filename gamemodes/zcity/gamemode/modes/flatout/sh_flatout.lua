local MODE = MODE

zb = zb or {}
zb.Points = zb.Points or {}

zb.Points.FLATOUT_SPAWN = zb.Points.FLATOUT_SPAWN or {}
zb.Points.FLATOUT_SPAWN.Color = Color(0, 200, 80)
zb.Points.FLATOUT_SPAWN.Name = "FLATOUT_SPAWN"

zb.Points.FLATOUT_CHECKPOINT = zb.Points.FLATOUT_CHECKPOINT or {}
zb.Points.FLATOUT_CHECKPOINT.Color = Color(255, 180, 0)
zb.Points.FLATOUT_CHECKPOINT.Name = "FLATOUT_CHECKPOINT"

zb.Points.FLATOUT_FINISH = zb.Points.FLATOUT_FINISH or {}
zb.Points.FLATOUT_FINISH.Color = Color(255, 50, 50)
zb.Points.FLATOUT_FINISH.Name = "FLATOUT_FINISH"

-- надо сделать проперти чтобы добавлять новые мошонки через qmenu)
--MODE.Vehicles = {
--	{name = "Dukes", class = "gtav_dukes", model = "models/gta5/vehicles/dukes/chassis.mdl"},
--	{name = "Infernus", class = "gtav_infernus", model = "models/gta5/vehicles/infernus/chassis.mdl"},
--	{name = "Speedo", class = "gtav_speedo", model = "models/gta5/vehicles/speedo/chassis.mdl"},
--}

MODE.Vehicles = {
	{name = "Sophie", class = "exid_daewoo_nexia", model = "models/glide/exid/daewoo_nexia.mdl"},
	{name = "Sophie Max", class = "exid_daewoo_nexia", model = "models/glide/exid/2000_plymouth_neon.mdl"},
	{name = "Qubat Legacy", class = "exid_1966_pontiac_bonneville", model = "models/glide/exid/1966_pontiac_bonneville.mdl"},
	{name = "Qubat", class = "exid_1970_chrysler_300", model = "models/glide/exid/1970_chrysler_300.mdl"},
	{name = "Qubat Next", class = "exid_1985_cadillac_coupe_deville", model = "models/glide/exid/1985_cadillac_coupe_deville.mdl"},
	{name = "Bonecracker", class = "exid_1987_oldsmobile_cutlass", model = "models/glide/exid/1987_oldsmobile_cutlass.mdl"},
	{name = "Bobtail", class = "exid_1972_buick_riviera_boattail", model = "models/glide/exid/1972_buick_riviera_boattail.mdl"},
	{name = "Flicker", class = "exid_volkswagen_golf_mk2_alt", model = "models/glide/exid/volkswagen_golf_mk2_alt.mdl"},
	{name = "Stepvan", class = "exid_1996_dodge_caravan", model = "models/glide/exid/1996_dodge_caravan.mdl"},
	{name = "Omega Throw", class = "exid_1970_buick_gsx", model = "models/glide/exid/1970_buick_gsx.mdl"},
	{name = "Eyesless", class = "exid_1979_chevrolet_camaro_z28", model = "models/glide/exid/1979_chevrolet_camaro_z28.mdl"},
	{name = "Gazelle", class = "exid_1970_chevrolet_chevelle_ss", model = "models/glide/exid/1970_chevrolet_chevelle_ss.mdl"},
	{name = "Camino", class = "exid_1973_chevrolet_el_camino", model = "models/glide/exid/1973_chevrolet_el_camino.mdl"},
	{name = "Camino Revolution", class = "exid_1985_chevrolet_el_camino", model = "models/glide/exid/1985_chevrolet_el_camino.mdl"},
	{name = "Foxie", class = "exid_1993_ford_mustang_gt_foxbody", model = "models/glide/exid/1993_ford_mustang_gt.mdl"},
	{name = "Mustang", class = "exid_1995_ford_mustang_gt", model = "models/glide/exid/1995_ford_mustang_gt.mdl"},
	{name = "Alpha Throw", class = "exid_1970_oldsmobile_442", model = "models/glide/exid/1970_oldsmobile_442.mdl"},
	{name = "Roamer", class = "exid_plymouth_roadrunner_383", model = "models/glide/exid/plymouth_roadrunner_383.mdl"},
	{name = "Shelby", class = "exid_1967_shelby_gt500", model = "models/glide/exid/1967_shelby_gt500.mdl"},
	{name = "Behemoth Legacy", class = "exid_1982_ford_bronco_xlt", model = "models/glide/exid/1982_ford_bronco_xlt.mdl"},
	{name = "Behemoth", class = "exid_1998_dodge_durango", model = "models/glide/exid/1998_dodge_durango.mdl"},
	{name = "Behemoth Next", class = "exid_2003_ford_excursion", model = "models/glide/exid/2003_ford_excursion.mdl"},
	{name = "Behemoth Next Pickup", class = "exid_2002_ford_f_250", model = "models/glide/exid/2002_ford_f_250.mdl"},
	{name = "Tucson", class = "exid_1970_gmc_jimmy", model = "models/glide/exid/1970_gmc_jimmy.mdl"},
	{name = "Dirtkiller", class = "exid_1986_gmc_sierra", model = "models/glide/exid/1986_gmc_sierra.mdl"},
	{name = "Boyarin", class = "exid_lada_niva", model = "models/glide/exid/lada_niva.mdl"},
	{name = "Demonoid", class = "exid_1984_oldsmobile_cutlass_supreme", model = "models/glide/exid/1984_oldsmobile_cutlass_supreme.mdl"},
	{name = "Wrecker", class = "exid_volvo_240", model = "models/glide/exid/volvo_240.mdl"},
	{name = "Wrecker Cab", class = "exid_volvo_940", model = "models/glide/exid/volvo_940.mdl"},
	{name = "Cutlass", class = "exid_chevrolet_corvette_c4", model = "models/glide/exid/chevrolet_corvette_c4.mdl"},
	{name = "Germantachz", class = "exid_1992_mercedes_benz_600sl", model = "models/glide/exid/1992_mercedes_benz_600sl.mdl"},
	{name = "Germantachz Next", class = "exid_1993_bmw_m3_coupe", model = "models/glide/exid/1993_bmw_m3_coupe.mdl"},
	{name = "Elephant", class = "exid_isuzu_saz_hc_40", model = "models/glide/exid/isuzu_saz_hc_40.mdl"},
}

MODE.CheckpointRadius = 520 -- 220
MODE.LapsRequired = 3
MODE.OutsideVehicleTimeout = 3

-- GOVNO!
MODE.CheckpointColor = Color(255, 180, 0)
MODE.CheckpointNextColor = Color(0, 255, 100)
MODE.CheckpointDoneColor = Color(80, 80, 80)
MODE.CheckpointBeamHeight = 500