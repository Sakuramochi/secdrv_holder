#secdrv_holder.ps1
#---------------------------------------------------------------------------#
# 言語
# Windows Powershell

# アプリケーション情報
$app_path = 'F:\Game\Electronic Arts\SimPeople\Sims.exe'
$app_args = "-r 1024x768 -w"

# simsブラックアウト対策
$dummy_app_FLG = 1 # 1:dummy_app.psの起動をメッセージで促す

# アプリケーション起動待ち時間
$sleep_sec = 10
#---------------------------------------------------------------------------#

# デバッグ出力設定
#$DebugPreference = "Continue"
#$DebugPreference = "SilentlyContinue"


# ファイル読み込み
$script_dir = Split-Path -Parent $MyInvocation.MyCommand.Path
. $script_dir\module\Set-secdrv.ps1
. $script_dir\module\secdrv_holder_child1.ps1
. $script_dir\module\secdrv_holder_child2.ps1

$dummy_app = "$script_dir\dummy_app.ps1"

Write-Debug( "parent app_path {0} app_args {1}" -f $app_path, $app_args )

# 管理者権限チェック
$id = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())

if (!($id.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))) {
    Write-Warning "管理者として実行していません。終了します。"
    exit 1
}

if( !(Test-Path ($app_path)) )
{
    Write-Warning( "{0}が見つかりません。終了します。" -f $app_path )
    exit
}

try{
    # secdrv起動
    # アプリケーション起動
    secdrv_holder_child1 -app_path $app_path -app_args $app_args

    # secdrv状態表示
    write-Host( "secdrv:State[{0}] Startup[{1}]" `
        -f (Get-Service secdrv).Status.toString(), `
        (Get-WmiObject -Query "select * from win32_baseService where name='secdrv'").StartMode)

    if( $dummy_app_FLG -eq 1 )
    {
        # ダミープロセスを管理者として実行するようにメッセージを出す
        write-Warning( "ダミープロセス{0}を手動で起動し、UAC確認ダイアログを閉じてください。"  -f $dummy_app )
    }

    # Sleep
    Start-Sleep -s $sleep_sec

    # アプリケーション監視
    # secdrv停止
    secdrv_holder_child2 -app_path $app_path

}
finally
{
    Set-Secdrv stop Disabled
    write-Host( "secdrv:State[{0}] Startup[{1}]" `
        -f (Get-Service secdrv).Status.toString(), `
        (Get-WmiObject -Query "select * from win32_baseService where name='secdrv'").StartMode)

    Read-host( "終了します。何かキーを押してください。" )
}
