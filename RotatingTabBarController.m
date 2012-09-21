//
//  RotatingTabBarController.m
//  附中新闻
//
//  Created by 皓斌 朱 on 12-3-5.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import "RotatingTabBarController.h"
#import "bigClass.h"
@implementation RotatingTabBarController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    UIViewController *theSelectedViewController=[self selectedViewController];
    /*
    if ([[self selectedViewController] isKindOfClass:[bigClass class]]){
        
        return YES;
        
    }
    */
    if ([theSelectedViewController.title isEqualToString:@"视频推送"]) {
        return NO;
    }
    else{
        
        return NO;
    }
    
}
-(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationPortrait;
}

@end
