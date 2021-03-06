#vi3.fish provides helper functions to provide vi like keybindings for the i3 window manager

function defop
    set -U operation $argv[1]_op
    set -U numberofkeys $argv[2]
    set -U finalfunction $argv[3..-1]
    functions -e $argv[1]_op
    functions -e $argv[1]

    function $argv[1]_op
        eval $finalfunction
    end

    function $argv[1]
         eval vi3_take-{$numberofkeys} $argv[1] $operation
    end
end

function vi3_start-vi3
    xmodmap keys
    toggle-symbol-lock
    vi3_define-vars
    vi3_setup-keyboard
    vi3_bind-shift-keys
end

function vi3_destroy-workspace
    save-workspaces
    vi3_workspace $argv
    vi3_kill d
    restore-workspaces
end

function vi3_define-vars
    set -U vi3_targetMode default # valid values default and command
    # set -U vi3_currentDesktop 1
    # set -U vi3_lastDesktop 1
    # set -U vi3_workspaceOperation # valid values lws sws saw law
    set -U vi3_currentmode default
    set -U symbollock true
end

function vi3_setup-keyboard
    killall xcape
    /opt/bin/xcape -e 'Super_L=XF86LaunchB'
    /opt/bin/xcape -e 'Alt_L=Page_Up'
    /opt/bin/xcape -e 'Control_L=Page_Down'
end

function vi3_bind-shift-keys
    /opt/bin/xcape -e 'Shift_L=XF86Launch1'
    /opt/bin/xcape -e 'Shift_R=XF86Launch2'
end

function vi3_kill-shift-keys
    killall xcape
    vi3_setup-keyboard
end

function toggle-shift-keys
    if [ $shiftkeys = enabled ]
        set shiftkeys disabled
        msg shift keys disabled
        killall xcape
        vi3_setup-keyboard
    else
        set shiftkeys enabled
        msg shift keys enabled
        /opt/bin/xcape -e 'Shift_L=XF86Launch1'
        /opt/bin/xcape -e 'Shift_R=XF86Launch2'
    end
end

function vi3_toggle_shift_keys
    if pgrep xcape > /dev/null
        killall xcape
    else
        vi3_setup-keyboard
        vi3_bind-shift-keys
    end
end

function vi3_combo
    vi3_get-workspace $combolist[1]
    vi3_get-workspace $combolist[2]
end

function vi3_rearrange
    save-workspaces
    vi3_workspace $combolist[1]
    vi3_take-window-to-workspace $combolist[2]
    restore-workspaces
end

function vi3_change-all
    set num 1
    for i in $combolist
        vi3_workspace $combolist[$num]
        set num (math $num + 1)
    end
    ws (explode $combolist)
end

function vi3_change-all-workspaces
    set numdisplays (get-number-of-displays)
    eval vi3_take-{$numdisplays} $argv[1] vi3_change-all
end

function get-active-workspaces
    get-ws-info get name where visible = true
end

function focus-primary
    i3-msg focus output (get-primary-display)
end

function restore-workspaces
    for i in (reverse $workspaces)
        vi3_workspace $i
    end
end

function save-workspaces
    set -U workspaces (get-active-workspaces)
end

function evalandrestore
   # set -U workspaces (get-active-workspaces)
    save-workspaces
    eval $argv
    restore-workspaces
end

function vi3_take-n

# takes a letter which is added to a list a function to eval
# and a number n when the list is n letters long the function
# is evaluated making use of the list

    set -U combolist $combolist $argv[1]
    if test (count $combolist) = $argv[3]
        eval $argv[2]
        echo "done!" &
        set -e combolist
        i3-msg mode "default" &
        er vi3op &
        update-op-status &
    else
        echo "not yet" &
        i3-msg mode "op" &
    end
end

function vi3_take-1
    vi3_take-n $argv[1] $argv[2] 1
end

function vi3_take-2
    vi3_take-n $argv[1] $argv[2] 2
end


function vi3_combine-workspaces
    evalandrestore vi3_take-2 $argv[1] vi3_combo
    er vi3op
    update-op-status
end

function vi3_rearrange-workspaces
    vi3_take-2 $argv[1] vi3_rearrange
end

function vi3_trans-set
    trans .{$combolist[1]}{$combolist[2]}
end

function vi3_trans
    vi3_take-2 $argv[1] vi3_trans-set
end

function vi3_vol-set
    setvol {$combolist[1]}{$combolist[2]}
end

function vi3_vol
    vi3_take-2 $argv[1] vi3_vol-set
end

function vi3_width-set
    set-window-size perc width {$combolist[1]}{$combolist[2]}
    er vi3op
    update-op-status
end

function vi3_width
    vi3_take-2 $argv[1] vi3_width-set
end

function vi3_height-set
    set-window-size perc height {$combolist[1]}{$combolist[2]}
    er vi3op
    update-op-status
end

function vi3_height
    vi3_take-2 $argv[1] vi3_height-set
end

function vi3_workspace -d 'switch workspace [a-z]'
    switch (count $argv)
      case 1
        i3-msg $argv
      case'*'
        for i in (explode-words $argv)
            i3-msg workspace $i
        end
        er vi3op
        update-op-status
      end
end

function vi3_op_workspace2
    vi3_take-1 $argv[1] vi3_workspace2
end

function vi3_workspace2
    i3-msg workspace $combolist[1]
end

function vi3_take-window-to-workspace
    er vi3op
    update-op-status
    i3-msg move container to workspace $argv
    vi3_workspace $argv
end

function vi3_move-window-to-workspace
    i3-msg move container to workspace $argv
    er vi3op
    update-op-status
end

function vi3_operator-mode
    set -U vi3op $argv
    signal-i3blocks vi3
    update-op-status
    i3-msg mode "op"
end

function vi3_fetch-window
    er vi3op
    update-op-status
    save-workspaces
    focus-app $argv
    vi3_take-back
    restore-workspaces
end

function vi3_fetch-to-target
    "todo"
    "this should allow you to press 2 keys an appkey and then a destination ws"
    "eg b r should take appkey b to workspace r"
end

function vi3_take-back
    i3-msg move container to workspace back_and_forth
    vi3_workspace back_and_forth
end

function vi3_backout
    set -e vi3op
    set -e combolist
    set -U numkeyed 0
    i3-msg mode "default"
    update-op-status
end

function update-op-status
    signal-i3blocks vi3
end

function vi3_get-workspace
    er vi3op
    update-op-status
    checkpoint-ws
    vi3_workspace $argv
    vi3_select-all-in-workspace
    vi3_take-back
    restore-ws
end

function checkpoint-ws
    set -U current_ws (get-active-workspaces)
end

function restore-ws
    for i in $current_ws;vi3_workspace $i;end
end

function vi3_select-all-in-workspace
    i3-msg focus parent
    i3-msg focus parent
    i3-msg focus parent
    i3-msg focus parent
    i3-msg focus parent
end

function evalvi3op
    # set -U lastcom $vi3op $argv
    set com $vi3op $argv
    eval $com
end

function vi3_set_lastcom
    set -U lastcom $argv
end

function vi3_repeat
    eval $lastcom
end

function focus-app
    set currentclass (winclass)
    set command (appkey $argv)
    set class (return-windowclass $command)
    if match $currentclass $target
        nextwindow
        msg next
    else
        set -U lasttarget $class
        if focus class (tolower $class)
        else
            focus $command
        end
    end
    er vi3op
    update-op-status
end

function kill-app
    save-workspaces
    focus-app $argv
    sleep 0.5
    i3-msg kill
    restore-workspaces
    er vi3op
    update-op-status
end

function kill-all-app
    set target (tri3-msg (return-program-name (appkey $argv)))
    sudo killall $target
    er vi3op
    update-op-status
end

function focus-next
    nextmatch $lasttarget
end

function open-app
    set target (appkey $argv) \&
    echo $target
    eval $target
    er vi3op
    update-op-status
end

function select-all-in-workspace
    i3-msg focus parent
    i3-msg focus parent
    i3-msg focus parent
end

function kill-workspace
    select-all-in-workspace
    i3-msg kill
end

function kill-other-windows
    i3-msg move container to workspace keep
    kill-workspace
    vi3_get-workspace keep
end


function destroy-everything
    set displays (get-connected-displays)
    for i in $displays
        i3-msg focus output right
        kill-workspace
    end
end

function update-vi3-config
    killall i3blocks
    rm ~/.i3/config
    cat /opt/vi3/header.txt ~/.i3/colors/{$colors} ~/.i3/personalconfig /opt/vi3/vi3config > ~/.i3/config
    i3-msg restart
    sleep 3
    transparent-bars
end

function colorscheme
    if not match $colors $argv
        set -U colors $argv
        update-vi3-config
    end
end

function saveme
    i3-save-tree --workspace (get-focused-workspace) | sed 's-^\([[:blank:]]*\)//\([[:blank:]]"class".*\),$-\1\2-' > ~/.i3/sessions/{$argv}.json
    set sessionscript ~/sessions/{$argv}
    echo '#!/bin/fish' > $sessionscript
    chmod +x $sessionscript
    eval $EDITOR $sessionscript
end

function restoreme
    i3-msg append_layout ~/.i3/sessions/{$argv}.json
    ff ~/sessions/{$argv}
end

function vi3_firstrun
    cat ~/.config/fish/config.fish /opt/vi3/fishconfig.txt > /tmp/tmpvi3fish
    cp /tmp/tmpvi3fish ~/.config/fish/config.fish
    cp /opt/vi3/personalconfigexample ~/.i3/personalconfig
    cp /opt/vi3/template.json ~/.i3/sessions/template.json
    mkdir ~/sessions
    mkdir ~/.i3/sessions
    mkdir ~/.i3/colors
    set -U colors greenandyellow
    update-vi3-config
end

function makescript
    set f $argv
    touch $f
    echo '#!/usr/bin/fish' > $f
    chmod +x $f
end

function new-open-app
    set target (appkey $argv)
    set winclass (return-windowclass $target)
    set sizeof (math $numkeyed \* 2)
    set sizeof $numkeyed
    # set sizeof (wcalc -q "$numkeyed \* 2")

    if [ $numkeyed = "0" ]
        echo "no size chosen"
    else
        cat ~/.i3/sessions/template.json | sed "s/#size/$sizeof/g" | sed "s/#winclass/$winclass/g" > /tmp/template.json
        cat /tmp/template.json
        i3-msg append_layout /tmp/template.json
        set -U numkeyed 0
    end
    er vi3op
    update-op-status
    #running urxvtc as root doesn't result in a root terminal OBVIOUSLY so need to run
    #urxvt obviously this is a flakey special case for one app
    if exists $sustatus
        if [ $target = urxvtt ]
            set target urxvt
        end
    end
    eval $sustatus $target &
    er sustatus
    sleep 0.5
end

function set-size-of-next-window
    set -U numkeyed $argv
end

function defaultmode
    i3-msg mode "default"
    set -U numkeyed 0
end

function im
    eval i3-msg $argv > /dev/null
end

function get-focused-workspace
    get-ws-info get name where focused = true
end

function get-ws-info1
    #example get output where focused = true
    set var $argv[4]
    set val $argv[6]
    set desired $argv[2]
    set com i3-msg -t get_workspaces \| jq \'.\[\] \| \{output: .output, width: .rect.width, height: .rect.height, x: .rect.x, y: .rect.y, name: .name, visible: .visible, focused: .focused, urgent: .urgent\}\' \| jq -r \'select\(.$var == $val\).$desired\'
    eval $com
end

function get-ws-info2
    #example get output where focused = true
    eval i3-msg -t get_workspaces \| jq \'.\[\] \| \{output: .output, width: .rect.width, height: .rect.height, x: .rect.x, y: .rect.y, name: .name, visible: .visible, focused: .focused, urgent: .urgent\}\' \| jq -r \'select\(.$argv[2] == $argv[3]\).$argv[1]\'
end


function get-ws-info3
    i3-msg -t get_workspaces | jq . | grep -E "$argv[2].*$argv[3]" -B 12 -A 10 | grep -E "$argv[1].*" | cut -d : -f2 | sort -u
end

function show-menu
    if exists $vi3op
        set msg (show-op)
    else
        set msg (show-mode)
    end

    echo $msg

end

function better-show-menu
    if exists $vi3op
        fn -d $vi3op
    else
        switch $vi3mode
            case "kill"
                set msg '(a) all appkey (d) workspace (o) others in workspace (w) window (z) all visible'
            case "default"
                set msg '(mod+hjkl change focus (RShift) command (Lshift) switch workspace (mod+a) audio (PrintScreen) screenshot'
                set msg 'default'
            case "command"
                set msg "command"
            case "screenshot"
                set msg 'Screenshot (w)indow (d)isplay (e)verything'
            case "*"
                set msg $vi3mode
       end
    end

end

function show-op
      if exists $vi3op
          switch $vi3op
              case "ws"
                  set msg "switch workspace [a-z]"
              case "vi3_trans"
                  set msg "set transparency [00-99]"
              case "gws"
                  set msg "get windows from [a-z]"
              case "mws"
                  set msg "move window to [a-z]"
              case "tws"
                  set msg "take window to [a-z]"
              case "vi3_vol"
                  set msg "set volume [00-99]"
              case "focus-app"
                  set msg "focus appkey [a-zA-Z]"
              case "vi3_fetch-window"
                  set msg "fetch appkey[a-zA-Z]"
              case "open-app"
                  set msg "open appkey [a-zA-Z]"
              case "new-open-app"
                  set msg "open appkey [a-zA-Z]"
              case "vi3_kill"
                  set msg "kill (d)elete all in ws (a)pp (e)verything visible (o)ther windows (t) another ws"
              case "rws"
                  set msg "relocate windows from [a-z] to [a-z]"
              case "kill-all-app"
                  set msg "kill all instances of appkey [a-zA-Z]"
              case "vi3_height"
                  set msg 'set window height [01-99]'
              case "vi3_width"
                  set msg 'set window width [01-99]'
              case "vi3_vol"
                  set msg 'set volume [01-99]'
              case "*"
                  set msg "some other op"
          end
      end

      echo $msg
end

function show-mode
    switch $vi3mode
        case "kill"
            set msg '(a) all appkey (d) workspace (o) others in workspace (w) window (z) all visible'
        case "default"
            set msg '(mod+hjkl change focus (RShift) command (Lshift) switch workspace (mod+a) audio (PrintScreen) screenshot'
            set msg 'default'
        case "command"
            set msg "command"
        case "screenshot"
            set msg 'Screenshot (w)indow (d)isplay (e)verything'
        case "*"
            set msg $vi3mode
    end
    echo $msg
end

function appkey
    if matches "$argv" '[a-zA-Z]'                # view
        set var appkey_$argv
        echo $$var
    else if matches "$argv" 'erase [a-zA-Z]'     # erase
        er appkey_$argv[2]
    else if matches "$argv" 'show'               # show
        for i in (alphabet)
            echo $i: (appkey $i)
        end
    else if matches "$argv"  'find [a-zA-Z\-]+'
        appkey show | grep -i --color=never $argv[2..-1]
    else if matches "$argv" '[a-zA-Z] .+' # set
        set value appkey_$argv[1]
        set -U $value $argv[2..-1]
    end
end

function sset
    set $argv
    echo $argv[-1]
end



function vi3_mode
    i3-msg mode $argv
    set -U vi3mode $argv
    update-op-status
end

function vi3_kill
    switch $argv
        case "d" #kill workspace
           select-all-in-workspace
           i3-msg kill
        case "a" #all of a given appkey
            vi3_operator-mode kill-all-app
        case "w" #window
            i3-msg kill
        case "e" #all visiable eg everything
            set displays (get-connected-displays)
            for i in $displays
                i3-msg focus output $i
                select-all-in-workspace
                i3-msg kill
            end
        case "o" #other windows on workspace
            i3-msg move container to workspace keep
            vi3_kill d
            vi3_get-workspace keep
        case "t"
            vi3_operator-mode vi3_destroy-workspace
    end
    er vi3op
    update-op-status

end

function show-keys
    # xev | grep --line-buffered keysym | sed -u 's/[),]//g' | stdbuf cut -d " " -f11
    xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'
end

function cut-while
    while read -l line
        echo $line | cut -d " " -f11 | cut -d ')' -f1
    end
end

function commandn
    switch $argv
        case "a"
        case "b"
        case "c"
        case "d"
        case "e"
        case "f"
        case "g"
        case "h"
        case "i"
        case "j"
        case "k"
        case "l"
        case "m"
        case "n"
        case "o"
        case "p"
        case "q"
            set thecommand "i3-msg kill"
        case "r"
        case "s"
        case "t"
        case "u"
        case "v"
        case "w"
        case "x"
        case "y"
        case "z"
    end
end

function reverse
    set size (count $argv)
    println $argv[$size..1]
end

alias ws vi3_workspace
alias gws vi3_get-workspace
alias cws vi3_combine-workspaces
alias rws vi3_rearrange-workspaces
alias saw vi3_select-all-in-workspace
alias mws vi3_move-window-to-workspace
alias tws vi3_take-window-to-workspace
