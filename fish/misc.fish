set query blah
set filenames blah


alias rl reload-config

function ip3
    ipython3 qtconsole --colors=linux --ConsoleWidget.font_family="DejaVu Sans Mono" --ConsoleWidget.font_size="12"
end

function ip2
    ipython qtconsole --colors=linux --ConsoleWidget.font_family="DejaVu Sans Mono" --ConsoleWidget.font_size="12"
end

function theend
    sudo shutdown -h now
end

function rboot
    sudo shutdown -r now
end

function u
    cd ..
end

function fizzbuzz
    for i in (seq $argv)
        set result ""
        if divisible $i 3
            set result {$result}fizz
        end
        if divisible $i 5
            set result {$result}buzz
        end
        if match $result ""
            echo $i
        else
            echo $result
        end
    end
end

function reset-net
    sudo ifconfig eth0 down
    sleep 3
    sudo ifconfig eth0 up
end

function h
    cd ~
end

function die
    xkill
end

function logoff
    i3-msg exit
end


function kill-user
    sudo pkill -KILL -u $argv
end

function tm
    time $argv
    echo " "
end

function logout
    i3-msg exit
end



function grepproc
    ps -A | grep $argv
end

function serv
    sudo /etc/init.d/$argv[1] $argv[2]
end

function service-list
    ls /etc/init.d/
end

function freespin
    sudo /opt/bin/revoco free
end

function clickit
    sudo /opt/bin/revoco click
end

function uz
    for i in $argv
        atool -x $i
    end
end

function v
    qvim $argv
end

function vs
    qvim -S ~/.vim/sessions/{$argv}
end

function ffs
    eval firefox -pentadactyl \"+c \'sessionload $argv\'\"
end

function session-load
    restoreme $argv
end

function session-edit
    qvim ~/sessions/{$argv}
end

function vimcloj
    session-load $argv
    vs $argv
    konsole --workdir /home/michael/proj/clojure/{$argv} -e lein repl
end

function ins
    sudo apt-get install $argv
end

function upg
    sudo apt-get upgrade $argv
end

function kill-last
    kill -9 %1
end

function pstatus
    apt-cache policy $argv
end

function aptup
    sudo apt-get update
end

function psearch
    apt-cache search $argv
end

function repo
    sudo add-apt-repository $argv
    aptup
end

function ppa
    sudo add-apt-repository ppa:$argv
    aptup
end

function unins
    sudo apt-get remove $argv
end

function cs-compile
    ~/clojurescript/bin/cljsc $argv[1] '{:optimizations :advanced}' > $argv[2]
end

function version-info
    cat /etc/linuxmint/info
    cat /etc/*-release
end

function lclj
    zathura /home/michael/calibre/tech/Amit\ Rathore/Clojure\ in\ Action\ 2E\ MEAP\ version\ 06\ \(1244\)/Clojure\ in\ Action\ 2E\ MEAP\ version\ 06\ -\ Amit\ Rathore.pdf &
    idea
end


function wtfisthis
    whoami
    echo \n
    version-info
    echo \n
    inxi -Sxx
end

function ctof
    set temp $argv[1]
    set temp (math "$temp * 1.8 + 32")
    # echo $argv º celcius is $temp º fahrenheit
    echo {$temp} ºF
end

function pdftoimages
    pdftk $argv burst
    for i in (ls *.pdf)
        set fname (extractfilename $i)
        convert $i $fname".png"
    end

    rm *.pdf
end

function extractfilename
    echo $argv | cut -d '.' -f1
end

function center-text
    set msize (sizeof "$argv")
    set buffer (math "480 / 2 - $msize")
    set message (spaces $buffer) $argv (spaces $buffer)
    echo $message
end

function msg
    twmnc (center-text $argv)
end

function spaces
    set spaces "                                                                                                                                                                                                                                                                                                                                                                                                                                    "
    echo $spaces | cut -c1-$argv
end

alias netflix netflix-desktop

# . /opt/fish/standard.fish

#--------------------------------------------------------------------------
# git stuff
#--------------------------------------------------------------------------
function gl
    git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit
end

function gc
    git commit $argv
end

function gsb
    git submodule $argv
end

function gs
    git status
end

function cclass
    startvm Compilers
    mountccl
    qvim ~/devvm
end
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
#ssh stuff
#--------------------------------------------------------------------------
function mountccl
    sshfs ccl:/home/compilers ~/devvm -o Compression=no -o Ciphers=arcfour
end

function umountccl
    fusermount -u ~/devvm
end

function startvm
    vmrun start ~/vmware/$argv/$argv.vmx
end

function suspendvm
    vmrun suspend ~/vmware/$argv/$argv.vmx
end
#--------------------------------------------------------------------------

function coursedl
    coursera-dl -d ~/courses $argv
end

function noteit
    set tmp /tmp/notes-(uid)
    if exists $argv
        println $argv > $tmp
    end
    qvim $tmp -c "Simplenote -n" -c "quit"
end

function vlcclip
    vlc (xclip -o)
end

function vplugname
    echo $argv | cut -d "/" -f5
end

function vimplug
    set dir (pwd)
    cd ~/.vim
    git submodule add $argv ./bundle/(vplugname $argv)
    cd $dir
end

function fadetoblack
    kdmctl kdm stop
end

function trackedvplug
    cat .gitmodules | grep path | cut -d "/" -f2
end

function gcal
    # google calendar add "{$argv}"
    gcalcli --calendar 'michael@rosenetwork.net' quick $argv
end

function work
    gcal "work $argv"
end

function gcalendar
    chromeless -new-window calendar.rosenetwork.net &
end

function fm
        set startingdir (pwd)
        j $argv
        open (pwd) &
        cd $startingdir
end

function keyp
    xdotool key $argv
end

function open-trans
    eval $argv[1]
    sleep 1
    set mywin (xdotool getactivewindow)
    transset -i $mywin $argv[2]
end

function trans
    currentapp
    transset -i $mywin $argv
end

function another-trans
    transset -i (xdotool getactivewindow) .{$argv}
end

function currentapp
    set -U mywin (xdotool getactivewindow)
end

function mywin
   xdotool getactivewindow
end

function transparent
    currentapp
    transset -i $mywin .86
end

function solid
    currentapp
    transset -i $mywin 1.0
end

function chromeless3
    firefox -P chromeless -no-remote $argv &
    sleep 3
    unset-fullscreen
end

function chromeless2
    firefox -new-window $argv
    sleep 3
    keyp colon c h r o m e l e s s Return Control+z
end

function chromeless
    chromium-browser --kiosk $argv
end

function arrangeme
    if not pgrep urxvt
        urxvtc &
    end
    focus class firefox
    mws k
    focus class dolphin
    mws d
    focus class qvim
    mws j
    focus class urxvt
    mws f
    focus class hexchat
    mws a
    i3-msg workspace k
    i3-msg workspace a
end

function pman
    set app $argv
    set pdf /tmp/{$app}.pdf

    if man $app > /dev/null
        man -t $app | ps2pdf - $pdf
    else
        help2man $app > /tmp/{$app}.txt
        man -lt /tmp/{$app}.txt | ps2pdf - $pdf
    end
    open /tmp/{$argv}.pdf &
end

function pman2 --argument-names app --description 'opens pdf version of man page or help'
    set pdf /tmp/{$app}.pdf
    if man $app > /dev/null
        set com man $app
    else
        set com help2man $app
    end
    man -lt (write-file $com) | ps2pdf - $pdf
    open $pdf
end

function vman
    man $argv | col -b | qvim -R -c 'set ft=man nolist' -c 'colorscheme distinguished' -c 'set number! relativenumber!' -c 'set guifont=Source\ Code\ Pro\ for\ Powerline\ 13' -
end

function write-file
    set tmp /tmp/(uid)
    set contents (eval $argv)
    println $contents > $tmp
    echo $tmp
end



function display-manual
    if exists $argv
        switch $argv[1]
            case -v
                set com vman
            case -p
                set com pman2
        end
   else
       set com pman2
   end
    eval $com (tolower (return-program-name (winclass)))
    # pman2 (tolower (return-program-name (winclass)))
end

function why
    set pkg (dpkg -S (which $argv))
    if exists $pkg
        set pkg (echo $pkg | cut -d ":" -f1)
        set result (apt-cache search $pkg | grep "^$pkg - ")
        echo $argv was installed as part of $result
    else
        echo $argv is not part of a package
        return 1
    end
end

function depends-on
    apt rdepends $argv
end

function fz
    fzf -1 -q "$argv" | pipetest | openpipe
end

function fe
  set tmp $TMPDIR/fzf.result
  fzf --query="$argv[1]" --select-1 --exit-0 > $tmp
  if [ (cat $tmp | wc -l) -gt 0 ]
    set -U fquery (cat $tmp)
  end
end

function fp
  set tmp $TMPDIR/fzf.result
  set ph ""
  while read -l line
    echo $line | fzf > $tmp
    set ph $ph $line
  end
  echo $ph | fzf > tmp
  # fzf --query="$argv[1]" --select-1 --exit-0 > $tmp
  if [ (cat $tmp | wc -l) -gt 0 ]
    set -U fquery (cat $tmp)
  end
end

function blist
    for i in title tags;
        println -e {$green}"resuts in $i" {$white}(calibredb list -f title -s $i:$argv)[2..-1]
    end
end

function bsrch
    calibredb list -s $argv
end

function save-layout
    i3-save-tree --workspace (getCurrentWorkspace)   > ~/workspace.json
end

function sxivd
    sxiv *.png *.bmp *.jpg
end

function imgur-upload
    set img (imgur --anon upload $argv| grep imgur_page | cut -d ":" -f2-3 | trim)
    open $img
    echo $img
    echo $img | xclip -i -selection clipboard
end

if test -f /home/michael/.autojump/etc/profile.d/autojump.fish; . /home/michael/.autojump/etc/profile.d/autojump.fish; end

function bind-keys
    killall sxhkd
    sxhkd -c ~/keybindings/$argv &
end

function xcow
    xcowsay $argv --cow-size=large --monitor=0 --at=100,0 --font="DejaVu Sans Mon 60"
end

function replace-str
    set numargs (count $argv)
    if test $numargs -gt 2
            echo $argv[3..-1] | sed "s/$argv[1]/$argv[2]/g"
    else
        while read -l line
            echo $line | sed "s/$argv[1]/$argv[2]/g"
        end
    end
end

function testf
    set ndx $argv[1]
    for i in $$argv[2]
        echo $i
    end
end

function removespaces-from-fnames
        for i in (ls)
            mv $i (echo $i | sed 's/ //g')
        end
end

function show-winclass
    msg (winclass)
end

function update-calibre
    sudo python -c "import sys; py3 = sys.version_info[0] > 2; u = __import__('urllib.request' if py3 else 'urllib', fromlist=1); exec(u.urlopen('http://status.calibre-ebook.com/linux_installer').read()); main()"
end

function list-books
    set files (ls)
    filter files pdf
    filter files epub
end

function snip
    set cnt 1
    set cutcom "cut "
    set str $argv[1]
    set ops $argv[2..-1]
    for i in $ops
        if divisible $cnt 2
            set cutcom "$cutcom -f$i | cut "
        else
            set cutcom "$cutcom - \"$i\" "
        end
        inc cnt
    end
    set cutcom $cutcom -f1-
    set mycom "echo $str | $cutcom"
    # echo $mycom
    eval $mycom
end

function mth
    set varname $argv[1]; set varvalue $$argv[1]; set opstring $argv[2]
    set expression (echo "set $varname (math \"$opstring\")" | sed "s/self/$varvalue/g")
    eval $expression
    echo $$argv[1]
end

function mwrapwrap
    eval mthwrap
end

function mthwrap
    set cnt 1
    echo (mth cnt "self+3")
end

function inc
    mth $argv[1] "self+1"
end

function incr
    math $argv +1
end

function mth2
    math "$argv"
    set val (math $val + 1)
    set val (inc $val)
end

function choose
    switch $argv
        case "java"
            sudo update-alternatives --config java
        case "scala"
            set versions (ls /opt | grep scala-2)
            echo $versions | pipeit fuzzymenu
            if test (sizeof $fquery) -gt 0
                sudo rm /opt/scala
                sudo ln -s /opt/$fquery /opt/scala
            else
                echo not a valid choice
            end
    end
end

function myemail
    git config user.email
end

function turnitin
    set dir (pwd)
    cpr

    if [ $argv[1] = 'pw' ]
        echo $argv[2] > .pw
    else
        set email (myemail)
        set pw (cat .pw)
        echo sbt submit $email $pw
    end

    cd $dir
end

function cd-project-root
    if [ (pwd) = "/" ]
        return 1
    end
    if not test -d .git
        cd ..
        cd-project-root
    else
        return 0;
    end
end

alias cpr cd-project-root

function get-filename
    echo (cutlast "/" $argv) | cut -d "." -f1
end

function get-fname-of-path
    if exists $argv
        cutlast "/" $argv
    else
        while read -l line
           get-fname-of-path $line
        end
    end
end

function get-fname
    get-fname-of-file (get-fname-of-path $argv)
end

function get-fname-of-file
    if exists $argv
        set sizeofext (math (sizeof (get-ext $argv)) +1)
        set sizeofname (math (sizeof $argv) - $sizeofext)
        echo $argv | cut -c1-$sizeofname
    else
        return 1
    end
    # else
    #     while read -l line
    #         get-ext $line
    #     end
    # end
end


function extract-filename
    if exists $argv
        get-filename $argv
    else
        while read -l line
            echo $line | pipeit get-filename
        end
    end
end

function really-quit
    xkill -id (mywin)
end

function pinfo-choose
    set pkgs (psearch $argv)
    switch (count $pkgs)
        case "1"
            pinfo $pkgs
        case "*"
            fuzzymenu $pkgs
            pinfo (echo $fquery | cut -d "-" -f1)
    end
end

function pkginfo
    set pkgs (psearch $argv)
    for i in $pkgs
        set info (pstatus (extract-package-name $i))
        set name (echo $info | cut -d ":" -f1)
        set desc (extract-package-description $i)
        set insvers (echo $info | cut -d " " -f5-6 | trim)
        set canidatevers (echo $info | cut -d " " -f9 | trim)
        if [ $insvers = $canidatevers ]
            set versions $canidatevers
        else
            set versions $insvers $canidatevers
        end
        echo -e {$white} $name - $desc Versions: $versions
    end
end

function extract-package-name
    echo $argv | cut -d " " -f1
end

function extract-package-description
    echo $argv | cut -d " " -f3-
end

function switch-library
    calibre -s
    calibre --with-library ~/calibre/$argv --detach &
end

function honey-i-shrunk-the-window
    i3-msg floating enable
    xdotool getactivewindow windowsize 1 1
    transset -i (xdotool getactivewindow) 0.0
end

function look-no-window
    xterm -hold -e honey-i-shrunk-the-window
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

function starton
    set ws $argv[1]
    set program $argv[2..-1] &
    set num (instances-of $program)
    ws $ws
    eval $program &
    while test (instances-of $program) -le $num
        sleep 0.25
    end
end

function instances-of
    count (wmctrl -lxp | grep -i $argv)
end


function window-exists
    set result (xwininfo -tree -root | grep $argv)
    if exists $result
        return 0
    else
        return 1
    end
end


function urxvtt
    if not pgrep urxvtd
        urxvtd &
    end
    while not pgrep urxvtd
    end
    urxvtc &
end

alias libprs500 calibre

function system-menu
    set choice (rfi match "logout" "reboot" "shutdown" "new session")
    if exists $choice
        switch $choice
            case "logout"
                i3-msg exit
            case "reboot"
                sudo shutdown -r now
            case "shutdown"
                sudo shutdown -h now
            case "new session"
                new-session
            case "*"
                echo not an option
        end
    end
end

function set-brightness-current-display
    set-brightness (get-focused-display) $argv
end

function set-brightness
    set display $argv[1]
    set number $argv[2]
    set adjustment (stripsign $number)
    set currentval (get-brightness $display)
    if expr $number : +[0-9]\* > /dev/null
        set adjustment (math $currentval + $adjustment)
    end
    if expr $number : -[0-9]\* > /dev/null
        set adjustment (math $currentval - $adjustment)
    end
    xrandr  --output $display  --brightness (dividebyten $adjustment)
end

alias bright set-brightness-all-displays

function set-brightness-all-displays
    set displays (get-connected-displays)
    for i in $displays
        set-brightness $i $argv
        # xrandr --output $i --brightness $argv
    end
end

function get-brightness-of-all
    set result (xrandr --verbose | grep -i brightness |  cut -d " " -f2)
    for i in $result
        echo (multiplybyten $i)
    end
end

function get-brightness
    set displays (get-connected-displays)
    set values (get-brightness-of-all)
    set ndx (findindex $argv $displays)
    echo $values[$ndx]
end

function get-brightness-current-display
    get-brightness (get-focused-display)
end

function dividebyten
    if test $argv -ge 100
        echo 1
    else
        echo "0."$argv
    end
end

function multiplybyten
    if [ $argv = 1.0 ]
        echo 100
    else
        set result (echo $argv | cut -d '.' -f2)
        if test (expr length $result) -lt 2
            set result {$result}0
        end
        echo $result
    end
end


function nmc -d "choose wireless connection"
    set connections println (nmcli connection | condense_spaces)[2..-1] | grep wireless | cut -d " " -f1
    set uuids println (nmcli connection | condense_spaces)[2..-1] | grep wireless | cut -d " " -f2
    switch $argv[1]
        case list
            println $connections
        case choose
            set choice (rfi match $connections)
            nmc to $choice up
        case to
            set command $argv[-1]
            set location $argv[2..-2]
            set ndx (findindex $location $connections)
            set uid $uuids[$ndx]
    end
end


function vpn -d "run vpn list show down reset choose or to location [up,down]"
    switch $argv[1]
        case list
             nmcli connection | grep vpn | cut -d " " -f3-5
        case show
            set result (nm-tool | grep -i vpn | cut -d " " -f7 | cut -d ']' -f1)
            if exists $result
                echo $result
            else
                echo None
            end
        case up
             vpn to $vpn_location up
        case down
            vpn to (vpn show) down
        case reset
            set con (vpn show)
            vpn down
            vpn to $con up
        case choose
            set choice (rfi match (vpn list))
            if exists $choice
                vpn to $choice up
            end

        case toggle
            if vpn exists
                vpn down
            else
                vpn up
            end
        case exists
            set result (vpn show)
            if [ $result = "None" ]
                return 1
            else
                return 0
            end
        case "*"
            #vpn to $location $command
            set location $argv[2..-2]
            set -U vpn_location $location
            set command $argv[-1]
            set uuid (nmcli connection | grep vpn | grep -i "$location" | condense_spaces | cut -d " " -f5)
            sudo nmcli connection $command uuid $uuid
            signal-i3blocks vpn
    end

end

function display-in-editor
    set tmp /tmp/view
    rm $tmp
    for i in $argv
        echo $i >> $tmp
    end
    eval $EDITOR $tmp
end

function viewable
    xwininfo -id $argv | grep "Map State: IsViewable" > /dev/null
end


function show-title
    msg (window-title)
end

set windows (wmctrl -l | cut -d " " -f1)

function list-windows

    # transform-with apply function to list replacing list with the result of applying function

    # filter-with apply function to every element of list removing those in which it returned 1

    # apply apply function to every element of a list returning modified list

    set windows (wmctrl -l | cut -d " " -f1)

    if contains "dec" $argv
        transform-with hextodec windows
    end

    if contains "visible" $argv
        filter-with viewable windows
    end

    if contains "names" $argv
        transform-with window-name windows
    end

    println $windows

end

function testfn
    if test $argv -gt 3
        echo testing this shit
        return 0
    else
        return 1
    end
end

function choose-window
    switch $argv
        case "visible"
            set ids (list-windows visible)
            set windows (list-windows visible names)
            set options $windows
        case "all"
            set ids (list-windows)
            set windows (list-windows names)
            for i in $windows
                if not substr Firefox $i
                    set realwins $realwins $i
                end
            end
            set windows $realwins
            set tabs (get-tabs)
            set options $tabs $windows
    end
    set choice (rfi match "windows" $options)
    if contains $choice $windows
        set ndx (findindex $choice $windows)
        focus id (hextodec $ids[$ndx])
    else if contains $choice $tabs
        set ndx (findindex $choice $tabs)
        focus-tab $ndx
    else
        if exists $choice
            openurl $choice
        end
    end

end

function cpu-freq
    cpufreq-info | grep -i "current CPU" | cut -d " " -f7-
end

function cpu-set
    sudo cpufreq-set -c 1 -f $argv GHz
    sudo cpufreq-set -c 0 -f $argv GHz
end

function smartnav
    set title (window-title)
    switch $argv
        case "up"
            set key k
        case "down"
            set key j
        case "left"
            set key h
        case "right"
            set key l
    end
    set vimmod Shift
    set i3mod Super
    set class (tolower (winclass))
    switch $class
        case "qvim"
            set mod $vimmod
        case "*"
            set mod $i3mod
   end
   xdotool keydown $mod;xdotool key $key;xdotool keyup $mod
   echo mod is $mod
   sleep 1
   set newtitle (window-title)
   if match $title $newtitle
        # msg vim nav
        xdotool keydown $i3mod
        xdotool key $key
        xdotool keyup $i3mod
    end
end

function choose-session
    restoreme (rfi match "choose a session" (list-sessions))
end

function list-sessions
    set sessions (ls ~/.i3/sessions)
    for i in $sessions
        echo $i | cut -d "." -f1
    end
end

function freespace
    df $argv -h | grep dev | tr -s ' ' | cut -d " " -f4
end

# function process-book-rar
#     uz $argv
#     if ls $argv
#         set name (get-filename $argv)
#         cd $name
#         badd *.pdf *.epub --duplicates
#         cd ..
#         rm $argv
#         rm -rf $name
#     else
#         echo not found
#     end
# end
function process-book-rar
    set tmp /tmp/thebook
    atool -X $tmp $argv
    rm $tmp/*.txt
    badd -1 $tmp
    rm -rf $tmp
    rm $argv
end


function choose-trans
    trans (dividebyten (dm choice "set opacity")) > /dev/null
end

function choose-volume
    setvol (dm choice "set volume")
end

function typeforme
    xdotool key k
end

function smart-pick
    set result (ls | grep -i "$argv")
    switch (count $result)
        case "1"
            echo $result
        case "*"
            fuzzymenu $result
            echo $fquery
    end
end

function smart-open
    set result (ls | grep -i "$argv")
    switch (count $result)
        case "1"
            open $result
        case "*"
            fuzzymenu $result
            open $fquery
    end
end

function echofun
    set value (toilet $argv -f future)
    println $value
end

function weather-here
    #echo (weather-icon) (weather $geo) in $geo
    echo (weather $geo) in $geo
end

function weather-icon
    weather $geo --iconify | rev | cut -c1-3
end

function transwindows
    for i in (list-windows)
        transset -i $i .77
    end
end

function vpn-status-line
    set vpnstatus (vpn show)
    switch $vpnstatus
        case None
            set symbol 
        case "*"
            set symbol 
    end
    echo $symbol $vpnstatus
end

function keysd
    switch $argv[1]
        case "toggle"
            if pgrep sxhkd
                keysd stop
                msg --id 1 -t "sxhkd disabled"
            else
                keysd mode default
                sxhkd &
                msg --id 1 -t "sxhkd enabled"
            end
        case "mode"
            set mode $argv[2]
            set cfg sxhkdrc
            set dir ~/.config/sxhkd
            rm $dir/$cfg
            ln -s $dir/$mode $dir/$cfg
            kill -10 (pgrep sxhkd)
        case "stop"
            killall sxhkd
        case "start"
            keysd mode default
            sxhkd &
    end
end

function sxmode
    set mode $argv
    set cfg sxhkdrc
    set dir ~/.config/sxhkd
    rm $dir/$cfg
    ln -s $dir/$mode $dir/$cfg
    kill -10 (pgrep sxhkd)
end

function kmd
    keysd mode default
end

function show-mouse-battery
    solaar-cli show 1 -v | grep Battery | cut -d ":" -f2 | trim | cut -d "," -f1
end

function clem
    clementine &
    while note pgrep clementine
    end
    update-now-playing.py
end

function game-mode
    switch $argv
        case "on"
            killall compton
            switchconfig single
            toggle-shift-keys
            wp scale
            set -U game_mode on
        case "off"
            compton &
            switchconfig dual
            toggle-shift-keys
            wp scale
            set -U game_mode off
        case "toggle"
            if match $game_mode on
                game-mode off
            else
                game-mode on
            end
        end
end

function switchconfig
    set primary DVI-I-0
    set secondary DVI-I-1
    switch $argv
        case "single"
            xrandr --output $primary --auto --output $secondary --off
        case "dual"
            xrandr --output $primary --auto --output $secondary --auto --left-of $primary
    end
end

alias xrr switchconfig

function display-appkeys
    set tmp /tmp/appkeys
    show-appkeys > $tmp
    eval $EDITOR $tmp
end


function now-playing
    while not pgrep clementine
        sleep 1
    end
    sleep 3
    update-now-playing.py &
end

function players-exist
    set result (playerctl -l)
    if [ $result = "No players were found" ]
        return 1
    else
        return 0
    end
end

function zp
    sudo zpool $argv
end

function zf
    sudo zfs $argv
end

function seconds
    date +%s
end

function show
    set tmp /tmp/show-(seconds)
    eval $argv > $tmp
    qvim $tmp
end

function watch-video
    set pth (pwd)
    cd /mnt/ext/Videos
    set files (findall avi mkv mp4 wmv)
    set words $argv

    for i in $words
        set files (println $files | grep -i $i)
    end

    if test (count $files) -gt 1
        set files (rfi match "pick a movie" $files)
    end
    open $files
    cd $pth
end

function find-video
    set pth (pwd)
    cd /mnt/ext/Videos
    set files (findall avi mkv mp4 wmv)
    set words $argv

    for i in $words
        set files (println $files | grep -i $i)
    end

    println $files
end

function intersection -d "prints the common elements of n lists"
    set max (count $argv)
    set first 0
    set second 1
    set rest 2
    set result $$argv[1]
    switch (count $argv)
        case 0
        case 1
            echo $$argv[1]
        case 2
            set lsta $$argv[1]
            set lstb $$argv[2]
            for i in $lsta
                if contains $i $lstb
                    if not contains $i $finalresult
                        set result $finalresult $i
                    end
                end
            end
            echo $result
        case "*"
            #echo (count $argv)
            set rest (math "$rest + 1")
            set first (math "$first + 1")
            set second (math "$second + 1")
            set intermediateresult (intersection $argv[$first] $argv[$second])
            intersection intermediateresult $argv[$rest..-1]
    end
end


function intersect-2 -d "prints the common elements of 2 lists"
    set lsta $$argv[1]
    set lstb $$argv[2]
    for i in $lsta
        if contains $i $lstb
            if not contains $i $result
                set result $result $i
            end
        end
    end
    echo $result
end


function choose-video
    mm watch (dm choice "enter search query")
end

function signal-i3blocks
    switch $argv
        case vi3
            set val 1
        case output
            set val 2
        case playing
            set val 3
        case vpn
            set val 4
        case volume
            set val 5
        case windowtitle
            set val 6
        case wallpaper
            set val 7
        case "*"
            set val $argv
    end
    pkill -RTMIN+$val i3blocks
end

function new_tab
    set win (mywin)
    im layout tabbed
    urxvtc
    sleep 1
    msg $win
    focus id $win
end

function memusage
    set mem 0
    switch (count $argv)
        case 1
            set mem (eval smem -k -c uss -P \'\^$argv\$\' -H \| trim)
        case "*"
            for i in $argv
                set mem $mem (memusage $i)
            end

    end
    addmemsize $mem
end

function addmemsize
    set acc 0
    for i in $argv
        if endswith "K" $i
            set num (echo $i | cut -d "K" -f1)
        end
        if endswith "M" $i
            set num (echo $i | cut -d "M" -f1)
            set num (echo $i | cut -d "." -f1)
            set num (wcalc -q "$num * 1024")
        end
        if endswith "G" $i
            set num (echo $i | cut -d "G" -f1)
            set num (wcalc -q "$num * 1024 * 1024")
        end
        set acc (wcalc -q "$acc + $num")
    end
    if test $acc -gt 1048576
        set acc (wcalc -q "$acc / 1048576")
        set postfix "G"
    else if test $acc -gt 1024
        set acc (wcalc -q "$acc / 1024")
        set postfix "M"
    else
        set postfix "K"
    end
    set acc (truncate-num $acc 2)
    if match $acc "0.0 "
        echo none
    else
        echo {$acc}{$postfix}
    end
end

function addmemsize2
    for i in $argv
        set num (echo $i | cut -c1-(math (sizeof $i)-1))
        switch (lastchar $i)
            case M
                set num (wcalc -q "$num * 1024")
            case G
                set num (wcalc -q "$num * 1024 * 1024")
            end
        set acc (wcalc -q "$acc + $num")
    end
    if test $acc -gt 1048576
        set acc (wcalc -q "$acc / 1048576")
        set postfix "G"
    else if test $acc -gt 1024
        set acc (wcalc -q "$acc / 1024")
        set postfix "M"
    else
        set postfix "K"
    end
    set acc (echo $acc | head -c 5)
    echo {$acc}{$postfix}
end


function memusage-current
    memusage (tolower (winclass))
end

function show-memusage
    msg (memusage-current)
end

function lockme
    save-workspaces
    vi3_mode locked
    for i in (get-connected-displays)
        im focus output $i
        im workspace {$i}_is_locked
    end
    im bar mode invisible
end

function lockmeminimal
    save-workspaces
    for i in (get-connected-displays)
        im focus output $i
        im workspace {$i}_is_locked
    end
    im bar mode invisible
    set -U locked true
    xdotool key XF86LaunchA
end

function unlockmeminimal
    if [ $locked = "false" ]
        return 0
    else
        restore-workspaces
        im bar mode dock
        set -U locked false
    end
end

function unlockme
    vi3_mode default
    im bar mode dock
    restore-workspaces
end

function unlock-with-buffer
    if checkpw $buffer
        unlockme
    end
    mybuffer erase
end

function mybuffer
    switch $argv
        case "erase"
           set buffer ""
        case "*"
            set buffer $buffer$argv
    end
end

function checkpw
    if [ $argv = "foobar" ]
        return 0
    else
        return 1
    end
end

function lightsout
    xset dpms force off
end

function choose-music
    mm play (dm choice "enter a query")
end

function transfer
    curl --upload-file ./$argv https://transfer.sh/
end

function mydate
    set adate (date '+%I:%M:%S %b %d %Y')
    if startswith 0 $adate
        echo $adate | cut -c2-
    else
        echo $adate
    end
end

function return-program-name
    set words (explode $argv)
    switch $words[1]
        case kdesudo
            echo $words[2..-1]
        case sudo
            echo $words[2..-1]
        case libprs500
            echo calibre
        case urxvtt
            echo urxvtc
        case LilyTerm
            echo lilyterm
        case "*"
            echo $words
    end
end

function get-cpu-utilization
    top -bn 2 -d 0.01 | grep '^%Cpu' | tail -n 1 | gawk '{print $2+$4+$6}'
end

function cpuusage
    set pid (pidof $argv)
    set cnt 1
    for i in $pid
        set result (ps aux|awk  '{print $2,$3,$4}'| grep $pid[$cnt] | cut -d " " -f2)
        echo {$result}%
        set cnt (math "$cnt + 1")
    end
end

function watch-cpu-usage
    while true
        cpuusage $argv
        sleep 1
    end
end

function get-gpu-temp
    ctof (unique (nvidia-settings -q gpucoretemp -t))
end

function get-gpu-fanspeed
    set speed (nvidia-settings -q GPUCurrentFanSpeed -t)
    echo {$speed}%
end

function get-cpu-temp
    ctof (sensors | grep CPU\ Temp | cut -d ":" -f2 | cut -c 8-11)
end

function drop_caches
    sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
end

function mem_info
    set mem_info (explode (echo (free -h)[2] | cut -c 6- | condense_spaces))
    set total $mem_info[1]
    set used $mem_info[2]
    set free $mem_info[3]
    set buffers $mem_info[5]
    set cache $mem_info[6]
    # set total_free (addmemsize $free)
    echo -e total: $mem_info[1] used: $mem_info[2] free: $mem_info[3] buffers: $mem_info[5] cache: $mem_info[6]
end
function free-memory
    set mem_info (explode (echo (free -m)[2] | cut -d ":" -f2- | condense_spaces))
    set free {$mem_info[3]}M
    set buffers {$mem_info[5]}M
    set cache {$mem_info[6]}M
    echo f $free b $buffers c $cache
    # addmemsize $free $buffers $cache
end


function urlwithoutgui
    firefox --new-window $argv &
    sleep 1
    xdotool type ':chromeless';sleep 1; xdotool key Return
end

function windows-list
    wmctrl -lxp | condense_spaces
end

# function nextwin
#     set ids (windows-list | sort | grep (winclass) | cut -d " " -f1)
#     set cnt (count $ids)
#     set ndx (findindex (ensure-hex (mywin)) $ids)
#     if test $ndx -eq $cnt
#         set next 1
#     else
#         set next (math "$ndx + 1")
#     end
#     focus id $ids[$next]
# end

function nextwin
    nextmatch (winclass)
end

function nextmatch
    set ids (windows-list | sort | grep -i (return-windowclass $argv) | cut -d " " -f1)
    set cnt (count $ids)
    set ndx (findindex (ensure-hex (mywin)) $ids)
    if not exists $ndx #there is no $ndx as the current window is not the same window class as $argv
        set next 1
    else if test $ndx -eq $cnt #we are already at the last item on the list we should start at the begining
        set next 1
    else
        set next (math "$ndx + 1")
    end
    focus id $ids[$next]
end

function rlall
    save-workspaces
    set ids (windows-list | grep -i urxvt | cut -d " " -f1)
    for i in $ids
        focus id $i
        xdotool key r l Return
    end
    restore-workspaces
end

function get-tabs
    set tabs (gettabs.sh)
    set titles (gettabtitles.sh)
    set cnt 1
    for i in $tabs
        set result "$titles[$cnt] $tabs[$cnt]"
        set cnt (math "$cnt +1")
        set lst $lst $result
    end
    println $lst
end

function focus-tab
    focus class firefox
    sleep 0.25
    xdotool key colon b space $argv Return
end

function choose-tab
    set tabs (get-tabs)
    set choice (rfi match "pick a tab" $tabs)
    set ndx (findindex $choice $tabs)
    focus class firefox
    xdotool key colon b space $ndx Return
end

function cycle_windows
    set windows (list-windows dec $argv)
    set current (findindex (mywin) $windows)
    set dest (ensure_valid_index $current $windows)
    focus id $windows[$dest]
end

function float_fullscreen
    im floating enable
    resize_fullscreen
end

function resize_fullscreen
    set xoffset (math (get-focused-display-offset) + 50)
    set xsize (math (get-focused-display-width)- 100)
    set ysize (math (get-focused-display-height)- 100)
    xdotool getactivewindow windowmove $xoffset 50
    xdotool getactivewindow windowsize $xsize $ysize
end

function floating_term
    eval $TERMINAL &
    sleep 0.25
    float_fullscreen
    im move scratchpad
end

function scratchpad
    switch $argv
        case "show"
            im scratchpad show
            float_fullscreen
        case "hide"
            im scratchpad show
    end
end

function pversion --argument-names modulename --description 'display version of specified Perl module if it exists'
    eval perl -M{$modulename} -e \'print \"\${$modulename}::VERSION\\n\"\;\'
end

function calibre-fnames
    echo $argv | jq .[].formats
end

function start-quietly
    set com \'$argv '2>' ''/dev/null\'
    eval bash -c $com
end

function not-in-package
    set -e $notinpackage
    for i in $PATH
        set execs $execs (find $i -executable -type f)
    end
    for i in $execs
        if not why $i > /dev/null
            set notinpackage $notinpackage $i
        end
    end
end

function lsf
    for i in $argv
        ls $i
    end
end

function open-remote
   openurl (echo (git remote -v | condense_spaces | cut -d " " -f2)[1])
end

function isafile
    if exists $argv
        if test -f $argv
            echo $argv
        end
    end
end

function edit-var
    set lst (println $$argv)
    for i in (range (count $lst))
        echo $lst[$i]
        vared lst[$i]
    end
    set $argv $lst
end
alias rfm "urxvtc -e ranger"
alias qs quickswitch.py
alias pbr process-book-rar
alias pedit master-pdf-editor

# alias gargoyle gargoyle-free
alias so smart-open
alias sp smart-pick
alias htp 'sudo htop'
