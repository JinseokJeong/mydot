# $figlet -f fuzzy fish
#  .--. _       .-.
# : .-':_;      : :
# : `; .-. .--. : `-.
# : :  : :`._-.': .. :
# :_;  :_;`.__.':_;:_;
#
# Theo's Fish config

# Env var
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME "$HOME/.config"

switch $(uname)
    case Linux
        set -x OSTYPE Linux
    case Darwin
        set -x OSTYPE macOS
    case '*BSD' DragonFly
        set -x OSTYPE BSD
    case '*'
        set -x OSTYPE UNKNOWN
end

if [ $OSTYPE = Linux ]
    fish_add_path -m /usr/bin /usr/local/go/bin
end

function fish_greeting -d "Enki's Custom Greetin Msg"
    # Colors
    set -l normal (set_color normal)
    set -l cyan (set_color -o cyan)
    set -l brcyan (set_color -o brcyan)
    set -l green (set_color -o green)
    set -l brgreen (set_color -o brgreen)
    set -l red (set_color -o red)
    set -l brred (set_color -o brred)

    set -l blue (set_color -o blue)
    set -l brblue (set_color -o brblue)
    set -l magenta (set_color -o magenta)
    set -l brmagenta (set_color -o brmagenta)
    set -l yellow (set_color -o yellow)
    set -l bryellow (set_color -o bryellow)

    # Collection of Oliver ASCII arts
    set -l olivers \
        '
       \/   \/
       |\__/,|     _
     _.|o o  |_   ) )
    -(((---(((--------
    ' \
        '
       \/       \/
       /\_______/\
      /   o   o   \
     (  ==  ^  ==  )
      )           (
     (             )
     ( (  )   (  ) )
    (__(__)___(__)__)
    ' \
        '
                           _
          |\      _-``---,) )
    ZZZzz /,`.-```    -.   /
         |,4-  ) )-,_. ,\ (
        ---``(_/--`  `-`\_)
    ' \
        # Thanks Jonathan for the one below
        '
          \/ \/
          /\_/\ _______
         = o_o =  _ _  \     _
         (__^__)   __(  \.__) )
      (@)<_____>__(_____)____/
        ♡ ~~ ♡ OLIVER ♡ ~~ ♡
    ' \
        '
       \/   \/
       |\__/,|        _
       |_ _  |.-----.) )
       ( T   ))        )
      (((^_(((/___(((_/
    ' \
        '
    You found the only "fish" that Oliver could not eat!
           .
          ":"
        ___:____     |"\/"|
      ,`        `.    \  /
      |  O        \___/  |
    ~^~^~^~^~^~^~^~^~^~^~^~^~
    '
    set -l oliver "$(random choice $olivers)" # will break new line without the quotes

    # Other information
    set -l my_hostname $(hostname -s) # -s to trim domain, hostname variable is taken by Fish
    set -l timestamp $(date -I) $(date +"%T")
    set -l uptime $(uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 " " }')

    # Print the msg
    echo
    echo -e "  " "$brgreen" "Welcome back $USER!" "$normal"
    echo -e "  " "$brred" "$oliver" "$normal"
    echo -e "  " "$yellow" " Fish Open:\t" "$bryellow$timestamp" "$normal"
    echo -e "  " "$blue" " Hostname :\t" "$brmagenta$my_hostname" "$normal"
    echo -e "  " "$magenta" " Uptime   :\t" "$brblue$uptime" "$normal"
    echo
end

function fish_right_prompt -d "Enki's custom right prompt displaying command duration"
    set -l __last_command_duration $CMD_DURATION

    set -l colo (set_color -o magenta)

    if test $__last_command_duration -gt 1000
        set __last_command_duration (math $__last_command_duration / 1000) s
        set colo (set_color -o red)
    else
        set __last_command_duration $__last_command_duration ms
    end
    echo $colo $__last_command_duration (set_color normal)
end

function rgfzf
    if test (count $argv) -eq 0
        echo "At least 1 argument needed!!!"
        return 1
    else
        rg --color=always --line-number --ignore-case --hidden $argv[1] |
            fzf --ansi \
                --color "hl:-1:underline,hl+:-1:underline:reverse" \
                --delimiter : \
                --preview "bat --color=always {1} --highlight-line {2}" \
                --preview-window "up,60%,border-bottom,+{2}+3/3,~3" \
                --bind "enter:become(nvim {1} +{2})"
    end
end

if status is-interactive
    # Enable Vi keybinding
    fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_vi_force_cursor
end


set fish_color_error red --bold

# starship
starship init fish | source

# Set up fzf key bindings
fzf --fish | source
