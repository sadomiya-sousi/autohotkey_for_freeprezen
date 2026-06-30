; ==========================================
; 5. Layer2 の処理群（マウス操作・ワークスペース切替）
; ==========================================

; --- 数字段 (12345...) ---
; Action_Layer2_sc002_Down() => ""                                  ; 1
; Action_Layer2_sc003_Down() => ""                                  ; 2
; Action_Layer2_sc004_Down() => ""                                  ; 3
; Action_Layer2_sc005_Down() => ""                                  ; 4
; Action_Layer2_sc006_Down() => ""                                  ; 5
; Action_Layer2_sc007_Down() => ""                                  ; 6
; Action_Layer2_sc008_Down() => ""                                  ; 7
; Action_Layer2_sc009_Down() => ""                                  ; 8
; Action_Layer2_sc00A_Down() => ""                                  ; 9
; Action_Layer2_sc00B_Down() => ""                                  ; 0
; Action_Layer2_sc00C_Down() => ""                                  ; - (ほ)
; Action_Layer2_sc00D_Down() => ""                                  ; ^ (へ)
; Action_Layer2_sc07D_Down() => ""                                  ; ¥ (ー)
; Action_Layer2_sc00E_Down() => ""                                  ; BackSpace

; --- 上段 (QWERT...) ---
; Action_Layer2_sc00F_Down() => ""                                  ; Tab
; Action_Layer2_sc010_Down() => Click("Down")                         ; q
; qキーを押すたびに、左クリックの Down と Up を反転させる
Action_Layer2_sc011_Down() => Click("Down")                         ; w
Action_Layer2_sc011_Up()   => Click("Up")
Action_Layer2_sc012_Down() => GetKeyState("LButton") ? Click("Up") : Click("Down")                                  ; e
Action_Layer2_sc013_Down() => ""                                    ; r
Action_Layer2_sc013_Up()   => Click("Right")
; Action_Layer2_sc014_Down() => ""                                  ; t
; Action_Layer2_sc015_Down() => ""                                  ; y
; Action_Layer2_sc016_Down() => ""                                  ; u
Action_Layer2_sc017_Down() => ""                                    ; i
Action_Layer2_sc017_Up()   => Send("{Blind}#{Tab}")
; Action_Layer2_sc018_Down() => ""                                  ; o
; Action_Layer2_sc019_Down() => ""                                  ; p
; Action_Layer2_sc01A_Down() => ""                                  ; @
; Action_Layer2_sc01B_Down() => ""                                  ; [

; --- 中段 (ASDFG...) ---
; Action_Layer2_sc01D_Down() => ""                                    ;LCtrl
; Action_Layer2_sc01E_Down() => ""                                  ; a
Action_Layer2_sc01F_Down() {                                        ; s (マウス左)
    while GetKeyState("sc01F", "P") {
        moveDist := GetKeyState("Shift", "P") ? 2 : 11
        MouseMove(-moveDist, 0, 0, "R")
        Sleep(8)
    }
}
Action_Layer2_sc020_Down() {                                        ; d (マウス上)
    while GetKeyState("sc020", "P") {
        moveDist := GetKeyState("Shift", "P") ? 2 : 11
        MouseMove(0, -moveDist, 0, "R")
        Sleep(8)
    }
}
Action_Layer2_sc021_Down() {                                        ; f (マウス下)
    while GetKeyState("sc021", "P") {
        moveDist := GetKeyState("Shift", "P") ? 2 : 11
        MouseMove(0, moveDist, 0, "R")
        Sleep(8)
    }
}
Action_Layer2_sc022_Down() {                                        ; g (マウス右)
    while GetKeyState("sc022", "P") {
        moveDist := GetKeyState("Shift", "P") ? 2 : 11
        MouseMove(moveDist, 0, 0, "R")
        Sleep(8)
    }
}
Action_Layer2_sc023_Down() => ""                                    ; h
Action_Layer2_sc023_Up()   => SendEvent("{Blind}{F15}")
Action_Layer2_sc024_Down() => ""                                    ; j
Action_Layer2_sc024_Up()   => SendEvent("{Blind}{F16}")
Action_Layer2_sc025_Down() => ""                                    ; k
Action_Layer2_sc025_Up()   => SendEvent("{Blind}{F17}")
Action_Layer2_sc026_Down() => ""                                    ; l
Action_Layer2_sc026_Up()   => SendEvent("{Blind}{F18}")
Action_Layer2_sc027_Down() => ""                                    ; ;
Action_Layer2_sc027_Up()   => SendEvent("{Blind}{F19}")
Action_Layer2_sc028_Down() => ""                                    ; :
Action_Layer2_sc028_Up()   => SendEvent("{Blind}{F23}")
Action_Layer2_sc02B_Down() => ""                                  ; ]
; Action_Layer2_sc01C_Down() => ""                                  ; Enter

; --- 下段 (ZXCVB...) ---
; Action_Layer2_sc02A_Down() => ""                                  ;LShift
Action_Layer2_sc02C_Down() {                                        ; z (スクロール左等)
    while GetKeyState("sc02C", "P") {
        delta := GetKeyState("Shift", "P") ? -120 : -30
        DllCall("mouse_event", "uint", 0x1000, "int", 0, "int", 0, "int", delta, "ptr", 0)
        Sleep(10)
    }
}
Action_Layer2_sc02D_Down() {                                        ; x (スクロール下)
    while GetKeyState("sc02D", "P") {
        delta := GetKeyState("Shift", "P") ? -120 : -30
        DllCall("mouse_event", "uint", 0x0800, "int", 0, "int", 0, "int", delta, "ptr", 0)
        Sleep(10)
    }
}
Action_Layer2_sc02E_Down() {                                        ; c (スクロール上)
    while GetKeyState("sc02E", "P") {
        delta := GetKeyState("Shift", "P") ? 120 : 30
        DllCall("mouse_event", "uint", 0x0800, "int", 0, "int", 0, "int", delta, "ptr", 0)
        Sleep(10)
    }
}
Action_Layer2_sc02F_Down() {                                        ; v (スクロール右等)
    while GetKeyState("sc02F", "P") {
        delta := GetKeyState("Shift", "P") ? 120 : 30
        DllCall("mouse_event", "uint", 0x1000, "int", 0, "int", 0, "int", delta, "ptr", 0)
        Sleep(10)
    }
}
Action_Layer2_sc030_Down() => ""                                  ; b
Action_Layer2_sc031_Down() => ""                                    ; n
Action_Layer2_sc031_Up()   => SendEvent("{Blind}{F14}")
Action_Layer2_sc032_Down() => ""                                    ; m
Action_Layer2_sc032_Up()   => SendEvent("{Blind}{F13}")
Action_Layer2_sc033_Down() => ""                                    ; ,
Action_Layer2_sc033_Up()   => SendEvent("{Blind}{F22}")
Action_Layer2_sc034_Down() => ""                                    ; .
Action_Layer2_sc034_Up()   => SendEvent("{Blind}{F21}")
Action_Layer2_sc035_Down() => ""                                    ; /
Action_Layer2_sc035_Up()   => SendEvent("{Blind}{F20}")
Action_Layer2_sc073_Down() => ""                                    ; \ (ろ)
Action_Layer2_sc073_Up()   => SendEvent("{Blind}{F24}")
; Action_Layer2_sc036_Down() => ""                                    ; RShift
; --- 親指・その他 ---
; Action_Layer2_sc029_Down() => ""                                  ; 半角/全角
; Action_Layer2_sc07B_Down() => ""                                  ; 無変換
; Action_Layer2_sc039_Down() => ""                                  ; Space
; Action_Layer2_sc079_Down() => ""                                  ; 変換
; Action_Layer2_sc070_Down() => ""                                  ; カタカナ/ひらがな
; ==========================================
; 4. Layer3 の処理群（ナビゲーション・ショートカット）
; ==========================================

; --- 数字段 (12345...) ---
Action_Layer3_sc002_Down() =>  komorebic("manage")                                ; 1
Action_Layer3_sc003_Down() => komorebic("unmanage")                                  ; 2
Action_Layer3_sc004_Down() => komorebic("minimize")                                  ; 3
Action_Layer3_sc005_Down() => WinActive("ahk_exe obsidian.exe")                                ; 4
Action_Layer3_sc006_Down() => komorebic("eager-focus Obsidian.exe")                                  ; 5
; Action_Layer3_sc007_Down() => ""                                  ; 6
; Action_Layer3_sc008_Down() => ""                                  ; 7
; Action_Layer3_sc009_Down() => ""                                  ; 8
; Action_Layer3_sc00A_Down() => ""                                  ; 9
; Action_Layer3_sc00B_Down() => ""                                  ; 0
; Action_Layer3_sc00C_Down() => ""                                  ; - (ほ)
; Action_Layer3_sc00D_Down() => ""                                  ; ^ (へ)
; Action_Layer3_sc07D_Down() => ""                                  ; ¥ (ー)
; Action_Layer3_sc00E_Down() => ""                                  ; BackSpace

; --- 上段 (QWERT...) ---
; Action_Layer3_sc00F_Down() => ""                                  ; Tab
Action_Layer3_sc010_Down() => ""                                    ; q
Action_Layer3_sc010_Up()   => Send("{Blind}#{vk48}")
Action_Layer3_sc011_Down() => RepeatKey("sc011", "{Blind}+!{vk1B}") ; w
Action_Layer3_sc012_Down() => ""                                    ; e
Action_Layer3_sc012_Up()   => Komorebic("toggle-maximize")
Action_Layer3_sc013_Down() => ""                                    ; r
Action_Layer3_sc013_Up()   => Send("{Blind}!{vk73}")
Action_Layer3_sc014_Down() => RepeatKey("sc014", "{Blind}+{vk79}")  ; t
; Action_Layer3_sc015_Down() => ""                                  ; y
Action_Layer3_sc016_Down() => RepeatKey("sc016", "{Blind}{vk08}")   ; u
; Action_Layer3_sc017_Down() => ""                                  ; i
Action_Layer3_sc018_Down() => RepeatKey("sc018", "{Blind}{vk2E}")   ; o
; Action_Layer3_sc019_Down() => ""                                  ; p
Action_Layer3_sc01A_Down() => RepeatKey("sc01A", "{PgUp}")          ; @
; Action_Layer3_sc01B_Down() => ""                                  ; [

; --- 中段 (ASDFG...) ---
; Action_Layer3_sc01D_Down() => ""                                    ;LCtrl
; Action_Layer3_sc01E_Down() => RepeatKey("sc01E", "{Blind}{vk24}")   ; a
; なぜか,sands + homeが効かない>Blindを外してみる
Action_Layer3_sc01E_Down() => SendEvent("{home}")   ; a
; Action_Layer3_sc01F_Down() => RepeatKey("sc01F", "{Blind}#{vk32}")  ; s
; Action_Layer3_sc01F_Down() => RunOrActivate("ahk_exe obsidian.exe", "obsidian.exe") ;s
; Action_Layer3_sc01F_Down() => RunOrActivate("Obsidian ahk_exe Obsidian.exe", "C:\Users\sou\scoop\apps\obsidian\current\obsidian.exe")
; Action_Layer3_sc01F_Down() => SmartObsidianToggle() ;s
Action_Layer3_sc01F_Down() =>  SendEvent("#{vk32}")                  ;s

Action_Layer3_sc020_Down() => RepeatKey("sc020", "{Blind}{vk1B}")   ; d
Action_Layer3_sc021_Down() => RepeatKey("sc021", "{Blind}{vk09}")   ; f
Action_Layer3_sc022_Down() => RepeatKey("sc022", "{Blind}+{vk09}")  ; g
; Action_Layer3_sc023_Down() => RepeatKey("sc023", "{Blind}{vk25}")   ; h
;
; Action_Layer3_sc024_Down() => RepeatKey("sc024", "{Blind}{vk28}")   ; j
; Action_Layer3_sc025_Down() => RepeatKey("sc025", "{Blind}{vk26}")   ; k
; Action_Layer3_sc026_Down() => RepeatKey("sc026", "{Blind}{vk27}")   ; l
; Action_Layer3_sc023_Down() => RepeatKey("sc023", "{Blind}{Left}")   ; h (vk25 -> Left)
;
; Action_Layer3_sc024_Down() => RepeatKey("sc024", "{Blind}{Down}")   ; j (vk28 -> Down)
; Action_Layer3_sc025_Down() => RepeatKey("sc025", "{Blind}{Up}")     ; k (vk26 -> Up)
; Action_Layer3_sc026_Down() => RepeatKey("sc026", "{Blind}{Right}")  ; l (vk27 -> Right


Action_Layer3_sc023_Down() => RepeatKey("sc023", "{Left}")   ; h (vk25 -> Left)

Action_Layer3_sc024_Down() => RepeatKey("sc024", "{Down}")   ; j (vk28 -> Down)
Action_Layer3_sc025_Down() => RepeatKey("sc025", "{Up}")     ; k (vk26 -> Up)
Action_Layer3_sc026_Down() => RepeatKey("sc026", "{Right}")  ; l (vk27 -> Right


; sands + endもshiftが効いてないのでsandsを外してみる
; Action_Layer3_sc027_Down() => RepeatKey("sc027", "{Blind}{vk23}")   ; ;
Action_Layer3_sc027_Down() => SendEvent("{End}")   ; ;
Action_Layer3_sc028_Down() => Send("{Blind}{PgDn}")                 ; :
; Action_Layer3_sc02B_Down() => ""                                  ; ]
; Action_Layer3_sc01C_Down() => ""                                  ; Enter

; --- 下段 (ZXCVB...) ---
; Action_Layer3_sc02A_Down() =>                                       ;LShift
; Action_Layer3_sc02C_Down() => ""                                  ; z
; Action_Layer3_sc02D_Down() => ""                                  ; x
Action_Layer3_sc02E_Down() => RepeatKey("sc02E", "{Blind}{vk2C}")   ; c
; Action_Layer3_sc02F_Down() => ""                                  ; v
; Action_Layer3_sc030_Down() => ""                                  ; b
; Action_Layer3_sc031_Down() => ""                                  ; n
Action_Layer3_sc032_Down() => GrabFloatingWindow()
; Action_Layer3_sc033_Down() => ""                                  ; ,
; Action_Layer3_sc034_Down() => ""                                  ; .
; Action_Layer3_sc035_Down() => ""                                  ; /
; Action_Layer3_sc073_Down() => ""                                  ; \ (ろ)
; Action_Layer3_sc036_Down() =>                                       ;RShift
; --- 親指・その他 ---
; Action_Layer3_sc029_Down() => ""                                  ; 半角/全角
Action_Layer3_sc07B_Down() => ""                                    ; 無変換
Action_Layer3_sc039_Down() => RepeatKey("sc039", "{Blind}{vk0D}")   ; Space
Action_Layer3_sc079_Down() => RepeatKey("sc079", "!{vk09}")         ; 変換
; Action_Layer3_sc070_Down() => ""                                  ; カタカナ/ひらがな
; ==========================================
; 2. ホットキーの一括登録 (KeyDef全登録 ＋ 安全フィルター)
; ==========================================
; ※複数行ループ構造のため維持します

for keyName, keyData in KeyDef {

    if (keyName == "f12") {
        continue ; 登録をスキップして次のキーへ
    }

    ; スキップされなかった安全なキー（a~z, F1~F24, 記号など）をすべて登録！
    targetSC := keyData.sc

    Hotkey("*" targetSC, Router_KeyDown)
    Hotkey("*" targetSC " up", Router_KeyUp)
}
