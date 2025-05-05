
max_box = 6

tuning_markers = {
	[1] = {
		pos = {1238.2309570312, -1403.0009765625, 12.619346618652, 180}, -- x,y,z,rot
		logo = "textures/logo/los_santos.png",
	},
	[2] = {
		pos = {1791.7006835938, -1920.8826904297, 13.39213,180}, -- x,y,z,rot
		logo = "textures/logo/los_santos.png",
	},
	[3] = {
		pos = {37.794231414795, 140.59274291992, 2.078125}, -- x,y,z,rot
		logo = "textures/logo/los_santos.png",
	},
	[4] = {
		pos = {951.22265625, 2080.2219238281, 10.820312,180}, -- x,y,z,rot
		logo = "textures/logo/los_santos.png",
	},
}

tuning_options = {
	--// Main kategóriák
	name = "Kategóriák",
	[1] = {name = "Teljesítmény",icon = "textures/icons/engine.dds",
		[1] = {name = "Motor",icon = "textures/icons/engine.dds",
			[1] = {name = "Légbeömlő",icon = "textures/icons/air_intake.dds",data="danihe->tuning->airintake",
				desc = "A légbeömlő fejlesztések elősegítik a motor szabadabb lélegzését, és adnak egy adag extra kakót. A kevésébé korlátozó légszűrők és a tuningolt szívócső több levegőt enged a motorba, így nagyobb teljesítményt biztosítanak.",
				cameraSettings = {"bonnet_dummy", 70, 40, 4, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/air_intake.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/air_intake.dds",price=3500000*0.2,priceType="Money",handling={"maxVelocity",1.5}},
				[3] = {name = "Profi csomag",icon = "textures/icons/air_intake.dds",price=3500000*0.6,priceType="Money",handling={"maxVelocity",3}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/air_intake.dds",price=3500000,priceType="Money",handling={"maxVelocity",4.5}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/air_intake.dds",price=700,priceType="PP",handling={"maxVelocity",7.5}},
			},
			[2] = {name = "Üzemanyagrendszer",icon = "textures/icons/fuel_system.dds",data="danihe->tuning->fuelsystem",
				desc = "Az üzemanyagrendszer fejlesztések nagy teljesítmény növekedést hozhatnak. Biztosítják a hatékonyabb üzemanyag-áramlást, a pontosabb időzítést, a magasabb oktánszámú üzemanyag használatát, és a nagyobb teljesítmény kinyerést az általad használt üzemanyagból.",
				cameraSettings = {"bonnet_dummy", 110, 40, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/fuel_system.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/fuel_system.dds",price=6500000*0.2,priceType="Money",handling={"engineAcceleration",0.2}},
				[3] = {name = "Profi csomag",icon = "textures/icons/fuel_system.dds",price=6500000*0.6,priceType="Money",handling={"engineAcceleration",0.4}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/fuel_system.dds",price=6500000,priceType="Money",handling={"engineAcceleration",0.6}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/fuel_system.dds",price=700,priceType="PP",handling={"engineAcceleration",1}},
			},
			[3] = {name = "Gyújtás",icon = "textures/icons/ignite.dds",data="danihe->tuning->ignite",
				desc = "A gyújtás fejlesztései elősegítik, hogy a motor hatékonyabban égesse az üzemanyagot, és jobb teljesítményt nyújtson. Jobb tekercsekkel, gyújtógyertákkal és gyújtás vezetékekkel jelentős különbség mutatkozhat a motor erejében és az autó menetteljesítményében.",
				cameraSettings = {"bonnet_dummy", 80, 30, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/ignite.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/ignite.dds",price=4000000*0.2,priceType="Money",handling={"engineAcceleration",0.15}},
				[3] = {name = "Profi csomag",icon = "textures/icons/ignite.dds",price=4000000*0.6,priceType="Money",handling={"engineAcceleration",0.3}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/ignite.dds",price=4000000,priceType="Money",handling={"engineAcceleration",0.45}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/ignite.dds",price=700,priceType="PP",handling={"engineAcceleration",0.75}},
			},
			[4] = {name = "Kipufogó",icon = "textures/icons/exhaust.dds",data="danihe->tuning->exhaust",
				desc = "A kipufogórendszer fejlesztései, mint például a jobb gyűjtőcsövek, kipufogó dob, megkerülők és nagy átmérőjű csövek biztosítanak extra teljesítményt, viszonylag alacsony áron. Hagyják, hogy a motor sokkal szabadabban lélegezzen, és nagyobb teljesítményt adnak az ellennyomás csökkentésével és a kipufogógázok hatékonyabb elvezetésével.",
				cameraSettings = {"bump_rear_dummy", -105, 10, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/exhaust.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/exhaust.dds",price=5000000*0.2,priceType="Money",handling={"engineAcceleration",0.2}},
				[3] = {name = "Profi csomag",icon = "textures/icons/exhaust.dds",price=5000000*0.6,priceType="Money",handling={"engineAcceleration",0.4}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/exhaust.dds",price=5000000,priceType="Money",handling={"engineAcceleration",0.6}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/exhaust.dds",price=700,priceType="PP",handling={"engineAcceleration",1}},
			},
			[5] = {name = "Vezérműtengely",icon = "textures/icons/camshaft.dds",data="danihe->tuning->camshaft",
				desc = "A továbbfejlesztett szelepvezérléssel a motor szabadabban lélegezhet, és magasabb fordulatszámra pöröghet fel, nagyobb nyomatékot és teljesítményt biztosítva. Az eredmény magasabb vörös tartomány és nagyobb teljesítmény a magas fodulatszám-tartományban.",
				cameraSettings = {"bonnet_dummy", 92, 35, 2.5, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/camshaft.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/camshaft.dds",price=8000000*0.2,priceType="Money",handling={"engineAcceleration",0.15}},
				[3] = {name = "Profi csomag",icon = "textures/icons/camshaft.dds",price=8000000*0.6,priceType="Money",handling={"engineAcceleration",0.3}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/camshaft.dds",price=8000000,priceType="Money",handling={"engineAcceleration",0.45}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/camshaft.dds",price=700,priceType="PP",handling={"engineAcceleration",0.75}},
			},
			[6] = {name = "Szelepek",icon = "textures/icons/valve.dds",data="danihe->tuning->valve",
				desc = "A szelepek teszik lehetővé a levegő és üzemanyag keverék be- és kilépését a motorból. Ezek fejlesztése lehető teszi a nagyobb légáramlást a nagyobb teljesítményért.",
				cameraSettings = {"bonnet_dummy", 50, 30, 4, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/valve.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/valve.dds",price=2500000*0.2,priceType="Money",handling={"maxVelocity",2}},
				[3] = {name = "Profi csomag",icon = "textures/icons/valve.dds",price=2500000*0.6,priceType="Money",handling={"maxVelocity",4}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/valve.dds",price=2500000,priceType="Money",handling={"maxVelocity",6}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/valve.dds",price=700,priceType="PP",handling={"maxVelocity",10}},
			},
			[7] = {name = "Hengerűrtartalom",icon = "textures/icons/engine.dds",data="danihe->tuning->engine",
				desc = "A hengerűrtartalom fejlesztésekkel a motor sokkal tartósabb lesz, és kevésébé kitett a károsodásnak. Ezek csökkenthetik a súrlódást/tehetetlenséget, és növelhetik a löket/sűrítés értékét, hogy a motor nagyobb teljesítményű és rugalmasabb legyen.",
				cameraSettings = {"bonnet_dummy", 90, 30, 3.3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/engine.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/engine.dds",price=5500000*0.2,priceType="Money",handling={"maxVelocity",5}},
				[3] = {name = "Profi csomag",icon = "textures/icons/engine.dds",price=5500000*0.6,priceType="Money",handling={"maxVelocity",10}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/engine.dds",price=5500000,priceType="Money",handling={"maxVelocity",15}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/engine.dds",price=700,priceType="PP",handling={"maxVelocity",30}},
			},
			[8] = {name = "ECU",icon = "textures/icons/ecu.dds",data="danihe->tuning->ecu",
				desc = "A mai belső égésű motorok működését az elektronikus vezérlő egység(ECU) irányítja, a hozzá csatlakoztatott jeladóktól beérkező adatok alapján. Ez mechanikai átalakítás nélkül emeli meg a motor teljesítményét és fogatónyomatékát, az ECU szoftverének módosításával.",
				cameraSettings = {"bonnet_dummy", 110, 45, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/ecu.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/ecu.dds",price=3000000*0.2,priceType="Money",handling={"maxVelocity",3}},
				[3] = {name = "Profi csomag",icon = "textures/icons/ecu.dds",price=3000000*0.6,priceType="Money",handling={"maxVelocity",6}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/ecu.dds",price=3000000,priceType="Money",handling={"maxVelocity",9}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/ecu.dds",price=700,priceType="PP",handling={"maxVelocity",15}},
			},
			[9] = {name = "Dugattyúk",icon = "textures/icons/pistons.dds",data="danihe->tuning->pistons",
				desc = "A dugattyúk fejlesztése lehetővé teszi a nagy sűrítési arányt a nagyobb teljesítményért.",
				cameraSettings = {"bonnet_dummy", 140, 50, 2.5, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/pistons.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/pistons.dds",price=4500000*0.2,priceType="Money",handling={"engineAcceleration",0.2}},
				[3] = {name = "Profi csomag",icon = "textures/icons/pistons.dds",price=4500000*0.6,priceType="Money",handling={"engineAcceleration",0.4}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/pistons.dds",price=4500000,priceType="Money",handling={"engineAcceleration",0.6}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/pistons.dds",price=700,priceType="PP",handling={"engineAcceleration",1.0}},
			},
			[10] = {name = "Turbó",icon = "textures/icons/turbo.dds",data="danihe->tuning->turbo",
				desc = "A turbófeltöltő jelentős teljesítmény növekedést nyújt a kipufogógázokat egy turbina forgatására felhasználva, amely sűríti a levegő-üzemanyag keveréket és a légkörinél nagyobb nyomáson juttatja a motorba. Az eredmény több energia ütemenként, ami nagyobb teljesítményt jelent.",
				cameraSettings = {"bonnet_dummy", 90, 30, 3.3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/turbo.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/turbo.dds",price=6000000*0.2,priceType="Money",handling={"engineAcceleration",0.5}},
				[3] = {name = "Profi csomag",icon = "textures/icons/turbo.dds",price=6000000*0.6,priceType="Money",handling={"engineAcceleration",1.0}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/turbo.dds",price=6000000,priceType="Money",handling={"engineAcceleration",1.5}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/turbo.dds",price=700,priceType="PP",handling={"engineAcceleration",2.5}},
			},
			[11] = {name = "Hőcserélő",icon = "textures/icons/intercooler.dds",data="danihe->tuning->intercooler",
				desc = "A hőcserélő egy kis hűtőrács, ami lehűti a turbófeltöltőből vagy a feltöltőböl érkező forró levegőt, mielőtt a motorba jut. Ettől a levegő-üzemanyag keverék alacsonyabb hőmérsékletű, ezért sűrűbb lesz, több energiát adva ütemenként.",
				cameraSettings = {"bonnet_dummy", 90, 0, 4, false}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/intercooler.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/intercooler.dds",price=5000000*0.2,priceType="Money",handling={"engineAcceleration",0.3}},
				[3] = {name = "Profi csomag",icon = "textures/icons/intercooler.dds",price=5000000*0.6,priceType="Money",handling={"engineAcceleration",0.6}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/intercooler.dds",price=5000000,priceType="Money",handling={"engineAcceleration",0.9}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/intercooler.dds",price=700,priceType="PP",handling={"engineAcceleration",1.5}},
			},
			[12] = {name = "Olajhűtés",icon = "textures/icons/oil_cooler.dds",data="danihe->tuning->oil_cooler",
				desc = "Az olajhűtás felszerelése a megfelelő hőmérsékleten tartja a motorolajat, ezzel segítve a hatékonyságot, és növelve a teljesítményt.",
				cameraSettings = {"bonnet_dummy", 80, 0, 4, false}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/oil_cooler.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/oil_cooler.dds",price=4000000*0.2,priceType="Money",handling={"maxVelocity",1.2}},
				[3] = {name = "Profi csomag",icon = "textures/icons/oil_cooler.dds",price=4000000*0.6,priceType="Money",handling={"maxVelocity",2.4}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/oil_cooler.dds",price=4000000,priceType="Money",handling={"maxVelocity",3.6}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/oil_cooler.dds",price=700,priceType="PP",handling={"maxVelocity",6.0}},
			},
			[13] = {name = "Lendkerék",icon = "textures/icons/flywheel.dds",data="danihe->tuning->flywheel",
				desc = "A gyári autónál a lendkerék forgó tömege kisimítja és stabilizálja a féltengely forgását, de rontja a gázadás válaszidejét és a gyorsulást. Kisebb súlyú lendkerék fejlesztése lehetővé teszi, hogy a motor gyorsabban reagáljon a gázadásra, és gyorsabban növelje a fordulatszámot, így jobb gyorsulást biztosítva.",
				cameraSettings = {"bonnet_dummy", 92, 28, 3.3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/flywheel.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/flywheel.dds",price=5000000*0.2,priceType="Money",handling={"maxVelocity",1.2}},
				[3] = {name = "Profi csomag",icon = "textures/icons/flywheel.dds",price=5000000*0.6,priceType="Money",handling={"maxVelocity",2.4}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/flywheel.dds",price=5000000,priceType="Money",handling={"maxVelocity",3.6}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/flywheel.dds",price=700,priceType="PP",handling={"maxVelocity",6.0}},
			},
		},
		[2] = {name = "Kezelhetőség",icon = "textures/icons/brakes.dds",
			[1] = {name = "Fékek",icon = "textures/icons/brakes.dds",data="danihe->tuning->brakes",
				desc = "A fékek fontos részei a teljesítmény egészének. Ahhoz, hogy versenyképes autó legyen az autó, a fékhatása arányban kell álljon a teljesítményével és a kezelhetőségével. Ezek a fejlesztések növelik a fékező erőt, és csökkentik a fékerővesztést a túlzott hőhatás miatt.",
				cameraSettings = {"wheel_lf_dummy", 180, 10, 1.3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/brakes.dds",price=0,priceType="Money",handling={"brakeDeceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/brakes.dds",price=7000000*0.2,priceType="Money",handling={"brakeDeceleration",4}},
				[3] = {name = "Profi csomag",icon = "textures/icons/brakes.dds",price=7000000*0.6,priceType="Money",handling={"brakeDeceleration",8}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/brakes.dds",price=7000000,priceType="Money",handling={"brakeDeceleration",12}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/brakes.dds",price=700,priceType="PP",handling={"brakeDeceleration",20}},
			},
			[2] = {name = "Lengéscsillapító",icon = "textures/icons/suspension.dds",data="danihe->tuning->suspension",
				desc = "A rugók és a lengéscsillapítók jelentősen befolyásolhatják az autód kezelhetőségét, fenntartva az optimális menetmagasságot és gumiabroncs tapadást.",
				cameraSettings = {"wheel_rf_dummy", 0, 10, 1.3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/suspension.dds",price=0,priceType="Money",handling={"tractionMultiplier",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/suspension.dds",price=4000000*0.2,priceType="Money",handling={"tractionMultiplier",0.008}},
				[3] = {name = "Profi csomag",icon = "textures/icons/suspension.dds",price=4000000*0.6,priceType="Money",handling={"tractionMultiplier",0.016}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/suspension.dds",price=4000000,priceType="Money",handling={"tractionMultiplier",0.024}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/suspension.dds",price=700,priceType="PP",handling={"tractionMultiplier",0.040}},
			},
			[3] = {name = "Alváz megerősítés",icon = "textures/icons/drivetype.dds",data="danihe->tuning->chassis",
				desc = "Az alvázerősítések merevítik az autó vázát, csökkentve a feszítést kanyarodáskor, ami viszont segíti a felfüggesztést a gumiabroncsot a lehető legnagyobb mértékben az úton tartani.",
				[1] = {name = "Gyári csomag",icon = "textures/icons/drivetype.dds",price=0,priceType="Money",handling={"tractionMultiplier",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/drivetype.dds",price=6500000*0.2,priceType="Money",handling={"tractionMultiplier",0.007}},
				[3] = {name = "Profi csomag",icon = "textures/icons/drivetype.dds",price=6500000*0.6,priceType="Money",handling={"tractionMultiplier",0.014}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/drivetype.dds",price=6500000,priceType="Money",handling={"tractionMultiplier",0.021}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/drivetype.dds",price=700,priceType="PP",handling={"tractionMultiplier",0.035}},
			},
			[4] = {name = "Súlycsökkentés",icon = "textures/icons/weightreducation.dds",data="danihe->tuning->weight",
				desc = "Egy könnyebb autó jobban gyorsul és jobban kezelhető, mint egy nehezebb. A súly csökkentése a nem lényeges anyagokat eltávolítva vagy a gyári alkatrészeket könnyebbre cserélve megtérülhet.",
				[1] = {name = "Gyári csomag",icon = "textures/icons/weightreducation.dds",price=0,priceType="Money",handling={"tractionLoss",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/weightreducation.dds",price=3000000*0.2,priceType="Money",handling={"tractionLoss",0.007}},
				[3] = {name = "Profi csomag",icon = "textures/icons/weightreducation.dds",price=3000000*0.6,priceType="Money",handling={"tractionLoss",0.014}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/weightreducation.dds",price=3000000,priceType="Money",handling={"tractionLoss",0.021}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/weightreducation.dds",price=700,priceType="PP",handling={"tractionLoss",0.035}},
			},
			[5] = {name = "Gumik",icon = "textures/icons/tires.dds",data="danihe->tuning->tires",
				desc = "A gumiabroncsok lecserélése lágyabb, agresszívabb összetételre növeli a tapadást és javítja a gumiabroncsok képességét a tapadás fenntartására a magas hő ellenére is, de ugyanakkor növeli a kopást. A gyári gumikban használt keményebb összetétel feláldoz valamennyit a tapadásból a kopásállóság növelése érdekében.",
				cameraSettings = {"wheel_lf_dummy", 205, 15, 2, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/tires.dds",price=0,priceType="Money",handling={"tractionMultiplier",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/tires.dds",price=2000000*0.2,priceType="Money",handling={"tractionMultiplier",0.03}},
				[3] = {name = "Profi csomag",icon = "textures/icons/tires.dds",price=2000000*0.6,priceType="Money",handling={"tractionMultiplier",0.06}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/tires.dds",price=2000000,priceType="Money",handling={"tractionMultiplier",0.09}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/tires.dds",price=700,priceType="PP",handling={"tractionMultiplier",0.15}},
			},
		},
		[3] = {name = "Hajtáslánc",icon = "textures/icons/drivetype.dds",
			[1] = {name = "Kuplung",icon = "textures/icons/clutch.dds",data="danihe->tuning->clutch",
				desc = "A tengelykapcsoló létfontosságú kapcsolatot jelent a motor és a sebességváltó között. A fejlesztésekkel a tengelykapcsoló jobban képes kezelni egy versenymotor extra nyomatékát, károsodás nélkül.",
				cameraSettings = {"bonnet_dummy", 80, 30, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/clutch.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/clutch.dds",price=6500000*0.2,priceType="Money",handling={"engineAcceleration",0.15}},
				[3] = {name = "Profi csomag",icon = "textures/icons/clutch.dds",price=6500000*0.6,priceType="Money",handling={"engineAcceleration",0.3}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/clutch.dds",price=6500000,priceType="Money",handling={"engineAcceleration",0.45}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/clutch.dds",price=700,priceType="PP",handling={"engineAcceleration",0.75}},
			},
			[2] = {name = "Sebességváltó",icon = "textures/icons/gear.dds",data="danihe->tuning->gear",
				desc = "A sebességváltó adja át az autó teljesítményét a motorból a hajtott kerekeknek. A sebességváltó-fejlesztések meggyorsíthatják és hatékonyabbá tehetik a váltást, csökkenthetik a súrlódást és a teljesítmény veszteséget, és jobb tartósságot biztosíthatnak.",
				cameraSettings = {"bonnet_dummy", 108, 30, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/gear.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/gear.dds",price=7000000*0.2,priceType="Money",handling={"engineAcceleration",0.25}},
				[3] = {name = "Profi csomag",icon = "textures/icons/gear.dds",price=7000000*0.6,priceType="Money",handling={"engineAcceleration",0.5}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/gear.dds",price=7000000,priceType="Money",handling={"engineAcceleration",0.75}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/gear.dds",price=700,priceType="PP",handling={"engineAcceleration",1.25}},
			},
			[3] = {name = "Hajtáslánc",icon = "textures/icons/drivetype.dds",data="danihe->tuning->chain",
				desc = "Javíthatod a gázadás válaszidejét és a gyorsulást a hajtáslánc alkatrészek, különösen a féltengely súlyának és tehetetlenségének csökkentésével.",
				[1] = {name = "Gyári csomag",icon = "textures/icons/drivetype.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/drivetype.dds",price=5000000*0.2,priceType="Money",handling={"engineAcceleration",0.2}},
				[3] = {name = "Profi csomag",icon = "textures/icons/drivetype.dds",price=5000000*0.6,priceType="Money",handling={"engineAcceleration",0.4}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/drivetype.dds",price=5000000,priceType="Money",handling={"engineAcceleration",0.6}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/drivetype.dds",price=700,priceType="PP",handling={"engineAcceleration",1.0}},
			},
			[4] = {name = "Differenciálmű",icon = "textures/icons/diff.dds",data="danihe->tuning->diff",
				desc = "A differenciálmű lehetővé teszi, hogy az autó mindkét oldalán a kerekek különböző sebességgel forogjanak, mivel a belső kerék rövidebb távot tesz meg a kanyarban, mint a külső. Az önzáró differenciálmű egy előre beállított ponton lezár, hogy korlátozza a fordulatszám-különbséget, így maximális tapadást nyújt gyorsításkor és/vagy lassításkor.",
				cameraSettings = {"wheel_lb_dummy", 220, 15, 3, false}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Gyári csomag",icon = "textures/icons/diff.dds",price=0,priceType="Money",handling={"tractionMultiplier",0}},
				[2] = {name = "Utcai csomag",icon = "textures/icons/diff.dds",price=4000000*0.2,priceType="Money",handling={"tractionMultiplier",0.007}},
				[3] = {name = "Profi csomag",icon = "textures/icons/diff.dds",price=4000000*0.6,priceType="Money",handling={"tractionMultiplier",0.014}},
				[4] = {name = "Verseny csomag",icon = "textures/icons/diff.dds",price=4000000,priceType="Money",handling={"tractionMultiplier",0.021}},
				[5] = {name = "Prémium csomag",icon = "textures/icons/diff.dds",price=700,priceType="PP",handling={"tractionMultiplier",0.035}},
			},
		},
		[4] = {name = "Nitro",icon = "textures/icons/nitro.dds",data="danihe->tuning->nitro",
			cameraSettings = {"boot_dummy", -45, 22, 4, true}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Kiszerelés",icon = "textures/icons/nitro.dds",price=0,priceType="Money"},
			[2] = {name = "Beszerelés",icon = "textures/icons/nitro.dds",price=700,priceType="PP"},
			[3] = {name = "Palack feltöltése",icon = "textures/icons/nitro.dds",price=8000000,priceType="Money"},
 		},
	},
	[2] = {name = "Optika",icon = "textures/icons/optics.dds",
		[1] = {name = "Első felnik",icon = "textures/icons/rim.dds",wheelType="Front",
			cameraSettings = {"wheel_lf_dummy", 220, 15, 3, false}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Gyári",icon = "textures/icons/rim.dds",price=0,priceType="Money",wheelID = 0},
			[2] = {name = "Felni #1",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 1,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[3] = {name = "Felni #2",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 2,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[4] = {name = "Felni #3",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 3,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[5] = {name = "Felni #4",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 4,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[6] = {name = "Felni #5",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 5,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[7] = {name = "Felni #6",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 6,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[8] = {name = "Felni #7",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 7,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[9] = {name = "Felni #8",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 8,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[10] = {name = "Felni #9",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 9,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[11] = {name = "Felni #10",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 10,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[12] = {name = "Felni #11",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 11,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[13] = {name = "Felni #12",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 12,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[14] = {name = "Felni #13",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 13,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[15] = {name = "Felni #14",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 14,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[16] = {name = "Felni #15",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 15,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[17] = {name = "Felni #16",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 16,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[18] = {name = "Felni #17",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 17,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[19] = {name = "Felni #18",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 18,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[20] = {name = "Felni #19",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 19,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[21] = {name = "Felni #20",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 20,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[22] = {name = "Felni #21",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 21,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[23] = {name = "Felni #22",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 22,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[24] = {name = "Felni #23",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 23,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[25] = {name = "Felni #24",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 24,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[26] = {name = "Felni #25",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 25,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[27] = {name = "Felni #26",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 26,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[28] = {name = "Felni #27",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 27,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			--[[[29] = {name = "Felni #28",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 28,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[30] = {name = "Felni #29",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 29,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[31] = {name = "Felni #30",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 30,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[32] = {name = "Felni #31",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 31,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[33] = {name = "Felni #32",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 32,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[34] = {name = "Felni #33",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 33,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[35] = {name = "Felni #34",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 34,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[36] = {name = "Felni #35",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 35,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[37] = {name = "Felni #36",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 36,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[38] = {name = "Felni #37",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 37,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[39] = {name = "Felni #38",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 38,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[40] = {name = "Felni #39",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 39,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[41] = {name = "Felni #40",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 40,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[42] = {name = "Felni #41",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 41,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[43] = {name = "Felni #42",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 42,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[44] = {name = "Felni #43",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 43,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[45] = {name = "Felni #44",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 44,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[46] = {name = "Felni #45",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 45,wheelType="Front",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},}, --]]
		},
		[2] = {name = "Hátsó felnik",icon = "textures/icons/rim.dds",wheelType="Back",
			cameraSettings = {"wheel_lb_dummy", 220, 15, 3, false}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Gyári",icon = "textures/icons/rim.dds",price=0,priceType="Money",wheelID = 0},
			[2] = {name = "Felni #1",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 1,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[3] = {name = "Felni #2",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 2,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[4] = {name = "Felni #3",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 3,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[5] = {name = "Felni #4",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 4,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[6] = {name = "Felni #5",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 5,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[7] = {name = "Felni #6",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 6,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[8] = {name = "Felni #7",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 7,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[9] = {name = "Felni #8",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 8,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[10] = {name = "Felni #9",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 9,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[11] = {name = "Felni #10",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 10,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[12] = {name = "Felni #11",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 11,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[13] = {name = "Felni #12",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 12,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[14] = {name = "Felni #13",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 13,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[15] = {name = "Felni #14",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 14,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[16] = {name = "Felni #15",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 15,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[17] = {name = "Felni #16",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 16,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[18] = {name = "Felni #17",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 17,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[19] = {name = "Felni #18",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 18,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[20] = {name = "Felni #19",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 19,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[21] = {name = "Felni #20",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 20,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[22] = {name = "Felni #21",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 21,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[23] = {name = "Felni #22",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 22,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[24] = {name = "Felni #23",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 23,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[25] = {name = "Felni #24",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 24,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[26] = {name = "Felni #25",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 25,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[27] = {name = "Felni #26",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 26,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			[28] = {name = "Felni #27",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 27,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=1000000,priceType="Money"},},
			--[[[29] = {name = "Felni #28",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 28,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[30] = {name = "Felni #29",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 29,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[31] = {name = "Felni #30",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 30,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[32] = {name = "Felni #31",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 31,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[33] = {name = "Felni #32",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 32,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[34] = {name = "Felni #33",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 33,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[35] = {name = "Felni #34",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 34,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[36] = {name = "Felni #35",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 35,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[37] = {name = "Felni #36",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 36,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[38] = {name = "Felni #37",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 37,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[39] = {name = "Felni #38",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 38,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[40] = {name = "Felni #39",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 39,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[41] = {name = "Felni #40",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 40,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[42] = {name = "Felni #41",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 41,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[43] = {name = "Felni #42",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 42,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[44] = {name = "Felni #43",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 43,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[45] = {name = "Felni #44",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 44,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},},
			[46] = {name = "Felni #45",icon = "textures/icons/rim.dds",price=1000000,priceType="Money",wheelID = 45,wheelType="Back",[1] = {name = "Megvásárlás",icon = "textures/icons/rim.dds",price=385,priceType="Money"},}, --]]
		},
		[3] = {name = "Első lökhárító",icon = "textures/icons/front_bumper.dds",upgradeSlot=14,price=1500000,priceType="Money",
			cameraSettings = {"door_rf_dummy", 135, 10, 7, false},[1] = {},
		},
		[4] = {name = "Hátsó lökhárító",icon = "textures/icons/rear_bumper.dds",upgradeSlot=15,price=1500000,priceType="Money",
			cameraSettings = {"door_lf_dummy", -65, 3, 8, false},[1] = {},
		},
		[5] = {name = "Küszöb",icon = "textures/icons/sideskirt.dds",upgradeSlot=3,price=1500000,priceType="Money",
			cameraSettings = {"door_rf_dummy", 40, 30, 4, false},[1] = {},
		},
		[6] = {name = "Motorházterő",icon = "textures/icons/hood.dds",upgradeSlot=0,price=1500000,priceType="Money",
			cameraSettings = {"bonnet_dummy", 40, 10, 4, false},[1] = {},
		},
		[7] = {name = "Légterelő",icon = "textures/icons/spoiler.dds",upgradeSlot=2,price=1500000,priceType="Money",
			cameraSettings = {"boot_dummy", -30, 10, 5, false},[1] = {},
		},
		[8] = {name = "Tetőlégterelő",icon = "textures/icons/roof.dds",upgradeSlot=7,price=1500000,priceType="Money",
			cameraSettings = {"ug_roof", 40, 30, 4, false},[1] = {},
		},
		[9] = {name = "Kipufogó",icon = "textures/icons/exhaust.dds",upgradeSlot=13,price=1500000,priceType="Money",
			cameraSettings = {"wheel_lb_dummy", -65, 3, 5, false},[1] = {},
		},
	},
	[3] = {name = "Fényezés",icon = "textures/icons/paint.dds",
		[1] = {name = "Szín #1",icon = "textures/icons/paint.dds",paintID = 1,
			[1] = {name = "Megvásárlás",icon = "textures/icons/paint.dds",price=1500000,priceType="Money"},
		},
		[2] = {name = "Szín #2",icon = "textures/icons/paint.dds",paintID = 2,
			[1] = {name = "Megvásárlás",icon = "textures/icons/paint.dds",price=1500000,priceType="Money"},
		},
		[3] = {name = "Szín #3",icon = "textures/icons/paint.dds",paintID = 3,
			[1] = {name = "Megvásárlás",icon = "textures/icons/paint.dds",price=1500000,priceType="Money"},
		},
		[4] = {name = "Szín #4",icon = "textures/icons/paint.dds",paintID = 4,
			[1] = {name = "Megvásárlás",icon = "textures/icons/paint.dds",price=1500000,priceType="Money"},
		},
		[5] = {name = "Fényszóró",icon = "textures/icons/lamp.dds",paintID = 5,
			cameraSettings = {"bump_front_dummy", -45, 22, 8, false}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Megvásárlás",icon = "textures/icons/lamp.dds",price=1500000,priceType="Money"},
		},
	},
	[4] = {name = "Extrák",icon = "textures/icons/extras.dds",
		[1] = {name = "AirRide",icon = "textures/icons/airride.dds",data="danihe->tuning->airride",
			[1] = {name = "Kiszerelés",icon = "textures/icons/airride.dds",price=0,priceType="Money"},
			[2] = {name = "Beszerelés",icon = "textures/icons/airride.dds",price=3000000,priceType="Money"},
		},
		[2] = {name = "Fordulókör",icon = "textures/icons/steering.dds",
			[1] = {name = "30°",icon = "textures/icons/steering.dds",price=0,priceType="Money",steer=30},
			[2] = {name = "35°",icon = "textures/icons/steering.dds",price=500000,priceType="Money",steer=35},
			[3] = {name = "40°",icon = "textures/icons/steering.dds",price=500000,priceType="Money",steer=40},
			[4] = {name = "45°",icon = "textures/icons/steering.dds",price=500000,priceType="Money",steer=45},
			[5] = {name = "50°",icon = "textures/icons/steering.dds",price=500000,priceType="Money",steer=50},
			[6] = {name = "55°",icon = "textures/icons/steering.dds",price=500000,priceType="Money",steer=55},
			[7] = {name = "60°",icon = "textures/icons/steering.dds",price=500000,priceType="Money",steer=60},
		},
		[3] = {name = "Rendszámtábla",icon = "textures/icons/plate.dds",plate=true,
			cameraSettings = {"boot_dummy", 270, -5, 3, false}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Rendszámtábla #1",icon = "textures/icons/plate.dds",price=800,priceType="PP"},
			[2] = {name = "Rendszámtábla #2",icon = "textures/icons/plate.dds",price=800,priceType="PP"},
			[3] = {name = "Rendszámtábla #3",icon = "textures/icons/plate.dds",price=800,priceType="PP"},
			[4] = {name = "Rendszámtábla #4",icon = "textures/icons/plate.dds",price=800,priceType="PP"},
			[5] = {name = "Rendszámtábla #5",icon = "textures/icons/plate.dds",price=800,priceType="PP"},
			[6] = {name = "Rendszámtábla #6",icon = "textures/icons/plate.dds",price=800,priceType="PP"},
		},
		[4] = {name = "Meghajtás",icon = "textures/icons/drivetype.dds",
			[1] = {name = "Első kerék",icon = "textures/icons/drivetype.dds",price=4000000,priceType="Money",drivetype="fwd"},
			[2] = {name = "Összkerék",icon = "textures/icons/drivetype.dds",price=4000000,priceType="Money",drivetype="awd"},
			[3] = {name = "Hátsó kerék",icon = "textures/icons/drivetype.dds",price=4000000,priceType="Money",drivetype="rwd"},
		},
		[5] = {name = "Gumifüst",icon = "textures/icons/tiresmoke.dds",
			[1] = {name = "Bal oldal",icon = "textures/icons/tiresmoke.dds",tiredata="Left",
				cameraSettings = {"wheel_lb_dummy", 185, 10, 7, false}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Megvásárlás",icon = "textures/icons/tiresmoke.dds",price=500,priceType="PP"},
			},
			[2] = {name = "Jobb oldal",icon = "textures/icons/tiresmoke.dds",tiredata="Right",
				cameraSettings = {"wheel_rb_dummy", -5, 10, 7, false}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Megvásárlás",icon = "textures/icons/tiresmoke.dds",price=500,priceType="PP"},
			},
		},
		--[6] = {name = "LSD Ajtó",icon = "textures/icons/lsd_door.dds",

		--},
		[6] = {name = "Neon",icon = "textures/icons/neon.dds",neon=true,
			cameraSettings = {"chassis", 170, 15, 5.5, false}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Leszerelés",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
			[2] = {name = "Neon #1",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
			[3] = {name = "Neon #2",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
			[4] = {name = "Neon #3",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
			[5] = {name = "Neon #4",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
			[6] = {name = "Neon #5",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
			[7] = {name = "Neon #6",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
			[8] = {name = "Neon #7",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
			[9] = {name = "Neon #8",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
			[10] = {name = "Neon #9",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
			[11] = {name = "Neon #10",icon = "textures/icons/neon.dds",price=2500000,priceType="Money"},
		},
		[7] = {name = "Variáns",icon = "textures/icons/variant.dds",variant=true,
			[1] = {name = "Variáns #1",icon = "textures/icons/variant.dds",price=650,priceType="PP"},
			[2] = {name = "Variáns #2",icon = "textures/icons/variant.dds",price=650,priceType="PP"},
			[3] = {name = "Variáns #3",icon = "textures/icons/variant.dds",price=650,priceType="PP"},
			[4] = {name = "Variáns #4",icon = "textures/icons/variant.dds",price=650,priceType="PP"},
			[5] = {name = "Variáns #5",icon = "textures/icons/variant.dds",price=650,priceType="PP"},
			[6] = {name = "Variáns #6",icon = "textures/icons/variant.dds",price=650,priceType="PP"},
			[7] = {name = "Variáns #7",icon = "textures/icons/variant.dds",price=650,priceType="PP"},
			[8] = {name = "Variáns #8",icon = "textures/icons/variant.dds",price=650,priceType="PP"},
		},
	},
	[5] = {name = "Matricázás",icon = "textures/icons/stickers.dds",
		[1] = {name = "Új hozzáadása",icon = "textures/icons/sticker_new.dds",
			newSticker = true,
			[1] = {name = "Megvásárlás",icon = "textures/icons/sticker_new.dds",stickerEditing = true},
		},
		[2] = {name = "Szerkesztés",icon = "textures/icons/sticker_edit.dds",listStickers=true,
			[1] = {},
		},
		[3] = {name = "Összes törlése",icon = "textures/icons/sticker_delete.dds",delteStickers=true,price=0,priceType="Money"},
	},
}

function getPerformanceTuneDatas()
	local datas = {}
	for k,v in ipairs(tuning_options[1]) do
		for i,row in ipairs(v) do
			if row.data then
				table.insert(datas,row.data)
			end
		end
	end
	return datas
end

function getPerformanceTunesForDashboard()
	local datas = {}
	for k,v in ipairs(tuning_options[1]) do
		for i,row in ipairs(v) do
			if row.data then
				table.insert(datas,{name=row.name,elementdata=row.data})
			end
		end
	end
	return datas
end


--// Matrica kategóriák
stickers = {
	[1] = {name="Formák",icon="textures/stickers/shapes.dds",dir="shapes",stickerCount=136,price=200},
	[2] = {name="Fóliák",icon="textures/stickers/body.dds",dir="body",stickerCount=35,price=200},
	[3] = {name="Karakterek",icon="textures/stickers/characters.dds",dir="characters",stickerCount=65,price=200},
	[4] = {name="Szövegek",icon="textures/stickers/texts.dds",dir="texts",stickerCount=177,price=200},
	[5] = {name="Egyéb",icon="textures/stickers/misc.dds",dir="misc",stickerCount=229,price=200},
	[6] = {name="Goverment",icon="textures/stickers/gov.dds",dir="gov",stickerCount=17,price=2000000},
}

function getStickerPrice(dir)
	local price = 0
	for k,v in ipairs(stickers) do
		if v.dir == dir then
			price = v.price
		end
	end
	return price 
end

function findPerformanceByData(data,level)
	local handling = false
	for k,v in ipairs(tuning_options[1]) do
		for i,row in ipairs(tuning_options[1][k]) do
			if row.data == data then
				handling = row[level].handling
				break
			end
		end
	end
	return handling
end

timeBySound = {
	["sounds/upgrade.ogg"] = 1700,
	["sounds/paint.ogg"] = 3000,
}


function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function getPositionFromElementOffset(element, offsetX, offsetY, offsetZ)
	local elementMatrix = getElementMatrix(element)
    local elementX = offsetX * elementMatrix[1][1] + offsetY * elementMatrix[2][1] + offsetZ * elementMatrix[3][1] + elementMatrix[4][1]
    local elementY = offsetX * elementMatrix[1][2] + offsetY * elementMatrix[2][2] + offsetZ * elementMatrix[3][2] + elementMatrix[4][2]
    local elementZ = offsetX * elementMatrix[1][3] + offsetY * elementMatrix[2][3] + offsetZ * elementMatrix[3][3] + elementMatrix[4][3]
	
    return elementX, elementY, elementZ
end


function hsvToRgb(h, s, v, a)
  local r, g, b

  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255, a * 255
end

function rgbToHsv(r, g, b, a)
  r, g, b, a = r / 255, g / 255, b / 255, a / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then s = 0 else s = d / max end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v, a
end