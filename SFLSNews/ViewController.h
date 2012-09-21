//
//  ViewController.h
//  SFLS_Photo_Comp
//
//  Created by 皓斌 朱 on 12-3-6.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "uploadPhoto.h"
@interface ViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate,uploadPhotoDelegate>{
    UIImage *bigImage;
    UIImage *smallImage;
    UIActionSheet *classPicker;
    int timesOfPhotoTaken;
    float lastTimeIncreaseHeight;
    //5个说明uitextfield
    UITextField *infoText1;
    UITextField *infoText2;
    UITextField *infoText3;
    UITextField *infoText4;
    UITextField *infoText5;
    UIButton *submitPhoto;
    NSMutableArray *newlyPhotoArray;
    NSMutableArray *newlyPhotoArray_s;
    NSMutableArray *newlyPhotoNameArray;
    NSString *uploadServerAddress;
    UIView *loadingView;
    int uploadTimes;
    
}
@property (retain, nonatomic) IBOutlet UISwitch *isToPublic;
@property (retain, nonatomic) IBOutlet UIScrollView *BKScrollView;
@property (retain, nonatomic) IBOutlet UITextField *takerPWD2;
@property (retain, nonatomic) IBOutlet UITextField *takerPWD1;
@property (retain, nonatomic) IBOutlet UITextField *takerNumber;
@property (retain, nonatomic) IBOutlet UITextField *takerClass;
@property (retain, nonatomic) IBOutlet UITextField *takerName;
@property (retain, nonatomic) IBOutlet UITextField *classOfPhoto;
@property(nonatomic,retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) UIActionSheet *classPicker;
@property(nonatomic,retain)UIImage *bigImage;
@property(nonatomic,retain)UIImage *smallImage;
@property(nonatomic,retain)NSMutableArray *newlyPhotoArray;
@property(nonatomic,retain)NSMutableArray *newlyPhotoArray_s;
@property(nonatomic,retain)NSMutableArray *newlyPhotoNameArray;
@property(nonatomic,assign)int timesOfPhotoTaken;
@property(nonatomic,assign)float lastTimeIncreaseHeight;
@property (retain, nonatomic) IBOutlet UITextField *infoText1;
@property (retain, nonatomic) IBOutlet UITextField *infoText2;
@property (retain, nonatomic) IBOutlet UITextField *infoText3;
@property (retain, nonatomic) IBOutlet UITextField *infoText4;
@property (retain, nonatomic) IBOutlet UITextField *infoText5;
@property (retain, nonatomic) IBOutlet UIButton *submitPhoto;
@property (retain, nonatomic) NSString *uploadServerAddress;
@property (nonatomic,assign)int uploadTimes;
- (IBAction)photoTakeBtn:(id)sender;
@end
