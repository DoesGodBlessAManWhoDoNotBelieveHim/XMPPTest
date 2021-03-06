//
//  AppDelegate.h
//  XMPPTest
//
//  Created by wrt on 15/8/24.
//  Copyright (c) 2015年 wrtsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (AppDelegate *)aplicationDelegate;






@property (nonatomic,strong) XMPPStream *xmppStream;
-(void)loginWithJID:(XMPPJID *)aJID addPassword:(NSString *)password;
- (void)goOnline;
- (void)goOffline;

@end

