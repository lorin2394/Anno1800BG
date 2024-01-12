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
locations = {
    Red = {
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
        playerHandLocations = {
            position = {26.00, 1.00, -30.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {45, 7.00, 7.50},
        },
        homeIslandLocation = {
            position = {26.00, 0.10, -18.00},
            rotation = {0.00, 0.00, 0.00},
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
        playerHandLocations = {
            position = {-26.00, 1.00, 30.00},
            rotation = {0.00, 0.00, 0.00},
            scale = {45, 7.00, 7.50},
        },
        homeIslandLocation = {
            position = {-26.00, 0.10, 18.00},
            rotation = {0.00, 180.00, 0.00},
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
                    smooth = true
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
                smooth = true
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
    for index, player in ipairs(locations) do
        if index > numberOfPlayers then
            break
        end
        object = getObjectFromGUID(guids.old_world_islands).takeObject({
            position = locations[player].homeIslandLocation.position,
            rotation = locations[player].homeIslandLocation.rotation,
            smooth = true
        })
        object.setScale(locations[player].homeIslandLocation.scale)
        object = getObjectFromGUID(guids.new_world_islands).takeObject({
            position = locations[player].oldWorldIslandLocation.position,
            rotation = locations[player].oldWorldIslandLocation.rotation,
            smooth = true
        })
        object.setScale(locations[player].oldWorldIslandLocation.scale)
        object = getObjectFromGUID(guids.new_world_islands).takeObject({
            position = locations[player].newWorldIslandLocation.position,
            rotation = locations[player].newWorldIslandLocation.rotation,
            smooth = true
        })
        object.setScale(locations[player].newWorldIslandLocation.scale)
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

-- add more steps as needed

--[[ The onLoad event is called after the game save finishes loading. --]]
function onLoad(script_state)
    local state = JSON.decode(script_state)
    if state and state.setupCompleted then
        UI.hide("startGame")
    end

    return JSON.encode(state)
end

function onSave()
    local state = {
        firstGame = firstGame,
        setupCompleted = setupCompleted,
        numberOfPlayers = numberOfPlayers,
    }

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
    log(player.steam_name .. " selected: " .. option)
    numberOfPlayers = tonumber(option)
    log(numberOfPlayers)
end
