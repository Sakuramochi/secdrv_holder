# dummy_app.ps1

Write-Debug( "dummy_app 起動 (*`´▽｀*)" )
Write-Host( "ダミープロセスを起動しました。確認ダイアログを「はい」または「いいえ」をクリックし閉じてください。")
start-process powershell -ArgumentList "date" -verb runas
