; スクリプトを強制的に常駐（待機状態）にさせる
Persistent()
; ==========================================================
; main.ahk - 司令塔（初期設定とファイルの読み込み）
; ==========================================================

; --- システム設定 ---
A_MaxHotkeysPerInterval := 500

; 管理者権限の再起動処理
if !A_IsAdmin {
    try {
        Run('*RunAs "C:\Users\sou\scoop\apps\autohotkey\2.0.21\v2\AutoHotkey64.exe" /restart "C:\Users\sou\.config\autohotkey\main.ahk"')
    }
    ExitApp
}
compileTime := FormatTime(A_Now, "yyyyMMdd_HHmmss")
MsgBox "起動しました。`nコンパイル目安時刻: " compileTime

; --- ファイルの読み込み（順番が重要！） ---
#Include "lib\globals.ahk"
; #Include "lib\ModifierSync.ahk"
#Include "lib\utils.ahk"
#Include "lib\triggers.ahk"
#Include "lib\keymaps.ahk"
; #Include "lib\keymaps_komorebi.ahk"
