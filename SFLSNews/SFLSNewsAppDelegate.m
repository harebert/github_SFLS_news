//
//  SFLSNewsAppDelegate.m
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-13.
//  Copyright 2011年 sfls. All rights reserved.
//

#import "SFLSNewsAppDelegate.h"

#import "SFLSNewsViewController.h"
#import "alumniInput.h"
#import "bigClass.h"
#import "aboutUs.h"
#import "RotatingTabBarController.h"
#import "ViewController.h"
#import "WBEngine.h"
@implementation SFLSNewsAppDelegate

@synthesize MainWindow = _MainWindow;
@synthesize MainWindowImageView = _MainWindowImageView;
@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize myNewTabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    WBEngine *sflsNewsWBEngin=[[WBEngine alloc]initWithAppKey:@"184688088" appSecret:@"11b67e8dbf387e9432dc85c83da4238f"];
    //sleep(1);//用来等待launching image的时间 秒；
    
    UINavigationController *newsNav=[[UINavigationController alloc]init];
    UIBarButtonItem *newsBackButton=[[UIBarButtonItem alloc]initWithTitle:@"新闻" style:UIBarButtonItemStylePlain target:nil action:nil];
    newsNav.tabBarItem.image=[UIImage imageNamed:@"news.png"];
    self.viewController.navigationItem.backBarButtonItem=newsBackButton;
    [newsNav pushViewController:self.viewController animated:NO];
    
    //self.window.rootViewController=self.viewController;
    alumniInput *newAlumniInput=[[alumniInput alloc]init];
    newAlumniInput.title=@"校友联系";
    newAlumniInput.tabBarItem.image=[UIImage imageNamed:@"alumni.png"];
    UINavigationController *alumniNav=[[UINavigationController alloc]init];
    [alumniNav pushViewController:newAlumniInput animated:YES];
    //[newsNav pushViewController:newAlumniInput animated:NO];
    /*
    UINavigationController *avNav=[[UINavigationController alloc]init];
    bigClass *newAvTestView=[[bigClass alloc]init];
    newAvTestView.title=@"视频推送";
    [avNav pushViewController:newAvTestView animated:YES];
    avNav.title=@"视频推送";
    avNav.tabBarItem.image=[UIImage imageNamed:@"av.png"];
    */
    
    UINavigationController *photoCompNav=[[UINavigationController alloc]init];
    ViewController *newPhotoComp=[[ViewController alloc]init];
    newPhotoComp.title=@"摄影大赛";
    [photoCompNav pushViewController:newPhotoComp animated:YES];
    photoCompNav.title=@"摄影大赛";
    photoCompNav.tabBarItem.image=[UIImage imageNamed:@"photoComp.png"];
    
    aboutUs *newAboutUs=[[aboutUs alloc]init];
    newAboutUs.title=@"关于我们";
    newAboutUs.tabBarItem.image=[UIImage imageNamed:@"AboutUs.png"];
    
    NSArray *viewControllerArray=[[NSArray alloc]initWithObjects:newsNav,alumniNav,photoCompNav ,newAboutUs, nil];
    RotatingTabBarController *mainViewController=[[RotatingTabBarController alloc]init];
    myNewTabBarController=mainViewController;
    [myNewTabBarController setViewControllers:viewControllerArray animated:YES];
    
    
    [self.window addSubview:myNewTabBarController.view];
    //self.window.rootViewController =newsNav;
    //self.window.rootViewController=newAlumniInput;
    // self.viewController;
    /*
    CGRect frame = CGRectMake(-1, -1, 400, 44);//TODO: Can we get the size of the text?
    UILabel* label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor yellowColor];
    //The two lines below are the only ones that have changed
    label.text=self.viewController.title;
    label.backgroundColor=[UIColor blueColor];
    self.viewController.navigationItem.titleView=label;
    */
    self.viewController.navigationController.navigationBar.tintColor=[UIColor colorWithRed:0.6465 green:0 blue:0.1200 alpha:1];//设置navigationBar的颜色
    
    [self.window makeKeyAndVisible];
    [newsNav release];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
-(void)didPushViewtoNav:(UIViewController *)view{
    
}
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_MainWindow release];
    [_MainWindowImageView release];
    [super dealloc];
}

@end
