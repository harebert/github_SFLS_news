//
//  video.m
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "video.h"
#import "RotatingTabBarController.h"
@implementation video
@synthesize videoInfo;
@synthesize videoName,newVideoContent;
@synthesize moviePlayer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{   
    
    videoName.text=newVideoContent.videoName;
    videoInfo.text=newVideoContent.videoInfo;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setVideoName:nil];
    [self setVideoInfo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)dealloc {
    [videoName release];
    [videoInfo release];
    [super dealloc];
}
#pragma playing Movie
-(void)initAndPlay:(NSString *)videoURL

{
    
    if ([videoURL rangeOfString:@"http://"].location!=NSNotFound||[videoURL rangeOfString:@"https://"].location!=NSNotFound) 
        
    {
        
        NSURL *URL = [[NSURL alloc] initWithString:videoURL];
        
        if (URL) {
            MPMoviePlayerController* tmpMoviePlayViewController=[[MPMoviePlayerController alloc] initWithContentURL:URL];
            
            if (tmpMoviePlayViewController)
                
            {
                
                self.moviePlayer=tmpMoviePlayViewController;
                
                
                //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];  //设置应用程序的状态栏到指定的方向
                //[self.moviePlayer.view setFrame:CGRectMake(0, 0, 320, 480)];   //ipad下的设置
                //[self.moviePlayer.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];
                [self.view addSubview:self.moviePlayer.view];
                [self.moviePlayer play];
                [self.moviePlayer setFullscreen:YES animated:YES];
                
                
                //[self.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];
                 
                
            }
            
            //[tmpMoviePlayViewController release];    
            
            
            
            
            
            
            //视频播放完成通知
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoHasFinishedPlaying:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
            
        }
        
        //[URL release];
        
    }
    
}
-(IBAction)stopPlayingVideo:(id)paramSender;{
    if (self.moviePlayer!=nil) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
    }
}
- (void) videoHasFinishedPlaying:(NSNotification *)paramNotification{
    /* Find out what the reason was for the player to stop */ NSNumber *reason =
    [paramNotification.userInfo
     valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if (reason != nil){
        NSInteger reasonAsInteger = [reason integerValue];
        switch (reasonAsInteger){
            case MPMovieFinishReasonPlaybackEnded:{
                /* The movie ended normally */
                break; }
            case MPMovieFinishReasonPlaybackError:{
                /* An error happened and the movie ended */
                break; }
            case MPMovieFinishReasonUserExited:{ /* The user exited the player */
                break; }
        }
        //[self.moviePlayer.view removeFromSuperview];
        NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
        [self stopPlayingVideo:nil]; } /* if (reason != nil){ */
}

- (IBAction)clickToPlay:(id)sender {
    NSString *url=@"http://teacher.sfls.cn/sflsapp/video/Movie/";
    NSString *videoPath =[NSString stringWithFormat:@"%@%@",url,self.newVideoContent.videoPath];    
    
    if (videoPath == NULL)
        
        return;
    
    
    
    [self initAndPlay:videoPath];
}
@end
