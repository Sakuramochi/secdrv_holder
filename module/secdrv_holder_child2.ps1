#secdrv_holder_child2.ps1

function secdrv_holder_child2()
{
    param([string]$app_path)

    write-Debug( "child2 app_path {0}" -f $app_path )

    #サブスクライブするイベントの登録
    register-wmiEvent -class 'Win32_ProcessStopTrace' -sourceIdentifier "Process_Stop"

    try
    {
        $process_name = (Get-ChildItem $app_path ).Name

        Write-Debug ("process_name {0}" -f $process_name)

        if( !(Get-WmiObject win32_process | ? { $_.Name -eq $process_name }) )
        {
            Write-Host( "アプリケーションが起動していません。終了します。" )
            return
        }
    }catch    
    {
        Write-Warning "エラーが発生しました {0}" -f Split-Path -Parent $MyInvocation.MyCommand.Path
        $error[0]
        return
    }

    try
    {
        While( $true )
        {
            $new_event = Wait-Event -SourceIdentifier Process_Stop -Timeout -1
            $new_process_name = $new_event.SourceEventArgs.NewEvent.ProcessName.ToString()
            Write-Debug( "new_process_name = {0}" -f $new_process_name ) 
            if( $process_name -eq $new_process_name )
            {
                # アプリケーションの停止を検出
                Write-Debug( "{0} 停止イベント" -f $process_name )
                # プロセスが終了しているか確認
                # 存在していればそれが終わるのも待つ
                if( !(Get-WmiObject win32_process | ? { $_.Name -eq $process_name }) )
                {
                    Write-Host( "{0}が停止しました。" -f $process_name )
                    break
                }
                Write-Debug( "{0} 生存プロセス検出" -f $process_name )
            }else
            {
                # わりと勝手にエラーで落ちてるのでチェック追加
                if( !(Get-WmiObject win32_process | ? { $_.Name -eq $process_name }) )
                {
                    Write-Host( "アプリケーションが起動していません。終了します。" )
                    return
                }

            }
            Get-Event | Remove-Event
        }   
    }catch
    {
        Write-Warning "エラーが発生しました {0}" -f Split-Path -Parent $MyInvocation.MyCommand.Path
        $error[0]
    }finally
    {
        Get-Event | Remove-Event > $null 2>&1 
        Get-EventSubscriber | Unregister-Event
    }

}

