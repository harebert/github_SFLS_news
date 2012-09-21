//这个类是用来建立个性化tableViewCell的
//  CustomCell.m
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-21.
//  Copyright 2011年 sfls. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell


@synthesize tempActivityIdicator;
@synthesize CustomCell_newsImage2;
@synthesize CustomCell_backGround;
@synthesize CustomCell_newsInfo;
@synthesize CustomCell_newsTitle;
@synthesize CustomCell_newsImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"hello" message:@"hello" delegate:self cancelButtonTitle:@"hello" otherButtonTitles:nil, nil];
        //[alert show];
   
        
    
    }
    return self;
}

-(void)viewDidLoad{
    //CustomCell_newsImage.delegate=self;
    
        }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{   
    CustomCell_newsImage.delegate=self;
   // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [CustomCell_newsImage release];
    [CustomCell_newsTitle release];
    [CustomCell_newsInfo release];
    [CustomCell_backGround release];
    [tempActivityIdicator release];
    [CustomCell_newsImage2 release];
    [super dealloc];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    //tempActivityIdicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    tempActivityIdicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    [tempActivityIdicator startAnimating];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [tempActivityIdicator stopAnimating];
    [tempActivityIdicator hidesWhenStopped];
    tempActivityIdicator.hidden=YES;
    //[tempActivityIdicator release];
}
@end
