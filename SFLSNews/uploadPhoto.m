//
//  uploadPhoto.m
//  SFLS_Photo_Comp
//
//  Created by 皓斌 朱 on 12-3-9.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import "uploadPhoto.h"
#import <QuartzCore/QuartzCore.h>
@implementation uploadPhoto
@synthesize urlAdress,uploadImage,uploadImageName,postTime,delegate,uploadObjected;


-(id)initWithDelegate:(id<uploadPhotoDelegate>)paramDelegate{
    self=[super init];
    if (self!=nil) {
        delegate=paramDelegate;
    }
    return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"delegate in connectionresponse  ,%@",uploadObjected);
    [self.delegate uploadPhotoDelegateStartedAtObject:uploadObjected];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.delegate uploadPhotoDelegateMeetErrors:error];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.delegate uploadPhotoDelegateFinishedAtObject:uploadObjected];
}
-(void)uploadPhotoToUrl{
    //开始发送大图片到服务器
    NSData *m_imageData;//未修改
    NSString *string1 = uploadImageName;
    NSString *string2 = @"_s";
    NSRange range = [string1 rangeOfString:string2];
    int leight = range.length;
    if (leight!=0) {
        m_imageData=UIImageJPEGRepresentation(uploadImage, 0.3);
    }
    else{
        m_imageData=UIImagePNGRepresentation(uploadImage);
    }
    
    NSData *postDateBoundary = [[NSString stringWithFormat:@"---------------------------168072824752491622650073c\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *postDatename = [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"File1_desc\";\r\n\r\n desdefa\r\n\r\n"]dataUsingEncoding:NSUTF8StringEncoding];
    NSData *postDateBoundaryEnd = [[NSString stringWithFormat:@"\r\n-----------------------------168072824752491622650073c--\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *postDateHead = [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"File1\"; filename=\"cabcd.png\"\r\nContent-Type: image/jpg\r\n\r\n"]dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *postData = [NSMutableData dataWithCapacity:[m_imageData length] ];
    [postData appendData:postDateBoundary];
    [postData appendData:postDateHead];
    [postData appendData:m_imageData];
    [postData appendData:postDateBoundaryEnd];
    NSString *theLink=[NSString stringWithFormat:@"%@/upload.asp?imagename=%@",urlAdress,uploadImageName];
    NSLog(@"%@",theLink);
    NSURL *url=[NSURL URLWithString:theLink];
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    //设置头
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"]forHTTPHeaderField:@"Accept"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"gzip, deflate"]forHTTPHeaderField:@"Accept-Encoding"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"zh-cn,zh;q=0.5"]forHTTPHeaderField:@"Accept-Language"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"keep-alive"]forHTTPHeaderField:@"Connection"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"192.168.1.4"]forHTTPHeaderField:@"Host"];
    [urlRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"http://192.168.1.4/work/2yup/exp1.html"]forHTTPHeaderField:@"Referer"];
    [urlRequest setValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20100101 Firefox/10.0.1"]forHTTPHeaderField:@"User-Agent"];
    NSString *length=[NSString stringWithFormat:@"%d",[m_imageData length] + [postDateBoundary length]*2 + [postDateHead length]+[postDatename length]+ [postDateBoundaryEnd length]];
    [urlRequest addValue:[NSString stringWithFormat:@"%@%@",@"multipart/form-data; boundary=",postDateBoundary]forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:[NSString stringWithFormat:@"%d\r\n",length]forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody:postData];
    NSURLConnection *newConnection=[[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
        if (newConnection) {
        NSLog(@"in connection");
    }
}
-(void)uploadPhotoToUrl:(NSString *)fullurlAdress imageName:(NSString *)fulluploadImageName image:(UIImage *)fulluploadImage uploadObject:(NSString *)uploadObject{
    self.uploadImageName=fulluploadImageName;
    self.uploadImage=fulluploadImage;
    self.urlAdress=fullurlAdress;
    self.uploadObjected=uploadObject;
    [self uploadPhotoToUrl];
}

-(void)uploadInfoToUrl:(NSString *)fullurlAdress takerName:(NSString *)takerName takerClass:(NSString *)takerClass takerPhone:(NSString *)takerPhone takerPWD:(NSString *)takerPWD photoType:(NSString *)photoType is_Public:(NSString *)is_public withPhotoNames:(NSMutableArray *)photoNames withInfos:(NSMutableArray *)photoInfos takerTimes:(int)takerTimes uploadObject:(NSString *)uploadObject{
    NSString *connectUrl=[NSString stringWithFormat:@"%@/infoSave.asp",fullurlAdress];
    
    NSString *dataString=[NSString stringWithFormat:@"name=%@&class=%@&phone=%@&pwd=%@&photo_type=%@&is_public=%@",takerName,takerClass,takerPhone,takerPWD,photoType,is_public];
    int i,j;
    for (i=0; i<takerTimes; i++) {
        dataString=[NSString stringWithFormat:@"%@&photo%i=%@&photoinfo%i=%@",dataString,i+1,[photoNames objectAtIndex:i],i+1,[photoInfos objectAtIndex:i]];
    }
    for (j=i; j<5; j++) {
        dataString=[NSString stringWithFormat:@"%@&photo%i=%@&photoinfo%i=%@",dataString,j+1,@"",j+1,@""];
    }
    dataString=[NSString stringWithFormat:@"%@&submit=ok",dataString];
    NSData *theData=[dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",dataString);
    NSMutableData *infoSaveData=[NSMutableData dataWithCapacity:[theData length]];
    [infoSaveData appendData:theData];
    
    NSURL *infoSaveDataUrl=[NSURL URLWithString:connectUrl];
    NSString *infoSaveDatalength=[NSString stringWithFormat:@"%d",[infoSaveData length]];    
    NSMutableURLRequest *infoSaveDataRequest=[NSMutableURLRequest requestWithURL:infoSaveDataUrl];
    [infoSaveDataRequest setHTTPMethod:@"POST"];
    //设置头
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"]forHTTPHeaderField:@"Accept"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"gzip, deflate"]forHTTPHeaderField:@"Accept-Encoding"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"zh-cn,zh;q=0.5"]forHTTPHeaderField:@"Accept-Language"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"keep-alive"]forHTTPHeaderField:@"Connection"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"192.168.1.4"]forHTTPHeaderField:@"Host"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"http://192.168.1.4/work/2yup/exp1.html"]forHTTPHeaderField:@"Referer"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%@\r\n\r\n",@"application/x-www-form-urlencoded"]forHTTPHeaderField:@"Content-Type"];
    [infoSaveDataRequest addValue:[NSString stringWithFormat:@"%d\r\n",infoSaveDatalength]forHTTPHeaderField:@"Content-Length"]; 
    [infoSaveDataRequest setHTTPBody:infoSaveData];  
    NSURLConnection *infoSaveConnection=[[NSURLConnection alloc]initWithRequest:infoSaveDataRequest delegate:self startImmediately:YES];   
    if (infoSaveConnection) {
        NSLog(@"in connection");
    }

    
    
}
@end












