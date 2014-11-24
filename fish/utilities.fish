function dm
    set lastws (getCurrentWorkspace)
    focus-primary
    dmenu_run -p "Command: " -nb "black" -sf "#036300" -sb "#A6CD01" -nf "grey" -fn Inconsolata-12 -b
    ws $lastws
end

function wp
    feh --bg-{$argv[1]} $argv[2]
    convert $argv[2] -resize 1920x1080\! ~/.bgimage/img.png
end

function lock
    # i3lock -i ~/.bgimage/img.png -t
    xscreensaver-command -lock
end

function focus
    set numargs (count $argv)
    switch $numargs
        case "1"
            set target (return-windowclass $argv)
            i3-msg [class=$target] focus
        case "2"
            set cmd $argv[1]
            switch $cmd
                case "id"
                    im [id=$argv[2]] focus
                case "distinct"
                    focus-distinct $argv[2]
            end
    end
end

function return-windowclass
    switch $argv
        case calibre
            set returnval libprs500
        case urxvt
            set returnval URxvt
        case urxvtc
            set returnval URxvt
        case "*"
            set returnval (capitalize $argv)
    end
    echo $returnval
end

function focus-distinct
    set current_class (winclass)
    set current_id (mywin)
    while true
        im focus $argv
        set next_class (winclass)
        if not match $current_class $next_class
            set new_id (mywin)
            break
        end
    end
    focus id $current_id
    focus id $new_id
end        

function new-session
    kdmctl reserve
end

function setme
    set -U $argv[1] $argv[2]
end


function clemctl
    qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.{$argv}
end

function get-connected-displays
    xrandr | grep " connected" | cut -d "c" -f1 | trim
end

function get-number-of-displays
    count (get-connected-displays)
end

function unset-fullscreen
    if is-fullscreen
        i3-msg fullscreen > /dev/null
    end
end

function is-fullscreen
    xwininfo -id (mywin) -all | grep -i fullscreen > /dev/null
end

function get-primary-display
    xrandr | grep primary | cut -d " " -f1
end

function get-secondary-display
    xrandr | grep " connected [0-9]" | cut -d " " -f1
end

function get-dividing-line
    xrandr | grep "+[1-9]" | cut -d "+" -f2
end

function get-focused-display
    set xcorner (xwininfo -id (mywin) -all | grep -i "corners" | cut -d '+' -f2 | trim) 
    if test $xcorner -gt (get-dividing-line)
        get-primary-display
    else
        get-secondary-display
    end
end

function get-focused-display-resolution
    set res (xrandr --verbose | grep " connected" | grep (get-focused-display) | cut -d "x" -f1-2 | cut -d "+" -f1)
    set res (explode $res)
    set res $res[-1]
    echo $res
end

function get-focused-display-x-offset
    xrandr | grep (get-focused-display) | cut -d "+" -f2-3 | cut -d " " -f1 | cut -d "+" -f1
end

function get-focused-display-y-offset
    xrandr | grep (get-focused-display) | cut -d "+" -f2-3 | cut -d " " -f1 | cut -d "+" -f2
end

function screenshot
    set target ~/screenshots/(date +%T-%F).png
    switch $argv
        case "everything"
            maim $target
        case "window"
            maim -x (get-window-x-pos) -y (get-window-y-pos) -w (get-window-width) -h (get-window-height) $target
        case "display"
            maim -x (get-focused-display-x-offset) -y (get-focused-display-y-offset) -w (get-focused-display-width) -h (get-focused-display-height) $target
   end
   echo $target
end
            

function get-focused-display-width
    get-focused-display-resolution | cut -d "x" -f1
end

function get-focused-display-height
    get-focused-display-resolution | cut -d "x" -f2
end

function get-window-width
    xwininfo -id (mywin) | grep "Width" | cut -d ":" -f2  | trim
end

function get-window-height
    xwininfo -id (mywin) | grep "Height" | cut -d ":" -f2  | trim
end

function set-window-size
    set numargs (count $argv)
    switch $numargs
        case "3"
            set method $argv[1]
            set dimension $argv[2]
            set num $argv[3]
        case "2"
            set method $argv[1]
            set dimension $resizedim
            set num $argv[2]
    end

    switch $method
        case "exact"
            set targetsize $num
        case "aprox"
            set targetsize (math "$num * 100")
        case "perc"
            switch $dimension
                case "width"
                    set rescommand get-focused-display-width
                case "height"
                    set rescommand get-focused-display-height
            end
            set maxsize (eval $rescommand)
            set multiplier "0.$num"
            set targetsize (math "$maxsize * $multiplier")
    end 
    set sizecommand get-window-{$dimension}
    set currentsize (eval $sizecommand)
    set difference (math "($currentsize - $targetsize) / 16")
    if greaterthanzero $difference
        set direction shrink
    else
        set direction grow
        set difference (abs $difference)
    end
    set command i3-msg resize $direction $dimension $difference px or $difference ppt
    eval $command
end

function resize-window
    set dim $argv[1]
    set num (abs $argv[2])
    if test $argv[2] -gt 0
        set direction grow
    else
        set direction shrink
    end
    im resize $direction $dim {$num}px or {$num}pc
end

function adjust-height
    resize-window height $argv
end

function adjust-width
   resize-window width $argv
end

function trans
    transset -i (currentapp) $argv
end

function abs
    if greaterthanzero $argv
        echo $argv
    else
        math "$argv - ($argv * 2)"
    end
end

function greaterthanzero
    if test $argv -gt 0
        return 0
    else
        return 1
    end
end

function another-trans
    transset -i (xdotool getactivewindow) .{$argv}
end

function currentapp
    echo (xdotool getactivewindow)
end

function transparent
    transset -i (currentapp) .86
end

function solid
    transset -i (currentapp) 1.0
end

function nextwindow
    set currentclass (xprop -id (currentapp) | grep WM_CLASS | cut -d '"' -f4)
    nextmatch $currentclass
end

function pi3
   echo "import i3"\n{$argv} | python
end 

function getCurrentWorkspace
    pi3 "print i3.filter(i3.get_workspaces(), focused=True)[0]['name']"
end

function capitalize
    echo $argv | sed 's/\([a-z]\)\([a-z]*\)/\U\1\L\2/g'
end

function explode
    echo $argv | sed 's/ /\n/g'
end

function xdc
    xdotool getactivewindow $argv
end

function windowmove
    set directions left right down up
    if contains $argv[1] $directions
        windowmove-relative $argv
    else
        xdc windowmove $argv
    end
end

function get-window-x-pos
    xwininfo -id (mywin) | grep "Absolute upper-left X" | cut -d ":" -f2 | trim
end

function get-window-y-pos
    xwininfo -id (mywin) | grep "Absolute upper-left Y" | cut -d ":" -f2 | trim
end

function windowmove-relative
    set xpos (get-window-x-pos)
    set ypos (get-window-y-pos)
    set direction $argv[1]
    set distance $argv[2]
    switch $direction
        case "left"
            set xpos (math "$xpos - $distance")
        case "right"
            set xpos (math "$xpos + $distance")
        case "up"
            set ypos (math "$ypos - $distance")
        case "down"
            set ypos (math "$ypos + $distance")
    end
    if test $xpos -lt 0
        set xpos 0
    end
    if test $ypos -lt 0
        set ypos 0
    end
    xdc windowmove $xpos $ypos
end

