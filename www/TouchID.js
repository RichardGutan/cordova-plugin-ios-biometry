function TouchID() {
}

TouchID.prototype.isAvailable = function (successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "TouchID", "isAvailable", []);
};

TouchID.prototype.didFingerprintDatabaseChange = function (successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "TouchID", "didFingerprintDatabaseChange", []);
};

TouchID.prototype.verifyFingerprint = function (message, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "TouchID", "verifyFingerprint", [message]);
};

TouchID.prototype.verifyFingerprintWithCustomPasswordFallback = function (message, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "TouchID", "verifyFingerprintWithCustomPasswordFallback", [message]);
};

TouchID.prototype.verifyFingerprintWithCustomPasswordFallbackAndEnterPasswordLabel = function (message, enterPasswordLabel, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "TouchID", "verifyFingerprintWithCustomPasswordFallbackAndEnterPasswordLabel", [message, enterPasswordLabel]);
};

TouchID.prototype.add = function(key, value, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "TouchID", "add", [key, value]);
};

TouchID.prototype.update = function (key, value, message, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "TouchID", "update", [key, value, message]);
};

TouchID.prototype.contains = function (key, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "TouchID", "contains", [key]);
};

TouchID.prototype.remove = function (key, message, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "TouchID", "remove", [key, message]);
};

TouchID.prototype.retrieve = function (key, value, message, successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, "TouchID", "retrieve", [key, message]);
};

TouchID.install = function () {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.touchid = new TouchID();
  return window.plugins.touchid;
};

cordova.addConstructor(TouchID.install);
