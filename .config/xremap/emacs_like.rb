# bash keybind
window class_only: ['google-chrome',
                    'slack',
                    'keepassxc',
                    'libreoffice',
                    'synapse',
                    'shift',
                    'mysql-workbench-bin',
                    'crx_hbdpomandigafcibbmofojjchbcdagbl', # twitter
                    'crx_hmjkmjkepdijhoojdojkdfohbdgmmhki', # google keep
                    'crx_mjcnijlhddpbdemagnpefmlkjdagkogk', # pocket
                    'crx_ojcflmmmcfpacggndoaaflkmcoblhnbh', # wunderlist
                    'crx_menkifleemblimdogmoihpfopnplikde', # line
                    'evince',
                    'discord',
                    'wingpanel'] do
  remap 'C-o', to: 'Alt-Left'
  remap 'C-i', to: 'Alt-Right'

  remap 'C-b', to: 'Left'
  remap 'C-f', to: 'Right'
  remap 'C-p', to: 'Up'
  remap 'C-n', to: 'Down'

  # remap 'M-b', to: 'Ctrl-Left'
  # remap 'M-f', to: 'Ctrl-Right'

  remap 'C-a', to: 'Home'
  remap 'C-e', to: 'End'

  remap 'C-k', to: ['Shift-End',       'Delete']
  remap 'C-u', to: ['Shift-Home',      'Delete']
  remap 'C-w', to: ['Ctrl-BackSpace']
  # remap 'C-w', to: ['Ctrl-Shift-Left', 'Ctrl-x']

  remap 'C-d', to: 'Delete'
  remap 'M-d', to: 'Ctrl-Delete'
  remap 'C-h', to: 'BackSpace'

  remap 'C-m', to: 'Return'

  remap 'C-bracketleft', to: 'Escape'
  remap 'C-q', to: 'Ctrl-w'

  %w(a z x c v w t f).each do |key|
    remap "Alt-#{key}", to: "C-#{key}"
  end
end

window class_only: 'google-chrome' do
  remap 'Alt-space', to: 'Ctrl-l'
  remap 'Alt-n',     to: 'Ctrl-Tab'
  remap 'Alt-p',     to: 'Ctrl-Shift-Tab'
  # remap 'C-u',       to: 'u'
  # remap 'C-d',       to: 'd'
  remap 'C-q',       to: 'Ctrl-w'
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
  remap 'C-q',       to: 'Ctrl-w'
end

# twitter
window class_only: 'crx_hbdpomandigafcibbmofojjchbcdagbl' do
  remap 'Alt-space', to: 'S' # Search
  remap 'Alt-t',     to: 'n' # Open tweet dialog
  remap 'Alt-w',     to: %w(Escape Escape) # Close tweet dialog
  # remap 'C-p',       to: 'Page_Up'
  # remap 'C-n',       to: 'Page_Down'
  remap 'C-o',       to: 'BackSpace'
  remap 'Alt-Left',  to: 'BackSpace'
  remap 'C-q',       to: 'Ctrl-w'
end

# pocket
window class_only: 'crx_mjcnijlhddpbdemagnpefmlkjdagkogk' do
  remap 'Alt-space', to: 'S' # Search
  remap 'C-u',       to: 'Page_Up'
  remap 'C-d',       to: 'Page_Down'
  remap 'C-q',       to: 'C-w'
end


window class_only: 'keepassxc' do
  remap 'Alt-space', to: 'C-f'
  remap 'Alt-n',     to: 'C-n'
  remap 'Alt-b',     to: 'C-b'
  remap 'C-q',       to: 'C-w'
end

# window class_only: 'libreoffice' do
#   remap 'C-plus', to:
# end
