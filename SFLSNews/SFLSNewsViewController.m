//
//  SFLSNewsViewController.m
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-13.
//  Copyright 2011年 sfls. All rights reserved.
//

#import "SFLSNewsViewController.h"
#import "XMLelement.h"
#import "newsDetail.h"
#import "CustomCell.h"
#import "math.h"

@implementation SFLSNewsViewController
@synthesize backToIndex;
@synthesize Class_SlideIn_button;
@synthesize Class_view;
@synthesize topImage2;
@synthesize topImage;
@synthesize topTitle;
@synthesize xmlDocument,newsList,newsTableView,aboutPage;
@synthesize xmlAddress,isSmallClass;
//@synthesize tempWebView,activityIndicator;//用作头图片loading用
- (void)didReceiveMemoryWarning
{
       [super didReceiveMemoryWarning];
}
-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    
   
    self.newsList=self.xmlDocument.rootElement.children;
     [self.newsTableView reloadData];
    /*
    //寻找第一条新闻的图片连接
    XMLelement *tempElement;
    tempElement=[self.newsList objectAtIndex:0];
    tempElement=[tempElement.children objectAtIndex:3];
    NSString *URL = tempElement.text;
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:URL]];
    UIImage *image=[[UIImage alloc] initWithData:imageData];
    [topImage setImage:image]; 
    [imageData release];
    topTitle.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9];
    tempElement=[self.newsList objectAtIndex:0];
    tempElement=[tempElement.children objectAtIndex:0];
    topTitle.text=tempElement.text;
    //[tempElement release];
    */
    XMLelement *tempElement;
    tempElement=[self.newsList objectAtIndex:0];
    tempElement=[tempElement.children objectAtIndex:3];
    NSString *URL = tempElement.text;
    NSMutableString *HTMLString=[[NSMutableString alloc]initWithFormat:@"<html><body style=\"margin:0\"><style type=\"text/css\">body {background-color: #ffffff;}</style><img src=\"%@\" width=320 height=170 style=\"border:0 solid #ffffff\"></body></html>",URL];
    [topImage2  loadHTMLString:HTMLString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    //[HTMLString release];
        topTitle.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9];
    tempElement=[self.newsList objectAtIndex:0];
    tempElement=[tempElement.children objectAtIndex:0];
    topTitle.text=tempElement.text;
    
   
    //将新闻列表带内容图片等等都放入self的newslist里面。在numberof rows in secton中加以分离。
    }
-(void)xmlDocumentDelegateParsingFailed:(XMLDocument *)paramSender withError:(NSError *)paramError{
    NSLog(@"Parse xml failed");
}



-(void)viewDidLoad{
    //评分系统
    NSString *rateFilePath;
    char *errorMsg;
    rateFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"rate.sqlite"];
    NSLog(@"%@",rateFilePath);
    sqlite3_open( [rateFilePath UTF8String],&db);
    NSString * isFirst=@"select * from rateDB";
    sqlite3_stmt *isFirststatement;
    sqlite3_prepare_v2(db, [isFirst UTF8String], -1, &isFirststatement, nil);
    if (sqlite3_step(isFirststatement)==SQLITE_ROW) {
        int times;
        times= sqlite3_column_int(isFirststatement, 1);
        if (times==5) {
            NSLog(@"5 times");
            UIAlertView *rateAlertView=[[UIAlertView alloc]initWithTitle:@"请对APP评分" message:@"您已经使用本APP一段时间了，感谢您的支持的同时，如果支持此APP的发展，请拨冗前往进行评分" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去评分", nil];
            rateAlertView.tag=2;
            [rateAlertView show];
            NSString *addTimes=[NSString stringWithFormat: @"update rateDB set loginTimes=loginTimes+1 where rateId=1"];
            sqlite3_exec(db, [addTimes UTF8String], NULL, NULL, &errorMsg);
        }else{
            NSString *addTimes=[NSString stringWithFormat: @"update rateDB set loginTimes=loginTimes+1 where rateId=1"];
            sqlite3_exec(db, [addTimes UTF8String], NULL, NULL, &errorMsg);
        }
        //NSString *insertRecord=[NSString stringWithFormat: @"INSERT OR REPLACE INTO 'rateDB' ('rateId','loginTimes') VALUES(1,1)"];
        //sqlite3_exec(db, [insertRecord UTF8String], NULL, NULL, &errorMsg);
    }
    else{
        
        if (sqlite3_open([rateFilePath UTF8String], &db)!=SQLITE_OK) {//打开数据库失败
            NSLog(@"database error");
        }
        
        
        else{//打开数据库成功
            
            NSString *creatSQL=@"CREATE TABLE IF NOT EXISTS 'rateDB'('rateID' INTEGER primary key,'loginTimes' INTEGER DEFAULT 1)";
            if (sqlite3_exec(db,[creatSQL UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK)
            {
                //打开表、创建表失败
            }
            else
            {//打开表成功，写入数据库；
                NSString *insertRecord=[NSString stringWithFormat: @"INSERT OR REPLACE INTO 'rateDB' ('rateId','loginTimes') VALUES(1,1)"];
                sqlite3_exec(db, [insertRecord UTF8String], NULL, NULL, &errorMsg);   
            }
        }
    }
    //评分系统

    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.newsTableView.bounds.size.height, self.view.frame.size.width, self.newsTableView.bounds.size.height)];
        view.delegate = self;
        [self.newsTableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
        //[[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight animated:NO]; 
        topTitle.text=@"";
        NSString *defaultXmlAddress=[[NSString alloc]initWithString:@"http://teacher.sfls.cn/sflsapp/xmldoc.xml"];
        self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:0.6465 green:0 blue:0.1200 alpha:1];//设置标题色为红色
        if ([xmlAddress length]==0) {//如果第一次读取，则给予默认页面
        xmlAddress=defaultXmlAddress;
        self.title=@"上外附中 新闻";
            
        //self.navigationItem.leftBarButtonItem.enabled=NO;
    }
    else
    {//否则判断：1。非主页，则给一个返回按钮，回主页；2。主页，则不给返回按钮
        
        if ([xmlAddress isEqualToString:defaultXmlAddress]) {
            //self.navigationItem.leftBarButtonItem=nil;
        }
        else
        {
            backToIndex.title=@"返回";
            backToIndex.style=UIBarButtonItemStyleDone;
            self.navigationItem.leftBarButtonItem=backToIndex;
        }
    }

    NSString * xmlPath=xmlAddress;
    XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
    self.xmlDocument=newDocument;
    [newDocument release];
    //CGRect frame_topimage=CGRectMake(0, 0, 320, 171);
    //topImage2.frame=frame_topimage;
    CGRect frame_topTitle=CGRectMake(0, 151, 320, 20);
    topTitle.frame=frame_topTitle;
    [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
    CGRect frame=CGRectMake(320, 0, 85,170);
    Class_view.frame=frame;
    CGRect frame_slideInButton=CGRectMake(292, 0 , 28, 28);
    Class_SlideIn_button.frame=frame_slideInButton;
    Class_view.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.0];
    
    //[self.view addSubview:topImage2];    
    [self.newsTableView addSubview:topTitle];
    [self.view addSubview:Class_view];
    [self.view addSubview:Class_SlideIn_button];
    

}



#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.newsList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*以下原有的默认cell效果
    static NSString * NoteScanIdentifier=@"NoteScanIdentifier";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:NoteScanIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NoteScanIdentifier];
    }
    NSUInteger row=[indexPath row];
    XMLelement *singleNews=[[XMLelement alloc]init];
    singleNews=[newsList objectAtIndex:row];
    //分离出每一个单独的新闻，并将其中的title提取出来。
    cell.textLabel.text=[singleNews.attributes objectForKey:@"title"];
    [singleNews release];
    return cell;
     */
    static NSString * NoteScanIdentifier=@"NoteScanIdentifier";
    CustomCell *cell=(CustomCell *)[tableView dequeueReusableCellWithIdentifier:NoteScanIdentifier];
    
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    XMLelement * thisNewsElement=[[XMLelement alloc]init];
    thisNewsElement=[newsList objectAtIndex:[indexPath row]];//提取本条新闻含root
    NSMutableArray * thisNewsAll=[[NSMutableArray alloc]initWithArray:thisNewsElement.children];//提取不含root的新闻所有元素
    int i;
    NSMutableDictionary *thisNewsAllInDic=[[NSMutableDictionary alloc]init];
    for (i=0; i<[thisNewsAll count]; i++) {
        XMLelement *temp=[[XMLelement alloc]init];
        temp=[thisNewsAll objectAtIndex:i];
        [thisNewsAllInDic setObject:temp.text forKey:temp.name];
        [temp release];
    }
    //cell.CustomCell_backGround.backgroundColor=[UIColor redColor];
    //改变每个cell以不同的颜色
    NSString * webColor=[[NSString alloc]init];
    if ([indexPath row]%2==0) {
        cell.CustomCell_backGround.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
            webColor=@"cccccc";
    }
    else{
        cell.CustomCell_backGround.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
            webColor=@"e5e5e5";
    }
    //改变完毕
    
    NSString *titleTemp=[[NSString alloc]initWithString:[thisNewsAllInDic objectForKey:@"title"]];
    if ([titleTemp length]>11) {
        cell.CustomCell_newsTitle.text=[NSString stringWithFormat:@"%@..",[titleTemp substringToIndex:11]];
    }
    else{
        cell.CustomCell_newsTitle.text=[thisNewsAllInDic objectForKey:@"title"];
    }
    [titleTemp release];
    //设置标题题目不长于11个字符
    cell.CustomCell_newsInfo.text=[thisNewsAllInDic objectForKey:@"content"];
    NSMutableString *HTMLString=[[NSMutableString alloc]initWithFormat:@"<html><body style=\"margin:0\"><style type=\"text/css\">body {background-color: #%@;}</style><img src=\"%@\" width=85 height=61 style=\"border:1 solid #ffffff\"></body></html>",webColor,[thisNewsAllInDic objectForKey:@"image"]];
    
    //用作小标题头图片做动画用
    //activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //tempWebView=[[UIWebView alloc]init];
    //[tempWebView loadHTMLString:HTMLString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    //tempWebView.delegate=self;
    //cell.CustomCell_newsImage=tempWebView;
    //以上 完毕
   
    /*用UIIMAGE来获取图片
    NSString *URL = [thisNewsAllInDic objectForKey:@"image"];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:URL]];
    UIImage *image=[[UIImage alloc] initWithData:imageData];
    [cell.CustomCell_newsImage2 setImage:image]; 
    [imageData release];
    */
    [cell.CustomCell_newsImage loadHTMLString:HTMLString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    //NSLog(@"%@",HTMLString);
    [webColor release];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //按照选中的行号，进行新闻列表的定制，将每一条新闻按element进行传送。
    newsDetail *newsDetailTemp=[[newsDetail alloc]init];
    newsDetailTemp.newsDetail_singleNews=[self.newsList objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:newsDetailTemp animated:YES];
    
    
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [newsTableView release];
    newsTableView = nil;
    [aboutPage release];
    aboutPage = nil;
    [self setTopImage:nil];
    [self setTopTitle:nil];
    [self setTopImage2:nil];
    [self setClass_view:nil];
    [self setClass_SlideIn_button:nil];
    [self setBackToIndex:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return YES;
}
- (void)dealloc { 
    [xmlDocument release];
    [newsTableView release];
    [aboutPage release];
    [topImage release];
    [topTitle release];
    [topImage2 release];
    [Class_view release];
    [Class_SlideIn_button release];
    [backToIndex release];
    [super dealloc]; }
/*
//用作小标题头图片做动画用
-(void)webViewDidStartLoad:(UIWebView *)webView{
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{    
}
//以上 完毕
*/
- (IBAction)Class_SlideIn:(id)sender {//动画移动出class界面
    CGContextRef context = UIGraphicsGetCurrentContext();   
    [UIView beginAnimations:@"Curl" context:context];   
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   
    [UIView setAnimationDuration:0.5];   
    CGRect rect = [Class_view frame]; 
    CGRect rect2=[topImage2 frame];
    CGRect rect3=[topTitle frame];
    CGRect rect4=[Class_SlideIn_button frame];
    if (rect.origin.x==320) {
        rect.origin.x=235;
        rect2.origin.x=-85;
        rect3.origin.x=-85;
        rect4.origin.x=rect4.origin.x-85;
        rect4.origin.y=rect4.origin.y+145;
    }
    else
    {
        rect.origin.x=320;
        rect2.origin.x=0;
        rect3.origin.x=0;
        rect4.origin.x=rect4.origin.x+85;
        rect4.origin.y=rect4.origin.y-145;
    }
    
    [Class_view setFrame:rect];  
    [topImage2 setFrame:rect2]; 
    [topTitle setFrame:rect3];
    [Class_SlideIn_button setFrame:rect4];
    [UIView commitAnimations];   
}
- (IBAction)Class_1:(id)sender {
    SFLSNewsViewController *newSFLSNewsViewController=[[SFLSNewsViewController alloc]init];
    NSString *senderTitle;
    
    if ([sender tag]!=10) {
        
        senderTitle=[sender titleForState:UIControlStateNormal];
        
    }
    UIButton *button=[[UIButton alloc]init];
    
    switch ([sender tag]) {
            case 1:
            NSLog(@"学校概况");
            newSFLSNewsViewController.xmlAddress=@"http://teacher.sfls.cn/sflsapp/xxgk.xml";
            newSFLSNewsViewController.title=senderTitle;
            
            button=(UIButton *)[newSFLSNewsViewController.view viewWithTag:1];
            button.enabled=NO;
            
            [self.navigationController pushViewController:newSFLSNewsViewController animated:YES];
            break;
        case 2:            
            
            NSLog(@"校务公开");
            newSFLSNewsViewController.xmlAddress=@"http://teacher.sfls.cn/sflsapp/xwgk.xml";
            newSFLSNewsViewController.title=senderTitle;
            button=(UIButton *)[newSFLSNewsViewController.view viewWithTag:2];
            button.enabled=NO;
            [self.navigationController pushViewController:newSFLSNewsViewController animated:YES];
            break;
        case 3:
            //button.enabled=NO;
            NSLog(@"德育前沿");
            newSFLSNewsViewController.xmlAddress=@"http://teacher.sfls.cn/sflsapp/dyqy.xml";
            newSFLSNewsViewController.title=senderTitle;
            button=(UIButton *)[newSFLSNewsViewController.view viewWithTag:3];
            button.enabled=NO;
            [self.navigationController pushViewController:newSFLSNewsViewController animated:YES];
            break;
        case 4:
            //button.enabled=NO;
            NSLog(@"学生之窗");
            newSFLSNewsViewController.title=senderTitle;
            newSFLSNewsViewController.xmlAddress=@"http://teacher.sfls.cn/sflsapp/xszc.xml";
            button=(UIButton *)[newSFLSNewsViewController.view viewWithTag:4];
            button.enabled=NO;
            [self.navigationController pushViewController:newSFLSNewsViewController animated:YES];
            break;
        case 5:
            //button.enabled=NO;
            NSLog(@"教师园地");
            newSFLSNewsViewController.xmlAddress=@"http://teacher.sfls.cn/sflsapp/jsyd.xml";
            newSFLSNewsViewController.title=senderTitle;
            button=(UIButton *)[newSFLSNewsViewController.view viewWithTag:5];
            button.enabled=NO;
            [self.navigationController pushViewController:newSFLSNewsViewController animated:YES];
            break;
        case 6:
            //button.enabled=NO;
            NSLog(@"教育科研");
            newSFLSNewsViewController.title=senderTitle;
            newSFLSNewsViewController.xmlAddress=@"http://teacher.sfls.cn/sflsapp/jyky.xml";
            button=(UIButton *)[newSFLSNewsViewController.view viewWithTag:6];
            button.enabled=NO;

            [self.navigationController pushViewController:newSFLSNewsViewController animated:YES];
            break;
        case 7:
            //button.enabled=NO;
            NSLog(@"友好往来");
            newSFLSNewsViewController.title=senderTitle;
            newSFLSNewsViewController.xmlAddress=@"http://teacher.sfls.cn/sflsapp/yhwl.xml";
            button=(UIButton *)[newSFLSNewsViewController.view viewWithTag:7];
            button.enabled=NO;
            [self.navigationController pushViewController:newSFLSNewsViewController animated:YES];
            break;
        case 8:
           // button.enabled=NO;
            NSLog(@"党政工群");
            newSFLSNewsViewController.title=senderTitle;
            
            newSFLSNewsViewController.xmlAddress=@"http://teacher.sfls.cn/sflsapp/dzgq.xml";
            button=(UIButton *)[newSFLSNewsViewController.view viewWithTag:8];
            button.enabled=NO;
            [self.navigationController pushViewController:newSFLSNewsViewController animated:YES];
            break;
        case 9:
            //button.enabled=NO;
            NSLog(@"附中校友");
            newSFLSNewsViewController.xmlAddress=@"http://teacher.sfls.cn/sflsapp/fzxy.xml";
            newSFLSNewsViewController.title=senderTitle;
            button=(UIButton *)[newSFLSNewsViewController.view viewWithTag:9];
            button.enabled=NO;
            [self.navigationController pushViewController:newSFLSNewsViewController animated:YES];
            break;
        case 10:
            //NSLog(@"附中校友");
            newSFLSNewsViewController.xmlAddress=nil;
            newSFLSNewsViewController.navigationItem.hidesBackButton=YES;
            [self.navigationController pushViewController:newSFLSNewsViewController animated:NO];
            break;   
            
        default:
            break;
    }
    [newSFLSNewsViewController release];
}


#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.newsTableView];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    XMLDocument *newXmlDocument=[[XMLDocument alloc]initWithDelegate:self];
    self.xmlDocument=newXmlDocument;
    [self.xmlDocument parseRemoteXMLWithURL:xmlAddress];
    [self.newsTableView reloadData];
    //[self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
   // [self.xmlDocument parseRemoteXMLWithURL:xmlAddress];
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    [self.newsTableView reloadData];
    return [NSDate date]; // should return date data source was last changed
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==2) {
        if (buttonIndex==1) {
            NSLog(@"go to rate");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/sandman/id503536636?mt=8&uo=4"]];
        }
    }

}
 @end
