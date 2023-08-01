include("FLuaVector.lua")
local isDEBUG = 1
function debugPrint(...)
	if (isDEBUG) then
	  print(string.format(...))
	end
end

--火电管理局
local thermalPowerDepartment = GameInfoTypes["BUILDING_THERMAL_POWER_PLANNING_DEPARTMENT"]
--核电发展局
local nuclearDepartment = GameInfoTypes["BUILDING_NUCLEAR_POWER_MANAGEMENT_DEPARTMENT"]
--工业规划部
local industrialDivision = GameInfoTypes["BUILDING_INDUSTRIAL_PLANNING_DIVISION"]
--贵族议会
local houseOfLords = GameInfoTypes["BUILDING_HOUSE_OF_LORDS"]
local houseOfLordsPolicy = GameInfoTypes["POLICY_HOUSE_OF_LORDS_FREE"]
--皇城司
local imperialCityDepartment = GameInfoTypes["BUILDING_IMPERIAL_CITY_DEPARTMENT"]
--近卫军
local nationalGuardType = GameInfoTypes["UNIT_NATIONAL_GUARD"]
local nationalGuardClass = GameInfoTypes["UNITCLASS_NATIONAL_GUARD"]
--胜利女神像
local statueOfVictory = GameInfoTypes["BUILDING_STATUE_OF_VICTORY"]
--宏伟开门
local policyGrandeur =  GameInfoTypes["POLICY_BRANCH_GRANDEUR"]
--国子监
local imperialCollege = GameInfoTypes["BUILDING_IMPERIAL_COLLEGE_OF_SUPERVISION"]
--党卫军部
local Schutzstaffel = GameInfoTypes["BUILDING_AUTOCRACY_SCHUTZSTAFFEL"]
--国家集会场
local assemblyGround = GameInfoTypes["BUILDING_AUTOCRACY_ASSEMBLY_GROUND"]
--红场
local redSquare = GameInfoTypes["BUILDING_ORDER_RED_SQUARE"]
--革命历史博物馆
local museumOfRevolution = GameInfoTypes["BUILDING_ORDER_MUSEUM_OF_REVOLUTIONARY_HISTORY"]
--白金汉宫
local buckinghamPalace = GameInfoTypes["BUILDING_FREEDOM_BUCKINGHAM_PALACE"]
--解放纪念堂
local lincolnMemorial = GameInfoTypes["BUILDING_FREEDOM_LINCOLN_MEMORIAL"]


function QYNationalWonderCompletedDo(iPlayer, iCity, iBuilding, bGold, bFaithOrCulture)
	local pPlayer = Players[iPlayer]
	if not pPlayer:IsMajorCiv() then return end

	local iBuildingClass = GameInfo.Buildings[iBuilding].BuildingClass
	local isWorldWonder = GameInfo.BuildingClasses[iBuildingClass].MaxGlobalInstances
	local isNationWonder = GameInfo.BuildingClasses[iBuildingClass].MaxPlayerInstances

	if isNationWonder == 1 then
		if iBuilding == thermalPowerDepartment then
			debugPrint("玩家完成火电管理局")
			if not pPlayer:HasPolicy(GameInfo.Policies["POLICY_THERMAL_POWER_PLANNING_DEPARTMENT"].ID) then 
				pPlayer:SetHasPolicy(GameInfo.Policies["POLICY_THERMAL_POWER_PLANNING_DEPARTMENT"].ID,true,true)
			end

		--核电发展局
		elseif iBuilding == nuclearDepartment then
			debugPrint("玩家完成核电发展局")
			if not pPlayer:HasPolicy(GameInfo.Policies["POLICY_NUCLEAR_POWER_MANAGEMENT_DEPARTMENT"].ID) then 
				pPlayer:SetHasPolicy(GameInfo.Policies["POLICY_NUCLEAR_POWER_MANAGEMENT_DEPARTMENT"].ID,true,true)
			end	

		--工业规划部
		elseif iBuilding == industrialDivision then
			debugPrint("玩家完成工业规划部")
			if not pPlayer:HasPolicy(GameInfo.Policies["POLICY_INDUSTRIAL_PLANNING_DIVISION"].ID) then 
				pPlayer:SetHasPolicy(GameInfo.Policies["POLICY_INDUSTRIAL_PLANNING_DIVISION"].ID,true,true)	
			end

		--贵族议会
		elseif iBuilding == houseOfLords then
			debugPrint("玩家完成贵族议会")
			if not pPlayer:HasPolicy(GameInfo.Policies["POLICY_REPRESENTATION"].ID) then
				pPlayer:SetHasPolicy(GameInfo.Policies["POLICY_REPRESENTATION"].ID,true,true)
			else
				pPlayer:AddNotification(NotificationTypes.NOTIFICATION_FREE_POLICY, Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_FREE_POLICY"));
				pPlayer:SetNumFreePolicies(pPlayer:GetNumFreePolicies() + 1)
			end
			--赠送假政策
			if not pPlayer:HasPolicy(houseOfLordsPolicy) then
				pPlayer:SetHasPolicy(houseOfLordsPolicy,true,true)
			end

		--皇城司
		elseif iBuilding == imperialCityDepartment then  
			debugPrint("玩家完成皇城司")
			--首都赠送单位
			local capCity = pPlayer:GetCapitalCity()
			local thisCivGuardType = nationalGuardType
			--[[local civType = GameInfo.Civilizations[pPlayer:GetCivilizationType()].Type
			for row in GameInfo.Civilization_UnitClassOverrides{CivilizationType = civType, UnitClassType = nationalGuardClass} do
				if row.UnitType  then
					thisCivGuardType = row.UnitType
					break
				end
			end]]
			local pUnitA = pPlayer:InitUnit(thisCivGuardType,capCity:GetX(),capCity:GetY())
			pUnitA:ChangeExperience(105)
			local pUnitB = pPlayer:InitUnit(thisCivGuardType,capCity:GetX(),capCity:GetY())
			pUnitB:ChangeExperience(105)

		--党卫军部
		elseif iBuilding == Schutzstaffel then
			debugPrint("玩家完成党卫军部")
			--pPlayer:SetHasPolicy(GameInfo.Policies["POLICY_AUTOCRACY_SCHUTZSTAFFEL"].ID,true,true)
			local pCity = pPlayer:GetCityByID(iCity)
			if pCity == nil then return end
			local UnitType = GameInfoTypes["UNIT_GERMAN_WAFFEN_SS"]
			for i = 0,3 do
				local pUnit = pPlayer:InitUnit(UnitType,pCity:GetX(),pCity:GetY())
				pUnit:ChangeExperience(60)
				pUnit:JumpToNearestValidPlot()
			end

		--国家集会场
		elseif iBuilding == assemblyGround then
			debugPrint("玩家完成国家集会场")
			if not pPlayer:HasPolicy(GameInfo.Policies["POLICY_AUTOCRACY_ASSEMBLY_GROUND"].ID) then 
				pPlayer:SetHasPolicy(GameInfo.Policies["POLICY_AUTOCRACY_ASSEMBLY_GROUND"].ID,true,true)	
			end

		--红场
		elseif iBuilding == redSquare then
			debugPrint("玩家完成红场")
			if not pPlayer:HasPolicy(GameInfo.Policies["POLICY_ORDER_RED_SQUARE"].ID) then 
				pPlayer:SetHasPolicy(GameInfo.Policies["POLICY_ORDER_RED_SQUARE"].ID,true,true)	
			end
		end
	end

	--革命历史博物馆
	if (isNationWonder == 1 or isWorldWonder == 1) and pPlayer:HasBuilding(museumOfRevolution) then 
		debugPrint("Player built a Wonder and get Bonus from Museum Of Revolution!!!!")
		local bonus = GameInfo.GameSpeeds[Game.GetGameSpeedType()].ConstructPercent/100
		local pCost = GameInfo.Buildings[iBuilding].Cost
		bonus = math.floor(bonus * pCost * 0.25)
		pPlayer:ChangeFaith(bonus)
		pPlayer:ChangeOverflowResearch(bonus)
		if pPlayer:IsHuman() then
			local pCity = pPlayer:GetCityByID(iCity)
			local pX = pCity:GetX()
			local pY = pCity:GetY()
			local hex = ToHexFromGrid(Vector2(pX,pY))
			Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("+{1_Num}[ICON_RESEARCH],+{1_Num}[ICON_PEACE]", bonus))
			Events.GameplayFX(hex.x, hex.y, -1)
		end
	end
end
GameEvents.CityConstructed.Add(QYNationalWonderCompletedDo)

--假建筑列表
local thermalPowerDepartmentFree =  GameInfoTypes.BUILDING_NATIONAL_PLANNING_GLOBAL_HEALTH_ELECTRICITY
local imperialCollegeFree = GameInfoTypes.BUILDING_IMPERIAL_COLLEGE_OF_SUPERVISION_FREE
--真建筑列表
local gasPlant = GameInfoTypes.BUILDING_GAS_PLANT
local coalCompany = GameInfoTypes.BUILDING_COAL_COMPANY


function QYNationalWonderEffectDoEveryTurn(iPlayer)
	local pPlayer = Players[iPlayer]
	if not pPlayer:IsMajorCiv() then return end

	local playerHasTPPD = pPlayer:HasBuilding(thermalPowerDepartment) --火电管理局
	local playerHasIPD = pPlayer:HasBuilding(industrialDivision) --工业规划部
	--赠送假建筑
	local NumOfPuppetCity = 0
	local NumOfCrownCity = 0
	local LinConCity = nil
	for iCity in pPlayer:Cities() do
		--傀儡/直辖城市计数
		if iCity:IsPuppet() then
			NumOfPuppetCity = NumOfPuppetCity + 1
		else
			NumOfCrownCity = NumOfCrownCity + 1
		end
		--解放纪念堂城市标记
		if iCity:IsHasBuilding(lincolnMemorial) then 
			LinConCity = iCity
		end

		--火电管理局
		if playerHasTPPD and iCity:IsHasBuilding(gasPlant) then
			iCity:SetNumRealBuilding(thermalPowerDepartmentFree,1)
		else 
			iCity:SetNumRealBuilding(thermalPowerDepartmentFree,0)
		end

		--国子监:根据城市科研梯度赠送不同数量的假建筑
		if iCity:IsHasBuilding(imperialCollege) then
			local ScienceOfCity = 0
			ScienceOfCity = iCity:GetYieldRate(YieldTypes.YIELD_SCIENCE)
			--向下取整
			ScienceOfCity = math.floor(ScienceOfCity/40)
			--上限5次
			if ScienceOfCity > 5 then
				ScienceOfCity = 5
			end
			iCity:SetNumRealBuilding(imperialCollegeFree,ScienceOfCity)
		end
	end

	if NumOfPuppetCity > 0 --白金汉宫
	and  pPlayer:HasBuilding(buckinghamPalace)
	then
		local eEra = pPlayer:GetCurrentEra()
		local eSpeed = GameInfo.GameSpeeds[Game.GetGameSpeedType()].ConstructPercent/100
		local BuckingGodBonus = NumOfPuppetCity * eEra * eEra * eSpeed
		BuckingGodBonus = math.floor(BuckingGodBonus)
		local BuckingCultureBonus = NumOfPuppetCity * 0.5 * eEra * eEra * eSpeed
		BuckingCultureBonus = math.floor(BuckingCultureBonus)
		pPlayer:ChangeJONSCulture(BuckingCultureBonus)
		pPlayer:ChangeGold(BuckingGodBonus)
		if pPlayer:IsHuman() then
			Events.GameplayAlertMessage(Locale.ConvertTextKey("TXT_KEY_MESSAGE_FREEDOM_BUCKINGHAM_PALACE_ALERT", BuckingGodBonus, BuckingCultureBonus) )
		end
	end

	if NumOfCrownCity > 0 --解放纪念堂
	and LinConCity ~= nil
	then
		local eEra = pPlayer:GetCurrentEra()
		local eSpeed = GameInfo.GameSpeeds[Game.GetGameSpeedType()].ConstructPercent/100
		local LinConProductionBonus = NumOfCrownCity * 2 * eEra * eSpeed
		LinConProductionBonus = math.floor(LinConProductionBonus)
		LinConCity:SetOverflowProduction(LinConCity:GetOverflowProduction() + LinConProductionBonus)
		if pPlayer:IsHuman() then
			Events.GameplayAlertMessage(Locale.ConvertTextKey("TXT_KEY_MESSAGE_FREEDOM_LINCOLN_MEMORIAL_ALERT",LinConCity:GetName(),LinConProductionBonus) )
		end
	end

end
GameEvents.PlayerDoTurn.Add(QYNationalWonderEffectDoEveryTurn)  --每回合生效




function QYConquestedCity(oldOwnerID, isCapital, cityX, cityY, newOwnerID)
    local pPlayer = Players[newOwnerID]
    local capturedPlayer = Players[oldOwnerID]
	if pPlayer == nil or capturedPlayer == nil then
	 	return
	end

	--胜利女神像下城送黄金时代
	if pPlayer:HasBuilding(statueOfVictory) then
		debugPrint("胜利女神像下城延长黄金时代!")  
		local conquestedCityPlot = Map.GetPlot(cityX, cityY)
		local city = conquestedCityPlot:GetPlotCity()
		if pPlayer:IsGoldenAge() then 
			pPlayer:ChangeGoldenAgeTurns(1) 
			if city:IsOriginalCapital() then
				pPlayer:ChangeGoldenAgeTurns(2)
			end
		else
			local GoldenAgeBonus = city:GetPopulation() * (pPlayer:GetCurrentEra() + 1) * 5
			pPlayer:ChangeGoldenAgeProgressMeter(GoldenAgeBonus)
			if pPlayer:IsHuman() then
				local hex = ToHexFromGrid(Vector2(city:GetX(), city:GetY()))
				Events.AddPopupTextEvent(HexToWorld(hex), Locale.ConvertTextKey("+{1_Num}[ICON_GOLDEN_AGE]", GoldenAgeBonus))
			end
		end 				
	end

	--清除buff
	if not capturedPlayer:IsAlive() then return end
	--攻占拥有胜利女神像城市清除对方Buff
	if capturedPlayer:HasPolicyBranch(policyGrandeur)
	and not capturedPlayer:HasBuilding(statueOfVictory) then
		debugPrint("拥有胜利女神像的城市被夺取,立即清除buff!")
		for Unit in capturedPlayer:Units() do
			if Unit:IsHasPromotion(GameInfo.UnitPromotions["PROMOTION_STATUE_OF_VICTORY"].ID) then 
				Unit:SetHasPromotion(GameInfoTypes.PROMOTION_STATUE_OF_VICTORY,false)
			end
		end
	end

	--拥有贵族议会的城市被攻占，清除假政策
	if capturedPlayer:HasPolicy(houseOfLordsPolicy)
	and not capturedPlayer:HasBuilding(houseOfLords) then
		debugPrint("拥有贵族议会的城市被攻占，清除假政策!")
		capturedPlayer:SetHasPolicy(houseOfLordsPolicy,false)
	end

end
GameEvents.CityCaptureComplete.Add(QYConquestedCity) --夺城生效

function QYCityCanConstruct(iPlayer, iCity, iBuilding)
	local pPlayer = Players[iPlayer]
	
	if pPlayer == nil then return end

	--只对ai有效
	local CapCity = pPlayer:GetCapitalCity()
	if not pPlayer:IsHuman() 
	and not (CapCity:IsOriginalCapital() and iPlayer == CapCity:GetOriginalOwner())
	then
		--不再允许失去原始首都的ai建造
		if iBuilding == GameInfoTypes.BUILDING_IMPERIAL_CITY_DEPARTMENT --皇城司
		or iBuilding == GameInfoTypes.BUILDING_IMPERIAL_COLLEGE_OF_SUPERVISION  --国子监
		or iBuilding == GameInfoTypes.BUILDING_STATUE_OF_VICTORY --胜利女神像
		or iBuilding == GameInfoTypes.BUILDING_AUTOCRACY_SCHUTZSTAFFEL --党卫军部
		or iBuilding == GameInfoTypes.BUILDING_FREEDOM_BUCKINGHAM_PALACE --白金汉宫
		or iBuilding == GameInfoTypes.BUILDING_FREEDOM_FREEDOM_LINCOLN_MEMORIAL --解放纪念堂
		or iBuilding == GameInfoTypes.BUILDING_FREEDOM_ORDER_RED_SQUARE --红场
		then 
			return false
		end
	end  
	return true
 end
GameEvents.CityCanConstruct.Add(QYCityCanConstruct)

local NationalMedicalCollege = GameInfoTypes.BUILDING_NATIONAL_MEDICAL_COLLEGE
local EralyDoctor = GameInfoTypes.UNITCLASS_ERALY_DOCTOR
local ModernDoctor = GameInfoTypes.UNITCLASS_MODERN_DOCTOR
local GreatDoctor = GameInfoTypes.UNITCLASS_GREAT_DOCTOR
function QYUnitCreated(iPlayer, iUnit, iUnitType, iPlotX, iPlotY)
    local pPlayer = Players[iPlayer]
	if pPlayer == nil or not pPlayer:IsMajorCiv() then return end
    local pUnit = pPlayer:GetUnitByID(iUnit)
    if pUnit == nil then return end

	local pUnitClass = pUnit:GetUnitClassType()
	if pUnitClass == GreatDoctor
    then
		if pPlayer:HasBuilding(NationalMedicalCollege) then
			debugPrint("拥有国家医学院且大医诞生!")
			for iCity in pPlayer:Cities() do
				if iCity:GetPlagueTurns() < 0 then
					iCity:SetPlagueCounter(iCity:GetPlagueCounter() * 0.85)
				elseif iCity:GetPlagueTurns() > 0 then
					iCity:ChangePlagueTurns(-1)
				end
			end
		end
	
	elseif pUnitClass == EralyDoctor or pUnitClass == ModernDoctor
	then
		if pPlayer:HasBuilding(NationalMedicalCollege) then
			debugPrint("拥有国家医学院且医生诞生!")
			local pCity = pUnit:GetPlot():GetPlotCity()
			if pCity == nil then return end
			if pCity:GetPlagueTurns() < 0 then
				pCity:SetPlagueCounter(pCity:GetPlagueCounter() * 0.85)
			elseif pCity:GetPlagueTurns() > 0 then
				pCity:ChangePlagueTurns(-1)
			end
		end
	end
end
GameEvents.UnitCreated.Add(QYUnitCreated)

print("National Buildings Lua Effect Check Pass !")