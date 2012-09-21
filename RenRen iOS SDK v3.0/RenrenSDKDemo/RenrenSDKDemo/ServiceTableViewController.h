//
//  RenrenSDKDemo
//
//  Created by renren-inc on 11-8-19.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import <UIKit/UIKit.h>


@interface ServiceTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,RenrenDelegate, RODialogDelegate, RenrenPayDelegate>{
    NSArray *_sectionHeaders; // NSString array;
    NSArray *_cellText; // array of NSString array;
    NSArray *_cellDetailText; // array of NSString array;
    IBOutlet UINavigationItem *navigationItem;
	Renren *_renren;
    RenrenPay *_renrenPay;
}


@property (nonatomic, retain)NSArray *sectionHeaders;
@property (nonatomic, retain)NSArray *cellText;
@property (nonatomic, retain)NSArray *cellDetailText;
@property (nonatomic, retain)Renren *renren;
@property (nonatomic, retain)RenrenPay *renrenPay;

- (IBAction)logoutButtonClick:(id)sender;
- (IBAction)checkLogButtonClick:(id)sender;
- (void)showAlert:(NSString *)message;
@end
