//
//  AppDelegate.h
//  DatenParty
//
//  Created by Maurice Kappelmeyer on 15.10.16.
//  Copyright © 2016 Maurice Kappelmeyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

