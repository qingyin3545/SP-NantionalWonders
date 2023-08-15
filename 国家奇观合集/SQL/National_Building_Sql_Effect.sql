--屏蔽城邦造奇观
UPDATE SPTriggerControler SET Enabled = 1 WHERE TriggerType = 'Minor_Building_Overrides_Trigger';

--国家情报局不再需要赞助开门，且要求降低至中型城市
UPDATE Buildings SET PolicyBranchType = NULL WHERE Type = 'BUILDING_INTELLIGENCE_AGENCY';
UPDATE Building_ClassesNeededInCity SET BuildingClassType = 'BUILDINGCLASS_CITY_SIZE_MEDIUM' WHERE BuildingType = 'BUILDING_INTELLIGENCE_AGENCY';

INSERT INTO Building_BuildingClassYieldChanges(BuildingType , BuildingClassType , YieldType , YieldChange)
--火电管理局增加发电站本地健康度
SELECT 'BUILDING_THERMAL_POWER_PLANNING_DEPARTMENT', 'BUILDINGCLASS_COAL_PLANT',        'YIELD_HEALTH', 1 UNION ALL --燃煤发电站
SELECT 'BUILDING_THERMAL_POWER_PLANNING_DEPARTMENT', 'BUILDINGCLASS_COAL_PLANT_EXTEND', 'YIELD_HEALTH', 1 UNION ALL --燃煤发电扩容机组
SELECT 'BUILDING_THERMAL_POWER_PLANNING_DEPARTMENT', 'BUILDINGCLASS_OIL_PLANT',         'YIELD_HEALTH', 1 UNION ALL --燃油发电站 
SELECT 'BUILDING_THERMAL_POWER_PLANNING_DEPARTMENT', 'BUILDINGCLASS_GAS_PLANT',         'YIELD_HEALTH', 1 UNION ALL --燃气发电站 

--工业规划局增加建筑本地健康度
SELECT 'BUILDING_INDUSTRIAL_PLANNING_DIVISION' , 'BUILDINGCLASS_FACTORY',           'YIELD_HEALTH',1 UNION ALL  --工厂
SELECT 'BUILDING_INDUSTRIAL_PLANNING_DIVISION' , 'BUILDINGCLASS_OIL_REFINERY',      'YIELD_HEALTH',1 UNION ALL  --石油精炼厂
SELECT 'BUILDING_INDUSTRIAL_PLANNING_DIVISION' , 'BUILDINGCLASS_STEEL_MILL',        'YIELD_HEALTH',1 UNION ALL  --增殖反应堆
SELECT 'BUILDING_INDUSTRIAL_PLANNING_DIVISION' , 'BUILDINGCLASS_MINING_COMPANY',    'YIELD_HEALTH',1 UNION ALL  --矿业公司
SELECT 'BUILDING_INDUSTRIAL_PLANNING_DIVISION' , 'BUILDINGCLASS_ORE_REFINERIES',    'YIELD_HEALTH',1 UNION ALL  --电冶金厂
SELECT 'BUILDING_INDUSTRIAL_PLANNING_DIVISION' , 'BUILDINGCLASS_COAL_COMPANY',      'YIELD_HEALTH',1 UNION ALL  --炼焦厂

--核电发展局增加核电站产能
SELECT 'BUILDING_NUCLEAR_POWER_MANAGEMENT_DEPARTMENT' , 'BUILDINGCLASS_NUCLEAR_PLANT',          'YIELD_PRODUCTION',3 UNION ALL  --核电站
SELECT 'BUILDING_NUCLEAR_POWER_MANAGEMENT_DEPARTMENT' , 'BUILDINGCLASS_NUCLEAR_PLANT_EXTEND',   'YIELD_PRODUCTION',3 UNION ALL  --核电扩容机组
SELECT 'BUILDING_NUCLEAR_POWER_MANAGEMENT_DEPARTMENT' , 'BUILDINGCLASS_FUSION_PLANT',           'YIELD_PRODUCTION',3 UNION ALL  --核聚变发电站
SELECT 'BUILDING_NUCLEAR_POWER_MANAGEMENT_DEPARTMENT' , 'BUILDINGCLASS_THORIUM_REACTOR',        'YIELD_PRODUCTION',3;           --钍反应堆


--政策增加建筑全局健康度
INSERT INTO Policy_BuildingClassYieldModifiers(PolicyType,BuildingClassType,YieldType,YieldMod)
--火电管理局
SELECT 'POLICY_THERMAL_POWER_PLANNING_DEPARTMENT', 'BUILDINGCLASS_COAL_PLANT',              'YIELD_DISEASE', -5 UNION ALL   --燃煤发电站
SELECT 'POLICY_THERMAL_POWER_PLANNING_DEPARTMENT', 'BUILDINGCLASS_COAL_PLANT_EXTEND',       'YIELD_DISEASE', -5 UNION ALL   --燃煤发电扩容机组
SELECT 'POLICY_THERMAL_POWER_PLANNING_DEPARTMENT', 'BUILDINGCLASS_OIL_PLANT',               'YIELD_DISEASE', -5 UNION ALL   --燃油发电站
SELECT 'POLICY_THERMAL_POWER_PLANNING_DEPARTMENT', 'BUILDINGCLASS_GAS_PLANT',               'YIELD_DISEASE', -5 UNION ALL   --燃气发电站
--核电发展局
SELECT 'POLICY_NUCLEAR_POWER_MANAGEMENT_DEPARTMENT' , 'BUILDINGCLASS_NUCLEAR_PLANT',        'YIELD_DISEASE', -3      UNION ALL   --核电站
SELECT 'POLICY_NUCLEAR_POWER_MANAGEMENT_DEPARTMENT' , 'BUILDINGCLASS_NUCLEAR_PLANT_EXTEND', 'YIELD_DISEASE', -3      UNION ALL   --核电扩容机组
--工业规划局
SELECT 'POLICY_INDUSTRIAL_PLANNING_DIVISION', 'BUILDINGCLASS_FACTORY',                      'YIELD_DISEASE', -5      UNION ALL   --工厂
SELECT 'POLICY_INDUSTRIAL_PLANNING_DIVISION', 'BUILDINGCLASS_OIL_REFINERY',                 'YIELD_DISEASE', -3      UNION ALL   --石油精炼厂
SELECT 'POLICY_INDUSTRIAL_PLANNING_DIVISION', 'BUILDINGCLASS_STEEL_MILL',                   'YIELD_DISEASE', -3      UNION ALL   --增殖反应堆
SELECT 'POLICY_INDUSTRIAL_PLANNING_DIVISION', 'BUILDINGCLASS_MINING_COMPANY',               'YIELD_DISEASE', -5      UNION ALL   --矿业公司
SELECT 'POLICY_INDUSTRIAL_PLANNING_DIVISION', 'BUILDINGCLASS_ORE_REFINERIES',               'YIELD_DISEASE', -3      UNION ALL   --电冶金厂
SELECT 'POLICY_INDUSTRIAL_PLANNING_DIVISION', 'BUILDINGCLASS_COAL_COMPANY',                 'YIELD_DISEASE', -3;                 --炼焦厂