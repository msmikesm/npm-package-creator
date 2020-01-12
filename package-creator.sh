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

echo -e "${LRED}!!WARNING!!${LCYAN} You must have Personal Access Token(PAT) for: ${LPURPLE}GitHub, GitLab ${LRED}!!WARNING!!${NC}\n"
echo -e "${LCYAN}Choose where to create the repository.${NC}"

PS3="Please enter your choice: "
options=("GitHub" "GitLab" "Bitbucket" "None")
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
        "None")
            serv=$opt
            break
            ;;
        *) echo -e "${LRED}Invalid option. Good bye. $REPLY ${NC}"
            exit 0
            break
            ;;
    esac
done

if [ "$serv" != "None" ]
    then
    echo -e "\n${LCYAN}Private or public ?${NC}"
    PS3="Please enter your choice: "
    options=("public" "private")
    select opt in "${options[@]}"
    do
        case $opt in
            "public")
                privMSG=$opt
                priv=false
                break
                ;;
            "private")
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
fi

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
if [ "$serv" != "None" ]
    then
    echo -e "${LCYAN}User name($serv):${YELLOW}"
    read usr
fi
if [ "$serv" = "GitHub" ]
    then
    echo -e "${LCYAN}Enter Token(PAT):${YELLOW}"
    read github_token
    curl -H "Authorization: token $github_token" \
    -d "{ \"name\": \"$packageName\", \"auto_init\": true, \"private\": $priv, \"description\": \"$description\" }" \
    https://api.github.com/user/repos

    git init
    git remote add origin https://github.com/$usr/$packageName.git

elif [ "$serv" = "GitLab" ]
    then
    echo -e "${LCYAN}Enter Token(PAT):${YELLOW}"
    read gitlab_token

    curl -s -S -H "Content-Type:application/json" https://gitlab.com/api/v4/projects?private_token=$gitlab_token -d \
        "{ \"name\": \"$packageName\", \"description\": \"$description\", \"visibility\": \"$privMSG\" }" > /dev/null

    git init
    git remote add origin https://gitlab.com/$usr/$packageName.git

elif [ "$serv" = "Bitbucket" ]
    then
    echo -e "${LCYAN}Password:${YELLOW}"
    read -s psv
    curl -s -S -u $usr:$psv -X POST -H "Content-Type: application/json" \
        -d "{ \"scm\": \"git\", \"is_private\": $priv }" https://api.bitbucket.org/2.0/repositories/$usr/$packageName > /dev/null

    git init
    git remote add origin https://$usr@bitbucket.org:$usr/$packageName.git
else
    echo -e "\n${LPURPLE}The repository will not be created${NC}"
fi

# Po zainicjowaniu npm
# wykonać npm i -D <wszystkie paczki>
# potworzyc pliki później wstrzyknąć zależności,
# dodać do package.josn skrypty, types, files
#
#



# INSTALL AND INJECT
echo -e "\n${LCYAN}Creating package template (${YELLOW}$tool${LCYAN}): ${LGREEN}$packageName\n${YELLOW}please wait...${NC}\n"
npm init -y
mkdir src
mkdir src/__tests__
mkdir src/dumb

GLOBIGNORE="*"
if [ "$tool" = "Webpack+babel" ]
    then
    # npm i -D @babel/cli @babel/core @babel/plugin-proposal-class-properties @babel/plugin-proposal-numeric-separator \
    # @babel/plugin-proposal-object-rest-spread @babel/preset-env @types/jest @typescript-eslint/eslint-plugin \
    # @typescript-eslint/parser babel-jest babel-loader clean-webpack-plugin eslint eslint-config-airbnb eslint-config-prettier \
    # eslint-import-resolver-typescript eslint-plugin-import eslint-plugin-json eslint-plugin-jsx-a11y eslint-plugin-prettier \
    # eslint-plugin-react jest prettier ts-jest ts-loader typescript webpack webpack-cli

    # main files ------------------------------------------------------------------
    mainFiles=(".babelrc" ".gitignore" ".eslintignore" ".eslintrc" ".prettierrc"
        "jest.json" "README.md" "tsconfig.json" "webpack.prod.js" "webpack.dev.js")
    main_files_lenght=${#mainFiles[@]}
    mainFilesTxt=("{
    \"presets\": [
        [\"@babel/preset-env\",
            {\"targets\": {
                \"browsers\": [
                    \"last 3 versions\",
                    \"safari >= 7\",
                    \"ie >= 8\"
                ],
                \"node\": \"6.10\"
            }}
        ]
    ],
    \"plugins\": [
        \"@babel/proposal-class-properties\",
        \"@babel/proposal-object-rest-spread\"
    ]
}"
    ".vscode
node_modules
/lib"
    "lib/
node_modules
src/__tests__
webpack.dev.js
webpack.prod.js"
    "{
    \"parser\": \"@typescript-eslint/parser\",
    \"extends\": [
        \"airbnb\",
        \"plugin:@typescript-eslint/recommended\",
        \"prettier\"
    ],
    \"plugins\": [\"prettier\", \"@typescript-eslint\"],
    \"settings\": {
        \"import/parsers\": {
            \"@typescript-eslint/parser\": [\".ts\", \".tsx\"]
        },
        \"import/resolver\": {
            \"typescript\": {}
        }
    },
    \"rules\": {
        \"prettier/prettier\": \"warn\",
        \"@typescript-eslint/no-unused-vars\":\"warn\",
        \"@typescript-eslint/no-console\": \"off\",
        \"@typescript-eslint/func-names\": \"off\",
        \"@typescript-eslint/no-process-exit\": \"off\",
        \"@typescript-eslint/object-shorthand\": \"off\",
        \"@typescript-eslint/class-methods-use-this\": \"off\",
        \"import/prefer-default-export\": \"off\",
        \"no-param-reassign\": \"off\",
        \"no-whitespace-before-property\":\"off\",
        \"react/jsx-filename-extension\": [2, { \"extensions\": [\".js\", \".jsx\", \".ts\", \".tsx\"] }],
        \"import/no-extraneous-dependencies\": [2, { \"devDependencies\": [\"**/test.tsx\", \"**/test.ts\"] }],
        \"import/extensions\": \"off\"
    }
}" "{
    \"printWidth\": 120,
    \"trailingComma\": \"none\",
    \"singleQuote\": true,
    \"tabWidth\": 4
}" "{
    \"transform\": {
      \"^.+\\\\.(t|j)sx?$\": \"ts-jest\"
    },
    \"testRegex\": \"(/__tests__/.*|(\\\\.|/)(test|spec))\\\\.(jsx?|tsx?)$\",
    \"moduleFileExtensions\": [\"ts\", \"tsx\", \"js\", \"jsx\", \"json\", \"node\"],
    \"collectCoverage\": true,
    \"coverageDirectory\": \"coverage\",
    \"collectCoverageFrom\": [
        \"**/src/*.{ts,tsx,js,jsx}\",
        \"!**/node_modules/**\",
        \"!**/lib/**\"
    ],
    \"coveragePathIgnorePatterns\": [\"<rootDir>/lib/\", \"<rootDir>/node_modules/\"],
    \"coverageReporters\": [\"json\", \"lcov\", \"text\", \"clover\"]
}" "## ${packageName}
${description}
### Installation

### Run

### Author:
${author}"
    "{
    \"compilerOptions\": {
        \"target\": \"ES6\",
        \"module\": \"ES6\",
        \"allowJs\": true,
        \"declaration\": true,
        \"outDir\": \"./lib\",
        \"strict\": true,
        \"noImplicitAny\": true,
        \"noUnusedParameters\": true,
        \"noImplicitReturns\": true,
        \"esModuleInterop\": true
    },
    \"include\": [
        \"src/**/*\"
    ],
    \"exclude\": [
        \"**/__tests__/*\",
        \"node_modules\",
        \"webpack.prod.js\",
        \"webpack.dev.js\"
    ]
}"
    "const path = require('path');

module.exports = {
    entry: './lib/index.js',
    mode: 'production',
    module: {
        rules: [
            {
                test: /\.js$/,
                include: path.resolve(__dirname, 'lib'),
                exclude: /node_modules/,
                loader: 'babel-loader'
            }
        ]
    },
    output: {
        path: path.resolve(__dirname, 'lib'),
        filename: 'index.js'
    }
};"
    "const path = require('path');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = {
    entry: './src/index.ts',
    mode: 'development',
    module: {
        rules: [
            {
                test: /\.ts?$/,
                include: path.resolve(__dirname, 'src'),
                exclude: /node_modules/,
                use: 'ts-loader'
            }
        ]
    },
    resolve: {
        extensions: ['.ts', '.js']
    },
    plugins: [new CleanWebpackPlugin()],
    output: {
        filename: 'index.js',
        path: path.resolve(__dirname, 'lib')
    }
};")

    tsFilesTxt=("export * from './dumb/dumbPrint';"
    "export const dumbPrint = (foo: string, bar: string): string => {
    return \`\${foo}-\${bar}\`;
};" "import * as dumb from '../index';

describe('Test dumbPrint', () => {
    test('Should return string = Foo-Bar', () => {
        expect(dumb.dumbPrint('Foo', 'Bar')).toStrictEqual('Foo-Bar');
    });
});")

     # CREATE FILES ----------------------------------------------------------------------
    for i in `seq 0 $[main_files_lenght-1]`
    do
        touch ${mainFiles[$i]}
    done
    touch src/index.ts src/dumb/dumbPrint.ts src/__tests__/dumb.test.ts

    # ADDING FILE CONTENT ---------------------------------------------------------------
    # add content to main files
    for i in `seq 0 $[main_files_lenght-1]`
    do
        echo "${mainFilesTxt[$i]}" > ${mainFiles[$i]}
    done
    echo "${tsFilesTxt[0]}" > src/index.ts
    echo "${tsFilesTxt[1]}" > src/dumb/dumbPrint.ts
    echo "${tsFilesTxt[2]}" > src/__tests__/dumb.test.ts

    # Replace package.json
    # packageOrgScripts="\"scripts\":{\"test\": \"echo \\\"Error: no test specified\\\" && exit 1\"},"
    # packageRplScripts="\"scripts\": {
    #     \"test\": \"jest --config jest.json\",
    #     \"lint\": \"eslint . --ext .ts,.tsx\",
    #     \"format\": \"prettier --write \\\"src/**/*.ts\\\"\",
    #     \"dev\": \"webpack --config webpack.dev.js\",
    #     \"build\": \"webpack --config webpack.prod.js\",
    #     \"prepare\": \"npm run dev && npm run build\",
    #     \"prepublishOnly\": \"npm test && npm run lint\",
    #     \"preversion\": \"npm run lint\",
    #     \"version\": \"git add -A src\",
    #     \"postversion\": \"git push && git push --tags\"
    # },"
    # sed -i "s/  ${packageOrgScripts}/${packageRplScripts}/" package.json

else
    # npm i -D


    # main files
    mainFiles=(".babelrc" ".gitignore" "README.md" "tsconfig.json" )
    main_files_lenght=${#mainFiles[@]}
fi








# Remove this after end
echo -e "ALL VARIABLES:
$packageName
$description
$author
$serv
$privMSG
$priv
$tool"
