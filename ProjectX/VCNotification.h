//
//  VCNotification.h
//  ProjectX
//
//  Created by ted on 16/7/11.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "noteinfo.h"
#import "DetailNote.h"
#import "DetailNoteDelegate.h"
@interface VCNotification : UIViewController
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
UIAlertViewDelegate,
DetailNoteDelegate,
NSURLSessionDelegate
>
{
    FMDatabase* noteDB;
    NSURLConnection* _connect;
    NSMutableData* _data;
    UITableView* _tableView;
}
@property(nonatomic,retain) NSString *firstValue ;
@property NSString *currentElement;
@end
