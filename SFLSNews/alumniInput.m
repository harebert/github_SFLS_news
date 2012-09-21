//
//  alumniInput.m
//  附中新闻
//
//  Created by 皓斌 朱 on 12-2-25.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import "alumniInput.h"
#import <QuartzCore/QuartzCore.h>
@implementation alumniInput
@synthesize alumniEmail;
@synthesize alumniPhone;
@synthesize alumniAddress;
@synthesize alumniCountry;
@synthesize alumniCity;
@synthesize alumniClass;
@synthesize alumniBusiness;
@synthesize scrollView;
@synthesize alumniName;
@synthesize BtnTakePhoto;
@synthesize isPublicToAll;
@synthesize graDate;
@synthesize datePicker;
@synthesize inSchoolDate,newAction,nowTextFieldTag;
@synthesize photoHasBeenTaken,photoFileName,serverURL;
@synthesize myImage,myImageSmall,headView;
@synthesize postTime,newlyActivityIndicatorView;
@synthesize loadingLayer,loadingView;
@synthesize uploadStatus,uploadTextStatus,submitButton;

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
    postTime=1;
    self.title=@"校友联系";
    self.tabBarItem.image=[UIImage imageNamed:@"alumni.png"];
    self.navigationController.navigationBar.hidden=YES;
    photoHasBeenTaken=NO;
    //serverURL=@"http://192.168.2.36/webpage/work/upload2";//学校
    //serverURL=@"http://192.168.1.11/work/upload2";//家
    serverURL=@"http://teacher.sfls.cn/sflsapp/work/upload2";
    
    scrollView.frame=CGRectMake(0, 44, 320, 480);
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 600)];
    [scrollView setPagingEnabled:NO];
    scrollView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{   //禁止照相功能启动，until姓名填写；
    [self setInSchoolDate:nil];
    [self setDatePicker:nil];
    [self setGraDate:nil];
    [self setInSchoolDate:nil];
    [self setBtnTakePhoto:nil];
    [self setAlumniName:nil];
    [self setScrollView:nil];
    [self setAlumniClass:nil];
    [self setAlumniBusiness:nil];
    [self setAlumniCity:nil];
    [self setAlumniCountry:nil];
    [self setAlumniAddress:nil];
    [self setAlumniPhone:nil];
    [self setAlumniEmail:nil];
    [self setIsPublicToAll:nil];
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
    [inSchoolDate release];
    [datePicker release];
    [graDate release];
    [inSchoolDate release];
    [BtnTakePhoto release];
    [alumniName release];
    [scrollView release];
    [alumniClass release];
    [alumniBusiness release];
    [alumniCity release];
    [alumniCountry release];
    [alumniAddress release];
    [alumniPhone release];
    [alumniEmail release];
    [isPublicToAll release];
    [super dealloc];
}
-(void)DatePickerDoneClick{
    [newAction dismissWithClickedButtonIndex:0 animated:YES];
    NSDate *newDate=datePicker.date;
    NSDateFormatter *newDateFormatter=[[NSDateFormatter alloc]init];
    [newDateFormatter setDateFormat:@"MM/dd/yyyy"];
    if (nowTextFieldTag==3) {
        inSchoolDate.text=[NSString stringWithFormat:@"%@",[newDateFormatter stringFromDate:newDate]];
    }
    else{
        graDate.text=[NSString stringWithFormat:@"%@",[newDateFormatter stringFromDate:newDate]];
    }
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==3||textField.tag==4) {
        [textField resignFirstResponder];
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"请选择入学年份" delegate:self cancelButtonTitle:@"Cancle" destructiveButtonTitle:@"OK" otherButtonTitles:nil, nil];
        datePicker.frame=CGRectMake(-160,44, 0, 0);
          [action addSubview:datePicker];
        UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerDateToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DatePickerDoneClick)];
        nowTextFieldTag=textField.tag;
        [barItems addObject:doneBtn];    
        [pickerDateToolbar setItems:barItems animated:YES];
        
        [action addSubview:pickerDateToolbar];
        newAction=action;
        [newAction showInView:self.view];
        [newAction setBounds:CGRectMake(0, 0, 320, 344)];
        return NO;
        
    }else
    {
        return YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag==1) {
        if ([textField.text isEqualToString:@""]) {
            return NO;
        }else{
            //textField.enabled=NO;
            UIButton *TakePhotoBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [TakePhotoBtn addTarget:self  action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
            TakePhotoBtn.frame=CGRectMake(219, 48, 70, 70);
            //[TakePhotoBtn setTitle:@"Take/na/nPhoto" forState:UIControlStateNormal];
            
            [TakePhotoBtn setBackgroundImage:[UIImage imageNamed:@"unknown.gif"] forState:UIControlStateNormal];
            
            BtnTakePhoto=TakePhotoBtn;
            
            
            [self.scrollView addSubview:BtnTakePhoto];
            return YES;
            
        }
        
    }
    else
    {
        return YES;
        
    }

}

#pragma theCamera
- (BOOL) doesCameraSupportMediaType:(NSString *)paramMediaType onSourceType:(UIImagePickerControllerSourceType)paramSourceType{
    BOOL result = NO;
    if (paramMediaType == nil || [paramMediaType length] == 0){
        return(NO); }
    if ([UIImagePickerController isSourceTypeAvailable:paramSourceType] == NO){
        return(NO); }
    NSArray *mediaTypes = [UIImagePickerController
                           availableMediaTypesForSourceType:paramSourceType];
    if (mediaTypes == nil){
        return(NO); }
    for (NSString *mediaType in mediaTypes){
        if ([mediaType isEqualToString:paramMediaType] == YES){
            return(YES); }
    }
    return(result); }
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO; }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES; }
    }];
    return result;
}
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
- (BOOL) isFlashAvailableOnFrontCamera{
    return [UIImagePickerController isFlashAvailableForCameraDevice: UIImagePickerControllerCameraDeviceFront];
}
- (BOOL) isFlashAvailableOnRearCamera{
    return [UIImagePickerController isFlashAvailableForCameraDevice: UIImagePickerControllerCameraDeviceRear];
}
- (BOOL)doesCameraSupportShootingVideos{
    return [self cameraSupportsMedia:(NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL)doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:(NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) isPhotoLibraryAvailable{
    return ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]);
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    BOOL result = NO;
    result = [self doesCameraSupportMediaType:(NSString *)kUTTypeMovie onSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    return(result); }
- (BOOL) canUserPickPhotosFromPhotoLibrary{ BOOL result = NO;
    result = [self
              doesCameraSupportMediaType:(NSString *)kUTTypeImage onSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    return(result); }
- (IBAction)takePhoto:(id)sender {
    
    UIActionSheet *photoFromActionSheet=[[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从图片库中选取",@"用设备拍照", nil];
    [photoFromActionSheet showInView:self.view];
       
}

//开始网络递交并定义connection动作
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"did receive response");
    postTime=postTime+1;
    if (postTime==4) {
        CABasicAnimation *theBaseAni=[CABasicAnimation animationWithKeyPath:@"opacity"];
        loadingView.layer.opacity=0;
        [theBaseAni setFromValue:[NSNumber numberWithFloat:0.9]];
        [theBaseAni setToValue:[NSNumber numberWithFloat:0]];
        [theBaseAni setDuration:1];
        
        [loadingView.layer addAnimation:theBaseAni forKey:@"opacityAnimation"];
        UIAlertView *newAlert=[[UIAlertView alloc]initWithTitle:@"资料递交成功" message:@"感谢您注册上外附中校友录" delegate:self cancelButtonTitle:@"点击继续浏览" otherButtonTitles:nil, nil];
        [newAlert show];
        //[newlyActivityIndicatorView stopAnimating];
        
    }

    
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
   }
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
        switch (postTime) {
            case 2:
                uploadTextStatus.text=@"小图上传中...";
                break;
            case 3:
                uploadTextStatus.text=@"资料上传中...";
                break;
            default:
                break;
        }
    
        
}
- (IBAction)submitSheet{//递交表单
    [submitButton setEnabled:NO];
    [submitButton setUserInteractionEnabled:NO];
    //首先渐出提示框
    if (postTime==1) {
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
        //NSString *status=[[NSString alloc]init];
        switch (postTime) {
            case 1:
                uploadStatus=@"大图";
                break;
            case 2:
                uploadStatus=@"小图";
                break;
            case 3:
                uploadStatus=@"信息";
                break;
            default:
                break;
        }
        theTexVie.text=[NSString stringWithFormat:@"%@上传中..",uploadStatus];
        theTexVie.font=[UIFont fontWithName:@"黑体" size:40];
        theTexVie.backgroundColor=[UIColor clearColor];
        theTexVie.textAlignment=UITextAlignmentCenter;
        theTexVie.textColor=[UIColor whiteColor];
        uploadTextStatus=theTexVie;
        [theView addSubview:uploadTextStatus];
        self.loadingView=theView;
        [self.view addSubview:loadingView];
        self.view.layer.backgroundColor=[UIColor whiteColor].CGColor;
        self.view.layer.opacity=0.9;
        CABasicAnimation *theBaseAni=[CABasicAnimation animationWithKeyPath:@"opacity"];
        [theBaseAni setFromValue:[NSNumber numberWithFloat:0]];
        [theBaseAni setToValue:[NSNumber numberWithFloat:0.9]];
        [theBaseAni setDuration:1];
        
        [loadingView.layer addAnimation:theBaseAni forKey:@"opacityAnimation"];
        
        
        
        
        
        
    }else{
        
    }  

    //开始发送图片到服务器
    NSData *m_imageData;//未修改
    NSData *m_imageData_s;//已修改
    NSLog(@"%@",myImageSmall);
    m_imageData=UIImagePNGRepresentation(myImage);
    m_imageData_s=UIImagePNGRepresentation(myImageSmall);
    NSData *postDateBoundary = [[NSString stringWithFormat:@"---------------------------168072824752491622650073c\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *postDatename = [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"File1_desc\";\r\n\r\n desdefa\r\n\r\n"]dataUsingEncoding:NSUTF8StringEncoding];
    NSData *postDateBoundaryEnd = [[NSString stringWithFormat:@"\r\n-----------------------------168072824752491622650073c--\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *postDateHead = [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"File1\"; filename=\"cabcd.png\"\r\nContent-Type: image/jpg\r\n\r\n"]dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *postData = [NSMutableData dataWithCapacity:[m_imageData length] ];
    NSMutableData *postData_s = [NSMutableData dataWithCapacity:[m_imageData_s length] ];
    //[postData appendData:postDateBoundary];
    //[postData appendData:postDatename];//name=
    [postData appendData:postDateBoundary];
    [postData appendData:postDateHead];
    [postData appendData:m_imageData];
    [postData appendData:postDateBoundaryEnd];
    
    [postData_s appendData:postDateBoundary];
    [postData_s appendData:postDateHead];
    [postData_s appendData:m_imageData_s];
    [postData_s appendData:postDateBoundaryEnd];
    
    srand(time(nil));
    int randnum=rand()%100000;
    NSString *theLink=[NSString stringWithFormat: @"%@/upload.asp?imagename=%@%i-L",serverURL,[alumniName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],randnum];
    NSString *theLink_s=[NSString stringWithFormat: @"%@/upload.asp?imagename=%@%i-S",serverURL,[alumniName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],randnum];
    //NSLog(@"l:%@s:%@",theLink,theLink_s);
    NSURL *url=[NSURL URLWithString:theLink];
    NSURL *url_s=[NSURL URLWithString:theLink_s];
    photoFileName=[NSString stringWithFormat:@"%@%i",alumniName.text,randnum];
    photoHasBeenTaken=YES;
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:url];
    NSMutableURLRequest *urlRequest_s=[NSMutableURLRequest requestWithURL:url_s];
    [urlRequest setHTTPMethod:@"POST"];
    //设置头
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"]forHTTPHeaderField:@"Accept"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"gzip, deflate"]forHTTPHeaderField:@"Accept-Encoding"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"zh-cn,zh;q=0.5"]forHTTPHeaderField:@"Accept-Language"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"keep-alive"]forHTTPHeaderField:@"Connection"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"192.168.1.4"]forHTTPHeaderField:@"Host"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"http://192.168.1.4/work/2yup/exp1.html"]forHTTPHeaderField:@"Referer"];
    [urlRequest setValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20100101 Firefox/10.0.1"]forHTTPHeaderField:@"User-Agent"];
    NSString *length=[NSString stringWithFormat:@"%d",[m_imageData length] + [postDateBoundary length]*2 + [postDateHead length]+[postDatename length]+ [postDateBoundaryEnd length]];
    
    [urlRequest addValue:[NSString stringWithFormat:@"%@%@",@"multipart/form-data; boundary=",postDateBoundary]forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:[NSString stringWithFormat:@"%d\r\n",length]forHTTPHeaderField:@"Content-Length"];
    
    [urlRequest_s setHTTPMethod:@"POST"];
    //设置头
    [urlRequest_s addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"]forHTTPHeaderField:@"Accept"];
    [urlRequest_s addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"gzip, deflate"]forHTTPHeaderField:@"Accept-Encoding"];
    [urlRequest_s addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"zh-cn,zh;q=0.5"]forHTTPHeaderField:@"Accept-Language"];
    [urlRequest_s addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"keep-alive"]forHTTPHeaderField:@"Connection"];
    [urlRequest_s addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"192.168.1.4"]forHTTPHeaderField:@"Host"];
    [urlRequest_s addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"http://192.168.1.4/work/2yup/exp1.html"]forHTTPHeaderField:@"Referer"];
    [urlRequest_s setValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20100101 Firefox/10.0.1"]forHTTPHeaderField:@"User-Agent"];
    NSString *length_s=[NSString stringWithFormat:@"%d",[m_imageData_s length] + [postDateBoundary length]*2 + [postDateHead length]+[postDatename length]+ [postDateBoundaryEnd length]];
    
    [urlRequest_s addValue:[NSString stringWithFormat:@"%@%@",@"multipart/form-data; boundary=",postDateBoundary]forHTTPHeaderField:@"Content-Type"];
    [urlRequest_s addValue:[NSString stringWithFormat:@"%d\r\n",length_s]forHTTPHeaderField:@"Content-Length"];
    
    
    [urlRequest_s setHTTPBody:postData_s];
    [urlRequest setHTTPBody:postData];
    
    
    
    
    NSURLConnection *newConnection=[[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    
    
    
    NSURLConnection *newConnection_s=[[NSURLConnection alloc]initWithRequest:urlRequest_s delegate:self startImmediately:YES];
    if (newConnection&&newConnection_s) {
        
        NSLog(@"in connection");
    }
    //发送图片完毕
    
    //开始发送信息
    NSString *connectUrl=[NSString stringWithFormat:@"%@/infoSave.asp",serverURL];
    NSString *is_public=[[NSString alloc]init];
    if (isPublicToAll.on) {
        is_public=@"YES";
    }
    else{
        is_public=@"NO";
    }
    NSData *theData=[[NSString stringWithFormat:@"name=%@&class=%@&inschool=%@&graDate=%@&business=%@&city=%@&country=%@&address=%@&phone=%@&email=%@&photo_s=%@_s&photo_l=%@_l&is_public=%@&submit=ok",alumniName.text,alumniClass.text,inSchoolDate.text,graDate.text,alumniBusiness.text,alumniCity.text,alumniCountry.text,alumniAddress.text,alumniPhone.text,alumniEmail.text,photoFileName,photoFileName,is_public]dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",theData);
    NSMutableData *infoSaveData=[NSMutableData dataWithCapacity:[theData length]];
    [infoSaveData appendData:theData];
    
    NSURL *infoSaveDataUrl=[NSURL URLWithString:connectUrl];
    NSString *infoSaveDatalength=[NSString stringWithFormat:@"%d",[infoSaveData length]];    
    NSMutableURLRequest *infoSaveDataRequest=[NSMutableURLRequest requestWithURL:infoSaveDataUrl];
    [infoSaveDataRequest setHTTPMethod:@"POST"];
    //设置头
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"]forHTTPHeaderField:@"Accept"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"gzip, deflate"]forHTTPHeaderField:@"Accept-Encoding"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"zh-cn,zh;q=0.5"]forHTTPHeaderField:@"Accept-Language"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"keep-alive"]forHTTPHeaderField:@"Connection"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"192.168.1.4"]forHTTPHeaderField:@"Host"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"http://192.168.1.4/work/2yup/exp1.html"]forHTTPHeaderField:@"Referer"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"application/x-www-form-urlencoded"]forHTTPHeaderField:@"Content-Type"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%d\r\n",infoSaveDatalength]forHTTPHeaderField:@"Content-Length"]; 
    [infoSaveDataRequest setHTTPBody:infoSaveData];  
    NSURLConnection *infoSaveConnection=[[NSURLConnection alloc]initWithRequest:infoSaveDataRequest delegate:self startImmediately:YES];   
    if (infoSaveConnection) {
        NSLog(@"in connection");
    }
    
    
    
    //发送信息完毕
    
}



- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //文件传到服务器上，用的名字是姓名+6位随机数
    NSLog(@"Picker returned successfully.");
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *urlOfVideo =
        [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"Video URL = %@", urlOfVideo); }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        /* Let's get the metadata. This is only for images. Not videos */
        //NSDictionary *metadata = [info objectForKey: UIImagePickerControllerMediaMetadata];
        UIImage *theImage = [info objectForKey: UIImagePickerControllerOriginalImage];
        
        UIImage *theEditedImage=[info objectForKey:UIImagePickerControllerEditedImage];
        //NSLog(@"Image Metadata = %@", metadata); NSLog(@"Image = %@", theImage);
         
        myImage=[theImage copy];
        myImageSmall=theEditedImage;
        if (headView.image==nil) {
            NSLog(@"is nil");
            CALayer *imageLayerBk=[[CALayer alloc]init];
            imageLayerBk.frame=CGRectMake(219, 48, 70, 70);
            imageLayerBk.cornerRadius=10;
            imageLayerBk.borderColor=[UIColor whiteColor].CGColor;
            imageLayerBk.borderWidth=3;
            imageLayerBk.shadowColor=[UIColor blackColor].CGColor;
            imageLayerBk.shadowOffset=CGSizeMake(0, 3);
            imageLayerBk.shadowOpacity=0.7f;
            [self.scrollView.layer addSublayer:imageLayerBk];
            
            UIImageView *newImageView=[[UIImageView alloc]initWithImage:theEditedImage];
            newImageView.layer.frame=imageLayerBk.bounds;
            newImageView.layer.cornerRadius=10;
            newImageView.layer.masksToBounds=YES;
            self.headView=newImageView;
            [imageLayerBk addSublayer:newImageView.layer];
            
            //[self.scrollView addSubview:headView];
            //BtnTakePhoto.frame=CGRectMake(30, 400, 120, 37);
            
            UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            submitBtn.frame=CGRectMake(100, 490, 120, 37);
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [submitBtn addTarget:self action:@selector(submitSheet) forControlEvents:UIControlEventTouchUpInside];
            self.submitButton=submitBtn;
            [self.scrollView addSubview:submitButton];
        }
        else{
            
            headView.image=theEditedImage;
            
            NSLog(@"is not nil");
        }
        
        
        
        
        
        
}
    [picker dismissModalViewControllerAnimated:YES]; }


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Picker was cancelled");
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if ([self isPhotoLibraryAvailable] == YES){
            UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            if ([self canUserPickPhotosFromPhotoLibrary] == YES){
                [mediaTypes addObject:(NSString *)kUTTypeImage]; }
            if ([self canUserPickVideosFromPhotoLibrary] == YES){
                [mediaTypes addObject:(NSString *)kUTTypeMovie]; }
            imagePicker.mediaTypes = mediaTypes;
            imagePicker.delegate = self;
            imagePicker.allowsEditing=YES;
            [self presentModalViewController:imagePicker animated:YES];
            
        }
    }
    else
    {//用相机拍摄
        
         
         if ([self isCameraAvailable] &&
         [self doesCameraSupportTakingPhotos]){
         UIImagePickerController *controller = [[UIImagePickerController alloc] init];
         controller.sourceType = UIImagePickerControllerSourceTypeCamera;
             if ([self isFrontCameraAvailable]) {
                 controller.cameraDevice=UIImagePickerControllerCameraDeviceFront;

             }else{
                 controller.cameraDevice=UIImagePickerControllerCameraDeviceRear;
             }
                  NSString *requiredMediaType =(NSString *)kUTTypeImage; controller.mediaTypes =[[NSArray alloc]initWithObjects:requiredMediaType, nil];
         controller.allowsEditing = YES; controller.delegate = self;
         [self.navigationController presentModalViewController:controller animated:YES];
         } else {
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"您的设备没有相机功能，请检查后运行" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         NSLog(@"Camera is not available."); }
         

    }
}
@end










