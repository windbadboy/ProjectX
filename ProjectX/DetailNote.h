//
//  DetailNote.h
//  ProjectX
//
//  Created by ted on 16/7/21.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "noteinfo.h"
#import "DetailNoteDelegate.h"
#import "checklist.h"
@interface DetailNote : UIViewController
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
        FMDatabase* noteDB;
        UITableView* _tableView;
    NSURLConnection* _connect;
    NSMutableData* _data;
}
@property(nonatomic,retain) NSString *firstValue ;
@property(nonatomic,retain) NSString *badgeValue ;
@property(nonnull,retain) id<DetailNoteDelegate> delegate;
@property NSString *currentElement;
@end
