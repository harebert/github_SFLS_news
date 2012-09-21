//
//  bigClass.m
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "bigClass.h"
#import "smallClass.h"
#import <QuartzCore/QuartzCore.h>
@implementation bigClass
@synthesize scrowView;
@synthesize bigClassList,xmlDocument;
-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    NSArray *temparray=self.xmlDocument.rootElement.children;
    XMLelement *tempelement=[temparray objectAtIndex:0];
    NSLog(@"Parser finish the first data is %@",tempelement.text); 
    self.bigClassList=self.xmlDocument.rootElement.children;
    int i;
   
    for (i=0; i<=[temparray count]-1; i++) {
        XMLelement *tempele=[self.bigClassList objectAtIndex:i];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(40, i*(25+50)+50, 240, 50);
        NSMutableDictionary *tempid=tempele.attributes;
        button.titleLabel.text=tempele.text;
        [button setTitle:tempele.text forState:UIControlStateNormal];
        button.titleLabel.textColor=[UIColor blackColor];
        [button setTag:[[tempid objectForKey:@"id"] intValue]];
        [button addTarget:self action:@selector(toSmallClass:withTag:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=[UIColor clearColor];
        button.layer.cornerRadius=10;
        button.layer.borderColor=[UIColor blueColor].CGColor;
        button.layer.borderWidth=2;
        button.layer.shadowColor=[UIColor blackColor].CGColor;
        button.layer.shadowOpacity=0.8;
        button.layer.shadowOffset=CGSizeMake(0, 3);
        
        
        [self.scrowView addSubview:button];
        
        NSString *a=[tempid objectForKey:@"id"];
        NSLog(@"%@,%@",a,[a floatValue]);
        NSLog(@"%@",a);
        //NSLog(@"the id is %@ ",[[tempid objectForKey:@"id"] intValue]);
        
    }
    
    
     [self.view addSubview:scrowView];
}
-(void)xmlDocumentDelegateParsingFailed:(XMLDocument *)paramSender withError:(NSError *)paramError{
    NSLog(@"Parse xml failed");
}


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
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"avBAK.png"]];
    NSString *xmlPath=@"http://teacher.sfls.cn/sflsapp/video/creatVideo.asp?query=bigclass";
    XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
    self.xmlDocument=newDocument;
    [newDocument release];
    [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setScrowView:nil];
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
    [scrowView release];
    [super dealloc];
}
- (IBAction)toSmallClass:(id)sender withTag:(int)tag{
    //NSLog(@"%@",[sender tag]);
    smallClass *smallclass=[[smallClass alloc]init];
    smallclass.title=[sender titleForState:UIControlStateNormal];
    [self.navigationController pushViewController:smallclass animated:YES];
}
@end
