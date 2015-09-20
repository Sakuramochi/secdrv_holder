powershellでsecdrv.sysとsimsを操作するスクリプト
■ファイル
secdrv_holder.ps1	本体
dummy_app.ps1		権限確認の画面を出すためだけのダミーファイル
                    真ん中ブラックアウト対策用
read_me.txt         このファイル
module				直接操作しないファイル郡
	secdrv_holder_child1.ps1	secdrvの起動とアプリケーションの起動
	secdrv_holder_child2.ps1	アプリケーションの監視
	set-secdrv.ps1				secdrv 操作

■設定
●powershellのスクリプトが実行できるように設定する
	Set-ExecutionPolicy RemoteSignedなど
	詳細は各自調べること

●ショートカットファイルの作成と調整
	secdrv_holder.ps1のショートカットを作成する

	ショートカットを右クリック→プロパティ
	・コマンド名の追加
		ショートカットのタブ選択
		リンク先のパスの前に「powershell 」を追加(スペースも必要)
		修正前例
		C:\Users\us1\Desktop\secdrv_holder\secdrv_holder.ps1
		修正後例
		powershell C:\Users\us1\Desktop\secdrv_holder\secdrv_holder.ps1
	・管理者権限の付与
		ショートカットのタブ選択
		詳細設定のボタンクリック→「管理者として実行」にチェックを入れる

●スクリプトの起動するアプリケーション設定
	環境に合わせてアプリケーションのパスと引数を変更する
	# アプリケーション情報
	$app_path = 'F:\Game\Electronic Arts\SimPeople\Sims.exe'
	$app_args = "-r 1024x768 -w"

■使い方
	作成したsecdrv_holder.ps1をダブルクリックする
	何度か出るUACのダイアログをはいで許可する。
	途中でダミープロセス(dummy_app.ps1)起動を促すメッセージが表示されたら、
	dummy_app.ps1をダブルクリックして起動する

■注意
	テスト環境がかなりpowershellに関して不安定なので他の環境では動かない恐れあり


