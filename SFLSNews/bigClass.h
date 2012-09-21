//
//  bigClass.h
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLelement.h"
#import "XMLDocument.h"
@interface bigClass : UIViewController<XMLDocumentDelegate>{
    XMLDocument *xmlDocument;
    NSArray *bigClassList;
    UIScrollView *scrowView;
}
- (IBAction)toSmallClass:(id)sender withTag:(int)tag;
@property (nonatomic, retain) IBOutlet UIScrollView *scrowView;
@property(nonatomic,retain)XMLDocument *xmlDocument;
@property(nonatomic,retain)NSArray *bigClassList;
@end
