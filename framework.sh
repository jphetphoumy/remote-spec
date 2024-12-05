#!/usr/bin/env bash

# GLOBALS
indent_level=0
# Colors
red=$(tput setaf 1)
green=$(tput setaf 2)
green_bg=$(tput setab 2)
red_bg=$(tput setab 1)
normal_bg=$(tput setab 0)
gray=$(tput setaf 8)
normal=$(tput setaf 7)
bold=$(tput bold)

provider="local"
provider_opts=""
PASSES=0
FAILS=0

normal=$(tput setaf 7)

get_indentation() {
    local spaces=""
    for ((i = 0; i < indent_level; i++)); do
        spaces+="    "
    done
    echo "$spaces"
}

Setup() {
    # Set provider
    provider=$1
    echo "Setting Up for provider $provider"
    if [[ "ssh" == $provider ]]; then
        provider_opts=$2
    fi
}

Describe() {
    local test_description=$1
    echo "${green}Describe:${normal}$test_description"
    ((indent_level++))
}

It() {
    local test_description=$1
    local spaces
    spaces=$(get_indentation)
    echo "${spaces}${green}It:${normal}$test_description"
    ((indent_level++))
}

End() {
    ((indent_level--))
    local spaces
    spaces=$(get_indentation)
    #if [[ $indent_level == 0 ]];
    #then
    #    echo
    #    echo "Summary:"
    #    echo "    ${green}PASSES: $PASSES${normal}, ${red}FAILS: $FAILS${normal}"
    #fi
}

trace() {
    echo "${spaces}${red}Failure Details:${normal}"
    echo "${spaces}  ${gray}File:${normal} ${bold}${BASH_SOURCE[1]}${normal}"
    echo "${spaces}  ${gray}Function:${normal} ${FUNCNAME[0]}"
    echo "${spaces}  ${gray}Line:${normal} ${BASH_LINENO[0]}"
     # Print the call stack
    echo "${spaces}  ${red}Call Stack:${normal}"
    for ((i=1; i<${#FUNCNAME[@]}; i++)); do
        echo "${spaces}    ${gray}at ${FUNCNAME[$i]} (${BASH_SOURCE[$i]}:${BASH_LINENO[$((i-1))]})${normal}"
    done
}

run_with_provider() {
    local provider=$1
    shift
    local cmd=$*

    case "$provider" in
        local)
            eval "$cmd"
            ;;
        vagrant)
            vagrant ssh -c "$cmd"
            ;;
        ssh)
            ssh -oStrictHostKeyChecking=no $provider_opts "$cmd"
            ;;
        *)
            echo "${red_bg}FAIL${normal_bg} Unknown provider: \"$provider\"${normal}"
            return 1
            ;;
        esac
}

AssertEquals() {
    local expected=$1
    local received=$2
    local spaces
    spaces=$(get_indentation)
    if [[ $received == $expected ]];then
        echo "${spaces}${green_bg}PASS${normal_bg} ${gray}AssertEquals${normal} ${green}\"$received\"${normal} ${gray}to be equals to ${green}\"$received\"${normal}"
        ((PASSES++))
    else
        echo "${spaces}${red_bg}FAIL${normal_bg} ${gray}AssertEquals${normal} ${red}\"$received\"${normal} ${gray}to be equals to ${green}\"$received\"${normal}"
        trace
        ((FAILS++))
    fi
}

AssertInstalled() {
    local package=$1
    local spaces
    spaces=$(get_indentation)
    if run_with_provider "$provider" "command -v $package &>/dev/null"; then
        echo "${spaces}${green_bg}PASS${normal_bg} ${gray}AssertInstalled ($provider)${normal} ${green}\"$package\"${normal} ${gray}to be installed${normal}"
        ((PASSES++))
    else
        echo "${spaces}${red_bg}FAIL${normal_bg} ${gray}AssertInstalled($provider)${normal} ${red}\"$package\"${normal} ${gray}to be installed${normal}"
        ((FAILS++))
    fi
}

AssertLineInFile() {
    local line=$1
    local file=$2
    local spaces
    spaces=$(get_indentation)

    if run_with_provider "$provider" "grep -q '$line' '$file'"; then
        echo "${spaces}${green_bg}PASS${normal_bg} ${gray}AssertLineInFile ($provider)${normal} ${green}\"$line\"${normal} ${gray}present in $file${normal}"
        ((PASSES++))
    else
        echo "${spaces}${red_bg}FAIL${normal_bg} ${gray}AssertLineInFile ($provider)${normal} ${red}\"$line\"${normal} ${gray}absent from $file${normal}"
        ((FAILS++))
    fi
}
