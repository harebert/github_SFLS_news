//这个类是用来建立个性化tableViewCell的
//  CustomCell.h
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-21.
//  Copyright 2011年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell <UIWebViewDelegate>{

    UIWebView *CustomCell_newsImage;
    UILabel *CustomCell_newsTitle;
    UITextView *CustomCell_newsInfo;

    UIImageView *CustomCell_backGround;
    
    UIActivityIndicatorView *tempActivityIdicator;
    UIImageView *CustomCell_newsImage2;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *tempActivityIdicator;
@property (nonatomic, retain) IBOutlet UIImageView *CustomCell_newsImage2;

@property (nonatomic, retain) IBOutlet UIImageView *CustomCell_backGround;

@property (nonatomic, retain) IBOutlet UITextView *CustomCell_newsInfo;

@property (nonatomic, retain) IBOutlet UILabel *CustomCell_newsTitle;
@property (nonatomic, retain) IBOutlet UIWebView *CustomCell_newsImage;
-(void)webViewDidStartLoad:(UIWebView *)webView;
-(void)webViewDidFinishLoad:(UIWebView *)webView;
@end
