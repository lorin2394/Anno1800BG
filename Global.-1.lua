-- GameSetup.lua
GameSetup = {}
GameSetup.__index = GameSetup
firstGame = false
setupCompleted = false
numberOfPlayers = 4
turnOrder = {}
guids = {
    old_world_islands = '082e6b',
    new_world_islands = 'edc2d6',
    population_stacks = {
        farmers_workers = 'fca4fd',
        artisans_engineers_investors = '4da569',
        new_world = '82335f',
    },
    expedition_cards = '7a4aed',
    objective_cards = '8ba6d8',
    population_cubes = {
        farmers = '67a942',
        workers = 'ed7cea',
        artisans = 'a485ad',
        engineers = '414348',
        investors = '95e213',
    },
    tradeTokens = 'e77b34',
    explorationToken = '0ff433',
    goldToken1 = '38e1fd',
    goldToken5 = '6dba03',
    startingPlayerToken = '83541c',
}

globalState = {}

homeIslandScript = [[
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
    isInverse = false
    
    
    locations = {
        oldWorldXOffset = 6,
        newWorldIslandLocation = {
            position = {    
                self.getPosition()[1] + 12,
                self.getPosition()[2] + 1,
                self.getPosition()[3] + 3,
            },
            rotation = {0.00, 180.00, 0.00},
            scale = {1.02, 1.00, 1.02},
        },
        newWorldXOffset = 9,
    }
    
    function onLoad(script_state)
        if script_state ~= '' then
            local state = JSON.decode(script_state)
            guid = self.getGUID()
            oldIslandState = state[guid].oldIslandState
            oldIslandCounter = state[guid].oldIslandCounter
            cloneAndLockedShips = state[guid].cloneAndLockedShips
            isSpawnedBowl = state[guid].isSpawnedBowl
            objectGuids.bowl = state[guid].bowlGuid
            isSpawnedTreasureTile = state[guid].isSpawnedTreasureTile
            objectGuids.treasureTile = state[guid].treasureTileGuid
            isInverse = state[guid].isInverse
        end
    
        isInverse = Global.call('getIsInverse', {
            rotation = self.getRotation()
        })
    
        self.interactable = false
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
            font_color={1,1,1,1},
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
            local position = self.getPosition():add(Vector(-11, 1, -6.5))
            if isInverse then
                local x, y, z = position:get()
                position.x = -x
                position.z = 24.5
            end
            bowl = spawnObject({
                type = "Bowl",
                position = position,
                rotation = self.getRotation(),
                callback_function = function(obj) Wait.time(function() obj.setLock(true) end, 3) end,
            })
    
            objectGuids.bowl = bowl.getGUID()
            isSpawnedBowl = true
        end
    
        if not isSpawnedTreasureTile then
            spawnTreasureTile()
            isSpawnedTreasureTile = true
        end
    end
    
    function spawnTreasureTile()
        local position = self.getPosition():add(Vector(-11, 1, -0.5))
        if isInverse then
            local x, y, z = position:get()
            position.x = -x
            position.z = 18.5
        end
        local params = {
            type = 'Custom_Tile',
            position = position,
            rotation = self.getRotation(),
            scale = {3, 1, 3},
            callback_function = function(obj) Wait.time(function() obj.setLock(true) end, 3) end,
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
        isSpawnedTreasureTile = true
    end
    
    
    function cloneTradeAndExplorationShips()
        -- first trade ship
        cloneAndLockShip(objectGuids.tradeShips.level1, Vector(-5.5, 1, -5.5))
    
        -- second trade ship
        cloneAndLockShip(objectGuids.tradeShips.level1, Vector(-3.5, 1, -5.5))
    
        -- third Exploration ship
        cloneAndLockShip(objectGuids.explorationShips.level1, Vector(-0.5, 1, -5.5))
    
        cloneAndLockedShips = true
    end
    
    function cloneAndLockShip(shipGuid, positionOffset)
        local object = getObjectFromGUID(shipGuid)
        local takenObject = object.takeObject({
            position = self.getPosition():add(positionOffset),
            rotation = self.getRotation(),
            smooth = false,
        })
        local position = self.getPosition():add(positionOffset)
        if isInverse then
            local x, y, z = position:get()
            position.x = -x
            position.z = 23.5
        end
    
        local clonedObject = takenObject.clone({
            position = position,
            rotation = self.getRotation(),
            snap_to_grid = true,
        })
        if not isInverse then
            clonedObject.flip()
        end
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
            isInverse = isInverse,
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
        local position = {}
        local positionOffset = {}
        if isInverse then
            position = self.getPosition():add(Vector(-10.5, 1, 3))
            positionOffset = Vector(6, 0, 0):inverse()
        else
            position = self.getPosition():add(Vector(10.5, 1, -3))
            positionOffset = Vector(6, 0, 0)
        end
    
        for iteration = 1, oldIslandState - 1 do
            position:add(positionOffset)
        end
        object = getObjectFromGUID(objectGuids.old_world_islands)
        takenObject = object.takeObject({
            position = position,
            rotation = self.getRotation(),
            smooth = false,
            callback_function = function(obj) Wait.time(function() obj.setLock(true) end, 1) end,
        })
    
        takenObject.setName("")
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
        local position = {}
        local positionOffset = {}
        if isInverse then
            position = self.getPosition():add(Vector(-12, 1, -3))
            positionOffset = Vector(9, 0, 0):inverse()
        else
            position = self.getPosition():add(Vector(12, 1, 3))
            positionOffset = Vector(9, 0, 0)
        end
    
        for iteration = 1, newIslandState - 1 do
            position:add(positionOffset)
        end
        object = getObjectFromGUID(objectGuids.new_world_islands)
        takenObject = object.takeObject({
            position = position,
            rotation = self.getRotation(),
            smooth = false,
            callback_function = function(obj) Wait.time(function() obj.setLock(true) end, 1) end,
        })
    
        takenObject.setName("")
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
            size = {3.5, 3.5, 3.5}, 
            max_distance = 0,
            debug = true 
        })
        local tilePosition = self.getPosition()
        local objectsOnHomeIsland = Physics.cast({
            origin = tilePosition,
            direction = {0, 1, 0},
            type = 3,
            size = {15, 3, 15}, 
            max_distance = 0,
            debug = true
        })
        
    
        for _, object in ipairs(objectsOnHomeIsland) do
            fetchguidsFromCast(object)
        end
        for _, object in ipairs(objectsInBowl) do
            fetchguidsFromCast(object)
        end
    
        local position = {}
        if isInverse then
            position = self.getPosition():add(Vector(-10.5, 0, 3))
            positionOffset = Vector(6, 0, 0):inverse()
        else
            position = self.getPosition():add(Vector(10.5, 0, -3))
            positionOffset = Vector(6, 0, 0)
        end
    
        if oldIslandCounter > 0 then
            if isInverse then
                position[1] = position[1] - ((locations.oldWorldXOffset / 2) * (oldIslandCounter - 1))
            else
                position[1] = position[1] + ((locations.oldWorldXOffset / 2) * (oldIslandCounter - 1))
            end
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
    
        positionOffsetFarmer = Vector(-6.75, 0, 6.5)
        positionOffsetWorker = Vector(-3.75, 0, 6.5)
        positionOffsetArtisan = Vector(-0.75, 0, 6.5)
        positionOffsetEngineer = Vector(2, 0, 6.5)
        positionOffsetInvestor = Vector(5, 0, 6.5)
        positionOffsetTradeToken = Vector(-6.5, 1, -5.35)
        positionOffsetExplorationToken = Vector(-0.75, 1, -5.35)
    
        if isInverse then
            positionOffsetFarmer:inverse()
            positionOffsetWorker:inverse()
            positionOffsetArtisan:inverse()
            positionOffsetEngineer:inverse()
            positionOffsetInvestor:inverse()
            positionOffsetTradeToken:inverse()
            positionOffsetExplorationToken:inverse()
        end
        festivalPopInitialLocation = {
            farmers = {
                position = self.getPosition():add(positionOffsetFarmer),
                rotation = {0.00, 180.00, 0.00},
                positionXOffset = 0.5,
                positionZOffset = 0.5,
            },
            workers = {
                position = self.getPosition():add(positionOffsetWorker),
                rotation = {0.00, 180.00, 0.00},
                positionXOffset = 0.5,
                positionZOffset = 0.5,
            },
            artisans = {
                position = self.getPosition():add(positionOffsetArtisan),
                rotation = {0.00, 180.00, 0.00},
                positionXOffset = 0.5,
                positionZOffset = 0.5,
            },
            engineers = {
                position = self.getPosition():add(positionOffsetEngineer),
                rotation = {0.00, 180.00, 0.00},
                positionXOffset = 0.5,
                positionZOffset = 0.5,
            },
            investors = {
                position = self.getPosition():add(positionOffsetInvestor),
                rotation = {0.00, 180.00, 0.00},
                positionXOffset = 0.5,
                positionZOffset = 0.5,
            },
            tradeTokens = {
                position = self.getPosition():add(positionOffsetTradeToken),
                rotation = {0.00, 180.00, 0.00},
                positionXOffset = 0.5,
                positionZOffset = 0.5,
            },
            explorationTokens = {
                position = self.getPosition():add(positionOffsetExplorationToken),
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
                smooth = false,
            })
        end
    end
     
]]
locations = {
    Red = {
        isInverse = false,
        playerHandLocations = {
            position = {-26.00, 1.00, -30.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {45, 7.00, 7.50},
        },
        homeIslandLocation = {
            position = {-26.00, 0.10, -18.00},
            rotation = {0.00, 180.00, 0.00},
            scale = {7.50, 1.00, 7.50},
        },
        populationCubesInitialLocation = {
            xOffset = 1,
            zOffset = -1,
            farmers = {
                position = {-32.50, 0.20, -11.50},
                rotation = {0.00, 180.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
            workers = {
                position = {-29.50, 0.20, -11.50},
                rotation = {0.00, 180.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
            artisans = {
                position = {-26.50, 0.20, -11.50},
                rotation = {0.00, 180.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
        },
        tradeTokenLocations = {
            {
                position = {-32.00, 0.20, -24.00},
                rotation = {0.00, 180.00, 0.00},
                scale = {0.40, 1.00, 0.40},
            },
            {
                position = {-29.00, 0.20, -24.00},
                rotation = {0.00, 180.00, 0.00},
                scale = {0.40, 1.00, 0.40},
            },
        },
        explorationTokenLocation = {
            position = {-26.00, 0.40, -24.00},
            rotation = {0.00, 180.00, 0.00},
            scale = {0.40, 1.00, 0.40},
        },
        startingPlayerTokenLocation = {
            position = {-35.00, 0.30, -12.00},
            rotation = {0.00, 180.00, 180.00},
            scale = {0.80, 1.00, 0.80},
        },
    },
    Blue = {
        isInverse = false,
        playerHandLocations = {
            position = {26.00, 1.00, -30.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {45, 7.00, 7.50},
        },
        homeIslandLocation = {
            position = {26.00, 0.10, -18.00},
            rotation = {0.00, 180.00, 0.00},
            scale = {7.50, 1.00, 7.50},
        },
        oldWorldIslandLocation = {
            position = {15.50, 0.11, -21.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {2.93, 1.00, 2.93},
        },
        oldWorldXOffset = -6,
        newWorldIslandLocation = {
            position = {14.00, 0.13, -15.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {1.02, 1.00, 1.02},
        },
        newWorldXOffset = -9,
        populationCubesInitialLocation = {
            xOffset = 1,
            zOffset = -1,
            farmers = {
                position = {19.5, 0.20, -11.50},
                rotation = {0.00, 180.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
            workers = {
                position = {22.50, 0.20, -11.50},
                rotation = {0.00, 180.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
            artisans = {
                position = {25.50, 0.20, -11.50},
                rotation = {0.00, 180.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
        },
        tradeTokenLocations = {
            {
                position = {20.00, 0.20, -24.00},
                rotation = {0.00, 180.00, 0.00},
                scale = {0.40, 1.00, 0.40},
            },
            {
                position = {23.00, 0.20, -24.00},
                rotation = {0.00, 180.00, 0.00},
                scale = {0.40, 1.00, 0.40},
            },
        },
        explorationTokenLocation = {
            position = {26.00, 0.40, -24.00},
            rotation = {0.00, 180.00, 0.00},
            scale = {0.40, 1.00, 0.40},
        },
        startingPlayerTokenLocation = {
            position = {17.00, 0.30, -12.00},
            rotation = {0.00, 180.00, 0.00},
            scale = {0.80, 1.00, 0.80},
        },
    },
    Green = {
        isInverse = true,
        playerHandLocations = {
            position = {-26.00, 1.00, 30.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {45, 7.00, 7.50},
        },
        homeIslandLocation = {
            position = {-26.00, 0.10, 18.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {7.50, 1.00, 7.50},
        },
        oldWorldIslandLocation = {
            position = {-15.50, 0.11, 21.00},
            rotation = {0.00, 180.00, 0.00},
            scale = {2.93, 1.00, 2.93},
        },
        oldWorldXOffset = 6,
        newWorldIslandLocation = {
            position = {-14.00, 0.13, 15.00},
            rotation = {0.00, 180.00, 0.00},
            scale = {1.02, 1.00, 1.02},
        },
        newWorldXOffset = 9,
        populationCubesInitialLocation = {
            xOffset = -1,
            zOffset = 1,
            farmers = {
                position = {32.50, 0.20, 11.50},
                rotation = {0.00, 0.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
            workers = {
                position = {29.50, 0.20, 11.50},
                rotation = {0.00, 0.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
            artisans = {
                position = {26.50, 0.20, 11.50},
                rotation = {0.00, 0.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
        },
        tradeTokenLocations = {
            {
                position = {32.00, 0.20, 24.00},
                rotation = {0.00, 0.00, 0.00},
                scale = {0.40, 1.00, 0.40},
            },
            {
                position = {29.00, 0.20, 24.00},
                rotation = {0.00, 0.00, 0.00},
                scale = {0.40, 1.00, 0.40},
            },
        },
        explorationTokenLocation = {
            position = {26.00, 0.40, 24.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {0.40, 1.00, 0.40},
        },
        startingPlayerTokenLocation = {
            position = {17.00, 0.30, 12.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {0.80, 1.00, 0.80},
        },
    },
    Yellow = {
        isInverse = true,
        playerHandLocations = {
            position = {26.00, 1.00, 30.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {45, 7.00, 7.50},
        },
        homeIslandLocation = {
            position = {26.00, 0.10, 18.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {7.50, 1.00, 7.50},
        },
        oldWorldIslandLocation = {
            position = {15.50, 0.11, 21.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {2.93, 1.00, 2.93},
        },
        oldWorldXOffset = -6,
        newWorldIslandLocation = {
            position = {14.00, 0.13, 15.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {1.02, 1.00, 1.02},
        },
        newWorldXOffset = -9,
        populationCubesInitialLocation = {
            xOffset = -1,
            zOffset = 1,
            farmers = {
                position = {-19.5, 0.20, 11.50},
                rotation = {0.00, 0.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
            workers = {
                position = {-22.50, 0.20, 11.50},
                rotation = {0.00, 0.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
            artisans = {
                position = {-25.50, 0.20, 11.50},
                rotation = {0.00, 0.00, 0.00},
                scale = {0.22, 1.00, 0.22},
            },
        },
        tradeTokenLocations = {
            {
                position = {-20.00, 0.20, 24.00},
                rotation = {0.00, 0.00, 0.00},
                scale = {0.40, 1.00, 0.40},
            },
            {
                position = {-23.00, 0.20, 24.00},
                rotation = {0.00, 0.00, 0.00},
                scale = {0.40, 1.00, 0.40},
            },
        },
        explorationTokenLocation = {
            position = {-26.00, 0.40, 24.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {0.40, 1.00, 0.40},
        },
        startingPlayerTokenLocation = {
            position = {-35.00, 0.30, 12.00},
            rotation = {0.00, 0.00, 180.00},
            scale = {0.80, 1.00, 0.80},
        },
    },
}



function GameSetup.new()
    local self = setmetatable({}, GameSetup)
    -- you can initialize class variables here
    return self
end

function GameSetup:step1()
    -- starting_position = {-15.50, 0.30, 7.00}
    -- x_offset = 3.08
    -- y_offset = -3.17
    -- for _, row in pairs(guids.construction_tokens) do
    --     for _, token in ipairs(row) do
    --         getObjectFromGUID(token).setPositionSmooth(starting_position)
    --         starting_position[1] = starting_position[1] + x_offset
    --     end
    --     starting_position[1] = -15.50
    --     starting_position[3] = starting_position[3] + y_offset
    -- end
    
    -- Place the gameboard in the centre of the table.
    -- Sort all the construction tokens and place them on the gameboard according to their images.
    -- The bluelog side with the costs (pursple bar) must be visible. 
    -- Number of construction tokens:
    -- 35 industries x 2 of each
    -- 4 x shipyard strength 1
    -- 6 x shipyard strength 2
    -- 4 x shipyard strength 3
    -- 6 ships x 6 of each
    -- log("Setup 1 Done")
end

function GameSetup:step2()
    farmer_worker_location = {
        position = {-14.00, 0.54, -6.50},
        rotation = {0.00, 270.00, 180.00},
        scale = {1.80, 1.00, 1.80}
    }
    artisan_engineer_investor_location = {
        position = {-8.00, 0.47, -6.50},
        rotation = {0.00, 270.00, 180.00},
        scale = {1.80, 1.00, 1.80}
    }
    new_world_location = {
        position = {-2.00, 0.43, -6.50},
        rotation = {0.00, 270.00, 180.00},
        scale = {1.80, 1.00, 1.80}
    }
    expedition_cards_location = {
        position = {14.00, 0.42, -6.50},
        rotation = {0.00, 270.00, 180.00},
        scale = {1.80, 1.00, 1.80}
    }
    object = getObjectFromGUID(guids.population_stacks.farmers_workers)
    object.setPositionSmooth(farmer_worker_location.position)
    object.setRotationSmooth(farmer_worker_location.rotation)
    object.setScale(farmer_worker_location.scale)
    object.shuffle()
    
    object = getObjectFromGUID(guids.population_stacks.artisans_engineers_investors)
    object.setPositionSmooth(artisan_engineer_investor_location.position)
    object.setRotationSmooth(artisan_engineer_investor_location.rotation)
    object.setScale(artisan_engineer_investor_location.scale)
    object.shuffle()

    object = getObjectFromGUID(guids.population_stacks.new_world)
    object.setPositionSmooth(new_world_location.position)
    object.setRotationSmooth(new_world_location.rotation)
    object.setScale(new_world_location.scale)
    object.shuffle()

    object = getObjectFromGUID(guids.expedition_cards)
    object.setPositionSmooth(expedition_cards_location.position)
    object.setRotationSmooth(expedition_cards_location.rotation)
    object.setScale(expedition_cards_location.scale)
    object.shuffle()

    -- Shuffle the 3 population card stacks and the expedition cards separately
    -- Place them on their respective spaces on the gameboard facing down.
    log("Setup 2 Done")
end

function GameSetup:step3()
    -- Shuffle the Old and New World island boards separately
    getObjectFromGUID(guids.old_world_islands).shuffle()
    getObjectFromGUID(guids.new_world_islands).shuffle()
    
    -- Place them to the right of the gameboard.
    -- Lay out the navaland gold tokens ready beside them
    -- Place them on their respective spaces on the gameboard facing down.
    log("Setup 3 Done")
end

function GameSetup:step4()
    -- Sort the population cubes and place them in the correct position to the left of the gameboard.
    log("Setup 4 Done")
end

function GameSetup:step5()
    -- Place 5 objective cards and the fireworks token next to the population cubes.
    -- NOTE: Get the first game variable from the game state.
    location = {-22.00, 0.11, -8.00}
    zOffset = 4
    object = getObjectFromGUID(guids.objective_cards)
    if firstGame then
        for _, card in ipairs(object.getObjects()) do
            if findStringInTable(card.tags, "firstGame") then
                object.takeObject({
                    position = location,
                    rotation = {0.00, 90.00, 0.00},
                    smooth = false
                })
                location[3] = location[3] + zOffset
            end
        end
    else
        object.shuffle()
        for iteration = 1, 5 do
            object.takeObject({
                position = location,
                rotation = {0.00, 90.00, 0.00},
                smooth = false
            })
            location[3] = location[3] + zOffset
        end
    end
    -- For the first game, take the objective cards with the 3 diamonds above their names:
    --     Alonso Graves,
    --     University,
    --     Edvard Goode,
    --     Isabel Sarmento,
    --     Zoo
    log("Setup 5 Done")
end

function GameSetup:step6()
    -- Each player is given one home island and places 4 farmers, 3 workers and 2 artisans
    -- on their respective residential districts.
    for player, playerObject in pairs(locations) do
        homeIslandTile = spawnObject({
            type = "Custom_tile",
            position = playerObject.homeIslandLocation.position,
            rotation = playerObject.homeIslandLocation.rotation,
            scale = playerObject.homeIslandLocation.scale,
        })
        homeIslandTile.setCustomObject({
            image = 'http://cloud-3.steamusercontent.com/ugc/2283954541477632671/68F306DB1C47759911A1C497A25FC6023704D15D/',
            image_bottom = 'http://cloud-3.steamusercontent.com/ugc/2283954541477632671/68F306DB1C47759911A1C497A25FC6023704D15D/',
            thickness = 0.1,
            stackable = false,
            type = 0,
        })
        globalState[homeIslandTile.getGUID()] = {
            isInverse = playerObject.isInverse,
        }
        homeIslandTile.setLock(true)
        homeIslandTile.setName("Home Island")
        homeIslandTile.setLuaScript(homeIslandScript)
    end
    deal = {
        farmers = 4,
        workers = 3,
        artisans = 2,
    }
    for _, player in ipairs(getSeatedPlayers()) do
        for _, population in ipairs({"farmers", "workers", "artisans"}) do
            guid = guids.population_cubes[population]
            object = getObjectFromGUID(guid)
            xOffset = locations[player].populationCubesInitialLocation.xOffset
            zOffset = locations[player].populationCubesInitialLocation.zOffset
            position = locations[player].populationCubesInitialLocation[population].position
            initialXPosition = locations[player].populationCubesInitialLocation[population].position[1]
            rotation = locations[player].populationCubesInitialLocation[population].rotation
            for iteration = 1, deal[population] do
                object.takeObject({
                    position = position,
                    rotation = rotation,
                    smooth = true
                })
                position[1] = position[1] + xOffset
                if iteration % 2 == 0 then
                    position[3] = position[3] + zOffset
                    position[1] = initialXPosition
                end
            end
        end

        -- 1 trade token is placed on each of the two merchant ships
        for _, iteration in ipairs(locations[player].tradeTokenLocations) do
            getObjectFromGUID(guids.tradeTokens).takeObject({
                position = iteration.position,
                rotation = iteration.rotation,
                smooth = true
            })
        end

        -- 1 exploration token is placed on the exploration ship
        getObjectFromGUID(guids.explorationToken).takeObject({
            position = locations[player].explorationTokenLocation.position,
            rotation = locations[player].explorationTokenLocation.rotation,
            smooth = true
        })
    end
    log("Setup 6 Done")
end

function GameSetup:step7()
    -- To finish, each player is additionally given 7 farmer/worker
    -- 2 artisans/engineer/investor cards as their hand.
    for _, player in ipairs(getSeatedPlayers()) do
        getObjectFromGUID(guids.population_stacks.farmers_workers).deal(7, player)
        getObjectFromGUID(guids.population_stacks.artisans_engineers_investors).deal(2, player)
    end
    log("Setup 7 Done")
end

function GameSetup:step8()
    -- Whoever was abroad most recently is the starting player and is given the starting player token.
    -- Choose a player from random and give them the starting player token.
    object = getObjectFromGUID(guids.startingPlayerToken)
    local seatedPlayers = getSeatedPlayers()
    local player = seatedPlayers[math.random(#seatedPlayers)]
    object.setPositionSmooth(locations[player].startingPlayerTokenLocation.position)
    object.setRotationSmooth(locations[player].startingPlayerTokenLocation.rotation)
    Turns.enable = true
    -- TODO: How do I Assign the turn to the starting player?
    -- log(Turns.getNextTurnColor())
    log("Setup 8 Done")
end

function GameSetup:step9()
    local seatedPlayers = getSeatedPlayers()
    local numPlayers = #seatedPlayers
    for playerNum = 1, numPlayers do
        if playerNum == 2 then
            print("Second player gets 1 gold")
        elseif playerNum == 3 then
            print("Third player gets 2 gold")
        elseif playerNum == 4 then
            print("Fourth player gets 3 gold")
        end
    end
    log("Setup 9 Done")
end

function onLoad(script_state)
    if script_state ~= '' then
        local state = JSON.decode(script_state)
        if state and state.setupCompleted then
            UI.hide("startGame")
        end
    end
end

function onSave()
    local state = globalState
    state.firstGame = firstGame
    state.setupCompleted = setupCompleted
    state.numberOfPlayers = numberOfPlayers

    return JSON.encode(state)
end

function findStringInTable(tbl, str)
    for _, value in ipairs(tbl) do
        if value == str then
            return true
        end
    end
    return false
end

function gameSetup()
    UI.hide("startGame")
    UI.show("setupGame")
end

function cancel()
    UI.hide("setupGame")
    UI.show("startGame")
end

function startGame()
    local setup = GameSetup.new()

    if #getSeatedPlayers() <= 0 then
        broadcastToAll("Please choose a seat before starting the game")
        return
    else
        setup:step1()
        setup:step2()
        setup:step3()
        setup:step4()
        setup:step5()
        setup:step6()
        setup:step7()
        setup:step8()
        setup:step9()
        UI.hide("setupGame")
        setupCompleted = true
    end
end

function setFirstGame()
    firstGame = not firstGame
end

function optionSelected(player, option, s)
    numberOfPlayers = tonumber(option)
end

function getIsInverse(rotation)
    -- log(Vector(rotation.rotation):equals(Vector(0.00, 0.00, 0.00)))
    if Vector(rotation.rotation):equals(Vector(0.00, 0.00, 0.00)) then
        return true
    end
    return false
end