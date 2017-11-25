#！/bin/bash
function echo_color() {
    if [ $1 == "green" ]; then
        echo -e "\033[32;40m$2\033[0m"
    elif [ $1 == "red" ]; then
        echo -e "\033[31;40m$2\033[0m"
    fi
}
#方法2：
function echo_color1() {
    case $1 in
        green)
            echo -e "\033[32;40m$2\033[0m"
            ;;
        red)
            echo -e "\033[31;40m$2\033[0m" 
            ;;
        *) 
            echo "Example: echo_color red string"
    esac
}
#使用方法：
echo_color green "test"
echo_color1 red "test1"
