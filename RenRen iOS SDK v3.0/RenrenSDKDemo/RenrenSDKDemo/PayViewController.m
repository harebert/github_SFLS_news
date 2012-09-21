//
//  PayViewController.m
//  RenrenPaySDKDemo
//
//  Created by  on 11-11-8.
//  Copyright (c) 2011年 renren-inc. All rights reserved.
//

#import "PayViewController.h"

@implementation PayViewController
@synthesize amount = _amount;
@synthesize description = _description;
@synthesize renren = _renren;
@synthesize renrenPay = _renrenPay;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationItem.title = @"人人支付";
    UIBarButtonItem *rigthButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
	self.navigationItem.rightBarButtonItem = rigthButtonItem;
	[rigthButtonItem release];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backState:)];
	self.navigationItem.leftBarButtonItem = leftButtonItem;
	[leftButtonItem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)submitOrder:(id)sender
{
    [self.amount resignFirstResponder];
    [self.description resignFirstResponder];
    
    NSUInteger amountNum = [self.amount.text intValue];
    NSString *description = self.description.text;
    NSString *orderNum = [self.renrenPay getOrderNumber];
    
    ROPayOrderInfo *order = [self.renrenPay makePayOrderWithOrderNum:orderNum andAmount:amountNum andDescription:description andPayment:nil];

    [self.renrenPay submitPayOrderInNavigationWithOrder:order andPermissions:nil andDelegate:self];
}

- (IBAction)backgroundClicked:(id)sender
{
    [self.amount resignFirstResponder];
    [self.description resignFirstResponder];
}

- (void)logout:(id)sender
{
    [self.renren logout:self];
}

- (void)backState:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)renrenDidLogout:(Renren *)renren
{
	UIAlertView *alertView =[[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经成功退出登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
}


- (void)payDidSuccessWithOrder:(ROPayOrderInfo *)order
{
    if ([order.payEncode isEqualToString:[self.renrenPay getPayResultEncodeWithOrder:order andAppPayPassword:@"YOUR APP PAY PASSWORD"]]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单支付成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)payDidFailWithError:(ROPayError*)error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"code:%@ description:%@",error.errorCode,error.description] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)dealloc
{
    self.amount = nil;
    self.description = nil;
    self.renren = nil;
    self.renrenPay = nil;
    [super dealloc];
}

@end
