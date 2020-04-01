function SteamDetails()
    local desc =
        "Adds a new tool, the Magnet!  Magnets can be used to pull onto a tile all light-weight items within a one-tile radius.\r\n" ..
        "\r\n" ..
        "[Attribution]\r\n" ..
        "Magnet icon created by brgfx:  https://www.freepik.com/free-vector/magnet-white_5838219.htm\r\n" ..
        "Magnet model created by ali-mohsin14: https://free3d.com/3d-model/magnet-64871.html"
    ModBase.SetSteamWorkshopDetails("MagnetTool", desc, {"Tool","Toolcompo"}, "magnet.png")
end

-- Full table definitions are populated at the end of the file
local allTileTypes = {}
local magneticTypes = {}

function Creation()

    -- Name
    -- Ingredients (names + quantities)
    -- Target objects
    -- Target tiles
    -- Objects to produce (names + quantities)
    -- Animation duration
    -- Model name
    -- Using custom model?
    -- Callback function
    -- Destroy tool after use?
    ModTool.CreateTool(
        "Magnet",
        {"MetalPlateCrude"}, {2},
        {"TreePine"},
        allTileTypes,
        {}, {},
        1.0,
        "magnet",
        true,
        OnUseTool,
        false
    )
    
    ModTool.UpdateModelRotation("Magnet", 5, 90, 0)
    ModTool.UpdateModelTranslation("Magnet", 0.5, 0.2, 0)
end

function BeforeLoad()
    ModVariable.SetVariableForObjectAsInt("Magnet", "MaxUsage", 100)
    ModVariable.AddRecipeToConverter("MetalWorkbench", "Magnet", 1)
end

-- ----------------------------------------------------------------

local movingObjectUIDs = {}

function OnUseTool(UniqueID, PositionX, PositionY)
    -- movingObjectUIDs = ModTiles.GetObjectsOfTypeInAreaIDs("TreeSeed", PositionX-1, PositionY-1, PositionX+1, PositionY+1)
    movingObjectUIDs = getMagneticObjectsInArea(PositionX-1, PositionY-1, PositionX+1, PositionY+1)
    for _, uid in ipairs(movingObjectUIDs) do
        ModObject.StartMoveTo(uid, PositionX, PositionY, 10.0, 0.0)
    end
end

function OnUpdate()
    local stillMovingObjectUIDs = {}
    for i, uid in ipairs(movingObjectUIDs) do
        local complete = ModObject.UpdateMoveTo(uid, true, false)
        if not complete then
            table.insert(stillMovingObjectUIDs,uid)
        end
    end
    movingObjectUIDs = stillMovingObjectUIDs
end

function getMagneticObjectsInArea(startX, startY, endX, endY)
    local results = {}
    for x=startX, endX do
        for y=startY, endY do
            local objects = ModTiles.GetSelectableObjectUIDsOnTile(x, y);
            for _, uid in ipairs(objects) do
                if uid ~= -1 and isMagnetic(uid) then
                    table.insert(results, uid)
                end
            end
        end
    end
    return results;
end

function isMagnetic(uid)
    -- TODO: the following is what I'd like to do, unfortunately it doesn't work as expected because the "Weight"
    --       variable is only set for objects with a 'non-standard' weight (i.e. weight > 1).  Instead I will need to
    --       build a whitelist of object types that should be considered 'magnetic'
    -- local objectType = ModObject.GetObjectType(uid)
    -- local weight = ModVariable.GetVariableForObjectAsInt(objectType, "Weight")
    -- return weight == 1
    
    local objectType = ModObject.GetObjectType(uid)
    return magneticTypes[objectType] == true
end

magneticTypes = {
    ToolAxeStone=true,
    ToolShovelStone=true,
    ToolPickStone=true,
    ToolHoeStone=true,
    ToolScytheStone=true,
    ToolAxe=true,
    ToolShovel=true,
    ToolPick=true,
    ToolHoe=true,
    ToolScythe=true,
    ToolBucketCrude=true,
    ToolBucket=true,
    ToolBucketMetal=true,
    ToolMallet=true,
    ToolChiselCrude=true,
    ToolChisel=true,
    ToolFlailCrude=true,
    ToolFlail=true,
    ToolShears=true,
    ToolWateringCan=true,
    ToolFishingStick=true,
    ToolFishingRod=true,
    ToolBroom=true,
    ToolPitchfork=true,
    ToolTorchCrude=true,
    ToolDredgerCrude=true,
    ToolNet=true,
    ToolBlade=true,
    Plank=true,
    Pole=true,
    WheelCrude=true,
    Wheel=true,
    Crank=true,
    FixingPeg=true,
    Rock=true,
    RockSharp=true,
    Clay=true,
    PotClayRaw=true,
    PotClay=true,
    JarClayRaw=true,
    JarClay=true,
    FlowerPotRaw=true,
    FlowerPot=true,
    GnomeRaw=true,
    Gnome=true,
    Gnome2=true,
    Gnome3=true,
    Gnome4=true,
    Wool=true,
    Fleece=true,
    Blanket=true,
    Buttons=true,
    Thread=true,
    CottonLint=true,
    CottonThread=true,
    CottonCloth=true,
    BullrushesFibre=true,
    BullrushesThread=true,
    BullrushesCloth=true,
    WheatSeed=true,
    CarrotSeed=true,
    MushroomDug=true,
    MushroomHerb=true,
    Berries=true,
    BerriesSpice=true,
    Porridge=true,
    PumpkinRaw=true,
    PumpkinSeeds=true,
    PumpkinHerb=true,
    Apple=true,
    AppleSpice=true,
    FishRaw=true,
    FishHerb=true,
    Carrot=true,
    CarrotSalad=true,
    WeedDug=true,
    Egg=true,
    Milk=true,
    Honey=true,
    Butter=true,
    Manure=true,
    TreeSeed=true,
    Coconut=true,
    Seedling=true,
    Stick=true,
    Wheat=true,
    GrassCut=true,
    Turf=true,
    Fertiliser=true,
    Coal=true,
    Straw=true,
    Dough=true,
    DoughGood=true,
    Pastry=true,
    FlowerSeeds01=true,
    FlowerSeeds02=true,
    FlowerSeeds03=true,
    FlowerSeeds04=true,
    FlowerSeeds05=true,
    FlowerSeeds06=true,
    FlowerSeeds07=true,
    FlowerBunch01=true,
    FlowerBunch02=true,
    FlowerBunch03=true,
    FlowerBunch04=true,
    FlowerBunch05=true,
    FlowerBunch06=true,
    FlowerBunch07=true,
    StringBall=true,
    FlourCrude=true,
    Flour=true,
    FolkSeed=true,
    FolkHeart=true,
    FolkHeart2=true,
    BeesNest=true,
    CottonSeeds=true,
    CottonBall=true,
    BullrushesSeeds=true,
    BullrushesStems=true,
    DataStorageCrude=true,
    UpgradePlayerInventoryCrude=true,
    UpgradePlayerInventoryGood=true,
    UpgradePlayerInventorySuper=true,
    UpgradePlayerMovementCrude=true,
    UpgradePlayerMovementGood=true,
    UpgradePlayerMovementSuper=true,
    UpgradeWorkerMemoryCrude=true,
    UpgradeWorkerMemoryGood=true,
    UpgradeWorkerMemorySuper=true,
    UpgradeWorkerSearchCrude=true,
    UpgradeWorkerSearchGood=true,
    UpgradeWorkerSearchSuper=true,
    UpgradeWorkerCarryCrude=true,
    UpgradeWorkerCarryGood=true,
    UpgradeWorkerCarrySuper=true,
    UpgradeWorkerMovementCrude=true,
    UpgradeWorkerMovementGood=true,
    UpgradeWorkerMovementSuper=true,
    UpgradeWorkerEnergyCrude=true,
    UpgradeWorkerEnergyGood=true,
    UpgradeWorkerEnergySuper=true,
    UpgradeWorkerInventoryCrude=true,
    UpgradeWorkerInventoryGood=true,
    UpgradeWorkerInventorySuper=true,
    HatChullo=true,
    HatFarmerCap=true,
    HatCap=true,
    HatFarmer=true,
    HatWig01=true,
    HatBeret=true,
    HatSugegasa=true,
    HatKnittedBeanie=true,
    HatFez=true,
    HatChef=true,
    HatAdventurer=true,
    HatMushroom=true,
    HatLumberjack=true,
    HatBaseballShow=true,
    HatCrown=true,
    HatMortarboard=true,
    HatSouwester=true,
    HatTree=true,
    HatMadHatter=true,
    HatCloche=true,
    HatAcorn=true,
    HatSanta=true,
    HatWally=true,
    HatParty=true,
    HatViking=true,
    HatBox=true,
    HatTrain=true,
    HatSailor=true,
    HatMiner=true,
    HatFox=true,
    HatDinosaur=true,
    HatAntlers=true,
    TopPoncho=true,
    TopTunic=true,
    TopToga=true,
    WorkerFrameMk0=true,
    WorkerHeadMk0=true,
    WorkerDriveMk0=true,
    WorkerFrameMk1=true,
    WorkerHeadMk1=true,
    WorkerDriveMk1=true,
    WorkerFrameMk1Variant1=true,
    WorkerHeadMk1Variant1=true,
    WorkerDriveMk1Variant1=true,
    WorkerFrameMk1Variant2=true,
    WorkerHeadMk1Variant2=true,
    WorkerDriveMk1Variant2=true,
    WorkerFrameMk1Variant3=true,
    WorkerHeadMk1Variant3=true,
    WorkerDriveMk1Variant3=true,
    WorkerFrameMk1Variant4=true,
    WorkerHeadMk1Variant4=true,
    WorkerDriveMk1Variant4=true,
    WorkerFrameMk2=true,
    WorkerHeadMk2=true,
    WorkerDriveMk2=true,
    WorkerFrameMk2Variant1=true,
    WorkerHeadMk2Variant1=true,
    WorkerDriveMk2Variant1=true,
    WorkerFrameMk2Variant2=true,
    WorkerHeadMk2Variant2=true,
    WorkerDriveMk2Variant2=true,
    WorkerFrameMk2Variant3=true,
    WorkerHeadMk2Variant3=true,
    WorkerDriveMk2Variant3=true,
    WorkerFrameMk2Variant4=true,
    WorkerHeadMk2Variant4=true,
    WorkerDriveMk2Variant4=true,
    WorkerFrameMk3=true,
    WorkerHeadMk3=true,
    WorkerDriveMk3=true,
    WorkerFrameMk3Variant1=true,
    WorkerHeadMk3Variant1=true,
    WorkerDriveMk3Variant1=true,
    WorkerFrameMk3Variant2=true,
    WorkerHeadMk3Variant2=true,
    WorkerDriveMk3Variant2=true
}

allTileTypes = {
    "Empty", -- Turf
    "Soil",
    "SoilTilled",
    "SoilHole",
    "SoilUsed",
    "SoilDung",
    "WaterShallow",
    "WaterDeep",
    "SeaWaterShallow",
    "SeaWaterDeep",
    "Sand",
    "Dredged",
    "Swamp",
    "IronHidden",
    "IronSoil",
    "IronSoil2",
    "Iron",
    "IronUsed",
    "ClayHidden",
    "ClaySoil",
    "Clay",
    "ClayUsed",
    "CoalHidden",
    "CoalSoil",
    "CoalSoil2",
    "CoalSoil3",
    "Coal",
    "CoalUsed",
    "StoneHidden",
    "StoneSoil",
    "Stone",
    "StoneUsed",
    "Raised",
    "Building",
    "Trees",
    "CropWheat",
    "CropCotton",
    "Weeds",
    "Grass",
    "Decoration1",
    "Decoration2",
    "Decoration3",
    "Decoration4",
    "Decoration5",
    "Decoration6",
    "Decoration7",
    "Decoration8",
    "Decoration9",
    "Decoration10",
    "Decoration11",
    "Decoration12",
    "Decoration13",
    "Decoration14",
    "Decoration15",
    "Decoration16",
    "Decoration17",
    "Decoration18",
    "Decoration19",
    "Decoration20",
    "Decoration21",
    "Decoration22",
    "Decoration23",
    "Decoration24",
    "Decoration25",
    "Decoration26",
    "Decoration27",
    "Decoration28",
    "Decoration29",
    "Decoration30",
    "Decoration31",
    "Decoration32",
}