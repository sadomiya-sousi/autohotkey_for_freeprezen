#Include "globals.ahk"

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

ShowDebugInfo() {
    global ActiveLayers, ScToKeyName, KeySnapshot, HookAgents

    msg := "=== 🧠 システム状態モニター ===`n`n"

    msg .= "📊 【 ActiveLayers 】`n"
    if (ActiveLayers.Count == 0) {
        msg .= "  (空っぽ)`n"
    } else {
        for LayerName, activated_time in ActiveLayers {
            msg .= "  " . LayerName . " : " . activated_time . "`n"
        }
    }
    msg .= "`n"

    msg .= "📸 【 KeySnapshot 】`n"
    if (KeySnapshot.Count == 0) {
        msg .= "  (空っぽ)`n"
    } else {
        for key, savedLayer in KeySnapshot {
            msg .= "  キー [" . ScToKeyName[key] . "] は <" . savedLayer . "> として記憶中`n"
        }
    }
    msg .= "`n"

    msg .= "🕵️ 【 HookAgents 】`n"
    if IsSet(HookAgents) {
        if (Type(HookAgents) == "Map" && HookAgents.Count == 0) || (Type(HookAgents) == "Array" && HookAgents.Length == 0) {
            msg .= "  (監視中のエージェントはいません)`n"
        } else {
            for agentKey, agentData in HookAgents {
                if (Type(agentData) == "InputHook") {
                    hookStatus := agentData.InProgress ? "👀 監視中(InProgress)" : "💤 停止中"
                    msg .= "  " . ScToKeyName[agentKey] . " : InputHook状態 -> " . hookStatus . "`n"
                } else {
                    msg .= "  " . agentKey . " : [ 型: " . Type(agentData) . " ]`n"
                }
            }
        }
    } else {
        msg .= "  (変数 HookAgents は定義されていません)`n"
    }

    MsgBox(msg, "デバッグ情報モニター")
}

CompareWindowInfo() {
    hwnd := WinExist("A")
    title := WinGetTitle(hwnd)
    exe := WinGetProcessPath(hwnd)
    style := WinGetStyle(hwnd)
    exStyle := WinGetExStyle(hwnd)
    
    logPath := A_Desktop . "\win_log.txt"
    logEntry := Format("Time: {1}`nTitle: {2}`nExe: {3}`nStyle: 0x{4:X}`nExStyle: 0x{5:X}`n-------------------`n", 
                       A_Now, title, exe, style, exStyle)
    
    FileAppend(logEntry, logPath)
    ToolTip("Window情報をログに記録しました: " . title)
    SetTimer(() => ToolTip(), -2000)
}

GrabFloatingWindow() {
    hwnd := WinExist("A")
    PostMessage(0x0112, 0xF010, 0, , hwnd)
}

IsWindowCloaked(hwnd) {
    cloaked := 0
    hr := DllCall("dwmapi\DwmGetWindowAttribute"
        , "Ptr", hwnd     
        , "Int", 14       
        , "Int*", &cloaked 
        , "Int", 4)       
    
    return (hr == 0 && cloaked != 0)
}

SmartObsidianToggle() {
}

GetTrueMods() {
    result := []
    global ActiveLayers
    for key, val in ActiveLayers {
        if (val && key ~= "i)^(LShift|RShift|LCtrl|RCtrl|LAlt|RAlt|LWin|RWin)$") {
            result.Push(key)
        }
    }
    return result
}

SendInputWithActiveMods(ActiveMods, VK_Code) {
    DownStr := ""
    UpStr := ""

    for _, ModName in ActiveMods {
        DownStr .= "{" ModName " down}"
        UpStr   .= "{" ModName " up}"
    }

    SendInput(DownStr "{" VK_Code "}" UpStr)

    RestoreDown := ""
    CurrentTrueMods := GetTrueMods() 
    
    for _, modName in CurrentTrueMods {
        RestoreDown .= "{" modName " down}"
    }
    
    if (RestoreDown != "") {
        SendInput(RestoreDown)
    }
}

SendEventWithActiveMods(ActiveMods, VK_Code) {
    DownStr := ""
    UpStr := ""

    for _, ModName in ActiveMods {
        DownStr .= "{" ModName " down}"
        UpStr   .= "{" ModName " up}"
    }

    SendInput(DownStr)
    SendEvent("{" VK_Code "}")
    SendInput(UpStr)

    RestoreDown := ""
    CurrentTrueMods := GetTrueMods()
    for _, modName in CurrentTrueMods {
        RestoreDown .= "{" modName " down}"
    }
    
    if (RestoreDown != "") {
        SendInput(RestoreDown)
    }
}

ArrayJoin(arr, delimiter := ", ") {
    result := ""
    for index, val in arr {
        result .= val . (index == arr.Length ? "" : delimiter)
    }
    return result
}

RepeatKey(ScanCode_of_HoldKey, VirtualKey_of_OutputKey) {
    if !GetKeyState(ScanCode_of_HoldKey, "P")
        return

    Critical("On")
    Send(VirtualKey_of_OutputKey)
    
    Loop 20 {
        Sleep(10)
        if !GetKeyState(ScanCode_of_HoldKey, "P")
            return
    }

    While GetKeyState(ScanCode_of_HoldKey, "P") {
        SendEvent(VirtualKey_of_OutputKey)
        Sleep(50)
    }
}

DualRoleUp(KeyName, RoleName) {
    global HookAgents, ActiveLayers, KeyDef
    OutputDebug("AHK: [DualRoleUp | " KeyName "] 🔼 開始 | Role: " RoleName)

    if !KeyDef.Has(KeyName) {
        OutputDebug("AHK: [DualRoleUp | " KeyName "] ⚠️ 終了: KeyDefに存在しません")
        return   
    }

    SC_Code := KeyDef[KeyName].sc

    if (ActiveLayers.Has(RoleName) && ActiveLayers[RoleName]) {
        OutputDebug("AHK: [DualRoleUp | " KeyName "] レイヤー無効化: " RoleName)
        ActiveLayers[RoleName] := false
        
        if (RoleName ~= "i)^(LShift|RShift|LCtrl|RCtrl|LAlt|RAlt|LWin|RWin)$") {
            SendInput("{" RoleName " up}")
        }
    }

    if (HookAgents.Has(SC_Code) && IsObject(HookAgents[SC_Code]) && HookAgents[SC_Code].InProgress) {
        HookAgents[SC_Code].Stop()
        HookAgents.Delete(SC_Code)
        OutputDebug("AHK: [DualRoleUp | " KeyName "] 🛑 稼働中のHookを停止・削除しました (" SC_Code ")")
    }
}

DualRoleDown(KeyName, RoleName, TimeOut := 0.15) {
    global HookAgents, ActiveLayers, KeyDef
    OutputDebug("AHK: [DualRoleDown | " KeyName "] 🔽 開始 | Role: " RoleName)

    if (!KeyDef.Has(KeyName) || !ActiveLayers.Has(RoleName) || ActiveLayers[RoleName]) {
        return
    }

    SC_Code := KeyDef[KeyName].sc
    VK_Code := KeyDef[KeyName].vk
    ActivatedModsAtDown := GetTrueMods()

    ih := InputHook("T" (TimeOut == 0 ? 0.05 : TimeOut))
    ih.KeyOpt("{All}", "E")
    ih.KeyOpt("{" SC_Code "}", "-E")

    modifierList := ["LShift", "RShift", "LCtrl", "RCtrl", "LAlt", "RAlt", "LWin", "RWin"]
    for _, modKey in modifierList {
        ih.KeyOpt("{" modKey "}", "V -E")
    }

    ih.OnEnd := (ihObj) => ProcessDualRoleResult(ihObj, KeyName, RoleName, SC_Code, VK_Code, ActivatedModsAtDown)

    HookAgents[SC_Code] := ih

    for _, IhAgent in HookAgents {
        if (IhAgent.InProgress) {
             IhAgent.Stop()
        }
    }

    OutputDebug("AHK: [DualRoleDown | " KeyName "] ⏳ 監視開始 (非异步予約完了)")
    ih.Start()
    
    return 
}

ProcessDualRoleResult(ih, KeyName, RoleName, SC_Code, VK_Code, ActivatedModsAtDown) {
    global ActiveLayers
    OutputDebug("AHK: [Callback | " KeyName "] 🏁 事後処理開始 | EndReason: " ih.EndReason)

    if (ih.EndReason == "Timeout" ) {
        if GetKeyState(SC_Code, "P") {
            OutputDebug("AHK: [Callback | " KeyName "] 🕒 長押し判定 -> レイヤー有効化")
            ActiveLayers[RoleName] := A_TickCount

            if (RoleName ~= "i)^(LShift|RShift|LCtrl|RCtrl|LAlt|RAlt|LWin|RWin)$") {
                SendInput("{" RoleName " down}")
            }
        }
    }
    else {
        if (ih.EndReason == "EndKey" || ih.EndReason == "Stopped") {
            OutputDebug("AHK: [Callback | " KeyName "] ⌨️ 単押し判定 | トドメ: " ih.EndKey)
            SendInputWithActiveMods(ActivatedModsAtDown, VK_Code)
            ActiveMods := GetTrueMods()
            SendInput("{" . ih.EndKey . "}")
        }
        else {
            SendEventWithActiveMods(ActivatedModsAtDown, VK_Code)
        }
    }
}

ThumbDualRoleUp(KeyName, RoleName) {
    global HookAgents, ActiveLayers, KeyDef
    OutputDebug("AHK: [ThumbUp | " KeyName "] 🔼 開始 | Role: " RoleName)

    if !KeyDef.Has(KeyName) {
        return
    }

    SC_Code := KeyDef[KeyName].sc
    VK_Code := KeyDef[KeyName].vk

    if (ActiveLayers.Has(RoleName) && ActiveLayers[RoleName]) {
        OutputDebug("AHK: [ThumbUp | " KeyName "] レイヤー無効化: " RoleName)
        ActiveLayers[RoleName] := false

        if (RoleName ~= "i)^(LShift|RShift|LCtrl|RCtrl|LAlt|RAlt|LWin|RWin)$") {
            SendInput("{" RoleName " up}")
        }
    }

    if (HookAgents.Has(SC_Code) && IsObject(HookAgents[SC_Code]) && HookAgents[SC_Code].Inprogress) {
        HookAgents[SC_Code].Stop()
        OutputDebug("AHK: [ThumbUp | " KeyName "] 🛑 Hook停止 | EndReason: " HookAgents[SC_Code].EndReason)

         if (HookAgents[SC_Code].EndReason != "EndKey"){
            OutputDebug("AHK: [ThumbUp | " KeyName "] ⌨️ 単押し送信: " VK_Code)
            SendEvent("{" VK_Code "}")
         } 
        HookAgents.Delete(SC_Code)
    }
}

ThumbDualRoleDown(KeyName, RoleName) {
    global HookAgents, ActiveLayers, KeyDef, KeySnapshot
    OutputDebug("AHK: [ThumbDown | " KeyName "] 🔽 開始 | Role: " RoleName)

    if (!KeyDef.Has(KeyName) || !ActiveLayers.Has(RoleName) || ActiveLayers[RoleName]) {
        OutputDebug("AHK: [ThumbDown | " KeyName "] ⚠️ 終了: 条件不一致 (未定義, または既に有効)")
        return
    }

    SC_Code := KeyDef[KeyName].sc
    VK_Code := KeyDef[KeyName].vk

    ih := InputHook()
    ih.KeyOpt("{All}", "V E")
    ih.KeyOpt("{" SC_Code "}", "V -E")

    modifierList := ["LShift", "RShift", "LCtrl", "RCtrl", "LAlt", "RAlt", "LWin", "RWin"]
    for _, modKey in modifierList {
        ih.KeyOpt("{" modKey "}", "V -E")
    }

    ih.OnEnd := (ihObj) => OutputDebug("AHK: [ThumbDown | " KeyName "] 🏁 Hook終了 | Reason: " ihObj.EndReason " | EndKey: " ihObj.EndKey)

    HookAgents[SC_Code] := ih

    OutputDebug("AHK: [ThumbDown | " KeyName "] ⏳ 監視開始 (リアルタイム待機)")
    ih.Start()

    if GetKeyState(SC_Code, "P") {
        OutputDebug("AHK: [ThumbDown | " KeyName "] 🕒 即時レイヤー有効化 (" RoleName ")")
        Activelayers[RoleName] := A_TickCount

        if (RoleName ~= "i)^(LShift|RShift|LCtrl|RCtrl|LAlt|RAlt|LWin|RWin)$") {
            SendInput("{" RoleName " down}")
        }
    } else {
        OutputDebug("AHK: [ThumbDown | " KeyName "] ⚠️ 物理キーが押されていないためスキップ")
    }
}

ResetAllModifiers() {
    global ActiveLayers, KeySnapshot

    modifierList := ["LShift", "RShift", "LCtrl", "RCtrl", "LAlt", "RAlt", "LWin", "RWin"]
    
    for index, modKey in modifierList {
        Send("{Blind}{" . modKey . " down}")
        Sleep(10) 
        Send("{Blind}{" . modKey . " up}")
    }

    ToolTip("🚨 修飾キーとシステム状態を完全リセットしました！")
    SetTimer(() => ToolTip(), -2000)
}
