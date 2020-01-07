#!/bin/bash

# COLORS
NC='\033[0m' # no color
LGREEN='\033[1;32m'
LCYAN='\033[1;36m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
YELLOW='\033[1;33m'
LRED='\033[1;31m'

# WELCOME AND READ
echo -e "${LCYAN}Enter your's new package name (lowercase):${YELLOW}"
read packageName
if [ "$packageName" = "" ]
then
    packageName="untitled-package"
    echo -e "${LRED}Your's package name: ${YELLOW}$packageName${NC}"
fi

echo -e "${LCYAN}Description:${YELLOW}"
read description
if [ "$description" = "" ]
then
    description="New project"
fi

echo -e "${LCYAN}Author:${YELLOW}"
read author
if [ "$author" = "" ]
then
    author="Anonymous"
fi

# INFO ABOUT SSH GITHUB / GITLAB / BITBUCKET | PRIV: TRUE/FALSE
serv=""
privMSG=""
priv=""
tool=""

echo -e "${LRED}!!WARNING!!${LCYAN} You must have Personal Access Token(PAT) for: ${LPURPLE}GitHub ${LRED}!!WARNING!!${NC}\n"
echo -e "${LCYAN}Choose where to create the repository.${NC}"

PS3="Please enter your choice: "
options=("GitHub" "GitLab" "Bitbucket")
select opt in "${options[@]}"
do
    case $opt in
        "GitHub")
            serv=$opt
            break
            ;;
        "GitLab")
            serv=$opt
            break
            ;;
        "Bitbucket")
            serv=$opt
            break
            ;;
        *) echo -e "${LRED}Invalid option. Good bye. $REPLY ${NC}"
            exit 0
            break
            ;;
    esac
done

echo -e "\n${LCYAN}Private or public ?${NC}"
PS3="Please enter your choice: "
options=("Public" "Private")
select opt in "${options[@]}"
do
    case $opt in
        "Public")
            privMSG=$opt
            priv=false
            break
            ;;
        "Private")
            privMSG=$opt
            priv=true
            break
            ;;
        *) echo -e "${LRED}Invalid option. Good bye. $REPLY ${NC}"
            exit 0
            break
            ;;
    esac
done

# WEBPACK+BABEL / BABEL
echo -e "\n${LCYAN}Select tools${NC}"
PS3="Please enter your choice: "
options=("Webpack+babel" "Babel")
select opt in "${options[@]}"
do
    case $opt in
        "Webpack+babel")
            tool=$opt
            break
            ;;
        "Babel")
            tool=$opt
            break
            ;;
        *) echo -e "${LRED}Invalid option. Good bye. $REPLY ${NC}"
            exit 0
            break
            ;;
    esac
done

# CREATE FOLDER
mkdir $packageName
cd $packageName

# CREATE REPOSITORY
echo -e \
"\n${LCYAN}Creating ${YELLOW}$privMSG${LCYAN} repository (${YELLOW}$packageName${LCYAN}) on: ${YELLOW}$serv\nplease wait... ${NC}"

echo -e "${LCYAN}User name($serv):${YELLOW}"
read usr
if [ "$serv" = "GitHub" ]
    then
    echo -e "${LCYAN}Enter Token(PAT):${YELLOW}"
    read github_token
    curl  -H "Authorization: token $github_token" \
    -d "{ \"name\": \"$packageName\", \"auto_init\": true, \"private\": $priv, \"description\": \"$description\" }" \
    https://api.github.com/user/repos

    git init
    git remote add origin git@github.com:$usr/$packageName.git

elif [ "$serv" = "GitLab" ]
    then
    echo -e "${YELLOW}In preparation${NC}"
    # write for gitlab

elif [ "$serv" = "Bitbucket" ]
    then
    echo -e "${LCYAN}User name:${YELLOW}"
    read usr
    echo -e "${LCYAN}Password:${YELLOW}"
    read -s psv
    curl -s -o response.json -u $usr:$psv -X POST -H "Content-Type: application/json" \
        -d '{
            "scm": "git"
        }' https://api.bitbucket.org/2.0/repositories/$usr/$packageName

    type=$( cat response.json | jq '.type' )
        if [ "$type" == "\"error\"" ]
            then
            error=$( cat response.json | jq '.error.message' )
            echo -e "${LRED}FAILED"
            echo -e "${LRED}ERROR: "$error" "
            else
                rm response.json
                git init
                git remote add origin git@bitbucket.org:$usr/$packageName.git
        fi
else
    echo -e "\n${LRED}INVALID" ; sleep 2 ; (exit 1)
fi


# INSTALL AND INJECT
echo -e "\n${LCYAN}Creating package template (${YELLOW}$tool${LCYAN}): ${LGREEN}$packageName\n${YELLOW}please wait...${NC}"


echo -e "ALL VARIABLES:
$packageName
$description
$author
$serv
$privMSG
$priv
$tool"
