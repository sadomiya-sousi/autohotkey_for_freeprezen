; ==========================================================
; Layer4: Komorebi ウィンドウマネジメント (whkd移植版)
; ==========================================================
; ※ RMenu (右Alt) などを Layer4 の起動キーに設定している前提です

; --- 再読み込み・トグル系 ---
; o (Shift+O で設定リロード)
Action_Layer4_sc018_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("reload-configuration") : ""
; i (ショートカットのトグル)
Action_Layer4_sc017_Down() => Komorebic("toggle-shortcuts")
; a (Obsidianの強制フォーカス)
Action_Layer4_sc01E_Down() => Komorebic("eager-focus Obsidian.exe")
; q (ウィンドウを閉じる)
Action_Layer4_sc010_Down() => Komorebic("close")
; m (ウィンドウ最小化)
Action_Layer4_sc032_Down() => Komorebic("minimize")


; ---  フォーカス & ウィンドウ移動 (H, J, K, L) ---
; ShiftがONなら「move(移動)」、OFFなら「focus(フォーカス)」
Action_Layer4_sc023_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("move left")  : Komorebic("focus left")
Action_Layer4_sc024_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("move down")  : Komorebic("focus down")
Action_Layer4_sc025_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("move up")    : Komorebic("focus up")
Action_Layer4_sc026_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("move right") : Komorebic("focus right")


; ---  スタック・フォーカス循環 ([ と ]) ---
; [ (oem_4)
Action_Layer4_sc01B_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("cycle-focus previous") : Komorebic("cycle-stack previous")
; ] (oem_6)
Action_Layer4_sc02B_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("cycle-focus next")     : Komorebic("cycle-stack next")


; ---  スタック作成・解除 (矢印キー, Enter, ;) ---
Action_Layer4_sc14B_Down() => Komorebic("stack left")   ; Left Arrow
Action_Layer4_sc150_Down() => Komorebic("stack down")   ; Down Arrow
Action_Layer4_sc148_Down() => Komorebic("stack up")     ; Up Arrow
Action_Layer4_sc14D_Down() => Komorebic("stack right")  ; Right Arrow
Action_Layer4_sc01C_Down() => Komorebic("promote-swap") ; Enter
Action_Layer4_sc027_Down() => Komorebic("unstack")      ; ; (oem_1)


; ---  リサイズ (^ と -) ---
; ^ (ハット: JIS配列における oem_plus 相当)
Action_Layer4_sc00D_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("resize-axis vertical increase") : Komorebic("resize-axis horizontal increase")
; - (マイナス: JIS配列における oem_minus 相当)
Action_Layer4_sc00C_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("resize-axis vertical decrease") : Komorebic("resize-axis horizontal decrease")


; ---  ウィンドウ操作・レイアウト (T, F11, R, P, X, Y) ---
Action_Layer4_sc014_Down() => Komorebic("toggle-float")           ; t
Action_Layer4_sc057_Down() => Komorebic("toggle-monocle")         ; F11 (単押しF11の最大化はLayer1に記載)
Action_Layer4_sc013_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("retile") : "" ; r
Action_Layer4_sc019_Down() => Komorebic("toggle-pause")           ; p
Action_Layer4_sc02D_Down() => Komorebic("flip-layout horizontal") ; x
Action_Layer4_sc015_Down() => Komorebic("flip-layout vertical")   ; y


; ---  ワークスペースへ「送る」 (F13 ~ F24) ---
; RMenu(Layer4) + F13~F24 は "send-to-workspace"
; Action_Layer4_sc064_Down() => Komorebic("send-to-workspace 0")  ; F13
; Action_Layer4_sc065_Down() => Komorebic("send-to-workspace 1")  ; F14
; Action_Layer4_sc066_Down() => Komorebic("send-to-workspace 2")  ; F15
; Action_Layer4_sc067_Down() => Komorebic("send-to-workspace 3")  ; F16
; Action_Layer4_sc068_Down() => Komorebic("send-to-workspace 4")  ; F17
; Action_Layer4_sc069_Down() => Komorebic("send-to-workspace 5")  ; F18
; Action_Layer4_sc06A_Down() => Komorebic("send-to-workspace 6")  ; F19
; Action_Layer4_sc06B_Down() => Komorebic("send-to-workspace 7")  ; F20
; Action_Layer4_sc06C_Down() => Komorebic("send-to-workspace 8")  ; F21
; Action_Layer4_sc06D_Down() => Komorebic("send-to-workspace 9")  ; F22
; Action_Layer4_sc06E_Down() => Komorebic("send-to-workspace 10") ; F23
; Action_Layer4_sc076_Down() => Komorebic("send-to-workspace 11") ; F24
; ==========================================================
;  Layer4: ワークスペース切り替え・移動 (三項演算子版)
; ==========================================================
; ActiveLayers の LShift/RShift 状態を参照し、
; 真（ON）なら send-to-workspace、偽（OFF）なら focus-workspace を実行します。

; Action_Layer4_sc032_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 0")  : Komorebic("focus-workspace 0")  ; m
; Action_Layer4_sc031_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 1")  : Komorebic("focus-workspace 1")  ; n
;
; Action_Layer4_sc023_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 2")  : Komorebic("focus-workspace 2")  ; h
; Action_Layer4_sc024_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 3")  : Komorebic("focus-workspace 3")  ; j
; Action_Layer4_sc025_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 4")  : Komorebic("focus-workspace 4")  ; k
; Action_Layer4_sc026_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 5")  : Komorebic("focus-workspace 5")  ; l
; Action_Layer4_sc027_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 6")  : Komorebic("focus-workspace 6")  ; ;
;
; Action_Layer4_sc035_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 7")  : Komorebic("focus-workspace 7")  ; /
; Action_Layer4_sc034_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 8")  : Komorebic("focus-workspace 8")  ; .
; Action_Layer4_sc033_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 9")  : Komorebic("focus-workspace 9")  ; ,
; Action_Layer4_sc028_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 10") : Komorebic("focus-workspace 10") ; :
; Action_Layer4_sc073_Down() => (ActiveLayers["LShift"] || ActiveLayers["RShift"]) ? Komorebic("send-to-workspace 11") : Komorebic("focus-workspace 11") ; \

; ==========================================================
;  Layer1 (通常時) のKomorebi操作補足
; ==========================================================

; 単押し F11 はトグル最大化
Action_Layer1_sc057_Down() => Komorebic("toggle-maximize")

; 単押し F13~F24 はワークスペースの「移動 (focus)」
; Action_Layer1_sc064_Down() => Komorebic("focus-workspace 0")  ; F13
; Action_Layer1_sc065_Down() => Komorebic("focus-workspace 1")  ; F14
; Action_Layer1_sc066_Down() => Komorebic("focus-workspace 2")  ; F15
; Action_Layer1_sc067_Down() => Komorebic("focus-workspace 3")  ; F16
; Action_Layer1_sc068_Down() => Komorebic("focus-workspace 4")  ; F17
; Action_Layer1_sc069_Down() => Komorebic("focus-workspace 5")  ; F18
; Action_Layer1_sc06A_Down() => Komorebic("focus-workspace 6")  ; F19
; Action_Layer1_sc06B_Down() => Komorebic("focus-workspace 7")  ; F20
; Action_Layer1_sc06C_Down() => Komorebic("focus-workspace 8")  ; F21
; Action_Layer1_sc06D_Down() => Komorebic("focus-workspace 9")  ; F22
; Action_Layer1_sc06E_Down() => Komorebic("focus-workspace 10") ; F23
; Action_Layer1_sc076_Down() => Komorebic("focus-workspace 11") ; F24
