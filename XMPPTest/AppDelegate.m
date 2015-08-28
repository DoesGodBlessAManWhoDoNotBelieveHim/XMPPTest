//
//  AppDelegate.m
//  XMPPTest
//
//  Created by wrt on 15/8/24.
//  Copyright (c) 2015年 wrtsoft. All rights reserved.
//

#import "AppDelegate.h"

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPLogging.h"

@interface AppDelegate ()<XMPPStreamDelegate>{
    NSString *_password;
}

@end

@implementation AppDelegate

+ (AppDelegate *)aplicationDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // level 有很多种 debug info warn verbose
    DDTTYLogger *logger = [DDTTYLogger sharedInstance];
    [DDLog addLogger:logger withLogLevel:XMPP_LOG_LEVEL_VERBOSE];
    [DDLog addLogger:logger withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    // DDLog 支持输出信息类型的颜色配置，是日志信息类型分明
    
    [logger setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:XMPP_LOG_FLAG_RECV_POST];
    [logger setForegroundColor:[UIColor grayColor] backgroundColor:nil forFlag:XMPP_LOG_FLAG_SEND];
    
    return YES;
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.wrtsoft.XMPPTest" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XMPPTest" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XMPPTest.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (XMPPStream *)xmppStream{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc]init];
        
        [_xmppStream setHostName:kXMPP_HOST];
        [_xmppStream setHostPort:KXMPP_PORT];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppStream;
}

-(void)loginWithJID:(XMPPJID *)aJID addPassword:(NSString *)password{
    [self.xmppStream setMyJID:aJID];
    _password = password;
    [self.xmppStream connectWithTimeout:-1 error:nil];
}

- (void)goOnline{
    XMPPPresence *presence = [XMPPPresence presence];
    // 若要发送复杂的persence
    /*
     <presence type="availabel">
        <status>忙碌</status>         自定义
        <show>xa</show>               只能跟固定的值
     </presence>
     */
    [presence addChild:[DDXMLNode elementWithName:@"status" stringValue:@"忙碌"]];
    [presence addChild:[DDXMLNode elementWithName:@"show" stringValue:@"dnd"]];
    [self.xmppStream sendElement:presence];
}

- (void)goOffline{
    
}

#pragma mark - XMPPStream Delegate
// socket 连接建立成功
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"socketDidConnect");
    NSError *error;
    //[self.xmppStream authenticateWithPassword:_password error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}

// xml流初始化成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"xmppStreamDidConnect");
     NSError *error;
    
    [self.xmppStream authenticateWithPassword:_password error:&error];
}

/**
 * This method is called after authentication has successfully finished.
 * If authentication fails for some reason, the xmppStream:didNotAuthenticate: method will be called instead.
 **/
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"登录成功");
    [self goOnline];
}

/**
 * This method is called if authentication fails.
 **/
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"登录失败");
}

@end
