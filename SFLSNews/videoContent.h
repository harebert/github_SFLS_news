//
//  videoContent.h
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface videoContent : NSObject{
    NSString *videoisHot;
    NSString *hotImage;
    NSString *videoName;
    NSString *videoInfo;
    NSString *videoPath;
    
    
}

@property(nonatomic,assign)NSString *videoisHot;
@property(nonatomic,retain)NSString *hotImage;
@property(nonatomic,retain)NSString *videoName;
@property(nonatomic,retain)NSString *videoInfo;
@property(nonatomic,retain)NSString *videoPath;


@end
