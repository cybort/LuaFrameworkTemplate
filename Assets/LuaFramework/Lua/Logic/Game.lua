local breakSocketHandle,debugXpCall = require("LuaDebug")("localhost",7003)
local timer = Timer.New(function() 
breakSocketHandle() end, 1, -1, false)
timer:Start();

require "Common/define"
require "Logic/LuaClass"
require "Logic/CtrlManager"
require "Common/functions"

--管理器--
Game = {};
local this = Game;

--初始化完成，发送链接服务器信息--
function Game.OnInitOK()

    -- Socket 
    networkMgr:SendConnect("119.23.173.121",4020) -- Network.lua 里处理收发消息
    Network.Send("loginauto","") -- Socket 发包

    -- networkMgr2:SendConnect("119.23.173.121",4030) -- Network.lua 里处理收发消息
    -- Network2.Send("loginauto","") -- Socket 发包

    CtrlManager.Init();
    local ctrl = CtrlManager.GetCtrl(ControllerNames.Login);
    if ctrl ~= nil then
       ctrl:Awake();
    end

    logWarn('LuaFramework InitOK--->>>')

    -- Update 监听 
    UpdateBeat:Add(Update, self)

    -- HTTP  
    this.TestHTTP()
    -- 持久化
    this.TestPlayerPrefs()
end

function Update()
   -- LuaFramework.Util.Log("每帧执行一次");
end

--销毁--
function Game.OnDestroy()
	--logWarn('OnDestroy--->>>');
end

function Game.TestHTTP()

    local parameter = WWWForm()
    parameter:AddField("test1", 1) -- 传入参数

    local url = URL_Domain..HTTPRelativeURL.GetDeskCardOneCost
	HTTPClient.Request(HTTPRequestType.Get, url,  parameter, this.ResponseHTTP)
end

function Game.ResponseHTTP(state,code,message, data)
    logWarn("Game.ResponseHTTP--->>")

    if state == HTTPResponseState.Fail then
        logWarn("请求失败")
    end

    logWarn("state is "..state)
    logWarn("code is "..state)
    logWarn("message is "..message)
    logWarn("data is "..data)
end


function Game.TestPlayerPrefs()
    local stringKey = "StringKey"
    local intKey = "IntKey"
    PlayerPrefs.SetString(stringKey, "StringValue")
    PlayerPrefs.SetInt(intKey, 99)

    local strValue = PlayerPrefs.GetString(stringKey)
    local intValue = PlayerPrefs.GetInt(intKey)

    logWarn('strValue is'..strValue)
    logWarn('intValue is'..intValue)
end