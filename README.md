# npm-package-creator
> Complex npm package creator (bash).

## About
The Package Wizard will create a repository for you on the chosen platform (GitHub, GitLab or Bitbucket). It allows you to choose the right configuration (Webpack+babel, Babel, Node) for your target.  It will carry out the whole process of installation and configuration of tools according to good practices.

## Getting Started
> The script is designed for **Linux** and **Mac** users.

First we have to grant permission to the script.<br>
In the directory where we downloaded the script:
```
$ chmod +x package-creator.sh
```

Then we can run it:
```
$ ./package-creator.sh
```

Or we can add the script to the PATH<br>
Follow these steps:
```
$ sudo mv package-creator.sh /usr/local/bin
$ sudo touch ~/.bash_aliases
$ sudo sh -c "echo \"alias package-creator='/usr/local/bin/package-creator.sh'\" > ~/.bash_aliases"
$ source ~/.bash_aliases
```

And just type wherever you want to create a new package:
```
$ package-creator
```

## Running
The script will guide you through the whole installation process, from initialization of the repository on the chosen platform to installation and project configuration.

You can choose from 3 platforms:
- [Github](https://github.com/) (PAT needed)
- [Gitlab](https://gitlab.com/) (PAT needed)
- [Bitbucket](https://bitbucket.org/)

and 3 tool configurations:
- [Webpack](https://webpack.js.org) + [Babel](https://babeljs.io/)
- [Babel](https://babeljs.io/)
- [Node](https://nodejs.org/en/) (for pure nodejs packages)

You can create packages for any framework, like:
- [React](https://reactjs.org/)
- [Angular](https://angularjs.org/)


After creating a new project, you have ready-made commands:
- to build production package
```
    $ npm run build
```
- run tests
```
    $ npm run test
```
- lint code
```
    $ npm run lint
```
- format code
```
    $ npm run format
```
- publish package
```
    $ npm run publish
```
- prepare new version of package and publish it
```
    $ npm version patch && npm publish
```
for more commands (for specific configuration), see **`package.json`**

## Tools used
- [Webpack](https://webpack.js.org)
- [Babel](https://babeljs.io/)
- [Jest](https://jestjs.io/)
- [ESlint](https://eslint.org/)
- [Typescript](https://www.typescriptlang.org/)
- [Prettier](https://prettier.io/)

and more needed plugins and configurations.

## Author
>[Michal Siemienowicz](linkedin.com/in/michal-siemienowicz-761879151)

If I helped you, you can help me with my work. 🍻

<a target="_blank" rel="noopener noreferrer" href="https://paypal.me/msmikesm/3"><img src="https://img.shields.io/badge/-Donate--me-blue?color=00457C&logo=paypal&style=for-the-badge"></a>

## License
This project is licensed under the MIT License - see the LICENSE.md file for details.
