# R-shiny
1) Rがインストールされていない場合は、Sourforge ( https://sourceforge.net/projects/rportable/ ) から R-Portable(R-Portable_4.1.2.paf.exe) をダウンロードしてインストールしてください。
2) R-Portable.exeを起動し、「ファイル(File)」-「Rコードのソースを読み込み(Source R Code)」メニューからinstall_packages.Rを読み込んで実行してください（初回のみです）。
3) ファイルの階層構造を次の通りしてください。
   Apps/
    ├ R-Portable/
    |  ├ R-portable.exe
    |  └ App/
    |     └ R-Portable/
    |        └ library/
    └ R-shiny-main/
       ├ decon/
       |  └ run.vbs
       ├ moment/
       |  └ run.vbs
       ├ multi/
       |  └ run.vbs
       └ multi_rk/
          └ run.vbs
4) プログラムを起動するときは各フォルダのrun.vbsをダブルクリックしてください。R-Portableを起動する必要はありません。
