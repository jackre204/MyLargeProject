

addEventHandler ( "onClientResourceStart" , resourceRoot , 
    function () 
		engineReplaceCOL ( engineLoadCOL( "delialap/delialap.col" ) ,5489) 
		engineReplaceModel ( engineLoadDFF ( "delialap/delialap.dff" ) , 5489 ) 

		engineReplaceCOL ( engineLoadCOL( "eszakialap/eszakialap.col" ) ,5853) 
		engineReplaceModel ( engineLoadDFF ( "eszakialap/eszakialap.dff" ) , 5853 ) 

		engineImportTXD ( engineLoadTXD ( "kut/pump.txd" ) , 1686) 
		engineReplaceCOL ( engineLoadCOL( "kut/pump.col" ) ,1686)
		engineReplaceModel ( engineLoadDFF ( "kut/pump.dff" ) , 1686 )
		
		engineImportTXD ( engineLoadTXD ( "thetxd.txd" ) , 1327) 
		engineReplaceCOL ( engineLoadCOL( "pisztoly/pistol.col" ) ,1327) 
		engineReplaceModel ( engineLoadDFF ( "pisztoly/pistol.dff" ) , 1327 ) 
		
		engineImportTXD ( engineLoadTXD ( "thetxd.txd" ) , 5409) 
		engineReplaceCOL ( engineLoadCOL( "benzinkutmodell/benzinkut.col" ) ,5409)
		engineReplaceModel ( engineLoadDFF ( "benzinkutmodell/benzinkut.dff" ) , 5409 ) 

		engineImportTXD ( engineLoadTXD ( "ajto/d.txd" ) , 3893) 
		engineReplaceCOL ( engineLoadCOL( "ajto/d.col" ) ,3893)
		engineReplaceModel ( engineLoadDFF ( "ajto/d.dff" ) , 3893 )
		


end) 