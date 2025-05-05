local liftZ =
{
    13.99945 + 1,
    13.99945 + 0.5 + 6.25,
    25,
    13.99945 + 2 + 14.07,
}
for k,v in ipairs(getElementsByType("player")) do
setElementData(v,"inlift",false)
end
local liftStaticObj = {}
for k,v in ipairs(liftZ) do
	if k ~= 1 then
		liftStaticObj[k] = {
			createObject( 7636, 1444.3833476562, -1796.52578125, v+0.6, 0, 0, 270 ),
			createObject( 7637,  1444.3833476562, -1796.52578125, v+0.6, 0, 0, 270 )
		}
	else
		liftStaticObj[k] = {
			createObject( 7636, 1444.3833476562, -1796.52578125, v+0.6, 0, 0, 270 ),
			createObject( 7637, 1444.3833476562, -1796.52578125, v+0.6, 0, 0, 270 )
		}
	end
end

local curr = 1

for k,v in ipairs(liftZ) do
	sp = createColSphere(1446.1813964844, -1794.1046142578, v, 0.4)
    sp2 = createColSphere(1442.2279052734, -1795.0145263672, v,0.4)
    setElementData(sp2,"id2",k)
	setElementData(sp, "id", k)
end

function startfunc()
	obj = createObject( 3269,  1444.3188232422, -1792.5880859375, liftZ[curr]-1.5, 0, 0,0 )
	--left = createObject( 7638, 1444.8817138672, -1792.0849609375, liftZ[curr], 0, 0, 270 )
	--right = createObject( 7637, 1444.8817138672, -1792.0849609375, liftZ[curr], 0, 0, 270 )
	setElementDoubleSided(obj, true)
end
addEventHandler("onResourceStart",resourceRoot,startfunc)

local isMove = false

addEvent("moveLift", true)
addEventHandler("moveLift", getRootElement(), function(s,p)
	if liftZ[s] and not isMove then
		isMove = true
		
		local static = liftStaticObj[curr]
		sobj1 = static[1]
		sobj2 = static[2]
		moveObject(sobj1, 3000, 1444.3833476562, -1796.52578125, liftZ[curr]+0.6)
		moveObject(sobj2, 3000, 1444.3833476562, -1796.52578125, liftZ[curr]+0.6)
		
		triggerClientEvent(root, "playS3D", root, "open.mp3", 1786.678100, -1303.459472, liftZ[curr])
		
	--	moveObject(left, 3000, 1786.678100, -1303.459472, liftZ[curr])
	--	moveObject(right, 3000, 1786.678100, -1303.459472, liftZ[curr])
		setTimer(function(s)
			triggerClientEvent(root, "attachElevatorSoundForElevator", root, obj)
			
			if s > curr then
				timer = 2000*s
			else
				timer = 10000
			end
			
			curr = s
			moveObject(obj, timer, 1444.3188232422, -1792.5880859375, liftZ[s]-1.5)
		--	moveObject(left, timer, 1444.7836914062, -1792.4775390625, liftZ[s])
		--	moveObject(right, timer, 1444.7836914062, -1792.4775390625, liftZ[s])
			
			setTimer(function(s)
				isMove = false
				
				triggerClientEvent(root, "playS3D", root, "open.mp3",1444.7836914062, -1792.4775390625, liftZ[s])
				
				triggerClientEvent(root, "detachElevatorSoundForElevator", root, obj)
				
				local static = liftStaticObj[s]
				sobj1 = static[1]
				sobj2 = static[2]
				
				moveObject(sobj1,3000, 1443.836328125, -1796.52578125, liftZ[s]+0.6)
				moveObject(sobj2,3000, 1445.036328125, -1796.52578125, liftZ[s]+0.6)
				
			--	moveObject(left, 3000, 1444.7836914062, -1792.4775390625, liftZ[s])
			--	moveObject(right, 3000, 1444.7836914062, -1792.4775390625, liftZ[s])
				triggerClientEvent(root, "playS3D", root, "dingdong.mp3", 1786.678100, -1303.459472, liftZ[s])
                setElementData(p,"inlift",false)
			end, timer, 1, s)
		end,3000,1, s)
	elseif isMove then
	--	outputChatBox("#3d7abc[StrongMTA] #ffffffA lift jelenleg mozgásban van! Próbáld újra később!",p,255,255,255,true)
	end
end)