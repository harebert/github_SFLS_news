//
//  PayViewController.h
//  RenrenPaySDKDemo
//
//  Created by  on 11-11-8.
//  Copyright (c) 2011年 renren-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : UIViewController <RenrenDelegate,RenrenPayDelegate>{
    UITextField *_amount;
    UITextField *_description;
    Renren *_renren;
    RenrenPay *_renrenPay;
}

@property (retain ,nonatomic)IBOutlet UITextField *amount;
@property (retain ,nonatomic)IBOutlet UITextField *description;
@property (retain ,nonatomic)Renren *renren;
@property (retain ,nonatomic)RenrenPay *renrenPay;

- (IBAction)submitOrder:(id)sender;
- (IBAction)backgroundClicked:(id)sender;

@end
