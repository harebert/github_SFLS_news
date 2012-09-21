//  这个类是专门用来处理图片的。
//  newsImage.h
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-21.
//  Copyright 2011年 sfls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface newsImage : NSObject{
    NSString * imageURL;
    NSString * imageRange;
    NSString * imageInfo;
}
@property (retain,nonatomic)NSString * imageURL;
@property (retain,nonatomic)NSString * imageRange;
@property (retain,nonatomic)NSString * imageInfo;
@end
