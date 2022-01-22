AntibodiesShared = {}
AntibodiesShared.__index = AntibodiesShared

-----------------------------------------------------
--CONST----------------------------------------------
-----------------------------------------------------

AntibodiesShared.version = "1.21"
AntibodiesShared.author = "lonegamedev.com"
AntibodiesShared.modName = "Antibodies"
AntibodiesShared.modId = "lgd_antibodies"

local zeroMoodles = {"Angry", "Dead", "Zombie", "Injured"}

-----------------------------------------------------
--STATE----------------------------------------------
-----------------------------------------------------

AntibodiesShared.currentOptions = nil

-----------------------------------------------------
--COMMON---------------------------------------------
-----------------------------------------------------

local function has_value(table, val)
  for k,v in pairs(table) do
    if v == val then
      return true
    end
  end
  return false
end

local function has_key(table, key)
    return table[key] ~= nil
end

local function lerp(v0, v1, t)
  return (1.0 - t) * v0 + t * v1
end

local function format_float(num)
  return string.format("%.4f", num)
end

local function is_number(num)
    if type(num) == "number" then
        return true
    else
        return false
    end
end

local function clamp(num, min, max)
  return math.max(min, math.min(num, max))
end

local function deepcopy(val)
  local val_copy
  if type(val) == 'table' then
      val_copy = {}
      for k,v in pairs(val) do
        val_copy[k] = deepcopy(v)
      end
  else
      val_copy = val
  end
  return val_copy
end

local function parse_value(txt)
  if txt == "true" then return true end
  if txt == "false" then return false end
  local num = tonumber(txt)
  if num == nil then
    return txt
  end
  return num
end

local function print_options(options)
  for group_key, group in pairs(options) do
    for prop_key, prop_val in pairs(group) do
      print(group_key.."."..prop_key.." = "..tostring(prop_val))
    end
  end
end

-----------------------------------------------------
--OPTIONS--------------------------------------------
-----------------------------------------------------

local function hasOptions()
  --validate
  return AntibodiesShared.currentOptions ~= nil
end

local function getDefaultOptions()
  return {
    ["Antibodies"] = {
      ["version"] = AntibodiesShared.version,
      ["author"] = AntibodiesShared.author,
      ["modName"] = AntibodiesShared.modName,
      ["modId"] = AntibodiesShared.modId
    },
    ["General"] = {
      ["baseAntibodyGrowth"] = 1.6
    },
    ["Debug"] = {
      ["enabled"] = false,
      ["moodleEffects"] = false,
      ["damageEffects"] = false,
      ["traitsEffects"] = false
    },
    ["DamageEffects"] = {
      ["InfectedWound"] = -0.001
    },
    ["MoodleEffects"] = {
      ["Bleeding"] = -0.1,
      ["Hypothermia"] = -0.1,
      ["Injured"] = 0.0,
      
      ["Thirst"] = -0.04,
      ["Hungry"] = -0.03,
      ["Sick"] = -0.02,
      ["HasACold"] = -0.02,

      ["Tired"] = -0.01,
      ["Endurance"] = -0.01,
      ["Pain"] = -0.01,
      ["Wet"] = -0.01,
      ["HeavyLoad"] = -0.01,
      ["Windchill"] = -0.01,
      
      ["Panic"] = -0.01,
      ["Stress"] = -0.01,
      ["Unhappy"] = -0.01,
      ["Bored"] = -0.01,
      
      ["Hyperthermia"] = 0.01,
      ["Drunk"] = 0.01,
      ["FoodEaten"] = 0.05,
      
      ["Dead"] = 0.0,
      ["Zombie"] = 0.0,
      ["Angry"] = 0.0,
    },
    ["TraitsEffects"] = {
      ["Asthmatic"] = -0.01,
      ["Smoker"] = -0.01,
      
      ["Unfit"] = -0.02,
      ["Out of Shape"] = -0.01,
      ["Athletic"] = 0.01,
    
      ["SlowHealer"] = -0.01,
      ["FastHealer"] = 0.01,
      
      ["ProneToIllness"] = -0.01,
      ["Resilient"] = 0.01,
    
      ["Weak"] = -0.02,
      ["Feeble"] = -0.01,
      ["Strong"] = 0.01,
      ["Stout"] = 0.02,
    
      ["Emaciated"] = -0.02,
      ["Very Underweight"] = -0.01,
      ["Underweight"] = 0.005,
      ["Overweight"] = 0.005,
      ["Obese"] = -0.02
    }
  }
end

local function applyOptions(options)
  if (type(options) ~= "table") then
    return false
  end
  AntibodiesShared.currentOptions = deepcopy(options)
end

local function loadOptions()
  local options = {}
  local reader = getFileReader("antibodies_options.ini", false)
  if not reader then
    return false
  end
  local current_group = nil
  while true do
    local line = reader:readLine()
    if not line then
		  reader:close()
		  break
		end
    line = line:trim()
    if line ~= "" then
    local k,v = line:match("^([^=%[]+)=([^=]+)$")
		  if k then
        if current_group then
          k = k:trim()
          if current_group == "Antibodies" then         
            options[current_group][k] = v:trim()
          else
            options[current_group][k] = parse_value(v:trim())
          end
        end
      else
        local group = line:match("^%[([^%[%]%%]+)%]$")
        if group then
          current_group = group:trim()
          options[current_group] = {}
        end
      end
    end
  end
  if(options["Antibodies"] == nil) then 
    return false
  end
  if options["Antibodies"]["author"] ~= AntibodiesShared.author then
    return false
  end
  if options["Antibodies"]["modName"] ~= AntibodiesShared.modName then
    return false
  end
  if options["Antibodies"]["modId"] ~= AntibodiesShared.modId then
    return false
  end
  if(options["Antibodies"]["version"] == nil) then 
    return false
  end
  return options
end

local function saveHostOptions(options)
  if isClient() then
    sendClientCommand(getPlayer(), AntibodiesShared.modId, "saveOptions", options)
  end
end

local function saveOptions(options)
  if (type(options) ~= "table") then
    return false
  end
  local writer = getFileWriter("antibodies_options.ini", true, false)
  for id,group in pairs(options) do
    writer:write("\r\n["..id.."]\r\n")
    for k,v in pairs(group) do
      writer:write(k..' = '..tostring(v).."\r\n")
    end
	end
  writer:close()
  return true
end

local function mergeOptions(default, loaded)
  local result = deepcopy(default)
  if type(loaded) ~= "table" then
    return default
  end
  local groups = {"General", "MoodleEffects", "TraitEffect", "DamageEffects", "Debug"}
  for group_index, group_key in pairs(groups) do
    if type(loaded[group_key]) == "table" then
      for prop_key, prop_val in pairs(default[group_key]) do
        if loaded[group_key][prop_key] ~= nil then
          result[group_key][prop_key] = loaded[group_key][prop_key]
        end
      end
    end
  end
  for moodle_index, moodle_key in pairs(zeroMoodles) do
    result["MoodleEffects"][moodle_key] = 0
  end
  return result
end

local function getOptions()
  return mergeOptions(getDefaultOptions(), loadOptions())
end

-----------------------------------------------------
--EXPORTS--------------------------------------------
-----------------------------------------------------

AntibodiesShared.has_value = has_value
AntibodiesShared.has_key = has_key
AntibodiesShared.lerp = lerp
AntibodiesShared.format_float = format_float
AntibodiesShared.is_number = is_number
AntibodiesShared.clamp = clamp
AntibodiesShared.deepcopy = deepcopy
AntibodiesShared.parse_value = parse_value
AntibodiesShared.print_options = print_options
AntibodiesShared.zeroMoodles = zeroMoodles

AntibodiesShared.hasOptions = hasOptions
AntibodiesShared.applyOptions = applyOptions
AntibodiesShared.getOptions = getOptions
AntibodiesShared.loadOptions = loadOptions
AntibodiesShared.saveOptions = saveOptions
AntibodiesShared.saveHostOptions = saveHostOptions
AntibodiesShared.getDefaultOptions = getDefaultOptions

return AntibodiesShared