//
//  VCmytb_second.h
//  ProjectX
//
//  Created by ted on 16/8/13.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mydutyinfo.h"
#import "Masonry.h"
#import "VCmytb_final.h"
@interface VCmytb_second : UIViewController
<
//实现数据视图的普通协议
//数据视图的普通事件处理
UITableViewDelegate,
//实现数据视图的数据代理协议
//处理数据视图的数据代理
UITableViewDataSource,
NSURLConnectionDelegate,
NSURLConnectionDataDelegate,
NSXMLParserDelegate,
UIAlertViewDelegate

>

{
    UITableView* _tableView;
    NSMutableData* _data;
}

@property NSString *currentElement;
@property NSString *username,*rolename,*pbdate,*myweekday;
@end
