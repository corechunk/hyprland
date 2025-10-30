#!/bin/bash

menu(){
    while true;do
        local cho
        echo "1. install force"
        #echo "4. install"
        read -p "Options : " cho
        case $cho in
        1)
            rm -rf $HOME/.config/hypr/*
            cp -r ./hypr/* $HOME/.config/hypr
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