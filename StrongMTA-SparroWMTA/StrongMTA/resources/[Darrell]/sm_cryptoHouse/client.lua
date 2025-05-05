function replaceModel()

   txd = engineLoadTXD( "1.txd", 6007 )
  engineImportTXD(txd, 6007 )
  
  dff = engineLoadDFF( "1.dff", 6007 )
  engineReplaceModel(dff, 6007, true )
  
  col= engineLoadCOL ( "1.col" )
  engineReplaceCOL ( col, 6007 )
  
  
  
 setOcclusionsEnabled( false )
 
  
  
 
  
  
 
	
removeWorldModel(5682,10000,0,0,0)
removeWorldModel(5654,10000,0,0,0)
removeWorldModel(7311,10000,0,0,0)
removeWorldModel(7312,10000,0,0,0)
removeWorldModel(3769,10000,0,0,0)
removeWorldModel(5738, 10000, 0, 0, 0)
removeWorldModel(3625,10000,0,0,0)
removeWorldModel(3744,10000,0,0,0)
removeWorldModel(3574,10000,0,0,0)

removeWorldModel(1376,10000,0,0,0)
removeWorldModel(1377,10000,0,0,0)
removeWorldModel(3244,10000,0,0,0)
removeWorldModel(5364,10000,0,0,0)
removeWorldModel(5071,10000,0,0,0)
removeWorldModel(5070,10000,0,0,0)
removeWorldModel(5072,10000,0,0,0)
removeWorldModel(5075,10000,0,0,0)
removeWorldModel(5358,10000,0,0,0)
removeWorldModel(5076,10000,0,0,0)
removeWorldModel(5073,10000,0,0,0)
removeWorldModel(5074,10000,0,0,0)
removeWorldModel(1412,10000,0,0,0)
removeWorldModel(1413,10000,0,0,0)
removeWorldModel(5363,10000,0,0,0)

removeWorldModel(9352,10000,0,0,0)
removeWorldModel(10012,10000,0,0,0)
removeWorldModel(10040,10000,0,0,0)
removeWorldModel(10267,10000,0,0,0)
removeWorldModel(13452,10000,0,0,0)
removeWorldModel(13451,10000,0,0,0)
removeWorldModel(13444,10000,0,0,0)
removeWorldModel(13443,10000,0,0,0)
removeWorldModel(13442,10000,0,0,0)
removeWorldModel(13441,10000,0,0,0)
removeWorldModel(13440,10000,0,0,0)
removeWorldModel(13374,10000,0,0,0)
removeWorldModel(13375,10000,0,0,0)
removeWorldModel(13137,10000,0,0,0)















  

 
  
  
 
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)
