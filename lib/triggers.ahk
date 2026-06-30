; #Requires AutoHotkey v2.0


; --- 全体設定 ---
SendMode "Event"
SetKeyDelay -1, 0  ; Eventモードでも遅延なく送信


; ==========================================
; 1. 状態管理
; ==========================================
global ActiveLayers
global KeySnapshot

; レイヤー判定関数（タイムスタンプ・LIFO版）
GetCurrentActiveLayer() {
    global ActiveLayers
    
    latestTime := 0
    currentLayer := "Layer1"
    
    ; Layer2からLayer8まで順番にチェックする
    level := 2
    while (level <= 8) {
        layerName := "Layer" . level
        
        ; そのレイヤーが有効（0ではない）かつ、今まで見つけた中で「一番新しい時刻」なら更新
        if (ActiveLayers.Has(layerName) && ActiveLayers[layerName] > latestTime) {
            latestTime := ActiveLayers[layerName]
            currentLayer := layerName
        }
        level++ 
    }
    
    return currentLayer ; 一番最後に押されたレイヤーの名前を返す
}

GetSortedLayers(ALayers := Map()) {

    temp_activelayers := ALayers.Clone()
    sorted_layers := []

    while(1) {
        latest_time := 0
        latest_layer := ""
        
        for layers, activated_time in temp_activelayers {
            if (layers ~= "i)^(LShift|RShift|LCtrl|RCtrl|LAlt|RAlt|LWin|RWin)$") {
                ; for文で参照中のイテレータの要素を消去するのはだめ
                ; temp_activelayers.Delete(layers)
                continue
            }
            if (latest_time <= activated_time && activated_time != 0) {
                latest_time := activated_time
                latest_layer := layers
            }
        }
        
        if (latest_layer == ""){
            break
        }

        sorted_layers.Push(latest_layer)
        temp_activelayers.Delete(latest_layer)
    }
    ; array type で、先頭から順に新しく有効化されたlayerの名前が入っている
    return sorted_layers
}

; ==========================================
; 3. 共通ルーター
; ==========================================
Router_KeyDown(ThisHotkey) {
    OutputDebug("AHK:RouterKeyDown(" ThisHotkey ")が実行されました")
    global ActiveLayers
    global ScToKeyName
    global KeySnapshot
    cleanKey := StrReplace(ThisHotkey, "*", "")
    OutputDebug("AHK:RouterKeyDown(" ScToKeyName[cleanKey] ")が実行されました")
    ; ==================================================
    ; オートリピートの安全な処理
    ; ==================================================
    if (KeySnapshot.Has(cleanKey)) {
        if (KeySnapshot[cleanKey] == "Layer1_Normal") {
            SendEvent("{" cleanKey " down}") ; スペース除去済み
        }
        return
    }

; レイヤーの履歴を辿って、hotkeyを探索して該当しなければdefault Layerの1のhotkeyを実行するように組み替える、 
    sorted_layer := GetSortedLayers(ActiveLayers)
    for index, value in sorted_layer {
        funcName := "Action_" value "_" cleanKey "_Down"
        try {
            ; funcRef := %funcName%()
            funcRef := %funcName%
            KeySnapshot[cleanKey] := value
            funcRef()
            return
        }
        catch {
            continue
        }
    }
    KeySnapshot[cleanKey] := "Layer1_Normal"
    ; 最終key
    SendEvent("{" cleanKey " down}") ; スペース除去済み
    ; SafeSendEvent("{Blind}{" cleanKey " down}") ; スペース除去済み
    ; SafeSendEvent("{" cleanKey " down}") ; スペース除去済み
}

Router_KeyUp(ThisHotkey) {
    global KeySnapshot
    global ScToKeyName
    
    ; "*sc01E up" などの文字列から "sc01E" だけを綺麗に抽出
    cleanKey := StrReplace(StrReplace(ThisHotkey, "*", ""), " up", "")

    ; if GetKeyState(cleanKey, "P"){
    ;     return
    ; }
    ; sleep(30)
    if GetKeyState(cleanKey, "P"){
        return
    }

    
    OutputDebug("AHK:RouterKeyUp(" ScToKeyName[cleankey] ")が実行されました")
    ; 記憶を取り出す（万が一記憶が消えていたら、安全のためLayer1とする）
    ; savedState := KeySnapshot.Has(cleanKey) ? KeySnapshot[cleanKey] : "Layer1"
    if(KeySnapshot.Has(cleanKey)){ 
        savedState :=   KeySnapshot[cleanKey]
     }
     else {
        return
     }
     
    ; ==================================================
    ; 状態の復元と「普通キー」フラグの作成
    ; ==================================================
    if (savedState == "Layer1_Normal") {
        ; 普通の文字だった場合、関数の検索用には "Layer1" に戻しつつ、
        ; 「これは普通の文字だよ！」というフラグ(目印)を立てておく
        savedLayer := "Layer1"
        isNormalKey := true
    } 
    else {
        ; マクロや他のレイヤーだった場合はそのまま使い、フラグは折る
        savedLayer := savedState
        isNormalKey := false
    }
    
    ; 実行すべき関数名を組み立てる（例: Action_Layer1_sc01E_Up）
    funcName := "Action_" savedLayer "_" cleanKey "_Up"
    
    try {
        ; Up用の専用関数が存在すれば、それを実行する（DualRoleのUp処理など）
        %funcName%()
    } catch {
        ; ここが最大のポイント！
        ; Upの専用関数が存在せず、かつ「普通の文字（isNormalKeyがtrue）」だった場合のみ、
        ; OSに対して「キーが離された(up)」という信号を送る。
        ; （マクロキーや、Layer2/3の未定義キーの時は何もしない＝漏れ防止）
        if (isNormalKey) {
            SendEvent("{" cleanKey " up}")
            ; SafeSendEvent("{Blind}{" cleanKey " up}")
            ; SafeSendEvent("{" cleanKey " up}")
        }
    }
    
    ; 処理が終わったら、次の入力のために記憶を綺麗に消去（お片付け）
    ; KeySnapshot.Delete(cleanKey)
    ; 記憶が存在している場合のみ削除を実行する
    if KeySnapshot.Has(cleanKey) {
        KeySnapshot.Delete(cleanKey)
    }

}

; ==========================================================
; 独立グローバルショートカット (レイヤー非依存)
; ==========================================================
*F12::ShowDebugInfo()



!t:: {
    static isTransparent := false
    activeHwnd := WinExist("A") 
    
    if (isTransparent) {
        WinSetTransparent(255, activeHwnd)
        isTransparent := false
    } else {
        WinSetTransparent(200, activeHwnd)
        isTransparent := true
    }
}
; ----------------------------------------------------------
; テスト用：[Ctrl] + [Alt] + [Esc] を押した時にリセット発動！
; ----------------------------------------------------------
*F2::ResetAllModifiers()

; ; ==========================================================
; ; Layer1: 修飾キー (Modifier) の処理 (DualRole統合版)
; ; ==========================================================
; --- Ctrl ---
Action_Layer1_sc01D_Down() {
    DualRoleDown("LCtrl", "LCtrl", 0)
}
Action_Layer1_sc01D_Up() {
    DualRoleUp("LCtrl", "LCtrl")
}
Action_Layer1_sc11D_Down() {
    DualRoleDown("RCtrl", "RCtrl", 0)
}
Action_Layer1_sc11D_Up() {
    DualRoleUp("RCtrl", "RCtrl")
}

; --- Alt ---
Action_Layer1_sc038_Down() {
    DualRoleDown("LAlt", "LAlt", 0)
}
Action_Layer1_sc038_Up() {
    DualRoleUp("LAlt", "LAlt")
}
Action_Layer1_sc138_Down() {
    DualRoleDown("RAlt", "RAlt", 0)
}
Action_Layer1_sc138_Up() {
    DualRoleUp("RAlt", "RAlt")
}

; --- Win ---
Action_Layer1_sc15B_Down() {
    DualRoleDown("LWin", "LWin", 0)
}
Action_Layer1_sc15B_Up() {
    DualRoleUp("LWin", "LWin")
}
Action_Layer1_sc15C_Down() {
    DualRoleDown("RWin", "RWin", 0)
}
Action_Layer1_sc15C_Up() {
    DualRoleUp("RWin", "RWin")
}

; --- Shift ---
Action_Layer1_sc02A_Down() {
    DualRoleDown("LShift", "LShift", 0)
}
Action_Layer1_sc02A_Up() {
    DualRoleUp("LShift", "LShift")
}
Action_Layer1_sc136_Down() {
    DualRoleDown("RShift", "RShift", 0)
}
Action_Layer1_sc136_Up() {
    DualRoleUp("RShift", "RShift")
}
Action_Layer1_sc039_Down() {
    ThumbDualRoleDown("space", "LShift")
}

Action_Layer1_sc039_Up() {
    ThumbDualRoleUp("space", "LShift")
}

; ----------------------------------------------------------
;  ホームロウ・モッズ (sc020 / d)
; ----------------------------------------------------------
; Action_Layer1_sc020_Down() {
;     DualRoleDown("d", "RShift", 0.15)
; }
; Action_Layer1_sc020_Up() {
;     DualRoleUp("d", "RShift")
; }
Action_Layer1_sc020_Down() {
    DualRoleDown("d", "RCtrl", 0.15)
}
Action_Layer1_sc020_Up() {
    DualRoleUp("d", "RCtrl")
}

; ----------------------------------------------------------
;  Layer 2 起動キー (sc01E / a, sc079 / 変換)
; ----------------------------------------------------------
Action_Layer1_sc01E_Down() {
    DualRoleDown("a", "Layer2", 0.25)
    ; DualRoleDown("a", "Layer2", 4.45)
}
Action_Layer1_sc01E_Up() {
    DualRoleUp("a", "Layer2")
}

Action_Layer1_sc079_Down() {
    ThumbDualRoleDown("henkan", "Layer2")
}
Action_Layer1_sc079_Up() {
    ThumbDualRoleUp("henkan", "Layer2")
}

Action_Layer1_sc1F2_Down() {
    ThumbDualRoleDown("mac_kana", "Layer2")
}
Action_Layer1_sc1F2_Up() {
    ThumbDualRoleUp("mac_kana", "Layer2")
}


; Action_Layer1_sc079_Down() {
;     DualRoleDown("henkan", "Layer2", 0.09)
; }
; Action_Layer1_sc079_Up() {
;     DualRoleUp("henkan", "Layer2")
; }

; ----------------------------------------------------------
;  Layer 3 起動キー (sc027 / ;, sc07B / 無変換)
; ----------------------------------------------------------
Action_Layer1_sc027_Down() {
    DualRoleDown(";", "Layer3", 0.15)
}
Action_Layer1_sc027_Up() {
    DualRoleUp(";", "Layer3")
}

; Action_Layer1_sc07B_Down() {
;     DualRoleDown("muhenkan", "Layer3", 0.09)
; }
; Action_Layer1_sc07B_Up() {
;     DualRoleUp("muhenkan", "Layer3")
; }

Action_Layer1_sc07B_Down() {
    ThumbDualRoleDown("muhenkan", "Layer3")
}
Action_Layer1_sc07B_Up() {
     ThumbDualRoleUp("muhenkan", "Layer3")
}
