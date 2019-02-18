var accessControlFlags = {
	"kSecAccessControlDevicePasscode": "kSecAccessControlDevicePasscode",
	"kSecAccessControlUserPresence": "kSecAccessControlUserPresence",
	"kSecAccessControlBiometryAny": "kSecAccessControlBiometryAny",
	"kSecAccessControlBiometryCurrentSet": "kSecAccessControlBiometryCurrentSet"
};

function BiometricKeychain() {
}

BiometricKeychain.prototype.isAvailable = function (successCallback, errorCallback) {
	cordova.exec(successCallback, errorCallback, "BiometricKeychain", "isAvailable", []);
};

BiometricKeychain.prototype.verifyFingerprint = function (message, accessControlFlag, successCallback, errorCallback) {
	if (isFlagValid(accessControlFlag)) {
		cordova.exec(successCallback, errorCallback, "BiometricKeychain", "verifyFingerprint", [message, accessControlFlag]);
	} else {
		throw "BiometricKeychain: invalid access control flag provided.";
	}
};

BiometricKeychain.prototype.add = function (key, value, accessControlFlag, successCallback, errorCallback) {
	if (isFlagValid(accessControlFlag)) {
		cordova.exec(successCallback, errorCallback, "BiometricKeychain", "add", [key, value, accessControlFlag]);
	} else {
		throw "BiometricKeychain: invalid access control flag provided.";
	}
};

BiometricKeychain.prototype.update = function (key, value, message, accessControlFlag, successCallback, errorCallback) {
	if (isFlagValid(accessControlFlag)) {
		cordova.exec(successCallback, errorCallback, "BiometricKeychain", "update", [key, value, message, accessControlFlag]);
	} else {
		throw "BiometricKeychain: invalid access control flag provided.";
	}
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

function isFlagValid(flag) {
	return flag && typeof flag === "string" && accessControlFlags[flag];
}

BiometricKeychain.install = function () {
	if (!window.plugins) {
		window.plugins = {};
	}

	window.plugins.BiometricKeychain = new BiometricKeychain();
	return window.plugins.BiometricKeychain;
};

cordova.addConstructor(BiometricKeychain.install);
