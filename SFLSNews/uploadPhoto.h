//
//  uploadPhoto.h
//  SFLS_Photo_Comp
//
//  Created by 皓斌 朱 on 12-3-9.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol uploadPhotoDelegate <NSObject>
@required
-(void)uploadPhotoDelegateStartedAtObject:(NSString *)uploadObject;
-(void)uploadPhotoDelegateFinishedAtObject:(NSString *)uploadObject;
-(void)uploadPhotoDelegateMeetErrors:(NSError *)error;
@end
@interface uploadPhoto : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    @public
    UIImage *uploadImage;
    NSString *uploadImageName;
    NSString *urlAdress;
    int postTime;
    @public
    NSString * uploadObjected;
    id<uploadPhotoDelegate>delegate;
}
@property(nonatomic,retain)UIImage *uploadImage;
@property(nonatomic,retain)NSString *uploadImageName;
@property(nonatomic,retain)NSString *urlAdress;
@property(nonatomic,assign)int postTime;
@property(nonatomic,retain)NSString *uploadObjected;
@property(nonatomic,retain)id<uploadPhotoDelegate>delegate;
-(id)initWithDelegate:(id<uploadPhotoDelegate>)paramDelegate;
-(void)uploadPhotoToUrl;
-(void)uploadPhotoToUrl:(NSString *)fullurlAdress imageName:(NSString *)fulluploadImageName image:(UIImage *)fulluploadImage uploadObject:(NSString *)uploadObject;
-(void)uploadInfoToUrl:(NSString *)fullurlAdress takerName:(NSString *)takerName takerClass:(NSString *)takerClass takerPhone:(NSString *)takerPhone takerPWD:(NSString *)takerPWD photoType:(NSString *)photoType is_Public:(NSString *)is_public withPhotoNames:(NSMutableArray *)photoNames withInfos:(NSMutableArray *)photoInfos takerTimes:(int)takerTimes uploadObject:(NSString *)uploadObject;

@end
