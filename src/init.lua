--!strict

local DialogueContentFitter = require(script.Parent["dialogue-content-fitter"]);
local React = require(script.Parent.react);
local IDialogue = require(script.Parent["dialogue-types"]);
local IEffect = require(script.Parent["effect-types"]);
local ITheme = require(script.Parent["theme-types"]);

type Dialogue = IDialogue.Dialogue;
type Page = IEffect.Page;
type TextComponentProperties = ITheme.TextComponentProperties;
type TextComponentElement = React.ReactElement<any, TextLabel>;

local function usePages(dialogue: Dialogue, textContainerRef: React.Ref<GuiObject>, TextSegment: (TextComponentProperties) -> TextComponentElement, textSize: number): ({Page}, TextComponentElement?)

  local pages, setPages = React.useState({} :: {Page});
  local shouldShowTestSegment, setShouldShowTestSegment = React.useState(true);
  local testTextSegment: TextLabel?, setTestTextSegment = React.useState(nil :: TextLabel?);
  local testTextSegmentRef: React.Ref<TextLabel> = React.useRef(nil :: TextLabel?);
  local testTextSegmentComponent: TextComponentElement = React.createElement(TextSegment, {
    text = "";
    skipPageEvent = nil;
    letterDelay = 0;
    layoutOrder = 1;
    dialogue = dialogue;
    textSize = textSize;
    ref2 = testTextSegmentRef; 
    onComplete = function() end;
  });

  React.useEffect(function()
  
    assert(typeof(testTextSegmentRef) ~= "function", "textContainerRef must be a ref to a GuiObject");
    if testTextSegmentRef.current then

      setTestTextSegment(testTextSegmentRef.current:Clone());
      setShouldShowTestSegment(false);

    else

      setTestTextSegment(nil);
      setShouldShowTestSegment(true);

    end;

  end, {TextSegment :: unknown, textSize});

  React.useEffect(function()
  
    assert(typeof(textContainerRef) ~= "function", "textContainerRef must be a ref to a GuiObject");
    local textContainer = textContainerRef.current;
    if testTextSegment and textContainer then

      local dialogueContentFitter = DialogueContentFitter.new(textContainer, testTextSegment);
      local dialogueContent = dialogue:getContent();
      local pages = dialogueContentFitter:getPages(dialogueContent);
      setPages(pages);

    end;

  end, {dialogue :: unknown, testTextSegment});

  return pages, if shouldShowTestSegment then testTextSegmentComponent else nil;

end;

return usePages;