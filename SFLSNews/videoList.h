//
//  videoList.h
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLDocument.h"
#import "XMLelement.h"
@interface videoList : UITableViewController<XMLDocumentDelegate>{
    XMLDocument *xmlDocument;
    NSMutableArray *listOfVideo;
    NSMutableArray *videoContentList;//包含一个个video的实例
    NSString *mySmallClass;
}
@property(nonatomic,retain)XMLDocument *xmlDocument;
@property(nonatomic,retain)NSMutableArray *listOfVideo;
@property(nonatomic,retain)NSMutableArray *videoContentList;
@property(nonatomic,retain)NSString *mySmallClass;
@end
