# bash keybind
window class_only: ['google-chrome',
                    'Navigator', # firefox
                    'slack',
                    'keepassxc',
                    'libreoffice',
                    'synapse',
                    'shift',
                    'mysql-workbench-bin',
                    'crx_hbdpomandigafcibbmofojjchbcdagbl', # twitter
                    'crx_edcifkpoamnkimdpjiabhfjahoinbpbp', # twitter lite
                    'crx_hmjkmjkepdijhoojdojkdfohbdgmmhki', # google keep
                    'crx_mjcnijlhddpbdemagnpefmlkjdagkogk', # pocket
                    'crx_ojcflmmmcfpacggndoaaflkmcoblhnbh', # wunderlist
                    'crx_menkifleemblimdogmoihpfopnplikde', # line
                    'evince',
                    'discord',
                    'calibre-ebook-viewer'] do
  remap 'Ctrl-o', to: 'Alt-Left'
  remap 'Ctrl-i', to: 'Alt-Right'

  remap 'Ctrl-b', to: 'Left'
  remap 'Ctrl-f', to: 'Right'
  remap 'Ctrl-p', to: 'Up'
  remap 'Ctrl-n', to: 'Down'

  # remap 'M-b', to: 'Ctrl-Left'
  # remap 'M-f', to: 'Ctrl-Right'

  remap 'Ctrl-a', to: 'Home'
  remap 'Ctrl-e', to: 'End'

  remap 'Ctrl-k', to: ['Shift-End',       'Delete']
  remap 'Ctrl-u', to: ['Shift-Home',      'Delete']
  remap 'Ctrl-w', to: ['Ctrl-BackSpace']
  # remap 'Ctrl-w', to: ['Ctrl-Shift-Left', 'Ctrl-x']

  remap 'Ctrl-d', to: 'Delete'
  remap 'M-d', to: 'Ctrl-Delete'
  remap 'Ctrl-h', to: 'BackSpace'

  remap 'Ctrl-m', to: 'Return'

  remap 'Ctrl-bracketleft', to: 'Escape'
  remap 'Ctrl-q', to: 'Ctrl-w'

  %w(a z x c v w t f).each do |key|
    remap "Alt-#{key}", to: "Ctrl-#{key}"
  end
end

window class_only: ['google-chrome', 'Navigator'] do
  remap 'Alt-space', to: 'Ctrl-l'
  remap 'Alt-n',     to: 'Ctrl-Tab'
  remap 'Alt-p',     to: 'Ctrl-Shift-Tab'
  remap 'Ctrl-q',       to: 'Ctrl-w'
  remap 'Alt-space', to: 'Ctrl-f'
end

window class_only: ['discord', 'slack'] do
  remap 'Alt-space',    to: 'Ctrl-k'
  remap 'Alt-k',        to: 'Alt-Up'
  remap 'Alt-j',        to: 'Alt-Down'
  remap 'Ctrl-Alt-k',   to: 'Alt-Shift-Up'
  remap 'Ctrl-Alt-j',   to: 'Alt-Shift-Down'
  remap 'Ctrl-Shift-p', to: 'Page_Up'
  remap 'Ctrl-Shift-n', to: 'Page_Down'
  remap 'Alt-t',        to: 'Alt-Shift-Up'
  remap 'Alt-w',        to: 'Alt-Shift-Down'
  remap 'Ctrl-q',       to: 'Ctrl-w'
end

# twitter, twitter lite
window class_only: ['crx_hbdpomandigafcibbmofojjchbcdagbl', 'crx_edcifkpoamnkimdpjiabhfjahoinbpbp'] do
  remap 'Alt-space', to: 'S' # Search
  remap 'Alt-t',     to: 'n' # Open tweet dialog
  remap 'Alt-w',     to: %w(Escape Escape) # Close tweet dialog
  # remap 'Ctrl-p',       to: 'Page_Up'
  # remap 'Ctrl-n',       to: 'Page_Down'
  remap 'Ctrl-o',       to: 'BackSpace'
  remap 'Alt-Left',  to: 'BackSpace'
  remap 'Ctrl-q',       to: 'Ctrl-w'
end

# pocket
window class_only: 'crx_mjcnijlhddpbdemagnpefmlkjdagkogk' do
  remap 'Alt-space', to: 'S' # Search
  remap 'Ctrl-u',       to: 'Page_Up'
  remap 'Ctrl-d',       to: 'Page_Down'
  remap 'Ctrl-q',       to: 'Ctrl-w'
end


window class_only: 'keepassxc' do
  remap 'Alt-space', to: 'Ctrl-f'
  remap 'Alt-n',     to: 'Ctrl-n'
  remap 'Alt-b',     to: 'Ctrl-b'
  remap 'Ctrl-c',     to: 'Ctrl-c'
  remap 'Ctrl-b',     to: 'Ctrl-b'
  remap 'Ctrl-q',       to: 'Ctrl-w'
end

window class_only: 'calibre-ebook-viewer' do
  remap 'Alt-space', to: 'Ctrl-f'
  remap 'Ctrl-u',       to: 'Page_Up'
  remap 'Ctrl-d',       to: 'Page_Down'
  remap 'Alt-k',   to: 'Ctrl-Up'
  remap 'Alt-j',   to: 'Ctrl-Down'
end

# window class_only: 'libreoffice' do
#   remap 'Ctrl-plus', to:
# end
