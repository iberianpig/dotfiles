# 新規作成
new-window -c "#{pane_current_path}"

# # 一番初めのpaneを選択
# select-pane -t 0
# # 上下にウィンドウを分割する
# split-window -v -c "#{pane_current_path}"
# # 1番目(下側)のウィンドウを選択
# select-pane -t 1
# # # 左右にウィンドウを分割
# split-window -h -c "#{pane_current_path}"
#
# # メインとなるウィンドウの高さを35行に設定
# setw main-pane-height 30
# # 上下分割レイアウトを反映
# select-layout main-horizontal
# display-panes
#
# # 2番目(右下)のpaneの横幅（境界)を右に22文字幅移動する
# resize-pane -R -t 2
