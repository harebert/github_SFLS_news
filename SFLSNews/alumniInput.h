//
//  alumniInput.h
//  附中新闻
//
//  Created by 皓斌 朱 on 12-2-25.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface alumniInput : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,UINavigationControllerDelegate,NSURLConnectionDataDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    UIActionSheet *newAction;
    int nowTextFieldTag;
    BOOL photoHasBeenTaken;//已经拍过照了
    NSString *photoFileName;//最后一次拍照的照片名字
    //UINavigationController *navigationController;
    NSString *serverURL;
    UIImage *myImage;//记录照片
    UIImage *myImageSmall;//记录小照片
    UIImageView *headView;
    int postTime;//第一次为照片递交，第二次为表单递交
    UIActivityIndicatorView *newlyActivityIndicatorView;
    CALayer *loadingLayer;//提交时的显示进度层
    UIView *loadingView;//Loading时的界面
    NSString *uploadStatus;
    UITextView *uploadTextStatus;
    UIButton *submitButton;
}
@property (retain, nonatomic) IBOutlet UITextField *alumniEmail;
@property (retain, nonatomic) IBOutlet UITextField *alumniPhone;
@property (retain, nonatomic) IBOutlet UITextField *alumniAddress;
@property (retain, nonatomic) IBOutlet UITextField *alumniCountry;
@property (retain, nonatomic) IBOutlet UITextField *alumniCity;
@property (retain, nonatomic) IBOutlet UITextField *alumniClass;
@property (retain, nonatomic) IBOutlet UITextField *alumniBusiness;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *alumniName;
//@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) IBOutlet UITextField *inSchoolDate;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property(retain,nonatomic)UIActionSheet *newAction;
@property (retain, nonatomic) IBOutlet UISwitch *isPublicToAll;
@property (retain, nonatomic) IBOutlet UITextField *graDate;
@property(nonatomic,assign)int nowTextFieldTag;
//@property(nonatomic,retain)UINavigationController *navigationController;
- (IBAction)takePhoto:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *BtnTakePhoto;
@property (nonatomic,assign)BOOL photoHasBeenTaken;
@property (retain, nonatomic)NSString *photoFileName;
@property (retain, nonatomic)NSString *serverURL;
@property (retain, nonatomic)UIImage *myImage;
@property (retain, nonatomic)UIImage *myImageSmall;
@property (retain, nonatomic)UIImageView *headView;
@property(nonatomic,assign)int postTime;
@property(retain,nonatomic)IBOutlet UIActivityIndicatorView *newlyActivityIndicatorView;
@property(nonatomic,retain)CALayer *loadingLayer;
@property(nonatomic,retain)IBOutlet UIView *loadingView;
@property(nonatomic,retain)NSString *uploadStatus;
@property(nonatomic,retain)IBOutlet UITextView *uploadTextStatus;
@property(nonatomic,retain)IBOutlet UIButton *submitButton;

@end
