//
//  AppDelegate.m
//  ZBeaconSample
//
//  Created by 이수완 on 2016. 4. 4..
//  Copyright © 2016년 ZOYI. All rights reserved.
//

#import "AppDelegate.h"
#import <CommonCrypto/CommonCrypto.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.

  self.manager = [[Manager alloc]
                  initWithEmail:@"app@zoyi.co"
                  authToken:@"17bFLC5F3ddQNwSHKxSk"
                  target:TargetProduction];


  [Manager setDebugMode:true];

  NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  NSString *deviceIdWithSalt = [deviceId stringByAppendingString:@"YOUR_SALT"];
  NSString *customerId = [self hmac: deviceIdWithSalt withKey: @"YOUR_KEY_FOR_HMAC"];

  [Manager setCustomerId: customerId];
  [self.manager start];

  NSLog(@"%@", [Manager customerId]);
  NSLog(@"%@", [Manager packageId]);

//  [self.manager stop];

  return YES;
}

- (NSString *) hmac: (NSString *)plaintext withKey:(NSString *)key
  {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
      [HMAC appendFormat:@"%02x", buffer[i]];
    }
    return HMAC;
  }

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
