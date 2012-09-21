//
//  smallClass.h
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLelement.h"
#import "XMLDocument.h"
@interface smallClass : UITableViewController<XMLDocumentDelegate>{
    XMLDocument *xmlDocument;
    NSMutableArray *smallClassList;
}
@property (nonatomic, retain)XMLDocument *xmlDocument;
@property (nonatomic, retain)NSMutableArray *smallClassList;
@end
