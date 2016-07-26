//
//  MainFrame.h
//  ProjectX
//
//  Created by ted on 16/7/10.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "todayduty.h"
@interface MainFrame : UIViewController
<
NSURLConnectionDelegate,
NSURLConnectionDataDelegate,
NSXMLParserDelegate,
UIAlertViewDelegate
>

{
    NSURLConnection* _connect;
    
    NSMutableData* _data;
}
@property NSString *currentElement;
@end
