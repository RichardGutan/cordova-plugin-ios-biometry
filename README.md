# Cordova iOS Biometry plugin

## Index

1. [Installation](#installation)
2. [Usage](#usage)

## Installation

```
$ cordova plugin add https://github.com/RichardGutan/cordova-plugin-ios-biometry.git
```

## Usage

```js

var successCallback = function(type) {
    console.log(type); // "touch" || "face" 
};

var errorCallback = function(err) {
    console.error(err);
};

window.plugins.BiometricKeychain.isAvailable(successCallback, errorCallback);
```

For more info see the whole [interface](https://github.com/RichardGutan/cordova-plugin-ios-biometry/blob/master/www/BiometricKeychain.js)
