//
//  newsDetail.m
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-20.
//  Copyright 2011年 sfls. All rights reserved.
//

#import "newsDetail.h"
#import "XMLelement.h"
#import "newsImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
@implementation newsDetail
@synthesize shareView;
@synthesize ShareToBTN;
@synthesize newsDetail_newsTitle,newsDetail_newsDetail,newsDetail_singleNews,newsDetail_webView,sinaWeibo,weiboEngin,weiboFriends,postImage,faWeiboloadingView,weiboSendView;

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
    renren=[Renren sharedRenren];
    isAtFriendOn=NO;        //设置弹出好友列表为否
    [self.shareView setHidden:YES];//隐藏分享按钮栏
    self.title=[newsDetail_singleNews.attributes objectForKey:@"title"];
    self.navigationController.navigationBar.tintColor=self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:0.6465 green:0 blue:0.1200 alpha:1];//设置navigationBar的颜色
    //NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];//需要去掉的字符集
    //将每一个新闻里面的每一个element元素都放到相应的栏目里面，其中title和content为字符串，image和imageinfo放在可变数组里。或者放在字典里。
    NSMutableArray *thisNews=[[NSMutableArray alloc]initWithArray:newsDetail_singleNews.children];
    XMLelement *tempelement=[[XMLelement alloc]init];
    tempelement=[thisNews objectAtIndex:1];
    //NSLog(@"%@ %@",tempelement.name,tempelement.text);
    //NSLog([thisNews objectAtIndex:1])
    NSString *newsTitle=[[NSString alloc]init];
    NSString *newsContent=[[NSString alloc]init];
    NSMutableArray *imageArray=[[NSMutableArray alloc]init];//存放图片组
    NSMutableDictionary *elementInfo=[[NSMutableDictionary alloc]init];
    int i;
    for (i=0; i<[thisNews count]; i++) {
        XMLelement *thisElement=[[XMLelement alloc]init];
        thisElement=[thisNews objectAtIndex:i];
        [elementInfo setObject:thisElement.text forKey:thisElement.name];
       //开辟一个图片专用类，存放图片
        if ([thisElement.name isEqualToString:@"image"]) {
            newsImage *findNewImage=[[newsImage alloc]init];
            //NSLog(@"%@",thisElement.attributes);
            findNewImage.imageInfo=[thisElement.attributes objectForKey:@"imageinfo"];
            findNewImage.imageRange=[thisElement.attributes objectForKey:@"range"];
            findNewImage.imageURL=thisElement.text;
            [imageArray addObject:findNewImage];
            [findNewImage release];
        }
        
        //图片类开辟结束
               [thisElement release];
        
    }
    newsImage *newDownLoadIamage=[imageArray objectAtIndex:0];
    DownImage *newdownLoad=[[DownImage alloc]init];
    [newdownLoad setDelegate:self];
    newdownLoad.imageUrl=newDownLoadIamage.imageURL;
    [newdownLoad startDownload];
    //下载第一张图片

    newsTitle=[elementInfo objectForKey:@"title"];
    newsContent=[elementInfo objectForKey:@"content"];
    
    newsDetail_newsTitle.font=[UIFont fontWithName:@"新魏" size:57];
    newsDetail_newsTitle.text=newsTitle;
    newsDetail_newsDetail.text=newsContent;

    //为uiwebview添加html内容
    NSMutableString *HTMLString=[[NSMutableString alloc]initWithFormat:@""];
    //1。添加图片
    for (i=0; i<[imageArray count]; i++) {
        newsImage *tempimage=[[newsImage alloc]init];
        tempimage=[imageArray objectAtIndex:i];
        [HTMLString appendFormat:@"<p align=center><img src=\"%@\" width=240>",tempimage.imageURL];
        //[HTMLString appendFormat:@"</p>"];
        ///[HTMLString appendFormat:@"<p align=center>%@",tempimage.imageInfo;
        [HTMLString appendFormat:@"</p>"];
        [tempimage release];
    }
    //图片添加完毕
    [HTMLString appendFormat:@"%@",newsContent];
    [newsDetail_webView loadHTMLString:HTMLString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    [HTMLString release];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNewsDetail_newsTitle:nil];
    [newsDetail_newsDetail release];
    newsDetail_newsDetail = nil;
    [self setShareToBTN:nil];
    [self setShareView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [newsDetail_newsTitle release];
    [newsDetail_newsDetail release];
    [ShareToBTN release];
    [shareView release];
    [super dealloc];
}
#pragma sinaWeibo
- (void)weiboEngineInit                                         //微博初始化
{
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:SINA_WEIBO_APP_KEY appSecret:SINA_WEIBO_APP_SECRET];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    
    /*
     設為 YES 的話，執行 [self.sinaWeibo logIn] 之後
     如果已經登入過，就會直接執行 engineAlreadyLoggedIn
     否則就會出現輸入帳號密碼的 view
     */
    [engine setIsUserExclusive:YES];
    
    self.sinaWeibo = engine;
}

- (IBAction)ShareTo:(id)sender {                                //点击分享按钮
    //微博登录按钮
    UIButton *sinaWeiboBtn=[UIButton buttonWithType:UIButtonTypeCustom];;
    [sinaWeiboBtn setBackgroundImage:[UIImage imageNamed:@"sina.png"] forState:UIControlStateNormal];
    //CGRect shareBTNframe=ShareToBTN.frame;
    sinaWeiboBtn.frame=CGRectMake(5,15,40,40);
    sinaWeiboBtn.layer.shadowColor=[UIColor blackColor].CGColor;
    sinaWeiboBtn.layer.shadowOffset=CGSizeMake(1, 1);
    sinaWeiboBtn.layer.shadowOpacity=0.5;
    sinaWeiboBtn.layer.shadowRadius=1;
    [sinaWeiboBtn addTarget:self action:@selector(sinaWeiboBtn:) forControlEvents:UIControlEventTouchUpInside];
    //人人登录按钮
    UIButton *renrenBtn=[UIButton buttonWithType:UIButtonTypeCustom];;
    [renrenBtn setBackgroundImage:[UIImage imageNamed:@"renren.png"] forState:UIControlStateNormal];
    //CGRect shareBTNframe=ShareToBTN.frame;
    renrenBtn.frame=CGRectMake(5,65,40,40);
    renrenBtn.layer.shadowColor=[UIColor blackColor].CGColor;
    renrenBtn.layer.shadowOffset=CGSizeMake(1, 1);
    renrenBtn.layer.shadowOpacity=0.5;
    renrenBtn.layer.shadowRadius=1;
    [renrenBtn addTarget:self action:@selector(renrenLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    //[sinaWeiboBtn setFrame:CGRectMake(0, 0, 50, 50)];
    if (self.shareView.hidden) {
        
        self.shareView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"shareViewBG.png"]];
        //shareView.backgroundColor=[UIColor clearColor];
        //self.shareView.layer.opacity=0.7;
        [self.shareView setHidden:NO];
        self.shareView.frame=CGRectMake(270, 35, 50, 110);
        shareView.layer.shadowColor=[UIColor blackColor].CGColor;
        shareView.layer.shadowOffset=CGSizeMake(1, 1);
        shareView.layer.shadowOpacity=0.5;
        shareView.layer.shadowRadius=1;
        [self.shareView addSubview:sinaWeiboBtn];
        [self.shareView addSubview:renrenBtn];
    }
    else{
        [self.shareView setHidden:YES];
    }
    NSLog(@"addbutton at frame");
}
- (IBAction)sinaWeiboBtn:(id)sender {                       //点击新浪微博
    if (!self.sinaWeibo) {
        [self weiboEngineInit];
    }
    
    [self.sinaWeibo logIn];
    [shareView setHidden:YES];
}

- (void)engineAlreadyLoggedIn:(WBEngine *)engine{           //微博已经登录
    NSLog(@"already log in");
    WBSendView *newSendView=[[WBSendView alloc]initWithAppKey:SINA_WEIBO_APP_KEY appSecret:SINA_WEIBO_APP_SECRET text:newsDetail_newsTitle.text image:postImage];
    [newSendView setDelegate:self];
    [newSendView show:YES];
    self.weiboSendView=newSendView;
    
    //读取好友
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:engine.userID,@"uid",nil];
    [engine loadRequestWithMethodName:@"friendships/followers.json"
     //需要screen_name uid之一 双向好友
                           httpMethod:@"GET"
                               params:dictionary
     //params:nil
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
}
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{                                                           //微博请求得到响应（如好友信息等）
    
    NSLog(@"requestDidSucceedWithResult: %@", result);
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        NSMutableArray *users=[[NSMutableArray alloc]init];
        [users addObjectsFromArray:[dict objectForKey:@"users"]];
        weiboFriends=users;
        //[Follows addObjectsFromArray:[dict objectForKey:@"users"]];
        //[Follows addObjectsFromArray:[dict objectForKey:@"statuses"]];
        //[FollowsTableView reloadData];
    }
    //NSLog(@"%d",[Follows count]);
}
// Log in successfully.
- (void)engineDidLogIn:(WBEngine *)engine{                          //微博刚登录
    NSLog(@"did log in");
}
-(void)appImageDidLoad:(NSInteger)indexTag urlImage:(NSString *)imageUrl imageName:(NSString *)imageName{                                                               //获取到第一张发送图片
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",documentDir,imageName];
    NSLog(@"%@",imagePath);
    postImage=[[UIImage alloc]init];
    postImage=[UIImage imageWithContentsOfFile:imagePath];
    [postImage retain];

}
#pragma sendView
-(void)sendViewDidFinishSending:(WBSendView *)view{                 //微博通过窗口发送完毕
     NSLog(@"sent!");
    [view hide:YES];
    
    
}
-(void)sendView:(WBSendView *)view didFailWithError:(NSError *)error{       //微博发送失败
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"有点小麻烦哦"
                                                         message:@"可能有以下原因造成：\n1.你发送的太频繁了\n2.你发送同样一条新闻被新浪发现了\n再试试吧！"
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
    [alertView show];

}
-(void)sendViewDidClickAtButton:(WBSendView *)view{                             //点击@按钮弹出好友列表
    //隐藏键盘降下view
if (!isAtFriendOn) {
        
    [view.contentTextView resignFirstResponder];
    if (view.frame.origin.y==73)
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [view setFrame:CGRectInset(view.frame, 0, 51)];
        [UIView commitAnimations];
    //隐藏键盘降下view
    }
    CGSize size = CGSizeMake(320,2000);
    UIFont *font = [UIFont fontWithName:@"Arial" size:18];
    UIScrollView *atFriendsView=[[UIScrollView alloc]init];
    atFriendsView.frame=CGRectMake(0, 20, 320, 220);
    atFriendsView.backgroundColor=[UIColor clearColor];
    NSDictionary *singleFriendDic=[[NSDictionary alloc]init];
    
//添加关闭按钮    
    UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"完成@" forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"delete@2x.png"] forState:UIControlStateNormal];
    closeButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:14];
    closeButton.frame=CGRectMake(280, 0, 20, 20);
    [closeButton addTarget:self action:@selector(closeAtFriendsView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *tempview=[[UIView alloc]init];
    atFriendPanel=tempview;
    atFriendPanel.frame=CGRectMake(0, 480, 320, 240);
    atFriendPanel.backgroundColor=[UIColor clearColor];
//添加完毕
    int i=[weiboFriends count];
    int lineWidth=0;
    int line=0;
    for (i=0; i<[weiboFriends count]-1; i++) {
        UIButton *singleFriend=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        singleFriend.tintColor=[UIColor grayColor];
        singleFriend.titleLabel.textColor=[UIColor whiteColor];
        singleFriend.titleLabel.lineBreakMode=0;
        singleFriend.titleLabel.font=font;
        singleFriendDic=[weiboFriends objectAtIndex:i];
        [singleFriend setTitle:[NSString stringWithFormat:@"@%@",[singleFriendDic objectForKey:@"name"]] forState:UIControlStateNormal];
        [singleFriend addTarget:self action:@selector(clickAtFriend:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"%@",singleFriend.titleLabel.text);
        CGSize labelSize=[singleFriend.titleLabel.text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        labelSize.width++;
        labelSize.height++;
        NSLog(@"w:%f,h:%f",labelSize.width,labelSize.height);
        if (lineWidth+labelSize.width<320) {
            singleFriend.frame=CGRectMake(lineWidth, line*labelSize.height, labelSize.width, labelSize.height);
            lineWidth=lineWidth+labelSize.width;
            [atFriendsView addSubview:singleFriend];
        }
        else
        {
            lineWidth=0;
            line++;
            singleFriend.frame=CGRectMake(lineWidth, line*labelSize.height, labelSize.width, labelSize.height);
            lineWidth=lineWidth+labelSize.width;
            [atFriendsView addSubview:singleFriend];
        }
    }
    CGSize labelSize=[@"abcd" sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    atFriendsView.contentSize=CGSizeMake(320, (line+2)*labelSize.height);
    [atFriendsView setScrollEnabled:YES];
    [atFriendPanel addSubview:atFriendsView];
    [atFriendPanel addSubview:closeButton];
    [view addSubview:atFriendPanel];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Curl" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    atFriendPanel.frame=CGRectMake(0, 240, 320, 240);
    [UIView commitAnimations];
}
    isAtFriendOn=YES;
}
- (void)clickAtFriend:(UIButton *)sender {                              //点击@好友名字按钮
    
    weiboSendView.contentTextView.text=[NSString stringWithFormat:@"%@%@",weiboSendView.contentTextView.text,sender.titleLabel.text];
    NSLog(@"at a friend");
    
}
- (void)closeAtFriendsView:(UIButton *)sender {                         //关闭@好友列表
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Curl" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    atFriendPanel.frame=CGRectMake(0, 480, 320, 240);
    [UIView commitAnimations];
    isAtFriendOn=NO;
    //[atFriendsList setHidden:YES];

}
-(void)sendViewDidClickSendButton:(WBSendView *)view{                       //上传微博
    //显示上传指示符
    UIView *theView=[[UIView alloc]init];
    theView.frame=CGRectMake(110, 150, 100, 100);
    theView.backgroundColor=[UIColor blackColor];
    theView.layer.opacity=0.9;
    theView.layer.cornerRadius=10;
    UIActivityIndicatorView *theActInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [theActInd startAnimating];
    theActInd.frame=CGRectMake(40, 40, 20, 20);
    [theView addSubview:theActInd];
    UITextView *theTexVie=[[UITextView alloc]init];
    theTexVie.frame=CGRectMake(0, 60, 100, 40);
    theTexVie.text=@"上传中...";//[NSString stringWithFormat:@"%@...",uploadObject];
    theTexVie.font=[UIFont fontWithName:@"黑体" size:40];
    theTexVie.backgroundColor=[UIColor clearColor];
    theTexVie.textAlignment=UITextAlignmentCenter;
    theTexVie.textColor=[UIColor whiteColor];
    //uploadTextStatus=theTexVie;
    [theView addSubview:theTexVie];
    self.faWeiboloadingView=theView;
    //[self.view addSubview:loadingView];
    [view addSubview:faWeiboloadingView];
    self.view.layer.backgroundColor=[UIColor whiteColor].CGColor;
    self.view.layer.opacity=0.9;
    CABasicAnimation *theBaseAni=[CABasicAnimation animationWithKeyPath:@"opacity"];
    [theBaseAni setFromValue:[NSNumber numberWithFloat:0]];
    [theBaseAni setToValue:[NSNumber numberWithFloat:0.9]];
    [theBaseAni setDuration:1];
    
    [faWeiboloadingView.layer addAnimation:theBaseAni forKey:@"opacityAnimation"];
}

#pragma 人人网
-(void)renrenLogin:(id)sender{
    [self.shareView setHidden:YES];
    if(![renren isSessionValid]){//未登录的情况,进行授权登录
        NSArray *permissions=[NSArray arrayWithObjects:@"photo_upload",nil];
        [renren authorizationWithPermisson:permissions andDelegate:self];
    } else {//已登录的情况，退出登录
        [renren publishPhotoSimplyWithImage:postImage caption:newsDetail_newsTitle.text];
    }
}

@end
