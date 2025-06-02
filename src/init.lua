--!strict

local packages = script.Parent.roblox_packages;
local DialogueContentFitter = require(packages.dialogue_content_fitter);
local React = require(packages.react);
local IEffect = require(packages.effect_types);

type Page = IEffect.Page;

local function usePages(rawPage: Page, textContainerTemplate: GuiObject, textLabelTemplate: TextLabel): {Page}

  local pages = React.useMemo(function()
  
    local dialogueContentFitter = DialogueContentFitter.new(textContainerTemplate, textLabelTemplate);
    local pages = dialogueContentFitter:getPages(rawPage);
    return pages;

  end, {rawPage :: unknown, textContainerTemplate, textLabelTemplate});

  return pages;

end;

return usePages;