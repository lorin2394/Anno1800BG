
objectGuids = {
    old_world_islands = '082e6b',
    new_world_islands = 'edc2d6',
    tradeShips = {
        level1 = 'fe420c',
        level2 = '96cb2f',
        level3 = 'f4513f',
    },
    explorationShips = {
        level1 = '920d4c',
        level2 = 'd2e2b0',
        level3 = '9b362c',
    },
    tradeTokens = 'e77b34',
    explorationTokens = '0ff433',
    bowl = '',
    treasureTile = '',
}

oldIslandState = 1
oldIslandCounter = 0
newIslandState = 1
newIslandCounter = 0
cloneAndLockedShips = false
isSpawnedBowl = false
isSpawnedTreasureTile = false

locations = {
    oldWorldIslandLocation = {
        position = {
            self.getPosition()[1] + 10.5,
            self.getPosition()[2] + 1,
            self.getPosition()[3] - 3
        },
        rotation = {0.00, 180.00, 0.00},
        scale = {2.93, 1.00, 2.93},
    },
    oldWorldXOffset = 6,
    newWorldIslandLocation = {
        position = {    
            self.getPosition()[1] + 12,
            self.getPosition()[2] + 1,
            self.getPosition()[3] + 3
        },
        rotation = {0.00, 180.00, 0.00},
        scale = {1.02, 1.00, 1.02},
    },
    newWorldXOffset = 9,
}

function onLoad(script_state)
    if script_state ~= '' then
        local state = JSON.decode(script_state)
        log(state)
        guid = self.getGUID()
        oldIslandState = state[guid].oldIslandState
        oldIslandCounter = state[guid].oldIslandCounter
        cloneAndLockedShips = state[guid].cloneAndLockedShips
        isSpawnedBowl = state[guid].isSpawnedBowl
        objectGuids.bowl = state[guid].bowlGuid
        isSpawnedTreasureTile = state[guid].isSpawnedTreasureTile
        objectGuids.treasureTile = state[guid].treasureTileGuid
    end

    self.interactable = true
    self.createButton({
        click_function='addOldWorldIsland',
        function_owner=self,
        label='+ Old World Island',
        position={1,1,1.10},
        rotation={0,0,0},
        scale={1,1,1},
        width=150,
        height=20,
        font_size=30,
        color={0,0,0,1},
        font_color={1,1,1,1}
    })

    self.createButton({
        click_function='addNewWorldIsland',
        function_owner=self,
        label='+ New World Island',
        position={1,1,-1.05},
        rotation={0,0,0},
        scale={1,1,1},
        width=150,
        height=20,
        font_size=30,
        color={0,0,0,1},
        font_color={1,1,1,1}
    })

    self.createButton({
        click_function='festivalAction',
        function_owner=self,
        label='Festival',
        position={-1,1,1.05},
        rotation={0,0,0},
        scale={1,1,1},
        width=150,
        height=20,
        font_size=30,
        color={0,0,0,1},
        font_color={1,1,1,1}
    })
    
    self.setSnapPoints({
        {position = {0, 0, 0}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0.4, 0, 0.4}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {-0.4, 0, -0.4}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {-0.4, 0, 0.4}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0.4, 0, -0.4}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0, 0, 0.4}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0, 0, -0.4}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0.4, 0, 0}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {-0.4, 0, 0}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0, 0, 0.8}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0.8, 0, 0}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {-0.8, 0, 0}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0.8, 0, 0.8}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {-0.8, 0, 0.8}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {-0.4, 0, 0.8}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0.4, 0, 0.8}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {-0.8, 0, 0.4}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {-0.8, 0, -0.4}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0.8, 0, -0.4}, rotation = {0, 0, 0}, rotation_snap = true},
        {position = {0.8, 0, 0.4}, rotation = {0, 0, 0}, rotation_snap = true},
    })

    if not cloneAndLockedShips then
        cloneTradeAndExplorationShips()
    end

    if not isSpawnedBowl then
        bowl = spawnObject({
            type = "Bowl",
            position = {
                self.getPosition()[1] - 11,
                self.getPosition()[2] + 1,
                self.getPosition()[3] - 6.5
            },
            rotation = {0, 0, 0},
        })

        Wait.time(function() bowl.setLock(true) end, 3)
        objectGuids.bowl = bowl.getGUID()
        isSpawnedBowl = true
    end

    if not isSpawnedTreasureTile then
        spawnTreasureTile()
        isSpawnedTreasureTile = true
    end
    
end

function spawnTreasureTile()
    local params = {
        type = 'Custom_Tile',
        position = {
            self.getPosition()[1] - 11,
            self.getPosition()[2] + 1,
            self.getPosition()[3] - 0.5    
        },  -- replace with the desired coordinates
        rotation = {0, 180, 0},  -- replace with the desired rotation if needed
        scale = {3, 1, 3},  -- replace with the desired scale if needed
    }
    treasureTile = spawnObject(params)
    treasureTile.setCustomObject({
        image = 'http://cloud-3.steamusercontent.com/ugc/2283954541477222804/AB854B902BDCE04B8B9952EA0B63F2EC520D6C0D/',
        type = 0,
        image_bottom = 'http://cloud-3.steamusercontent.com/ugc/2283954541477222804/AB854B902BDCE04B8B9952EA0B63F2EC520D6C0D/',
        thickness = 0.1,
        stackable = false,
    })
    objectGuids.treasureTile = treasureTile.getGUID()
    Wait.time(function() treasureTile.setLock(true) end, 3)
    isSpawnedTreasureTile = true
end

function cloneTradeAndExplorationShips()
    -- first trade ship
    cloneAndLockShip(objectGuids.tradeShips.level1, {-5.5, 1, -5.5})

    -- second trade ship
    cloneAndLockShip(objectGuids.tradeShips.level1, {-3.5, 1, -4.5})

    -- third Exploration ship
    cloneAndLockShip(objectGuids.explorationShips.level1, {-0.5, 1, -4.5})

    cloneAndLockedShips = true
end

function cloneAndLockShip(shipGuid, positionOffset)
    local object = getObjectFromGUID(shipGuid)
    local takenObject = object.takeObject({
        position = {
            self.getPosition()[1],
            self.getPosition()[2],
            self.getPosition()[3]
        },
        rotation = {0, 180, 0},
        smooth = true,
    })
    local clonedObject = takenObject.clone({
        position     = {
            self.getPosition()[1] + positionOffset[1],
            self.getPosition()[2] + positionOffset[2],
            self.getPosition()[3] + positionOffset[3]
        },
        snap_to_grid = true,
    })
    clonedObject.flip()
    Wait.time(function() clonedObject.setLock(true) end, 3)
    object.putObject(takenObject)
end

function onSave()
    local state = {}
    state[self.getGUID()] = {
        oldIslandState = oldIslandState,
        oldIslandCounter = oldIslandCounter,
        cloneAndLockedShips = cloneAndLockedShips,
        isSpawnedBowl = isSpawnedBowl,
        bowlGuid = objectGuids.bowl,
        isSpawnedTreasureTile = isSpawnedTreasureTile,
        treasureTileGuid = objectGuids.treasureTile,
    }

    return JSON.encode(state)
end

function addOldWorldIsland(obj, player_clicker_color, alt_click)
    oldIslandCounter = oldIslandCounter + 1
    if oldIslandCounter + newIslandCounter > 4 then
        broadcastToAll('Player has the Max Number of Islands', {1,0,0})
        oldIslandCounter = oldIslandCounter - 1
        return
    end
    if oldIslandCounter > 4 then
        broadcastToAll('Player has the Max Number of Old World Island', {1,0,0})
        return
    end
    local position = {
        locations.oldWorldIslandLocation.position[1],
        locations.oldWorldIslandLocation.position[2],
        locations.oldWorldIslandLocation.position[3],
    }

    for iteration = 1, oldIslandState - 1 do
        position[1] = position[1] + locations.oldWorldXOffset
    end
    object = getObjectFromGUID(objectGuids.old_world_islands)
    takenObject = object.takeObject({
        position = position,
        rotation = locations.oldWorldIslandLocation.rotation,
        smooth = true,
    })

    takenObject.setName("")
    Wait.time(function() takenObject.setLock(true) end, 3)
    local snapPoints = {
        {position = {0, 0, 0}, rotation = {0, 0, 0}},
    }
    takenObject.setSnapPoints(snapPoints)
    oldIslandState = oldIslandState + 1
end

function addNewWorldIsland(obj, player_clicker_color, alt_click)
    newIslandCounter = newIslandCounter + 1
    if oldIslandCounter + newIslandCounter > 4 then
        broadcastToAll('Player has the Max Number of Islands', {1,0,0})
        newIslandCounter = newIslandCounter - 1
        return
    end
    if newIslandCounter > 4 then
        broadcastToAll('Player has the Max Number of New World Island', {1,0,0})
        return
    end
    local position = {
        locations.newWorldIslandLocation.position[1],
        locations.newWorldIslandLocation.position[2],
        locations.newWorldIslandLocation.position[3],
    }

    for iteration = 1, newIslandState - 1 do
        position[1] = position[1] + locations.newWorldXOffset
    end
    object = getObjectFromGUID(objectGuids.new_world_islands)
    takenObject = object.takeObject({
        position = position,
        rotation = locations.newWorldIslandLocation.rotation,
        smooth = true,
    })

    takenObject.setName("")
    Wait.time(function() takenObject.setLock(true) end, 3)
    newIslandState = newIslandState + 1
end

function festivalAction(obj, player_clicker_color, alt_click)
    festival_guids = {
        farmers = {},
        workers = {},
        artisans = {},
        engineers = {},
        investors = {},
        tradeTokens = {},
        explorationTokens = {},
        tradeShip = {
            level1 = {},
            level2 = {},
            level3 = {},
        },
        explorationShip = {
            level1 = {},
            level2 = {},
            level3 = {},
        },
    }
    local bowl = getObjectFromGUID(objectGuids.bowl)
    local bowlPosition = bowl.getPosition()
    local objectsInBowl = Physics.cast({
        origin = bowlPosition,
        direction = {0, 1, 0},
        type = 3,
        size = {3.5, 3.5, 3.5}, -- Adjust this to the size of your bowl
        max_distance = 0,
        debug = true -- Set this to true to draw the box
    })
    local tilePosition = self.getPosition()
    local objectsOnHomeIsland = Physics.cast({
        origin = tilePosition,
        direction = {0, 1, 0},
        type = 3,
        size = {15, 3, 15}, -- Adjust this to the size of your tile
        max_distance = 0,
        debug = true -- Set this to true to draw the box
    })
    

    for _, object in ipairs(objectsOnHomeIsland) do
        fetchguidsFromCast(object)
    end
    for _, object in ipairs(objectsInBowl) do
        fetchguidsFromCast(object)
    end

    position = {
        locations.oldWorldIslandLocation.position[1],
        locations.oldWorldIslandLocation.position[2],
        locations.oldWorldIslandLocation.position[3],
    }
    if oldIslandCounter > 0 then
        position[1] = position[1] + ((locations.oldWorldXOffset / 2) * (oldIslandCounter - 1))
        local objectsOnOldWorldIslands = Physics.cast({
            origin = position,
            direction = {0, 1, 0},
            type = 3,
            size = {6 * oldIslandCounter, 1, 9}, 
            max_distance = 0,
            debug = true
        })
        
        for _, object in ipairs(objectsOnOldWorldIslands) do
            fetchguidsFromCast(object)
        end
    end

    festivalPopInitialLocation = {
        farmers = {
            position = {self.getPosition()[1] - 6.75, self.getPosition()[2], self.getPosition()[3] + 6.5},
            rotation = {0.00, 180.00, 0.00},
            positionXOffset = 0.5,
            positionZOffset = 0.5,
        },
        workers = {
            position = {self.getPosition()[1] - 3.75, self.getPosition()[2], self.getPosition()[3] + 6.5},
            rotation = {0.00, 180.00, 0.00},
            positionXOffset = 0.5,
            positionZOffset = 0.5,
        },
        artisans = {
            position = {self.getPosition()[1] - 0.75, self.getPosition()[2], self.getPosition()[3] + 6.5},
            rotation = {0.00, 180.00, 0.00},
            positionXOffset = 0.5,
            positionZOffset = 0.5,
        },
        engineers = {
            position = {self.getPosition()[1] + 2, self.getPosition()[2], self.getPosition()[3] + 6.5},
            rotation = {0.00, 180.00, 0.00},
            positionXOffset = 0.5,
            positionZOffset = 0.5,
        },
        investors = {
            position = {self.getPosition()[1] + 5, self.getPosition()[2], self.getPosition()[3] + 6.5},
            rotation = {0.00, 180.00, 0.00},
            positionXOffset = 0.5,
            positionZOffset = 0.5,
        },
        tradeTokens = {
            position = {self.getPosition()[1] - 6.5, self.getPosition()[2] + 1, self.getPosition()[3] - 5.35},
            rotation = {0.00, 180.00, 0.00},
            positionXOffset = 0.5,
            positionZOffset = 0.5,
        },
        explorationTokens = {
            position = {self.getPosition()[1] - 0.75, self.getPosition()[2] + 1, self.getPosition()[3] - 5.35},
            rotation = {0.00, 180.00, 0.00},
            positionXOffset = 0.5,
            positionZOffset = 0.5,
        },
    }


    for category, guids in pairs(festival_guids) do
        local function isInTable(value, tbl)
            for _, v in pairs(tbl) do
                if v == value then
                    return true
                end
            end
            return false
        end
        if not isInTable(category, {
            'farmers', 'workers', 'artisans', 'engineers',
            'investors', 'tradeTokens', 'explorationTokens'
        }) then
            break
        end

        if category == 'tradeTokens' then
            for _, guid in ipairs(guids) do
                local bag = getObjectFromGUID(objectGuids.tradeTokens)
                local object = getObjectFromGUID(guid)
                bag.putObject(object)
            end
            local resetTradeTokenCount = 0
            for level, shipGUIDs in pairs(festival_guids.tradeShip) do
                if level == 'level1' then
                    resetTradeTokenCount = 1
                    for _, shipGUID in ipairs(shipGUIDs) do
                        dealTradeToken(shipGUID, objectGuids.tradeTokens, resetTradeTokenCount)
                    end
                end
                if level == 'level2' then
                    resetTradeTokenCount = 2
                    for _, shipGUID in ipairs(shipGUIDs) do
                        dealTradeToken(shipGUID, objectGuids.tradeTokens, resetTradeTokenCount)
                    end
                end
                if level == 'level3' then
                    resetTradeTokenCount = 3
                    for _, shipGUID in ipairs(shipGUIDs) do
                        dealTradeToken(shipGUID, objectGuids.tradeTokens, resetTradeTokenCount)
                    end
                end
                
            end
        end

        if category == 'explorationTokens' then
            for _, guid in ipairs(guids) do
                local bag = getObjectFromGUID(objectGuids.explorationTokens)
                local object = getObjectFromGUID(guid)
                bag.putObject(object)
            end
            local resetExplorationTokenCount = 0
            for level, shipGUIDs in pairs(festival_guids.explorationShip) do
                if level == 'level1' then
                    resetExplorationTokenCount = 1
                    for _, shipGUID in ipairs(shipGUIDs) do
                        dealTradeToken(shipGUID, objectGuids.explorationTokens, resetExplorationTokenCount)
                    end
                end
                if level == 'level2' then
                    resetExplorationTokenCount = 2
                    for _, shipGUID in ipairs(shipGUIDs) do
                        dealTradeToken(shipGUID, objectGuids.explorationTokens, resetExplorationTokenCount)
                    end
                end
                if level == 'level3' then
                    resetExplorationTokenCount = 3
                    for _, shipGUID in ipairs(shipGUIDs) do
                        dealTradeToken(shipGUID, objectGuids.explorationTokens, resetExplorationTokenCount)
                    end
                end
                
            end
        end

        if isInTable(category, {
            'farmers', 'workers', 'artisans', 'engineers',
            'investors',
        }) then
            local guidCounter = 0
            local positionXOffset = 0
            local positionZOffset = 0
            local position = {
                festivalPopInitialLocation[category].position[1],
                festivalPopInitialLocation[category].position[2] + 1,
                festivalPopInitialLocation[category].position[3],
            }
            for _, guid in ipairs(guids) do
                local object = getObjectFromGUID(guid)
                object.setRotationSmooth(festivalPopInitialLocation[category].rotation)
                object.setPositionSmooth(position)
    
                guidCounter = guidCounter + 1
                if guidCounter % 4 == 0 then
                    position[1] = festivalPopInitialLocation[category].position[1]
                    position[3] = festivalPopInitialLocation[category].position[3] - (
                        festivalPopInitialLocation[category].positionZOffset * (guidCounter / 4)
                    )
                else
                    position[1] = position[1] + festivalPopInitialLocation[category].positionXOffset
                end
            end
        end
    end
end

function fetchguidsFromCast(object)
    if object.hit_object.getName() == 'Investor' then
        festival_guids.investors[#festival_guids.investors + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Farmer' then
        festival_guids.farmers[#festival_guids.farmers + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Worker' then
        festival_guids.workers[#festival_guids.workers + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Artisan' then
        festival_guids.artisans[#festival_guids.artisans + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Engineer' then
        festival_guids.engineers[#festival_guids.engineers + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Trade Token' then
        festival_guids.tradeTokens[#festival_guids.tradeTokens + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Exploration Token' then
        festival_guids.explorationTokens[#festival_guids.explorationTokens + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Trade Ship 1' then
        festival_guids.tradeShip.level1[#festival_guids.tradeShip.level1 + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Trade Ship 2' then
        festival_guids.tradeShip.level2[#festival_guids.tradeShip.level2 + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Trade Ship 3' then
        festival_guids.tradeShip.level3[#festival_guids.tradeShip.level3 + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Exploration Ship 1' then
        festival_guids.explorationShip.level1[#festival_guids.explorationShip.level1 + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Exploration Ship 2' then
        festival_guids.explorationShip.level2[#festival_guids.explorationShip.level2 + 1] = object.hit_object.guid
    end
    if object.hit_object.getName() == 'Exploration Ship 3' then
        festival_guids.explorationShip.level3[#festival_guids.explorationShip.level3 + 1] = object.hit_object.guid
    end
end

function dealTradeToken(shipGUID, bagGUID, resetTradeTokenCount)
    local ship = getObjectFromGUID(shipGUID)
    local bag = getObjectFromGUID(bagGUID)
    for iteration = 1, resetTradeTokenCount do
        local token = bag.takeObject({
            position = {
                ship.getPosition()[1] + (0.5 * iteration - 1),
                ship.getPosition()[2] + (1 * iteration - 1),
                ship.getPosition()[3],
            },
            rotation = {0, 180, 0},
            smooth = true,
        })
    end
end