//
//  SFLSNewsViewController.h
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-13.
//  Copyright 2011年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLDocument.h"
#import "XMLelement.h"
#import "EGORefreshTableHeaderView.h"
#import "sqlite3.h"
@interface SFLSNewsViewController : UIViewController<XMLDocumentDelegate,UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,UIAlertViewDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;
    
    @public
    IBOutlet UIImageView *aboutPage;
    XMLDocument *xmlDocument;
    NSMutableArray *newsList;//新闻数据列表
    IBOutlet UITableView *newsTableView;
    UIWebView *tempWebView;//用来付给小标题头图片做动画用
    UIActivityIndicatorView *activityIndicator;
    UIImageView *topImage;//头条新闻图片
    UILabel *topTitle;//头条新闻标题
    UIWebView *topImage2;//标题新闻图片 用web格式（默认）
    UIView *Class_view;//新闻组侧边框
    UIButton *Class_SlideIn_button;//新闻组侧边框显示按钮
    NSString *xmlAddress;
    BOOL isSmallClass;
    UIBarButtonItem *backToIndex;
    sqlite3 *db;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backToIndex;
- (IBAction)Class_1:(id)sender;
@property (nonatomic, retain) IBOutlet UIButton *Class_SlideIn_button;
- (IBAction)Class_SlideIn:(id)sender;
@property (nonatomic, retain) IBOutlet UIView *Class_view;
@property (nonatomic, retain) IBOutlet UIWebView *topImage2;
@property (nonatomic, retain) IBOutlet UIImageView *topImage;
@property (nonatomic, retain) IBOutlet UILabel *topTitle;
@property(nonatomic,retain)XMLDocument *xmlDocument;
@property(nonatomic,retain)NSMutableArray *newsList;
@property(nonatomic,retain)IBOutlet UITableView *newsTableView;
@property(nonatomic,retain)UIImageView *aboutPage;
@property (nonatomic,retain)NSString *xmlAddress;
@property(nonatomic,assign)BOOL isSmallClass;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
/*
//用作小标题头图片做动画用
@property(nonatomic,retain)UIWebView *tempWebView;
@property(nonatomic,retain)UIActivityIndicatorView *activityIndicator;
-(void)webViewDidStartLoad:(UIWebView *)webView;
-(void)webViewDidFinishLoad:(UIWebView *)webView;
//以上 完毕
*/
 @end
