//
//  SFLSNewsAppDelegate.h
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-13.
//  Copyright 2011年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFLSNewsViewController;

@interface SFLSNewsAppDelegate : NSObject <UIApplicationDelegate> {
    SFLSNewsViewController *_MainWindow;
    UIImageView *_MainWindowImageView;
    IBOutlet UITabBarController *myNewTabBarController;
}

@property (nonatomic, retain) IBOutlet SFLSNewsViewController *MainWindow;
@property (nonatomic, retain) IBOutlet UIImageView *MainWindowImageView;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SFLSNewsViewController *viewController;
@property(nonatomic,retain)IBOutlet UITabBarController *myNewTabBarController;

@end
