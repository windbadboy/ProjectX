//
//  MainFrame.h
//  ProjectX
//
//  Created by ted on 16/7/10.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "todayduty.h"
#import "Masonry.h"
@interface MainFrame : UIViewController
<
NSURLConnectionDelegate,
NSURLConnectionDataDelegate,
NSXMLParserDelegate,
UIAlertViewDelegate,
NSURLSessionDelegate
>

{
    NSURLConnection* _connect;
    
    NSMutableData* _data;
        NSMutableData* _data2;
    NSLock* _lock;
}
@property NSString *currentElement;
-(void)getsth:(int)whichone para:(NSString*)whichpara;

-(NSMutableURLRequest*)getrequest:(NSString*)myrequest;
-(void)justdoit;
@end
