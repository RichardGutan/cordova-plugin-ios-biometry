function BiometricKeychain() {
}

BiometricKeychain.prototype.isAvailable = function (successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "BiometricKeychain", "isAvailable", []);
};

BiometricKeychain.prototype.didFingerprintDatabaseChange = function (successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "BiometricKeychain", "didFingerprintDatabaseChange", []);
};

BiometricKeychain.prototype.verifyFingerprint = function (message, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "BiometricKeychain", "verifyFingerprint", [message]);
};

BiometricKeychain.prototype.verifyFingerprintWithCustomPasswordFallback = function (message, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "BiometricKeychain", "verifyFingerprintWithCustomPasswordFallback", [message]);
};

BiometricKeychain.prototype.verifyFingerprintWithCustomPasswordFallbackAndEnterPasswordLabel = function (message, enterPasswordLabel, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "BiometricKeychain", "verifyFingerprintWithCustomPasswordFallbackAndEnterPasswordLabel", [message, enterPasswordLabel]);
};

BiometricKeychain.prototype.add = function(key, value, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "BiometricKeychain", "add", [key, value]);
};

BiometricKeychain.prototype.update = function (key, value, message, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "BiometricKeychain", "update", [key, value, message]);
};

BiometricKeychain.prototype.contains = function (key, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "BiometricKeychain", "contains", [key]);
};

BiometricKeychain.prototype.remove = function (key, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "BiometricKeychain", "remove", [key]);
};

BiometricKeychain.prototype.retrieve = function (key, message, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "BiometricKeychain", "retrieve", [key, message]);
};

BiometricKeychain.install = function () {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.BiometricKeychain = new BiometricKeychain();
  return window.plugins.BiometricKeychain;
};

cordova.addConstructor(BiometricKeychain.install);
