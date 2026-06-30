; ==========================================
; 👑 ソフトウェア同期型：絶対的モディファイア全制圧 (ActiveLayers統合版)
; ==========================================

; --------------------------------------------------
; ⬇️ 汎用同期関数：モディファイアが「押された時」
; --------------------------------------------------
SyncModDown(ModName) {
    global ActiveLayers
    
    ; 既にON（true）なら、OSからのオートリピート連打信号を無視する
    if (ActiveLayers[ModName])
        return
        
    ; 配電盤のスイッチをONにして、OSへ物理的な押し込み信号を送る
    ActiveLayers[ModName] := true
    SendEvent("{Blind}{" ModName " down}")
}

SyncModUp(ModName) {
    global ActiveLayers
    
    ; 1. 配電盤をOFFにする（既存の処理）
    ActiveLayers[ModName] := false
    ; 3. OSに離し信号を送る（既存の処理）
    SendEvent("{Blind}{" ModName " up}")
}




; ; ==========================================
; ; 🛡️ 各モディファイアへの適用 (ルーティング)
; ; ==========================================
;
; ; --- Ctrl ---
; $*LCtrl::SyncModDown("LCtrl")
; $*LCtrl up::SyncModUp("LCtrl")
; $*RCtrl::SyncModDown("RCtrl")
; $*RCtrl up::SyncModUp("RCtrl")
;
; ; --- Alt ---
; $*LAlt::SyncModDown("LAlt")
; $*LAlt up::SyncModUp("LAlt")
; $*RAlt::SyncModDown("RAlt")
; $*RAlt up::SyncModUp("RAlt")
;
; ; --- Win ---
; $*LWin::SyncModDown("LWin")
; $*LWin up::SyncModUp("LWin")
; $*RWin::SyncModDown("RWin")
; $*RWin up::SyncModUp("RWin")
;
; ; --- Shift ---
; $*LShift::SyncModDown("LShift")
; $*LShift up::SyncModUp("LShift")
; $*RShift::SyncModDown("RShift")
; $*RShift up::SyncModUp("RShift")

