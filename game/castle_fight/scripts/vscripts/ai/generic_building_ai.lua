require("ai/general_ai")

function Spawn(keys)
  -- Wait one frame to do logic on a spawned unit
  Timers:CreateTimer(.1, function()   
    -- Get all of the unit's abilities
    thisEntity.abilityList = {}
    for i=0,15 do
      local ability = thisEntity:GetAbilityByIndex(i)
      if ability and not ability:IsPassive() then
        table.insert(thisEntity.abilityList, ability)
        -- Toggle auto cast on
        ability:ToggleAutoCast()
      end
    end

    Timers:CreateTimer(function() return thisEntity:AIThink() end)
  end)
end

function thisEntity:AIThink()
  if self:IsNull() then return end
  if not self:IsAlive() then return end

  if GameRules:IsGamePaused() then
    return 0.1
  end

  return thisEntity:UseAutoCastAbility()
end

function thisEntity:UseAutoCastAbility()
  local ability = GetRandomTableElement(thisEntity.abilityList)

  if ability:IsFullyCastable() and ability:GetAutoCastState() then
    self:CastAbilityNoTarget(ability, -1)
  end

  return 0.1
end