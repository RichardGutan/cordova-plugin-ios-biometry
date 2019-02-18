#import "BiometricKeychain.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation BiometricKeychain

NSString *keychainItemServiceName = @"BiometricKeychainDummyValueForSecureVerification";

- (void) isAvailable:(CDVInvokedUrlCommand*)command {

  if (NSClassFromString(@"LAContext") == NULL) {
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    return;
  }

  [self.commandDelegate runInBackground:^{

    NSError *error = nil;
    LAContext *laContext = [[LAContext alloc] init];

    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
      NSString *biometryType = @"touch";
      if (@available(iOS 11.0, *)) {
        if (laContext.biometryType == LABiometryTypeFaceID) {
          biometryType = @"face";
        }
      }
      [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:biometryType]
                                  callbackId:command.callbackId];
    } else {
      NSArray *errorKeys = @[@"code", @"localizedDescription"];
      [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:[error dictionaryWithValuesForKeys:errorKeys]]
                                  callbackId:command.callbackId];
    }
  }];
}

- (void) verifyFingerprint:(CDVInvokedUrlCommand*)command {

  NSString *message = [command.arguments objectAtIndex:0];
  NSString *callbackId = command.callbackId;

  [self.commandDelegate runInBackground:^{
    CDVPluginResult* pluginResult = NULL;
    [self createDummyKeychainEntry];

    NSDictionary *query = @{
      (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
      (__bridge id)kSecAttrService: keychainItemServiceName,
      (__bridge id)kSecUseOperationPrompt: message
    };

    OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);

    if (result == errSecSuccess) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      NSString* errorCode = [NSString stringWithFormat:@"%i", result];
		  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorCode];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

- (void) createDummyKeychainEntry {

  NSDictionary *query = @{
		(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
		(__bridge id)kSecAttrService: keychainItemServiceName,
		(__bridge id)kSecValueData: [@"dummy content" dataUsingEncoding:NSUTF8StringEncoding],
		(__bridge id)kSecAttrAccessControl: (__bridge id)[self getAccessControlRef],
		(__bridge id)kSecUseAuthenticationUI: (__bridge id)kSecUseAuthenticationUIAllow
	};

  SecItemAdd((__bridge CFDictionaryRef)query, NULL);
}

- (SecAccessControlRef) getAccessControlRef {
  return SecAccessControlCreateWithFlags(
    kCFAllocatorDefault,
    kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
    1u << 3, // kSecAccessControlBiometryCurrentSet || kSecAccessControlTouchIDCurrentSet
    NULL
  );
}

- (void) add:(CDVInvokedUrlCommand*) command {
  
	NSString* key = [command.arguments objectAtIndex:0];
	NSString* value = [command.arguments objectAtIndex:1];

  [self.commandDelegate runInBackground:^{
    CDVPluginResult* pluginResult = NULL;

    NSDictionary *query = @{
      (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
      (__bridge id)kSecAttrService: key,
      (__bridge id)kSecValueData: [value dataUsingEncoding:NSUTF8StringEncoding],
      (__bridge id)kSecAttrAccessControl: (__bridge id)[self getAccessControlRef],
      (__bridge id)kSecUseAuthenticationUI: (__bridge id)kSecUseAuthenticationUIAllow
    };

    OSStatus result = SecItemAdd((__bridge CFDictionaryRef)query, NULL);

    if (result == errSecSuccess) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      NSString* errorCode = [NSString stringWithFormat:@"%i", result];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorCode];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

- (void) update:(CDVInvokedUrlCommand*) command {
  
	NSString* key = [command.arguments objectAtIndex:0];
	NSString* value = [command.arguments objectAtIndex:1];
	NSString* message = [command.arguments objectAtIndex:2];

  [self.commandDelegate runInBackground:^{
    CDVPluginResult* pluginResult = NULL;

    NSDictionary *query = @{
      (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
      (__bridge id)kSecAttrService: key,
      (__bridge id)kSecAttrAccessControl: (__bridge id)[self getAccessControlRef],
      (__bridge id)kSecUseOperationPrompt: message
    };

    NSDictionary *attributesToUpdate = @{
      (__bridge id)kSecValueData: [value dataUsingEncoding:NSUTF8StringEncoding],
    };

    OSStatus result = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);

    if (result == errSecSuccess) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      NSString* errorCode = [NSString stringWithFormat:@"%i", result];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorCode];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

- (void) contains:(CDVInvokedUrlCommand*) command {

	NSString *key = [command.arguments objectAtIndex:0];

  [self.commandDelegate runInBackground:^{
    CDVPluginResult* pluginResult = NULL;
    NSDictionary *query = @{
      (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
      (__bridge id)kSecAttrService: key,
      (__bridge id)kSecUseAuthenticationUI: (__bridge id)kSecUseAuthenticationUIFail
    };

    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
      
    if (status == errSecInteractionNotAllowed) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}


- (void) remove:(CDVInvokedUrlCommand*) command {

	NSString *key = [command.arguments objectAtIndex:0];

  [self.commandDelegate runInBackground:^{
    CDVPluginResult* pluginResult = NULL;
    NSDictionary *query = @{
      (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
      (__bridge id)kSecAttrService: key
    };

    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);

    if (status == errSecSuccess) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
      NSString* errorCode = [NSString stringWithFormat:@"%i", status];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorCode];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

- (void) retrieve:(CDVInvokedUrlCommand*) command {

	NSString *key = [command.arguments objectAtIndex:0];
	NSString *message = [command.arguments objectAtIndex:1];

  [self.commandDelegate runInBackground:^{
    CDVPluginResult* pluginResult = NULL;
    NSDictionary *query = @{
      (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
      (__bridge id)kSecAttrService: key,
      (__bridge id)kSecUseOperationPrompt: message,
      (__bridge id)kSecReturnData: @YES
    };

    CFDataRef dataRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef*)&dataRef);

    NSData *passwordData = (__bridge_transfer NSData *)dataRef;
    NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];

    if (status == errSecSuccess) {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:password];
    } else {
      NSString* errorCode = [NSString stringWithFormat:@"%i", status];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorCode];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

@end
