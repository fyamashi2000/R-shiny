# R-shiny
1) Rがまだインストールされていない場合は、Sourforge ( https://sourceforge.net/projects/rportable/ ) からR-Portableをダウンロードしてインストールしてください。
2) R-Portable.exeを起動し、File-Open R Scriptメニューからinstall_packages.Rを読み込んで実行してください（初回のみです）。
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
4) プログラムは各フォルダのrun.vbsをダブルクリックして起動してください。R-Portableを起動する必要はありません。
