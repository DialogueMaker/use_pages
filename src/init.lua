--!strict

local Players = game:GetService("Players");

local packages = script.Parent.roblox_packages;
local DialogueMakerTypes = require(packages.dialogue_maker_types);
local DialogueContentFitter = require(packages.dialogue_content_fitter);
local React = require(packages.react);

type Page = DialogueMakerTypes.Page;

export type FittingProperties = {
  containerSize: UDim2;
  fontFace: Font;
  textSize: number;
  lineHeight: number;
};

local function usePages(rawPage: Page, fittingProperties: FittingProperties): {Page}

  local pages = React.useMemo(function()

    local screenGUI = Instance.new("ScreenGui");
    screenGUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui");

    local testContentContainer = Instance.new("Frame");
    testContentContainer.Size = fittingProperties.containerSize;
    testContentContainer.Parent = screenGUI;

    local testTextLabel = Instance.new("TextLabel");
    testTextLabel.AutomaticSize = Enum.AutomaticSize.XY;
    testTextLabel.Size = UDim2.new();
    testTextLabel.FontFace = fittingProperties.fontFace;
    testTextLabel.TextSize = fittingProperties.textSize;
    testTextLabel.LineHeight = fittingProperties.lineHeight;
    testTextLabel.Parent = testContentContainer;

    local uiListLayout = Instance.new("UIListLayout");
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    uiListLayout.Wraps = true;
    uiListLayout.FillDirection = Enum.FillDirection.Horizontal;
    uiListLayout.Parent = testContentContainer;

    local dialogueContentFitter = DialogueContentFitter.new(testContentContainer, testTextLabel);
    local pages = dialogueContentFitter:getPages(rawPage);

    screenGUI:Destroy();

    return pages;

  end, {rawPage :: unknown, fittingProperties});

  return pages;

end;

return usePages;