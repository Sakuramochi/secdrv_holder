# Set-Secdrv
#---------------------------------------------------------------------------#
# 言語
# Windows Powershell
#
# 書式
# Set-Secdrv [-mode] Start|Stop [-startmode] Manual|Disabled|Auto
#
# オプション
# mode    start サービス:開始
#         stop  サービス:停止
# startmode Manual  :手動
#           Disabled:無効
#           Auto    :自動
#---------------------------------------------------------------------------#

function Set-Secdrv()
{
    param( [ValidateSet("Start","Stop","")] $mode="",
        [ValidateSet("Manual", "Disabled", "Auto", "")] $startmode="" )

    $startmode_bk = (Get-WmiObject -Query "select * from win32_baseService where name='secdrv'").StartMode

    # secdrv 設定 -------------------------------------------
    # サービス動作変更
    if( $mode -eq "start" )
    {
        Set-service secdrv -startuptype Manual
        Start-Service secdrv
    }elseif( $mode -eq "stop" )
    {
        Set-service secdrv -startuptype Manual
        Stop-Service secdrv
    }

    # サービススタートアップ変更
    if( $startmode -eq "" )
    {
        $startmode = $startmode_bk
    }
    Set-service secdrv -startuptype $startmode

    # secdrv状態チェック
    write-Debug( "secdrv:State[{0}] Startup[{1}]" `
        -f (Get-Service secdrv).Status.toString(), `
        (Get-WmiObject -Query "select * from win32_baseService where name='secdrv'").StartMode)
}
