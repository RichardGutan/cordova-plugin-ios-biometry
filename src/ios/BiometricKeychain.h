#import <Cordova/CDVPlugin.h>

@interface BiometricKeychain :CDVPlugin

- (void) isAvailable:(CDVInvokedUrlCommand*)command;

- (void) didFingerprintDatabaseChange:(CDVInvokedUrlCommand*)command;

- (void) verifyFingerprint:(CDVInvokedUrlCommand*)command;
- (void) verifyFingerprintWithCustomPasswordFallback:(CDVInvokedUrlCommand*)command;
- (void) verifyFingerprintWithCustomPasswordFallbackAndEnterPasswordLabel:(CDVInvokedUrlCommand*)command;

- (void) add:(CDVInvokedUrlCommand*) command;
- (void) update:(CDVInvokedUrlCommand*) command;
- (void) contains:(CDVInvokedUrlCommand*) command;
- (void) remove:(CDVInvokedUrlCommand*) command;
- (void) retrieve:(CDVInvokedUrlCommand*) command;

@end
