//这个类是用来显示单个新闻的
//  newsDetail.h
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-20.
//  Copyright 2011年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLDocument.h"
#import "XMLelement.h"
#import "WBEngine.h"
#import "WBSendView.h"
#import "DownImage.h"
#define SINA_WEIBO_APP_KEY @"184688088"
#define SINA_WEIBO_APP_SECRET @"11b67e8dbf387e9432dc85c83da4238f"
@interface newsDetail : UIViewController<WBEngineDelegate,WBRequestDelegate,DownloaderDelegate,WBSendViewDelegate,RenrenDelegate>
{
    UILabel *newsDetail_newsTitle;
    IBOutlet UITextView *newsDetail_newsDetail;
    XMLelement *newsDetail_singleNews;
    UIWebView *newsDetail_webView;
    WBEngine *weiboEngin;
    NSDictionary *newsImageIndex;
    UIImage *postImage;
    UIView *faWeiboloadingView;
    NSMutableArray *weiboFriends;
    WBSendView *weiboSendView;
    UIView *atFriendPanel;
    BOOL isAtFriendOn;
    
    //=============人人==================
    Renren *renren;
}
@property (retain, nonatomic) IBOutlet UIButton *ShareToBTN;
- (IBAction)ShareTo:(id)sender;

@property(nonatomic,retain)UITextView *newsDetail_newsDetail;
@property (nonatomic, retain) IBOutlet UILabel *newsDetail_newsTitle;
@property(nonatomic,retain)XMLelement *newsDetail_singleNews;
@property (nonatomic, retain) IBOutlet UIWebView *newsDetail_webView;
@property(nonatomic,retain)WBEngine *weiboEngin;
@property (strong, nonatomic) WBEngine *sinaWeibo;
@property (retain, nonatomic) IBOutlet UIView *shareView;
@property(retain,nonatomic)UIImage *postImage;
@property(retain,nonatomic)UIView *faWeiboloadingView;
@property(retain,nonatomic)NSMutableArray *weiboFriends;
@property(retain,nonatomic)WBSendView *weiboSendView;
@end
