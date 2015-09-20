#secdrv_holder_child1.ps1

. $script_dir\module\Set-secdrv.ps1

function secdrv_holder_child1()
{
    param([string]$app_path, [string]$app_args)

    write-Debug( "child1 app_path {0} app_args {1}" -f $app_path, $app_args )
    
    try{
        Write-Debug( "function {0} {1}" -f $app_path, $app_args )

        # secdrv起動
        Set-Secdrv start Manual

        # secdrv状態確認
        write-Debug( "secdrv:State[{0}] Startup[{1}]" `
            -f (Get-Service secdrv).Status.toString(), `
            (Get-WmiObject -Query "select * from win32_baseService where name='secdrv'").StartMode)
        

        # アプリケーション起動
        $workdir = ((Get-ChildItem $app_path).DirectoryName.ToString())
        Start-Process $app_path -ArgumentList $app_args -WorkingDirectory $workdir -verb runas

    }catch
    {
        Write-Warning "エラーが発生しました {0}" -f Split-Path -Parent $MyInvocation.MyCommand.Path
        $error[0]
    }

}

