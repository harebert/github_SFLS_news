//
//  ViewController.m
//  SFLS_Photo_Comp
//
//  Created by 皓斌 朱 on 12-3-6.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "uploadPhoto.h"
@implementation ViewController
@synthesize isToPublic;
@synthesize BKScrollView;
@synthesize takerPWD2;
@synthesize takerPWD1;
@synthesize takerNumber;
@synthesize takerClass;
@synthesize takerName;
@synthesize classOfPhoto;
@synthesize bigImage,smallImage;
@synthesize classPicker;
@synthesize timesOfPhotoTaken,lastTimeIncreaseHeight;
@synthesize infoText1,infoText2,infoText3,infoText4,infoText5;
@synthesize submitPhoto,newlyPhotoArray,newlyPhotoArray_s,newlyPhotoNameArray,uploadServerAddress;
@synthesize loadingView;
@synthesize uploadTimes;
#pragma theConnectionProtocol
-(void)uploadPhotoDelegateStartedAtObject:(NSString *)uploadObject{
    NSLog(@"received");
    uploadTimes++;
}
-(void)uploadPhotoDelegateFinishedAtObject:(NSString *)uploadObject{
    if (uploadTimes==(timesOfPhotoTaken*2+1)) {
        loadingView.layer.opacity=0;
    CABasicAnimation *theBaseAni=[CABasicAnimation animationWithKeyPath:@"opacity"];
    [theBaseAni setFromValue:[NSNumber numberWithFloat:0.9]];
    [theBaseAni setToValue:[NSNumber numberWithFloat:0]];
    [theBaseAni setDuration:1];
    
    [loadingView.layer addAnimation:theBaseAni forKey:@"opacityAnimation"];
    }
}
-(void)uploadPhotoDelegateMeetErrors:(NSError *)error{
    UIAlertView *newAlertView=[[UIAlertView alloc]initWithTitle:@"警告" message:@"网络错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [newAlertView show];
}


#pragma mark -View Lifecycle
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad

{   
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    self.BKScrollView.backgroundColor=[UIColor clearColor]; 
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    uploadTimes=0;
    NSString *serverAdress=@"http://teacher.sfls.cn/sflsapp/photocompupload";//家
    uploadServerAddress=serverAdress;
    NSMutableArray *newArray=[[NSMutableArray alloc]init];
    newlyPhotoArray=newArray;
    NSMutableArray *newArray_s=[[NSMutableArray alloc]init];
    newlyPhotoArray_s=newArray_s;
    NSMutableArray *newNameArray=[[NSMutableArray alloc]init];
    newlyPhotoNameArray=newNameArray;
    timesOfPhotoTaken=0;
    lastTimeIncreaseHeight=0.0f;
    //self.navigationController.navigationBar.hidden=YES;
    self.title=@"上外附中摄影大赛";
    BKScrollView.frame=CGRectMake(0,88, 320, 480);
    [BKScrollView setScrollEnabled:YES];
    [BKScrollView setContentSize:CGSizeMake(320, 480)];
    [BKScrollView setPagingEnabled:NO];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setClassOfPhoto:nil];
    [self setTakerName:nil];
    [self setTakerClass:nil];
    [self setTakerNumber:nil];
    [self setTakerPWD1:nil];
    [self setTakerPWD2:nil];
    [self setBKScrollView:nil];
    [self setIsToPublic:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


#pragma takePhoto
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
- (BOOL) canUserPickPhotosFromPhotoLibrary{ 
    BOOL result = NO;
    result = [self
              doesCameraSupportMediaType:(NSString *)kUTTypeImage onSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    return(result); }
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        if (timesOfPhotoTaken==0) {
            UILabel *slideLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 365, 320, 20)];
            slideLabel.backgroundColor=[UIColor blackColor];
            //slideLabel.layer.opacity=0.7f;
            slideLabel.alpha=0.7f;
            slideLabel.textColor=[UIColor whiteColor];
            slideLabel.textAlignment=UITextAlignmentCenter;
            [slideLabel setFont:[UIFont fontWithName:@"华文隶书" size:12]];
            slideLabel.text=@"以下为照片内容(最多5张)";
            [BKScrollView addSubview:slideLabel];
        }
        UIImage *theImage = [info objectForKey: UIImagePickerControllerOriginalImage];
        [newlyPhotoArray addObject:theImage];
        bigImage=[theImage copy];
        UIImage *theEditedImage=[info objectForKey:UIImagePickerControllerEditedImage];
        [newlyPhotoArray_s addObject:theEditedImage];
        smallImage=[theEditedImage copy];
        BKScrollView.frame=CGRectMake(0, 0, 320, 480);
        float imageHeight=bigImage.size.height*(250/bigImage.size.width);
        //BKScrollView.contentSize=CGSizeMake(320, 960);
        UIImageView *cameraImageView=[[UIImageView alloc]initWithImage:bigImage];
        float times;
        times=cameraImageView.frame.size.width/320;
        cameraImageView.frame=CGRectMake(0, 440+lastTimeIncreaseHeight, cameraImageView.frame.size.width/times   , cameraImageView.frame.size.height/times);
        cameraImageView.layer.cornerRadius=10;
        cameraImageView.layer.borderWidth=5;
        cameraImageView.layer.borderColor=[UIColor whiteColor].CGColor;
        cameraImageView.layer.masksToBounds=YES;
        lastTimeIncreaseHeight=lastTimeIncreaseHeight+imageHeight;//增加的高度=图片尺寸
        BKScrollView.contentSize=CGSizeMake(320, 480+lastTimeIncreaseHeight+60);//延长scrollview的长度，尺寸+50
        
        UITextField *commentText=[[UITextField alloc]init];
        commentText.borderStyle=UITextBorderStyleRoundedRect;
        commentText.frame=CGRectMake(35, 410+lastTimeIncreaseHeight+10, 250, 40);
        commentText.tag=timesOfPhotoTaken+7;
        
        commentText.delegate=self;
        commentText.textColor=[UIColor grayColor];
        NSLog(@"%i",commentText.tag);
        
        switch (timesOfPhotoTaken) {
            case 0:
                commentText.text=@"照片1的注释：";
                infoText1=commentText;
                [BKScrollView addSubview:infoText1];
                break;
            case 1:
                commentText.text=@"照片2的注释：";
                infoText2=commentText;
                [BKScrollView addSubview:infoText2];
                break;
            case 2:
                commentText.text=@"照片3的注释：";
                infoText3=commentText;
                [BKScrollView addSubview:infoText3];
                break;
            case 3:
                commentText.text=@"照片4的注释：";
                infoText4=commentText;
                [BKScrollView addSubview:infoText4];
                break;
            case 4:
                commentText.text=@"照片5的注释：";
                infoText5=commentText;
                [BKScrollView addSubview:infoText5];
                break;
                
            default:
                break;
        }
        //[BKScrollView addSubview:commentText];
        [BKScrollView addSubview:cameraImageView];
        [BKScrollView scrollsToTop];
        //动画缩放照片
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [UIView beginAnimations:@"showImage" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:2];
        [BKScrollView setContentOffset:CGPointMake(0, lastTimeIncreaseHeight) animated:YES];
        cameraImageView.frame=CGRectMake(35, 410+lastTimeIncreaseHeight-imageHeight, 250,imageHeight);
        
        [UIView commitAnimations];
       //动画完毕
        //增加提交按钮
        if (timesOfPhotoTaken==0) {
            BKScrollView.contentSize=CGSizeMake(320, BKScrollView.contentSize.height+84);
            UIButton *subBut=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            subBut.frame=CGRectMake(15, BKScrollView.contentSize.height-159, 290, 40);
            [subBut setTitle: @"提交作品" forState:UIControlStateNormal];
            
            [subBut addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
            subBut.tag=12;
            submitPhoto=subBut;
            [BKScrollView addSubview:submitPhoto];
        }
        else{
            BKScrollView.contentSize=CGSizeMake(320, BKScrollView.contentSize.height+84);
            submitPhoto.frame=CGRectMake(15, BKScrollView.contentSize.height-159, 290, 40);
        }
        //增加完毕
        timesOfPhotoTaken++;
        lastTimeIncreaseHeight=lastTimeIncreaseHeight+60;
        
    }
    
    
}
#pragma textField and pickerView
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (row) {
        case 0:
            return @"";
            break;
        case 1:
            return @"纪实性人物类";
            break;
        case 2:
            return @"非纪实性人物类";
            break;
        case 3:
            return @"风景类";
            break;
            
        default:
            break;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (row) {
        case 0:
            classOfPhoto.text=@"";
            break;
        case 1:
            classOfPhoto.text=@"纪实性人物";
            break;
        case 2:
            classOfPhoto.text=@"非纪实性人物类";
            break;
        case 3:
            classOfPhoto.text=@"风景类";
            break;
            
        default:
            break;
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==6) {
        [textField resignFirstResponder];
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"请选择照片类型" delegate:self cancelButtonTitle:@"Cancle" destructiveButtonTitle:@"OK" otherButtonTitles:nil, nil];
        UIPickerView *classSelectPicker=[[UIPickerView alloc]init];
        classSelectPicker.frame=CGRectMake(0,44, 0, 0);
        classSelectPicker.dataSource=self;
        classSelectPicker.delegate=self;
        classSelectPicker.autoresizingMask= UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        classSelectPicker.showsSelectionIndicator=YES;
        [action addSubview:classSelectPicker];
        UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerDateToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(PickerDoneClick)];
        //nowTextFieldTag=textField.tag;
        [barItems addObject:doneBtn];    
        [pickerDateToolbar setItems:barItems animated:YES];
        
        [action addSubview:pickerDateToolbar];
        //newAction=action;
        classPicker=action;
        [action showInView:self.view];
        [action setBounds:CGRectMake(0, 0, 320, 344)];
        return NO;
        NSLog(@"no");
    }else
    {
        if (textField.tag>=7) {
            textField.text=@"";
            textField.textColor=[UIColor blackColor];
            NSLog(@"%f,%f",BKScrollView.contentOffset.y,textField.frame.origin.y);
                        [BKScrollView setContentOffset:CGPointMake(0,textField.frame.origin.y-150) animated:YES];
            return YES;
        }else{
            return YES;
        }
    }
    return YES; 

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag>=7) {
        if ([textField.text isEqualToString:@""]) {
            return NO;
        }else{
            [textField resignFirstResponder];
            [BKScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            return YES;
        }
            }
    else{
        [textField resignFirstResponder];
        return YES;
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag==4) {
        if (![takerPWD2.text isEqualToString:@""]) {
            if ([textField.text isEqualToString:takerPWD2.text]) {
                return YES;
            }
            else
            {
                CGContextRef context = UIGraphicsGetCurrentContext();
                [UIView beginAnimations:@"shake" context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView setAnimationRepeatCount:2];
                [UIView setAnimationDuration:0.2];
                textField.frame=CGRectMake(textField.frame.origin.x-10, textField.frame.origin.y,textField.frame.size.width,textField.frame.size.height);
                textField.frame=CGRectMake(textField.frame.origin.x+10, textField.frame.origin.y,textField.frame.size.width,textField.frame.size.height);
                textField.frame=CGRectMake(textField.frame.origin.x+10, textField.frame.origin.y,textField.frame.size.width,textField.frame.size.height);
                textField.frame=CGRectMake(textField.frame.origin.x-10, textField.frame.origin.y,textField.frame.size.width,textField.frame.size.height);
                [UIView commitAnimations];
                
                return YES;
                
            }
        }
    }
    if (textField.tag==5) {
        if (![takerPWD1.text isEqualToString:@""]) {
            if ([textField.text isEqualToString:takerPWD1.text]) {
                return YES;
            }
            else
            {
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                [UIView beginAnimations:@"shake" context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView setAnimationRepeatCount:2];
                [UIView setAnimationDuration:0.2];
                textField.frame=CGRectMake(textField.frame.origin.x-10, textField.frame.origin.y,textField.frame.size.width,textField.frame.size.height);
                textField.frame=CGRectMake(textField.frame.origin.x+10, textField.frame.origin.y,textField.frame.size.width,textField.frame.size.height);
                textField.frame=CGRectMake(textField.frame.origin.x+10, textField.frame.origin.y,textField.frame.size.width,textField.frame.size.height);
                textField.frame=CGRectMake(textField.frame.origin.x-10, textField.frame.origin.y,textField.frame.size.width,textField.frame.size.height);
                [UIView commitAnimations];

                return YES;
            }
        }
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
-(void)PickerDoneClick{
    [classPicker dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma actionsheet
- (IBAction)photoTakeBtn:(id)sender {
    if (timesOfPhotoTaken==5) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"达到上传限制" message:@"每次只能上传五张照片，请挑选后上传" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
    
    UIActionSheet *photoTakeSelect=[[UIActionSheet alloc]initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择",@"拍照取景", nil];
    [photoTakeSelect showInView:self.view];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Picker was cancelled");
    [picker dismissModalViewControllerAnimated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"0");
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
    }else
    {
        NSLog(@"1");
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
#pragma uiscrollview
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [takerName resignFirstResponder];
    [takerClass resignFirstResponder];
    [takerNumber resignFirstResponder];
    [takerPWD1 resignFirstResponder];
    [takerPWD2 resignFirstResponder];
    //[infoText1 resignFirstResponder];
    //[infoText2 resignFirstResponder];
    //[infoText3 resignFirstResponder];
    //[infoText4 resignFirstResponder];
    //[infoText5 resignFirstResponder];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [takerName resignFirstResponder];
    [takerClass resignFirstResponder];
    [takerNumber resignFirstResponder];
    [takerPWD1 resignFirstResponder];
    [takerPWD2 resignFirstResponder];
    //[infoText1 resignFirstResponder];
    //[infoText2 resignFirstResponder];
    //[infoText3 resignFirstResponder];
    //[infoText4 resignFirstResponder];
    //[infoText5 resignFirstResponder];
}
#pragma 提交
-(void)submit{
    //提交第一步：验证
    NSString *errorInfo=[[NSString alloc]init];
    if ([takerName.text isEqualToString:@""]) {
        errorInfo=[NSString stringWithFormat:@"%@", @"姓名、"];
        NSLog(@"姓名空");
    }
    if ([takerClass.text isEqualToString:@""]) {
        errorInfo=[NSString stringWithFormat:@"%@%@",errorInfo,@"班级、"];
        NSLog(@"banji空");
    }
    if ([takerNumber.text isEqualToString:@""]) {
        errorInfo=[NSString stringWithFormat:@"%@%@",errorInfo,@"联系方式、"];
        NSLog(@"联系空");
    }
    if ([classOfPhoto.text isEqualToString:@""]) {
        errorInfo=[NSString stringWithFormat:@"%@%@",errorInfo,@"照片类型、"];
        NSLog(@"联系空");
    }
   
        if (timesOfPhotoTaken>=infoText1.tag-6) {
            if ([infoText1.text isEqualToString:@""]||[infoText1.text isEqualToString:@"照片1的注释："]) {
                    errorInfo=[NSString stringWithFormat:@"%@%@",errorInfo,@"第一张图片说明、"];
                }
                }
    if (timesOfPhotoTaken>=infoText2.tag-6) {
                if ([infoText2.text isEqualToString:@""] || [infoText2.text isEqualToString:@"照片2的注释："]) {
                    errorInfo=[NSString stringWithFormat:@"%@%@",errorInfo,@"第二张图片说明、"];
                }
    }
    if (timesOfPhotoTaken>=infoText3.tag-6) {
                if ([infoText3.text isEqualToString:@""] || [infoText3.text isEqualToString:@"照片3的注释："]) {
                    errorInfo=[NSString stringWithFormat:@"%@%@",errorInfo,@"第三张图片说明、"];
                }
    }
    if (timesOfPhotoTaken>=infoText4.tag-6) {
                if ([infoText4.text isEqualToString:@""] || [infoText4.text isEqualToString:@"照片4的注释："]) {
                    errorInfo=[NSString stringWithFormat:@"%@%@",errorInfo,@"第四张图片说明、"];
                }
    } 
    if (timesOfPhotoTaken>=infoText5.tag-6) {
                if ([infoText5.text isEqualToString:@""] || [infoText5.text isEqualToString:@"照片5的注释："]) {
                    errorInfo=[NSString stringWithFormat:@"%@%@",errorInfo,@"第五张图片说明、"];
                }
    }
    if (![takerPWD1.text isEqualToString:takerPWD2.text]) {
        errorInfo=[NSString stringWithFormat:@"%@%@",errorInfo,@"两遍输入密码不吻合、"];
    }
    NSLog(@"%@",errorInfo);
    if (![errorInfo isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告未填选项" message:[NSString stringWithFormat:@"%@必须填写",errorInfo] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
//显示上传指示符
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
        theTexVie.text=@"上传中...";//[NSString stringWithFormat:@"%@...",uploadObject];
        theTexVie.font=[UIFont fontWithName:@"黑体" size:40];
        theTexVie.backgroundColor=[UIColor clearColor];
        theTexVie.textAlignment=UITextAlignmentCenter;
        theTexVie.textColor=[UIColor whiteColor];
        //uploadTextStatus=theTexVie;
        [theView addSubview:theTexVie];
        self.loadingView=theView;
        [self.view addSubview:loadingView];
        self.view.layer.backgroundColor=[UIColor whiteColor].CGColor;
        self.view.layer.opacity=0.9;
        CABasicAnimation *theBaseAni=[CABasicAnimation animationWithKeyPath:@"opacity"];
        [theBaseAni setFromValue:[NSNumber numberWithFloat:0]];
        [theBaseAni setToValue:[NSNumber numberWithFloat:0.9]];
        [theBaseAni setDuration:1];
        
        [loadingView.layer addAnimation:theBaseAni forKey:@"opacityAnimation"];

//上传所有图片
        uploadPhoto *newUpLoadPhoto=[[uploadPhoto alloc]initWithDelegate:self];
        srand(time(nil));
        int randnum=rand()%100000;
        NSString *fileName;
        NSString *uploadObject;
        int i;
        for (i=1; i<=timesOfPhotoTaken; i++) {
            uploadObject=[NSString stringWithFormat:@"上传照片_%i",i];
            fileName=[[NSString stringWithFormat:@"%@%i_%i",takerName.text,i,randnum]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [newUpLoadPhoto uploadPhotoToUrl:uploadServerAddress imageName:fileName image:[newlyPhotoArray objectAtIndex:i-1] uploadObject:uploadObject];
            [newlyPhotoNameArray addObject:fileName];
            
        }
        for (i=1; i<=timesOfPhotoTaken; i++) {
            uploadObject=[NSString stringWithFormat:@"上传照片缩略_%i",i];
            fileName=[[NSString stringWithFormat:@"%@%i_%i_s",takerName.text,i,randnum]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [newUpLoadPhoto uploadPhotoToUrl:uploadServerAddress imageName:fileName image:[newlyPhotoArray_s objectAtIndex:i-1] uploadObject:uploadObject];
            //[newlyPhotoNameArray addObject:fileName];
            
        }
        
//上传所有信息
        uploadObject=@"上传用户信息";
        NSString *is_public;
        if (isToPublic.on) {
            is_public=@"YES";
        }else{
            is_public=@"NO";
        }
        NSMutableArray *newlyPhotoInfo=[[NSMutableArray alloc]init ];
        [newlyPhotoInfo addObject:infoText1.text];
        if (infoText2.tag-6<=timesOfPhotoTaken && infoText2!=nil) {
                [newlyPhotoInfo addObject:infoText2.text];
        }
        if (infoText3.tag-6<=timesOfPhotoTaken && infoText3!=nil) {
            [newlyPhotoInfo addObject:infoText3.text];
        }
        if (infoText4.tag-6<=timesOfPhotoTaken && infoText4!=nil) {
            [newlyPhotoInfo addObject:infoText4.text];
        }
        if (infoText5.tag-6<=timesOfPhotoTaken && infoText5!=nil) {
            [newlyPhotoInfo addObject:infoText5.text];
        }
        
        [newUpLoadPhoto uploadInfoToUrl:uploadServerAddress takerName:takerName.text takerClass:takerClass.text takerPhone:takerNumber.text takerPWD:takerPWD1.text photoType:classOfPhoto.text is_Public:is_public withPhotoNames:newlyPhotoNameArray withInfos:newlyPhotoInfo takerTimes:timesOfPhotoTaken uploadObject:uploadObject];
        
    }
    
}
@end
















