#!/usr/bin/env bash
# don't run without reading the whole code. if you dont know bash then GETOUT !!


menu(){
    while true;do
        local cho
        echo "1. install force"
        #echo "4. install"
        read -p "Options : " cho
        case $cho in
        1)
            rsync -av --delete ./hypr/ $HOME/.config/hypr/
            rsync -av --delete ./pypr/ $HOME/.config/pypr/
            chmod +x $HOME/.config/pypr/*.sh 2>/dev/null
            chmod +x $HOME/.config/hypr/scripts/*/*.sh 2>/dev/null
            chmod +x $HOME/.config/hypr/scripts/*/*/*.sh 2>/dev/null
            hyprctl reload
            ;;
        x|X)
            break
            ;;
        *)
            echo "invalid option"
            ;;
        esac
    done
}
menu
