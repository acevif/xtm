<br/><br/>
<p align="center">
  <img width="400" src="https://user-images.githubusercontent.com/2769158/44244892-6fa2ba00-a193-11e8-99e7-2da2e3d4978f.png"><br/><br/><br/>
 <img src="https://img.shields.io/badge/Version-1.0.0-blue.svg?longCache=true&style=for-the-badge">
  <a href="https://github.com/Camji55/Xcode-Template-Manager/blob/master/LICENCE.md"><img src="https://img.shields.io/badge/Licence-MIT-green.svg?longCache=true&style=for-the-badge"></a>
    <img src="https://img.shields.io/badge/Made With-Swift-red.svg?longCache=true&style=for-the-badge">
  <a href="https://github.com/vsouza/awesome-ios#other-xcode"><img height="28" src="https://user-images.githubusercontent.com/2769158/44446193-327a6580-a5a1-11e8-91e2-21ca857f95d4.png"></a>
</p><br/>

# Xcode Template Manager

Xcode Template Manager is a Swift command line tool that helps your manage your Xcode project templates.

## How to Install
#### Install with the Installer
Run the following command in your Terminal application:

```sh
curl -o install.sh https://raw.githubusercontent.com/Camji55/Xcode-Template-Manager/master/Install%20Scripts/install.sh && sudo bash install.sh && rm -R -f install.sh
```

#### Install Manually
1. Download or clone this repository

``` 
git clone https://github.com/Camji55/Xcode-Template-Manager.git
```

2. Copy xtm from the Xcode-Template-Manager/xtm folder to...

``` 
/usr/local/bin
```

If you have any issues with the install create an issue [here](https://github.com/Camji55/Xcode-Template-Manager/issues/new).

## How to Uninstall
#### Uninstall with the Uninstaller
Run the following command in your Terminal application:

```sh
curl -o uninstall.sh https://raw.githubusercontent.com/Camji55/Xcode-Template-Manager/master/Install%20Scripts/uninstall.sh && sudo bash uninstall.sh && rm -R -f uninstall.sh
```

#### Uninstall Manually
1. Delete xtm from...

``` 
/usr/local/bin
```

If you have any issues with the uninstall create an issue [here](https://github.com/Camji55/Xcode-Template-Manager/issues/new).

## How to Use

To view all commands type ```xtm -h``` or ```xtm --help``` in the terminal after it has been installed.

## Want your template on xtm?

All you need to do is make sure that the template.xctemplate is in the root folder of it's repository, and add a version.txt inside of the xctemplate folder with a 3 point version number. (Ex. 1.0.0)

[Here](https://github.com/Camji55/DevMountain-Xcode-Template) is an example template that meets these requirements.

## Contributions

Feel free to submit issues and pull requests.

## Licence

Xcode Template Manager is licenced under the MIT licence. See [Licence](https://github.com/Camji55/Xcode-Template-Manager/blob/master/LICENCE.md) for more info.

<br/>

Made with ❤️ by Cameron Ingham
