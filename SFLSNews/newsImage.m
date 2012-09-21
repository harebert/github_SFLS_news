//
//  newsImage.m
//  SFLSNews
//
//  Created by 皓斌 朱 on 11-12-21.
//  Copyright 2011年 sfls. All rights reserved.
//

#import "newsImage.h"

@implementation newsImage
@synthesize imageURL,imageInfo,imageRange;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    imageURL=[[NSString alloc]init];
    imageInfo=[[NSString alloc]init];
    imageRange=[[NSString alloc]init];
    return self;
}
-(void)dealloc{
    [imageURL release];
    [imageInfo release];
    [imageRange release];
    [super dealloc];
}
@end
