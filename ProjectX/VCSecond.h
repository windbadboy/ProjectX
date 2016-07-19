//
//  VCSecond.h
//  ProjectX
//
//  Created by ted on 16/7/11.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mydutyinfo.h"
@protocol VCSecondDelegate <NSObject>
-(NSString*)getuserid;
@end
@interface VCSecond : UIViewController
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
    NSURLConnection* _connect;
    NSMutableData* _data;
}
@property (assign,nonatomic) id<VCSecondDelegate>delegate;
@property(nonatomic,retain) NSString *firstValue ;
@property(nonatomic,retain) NSString *secondValue ;
@property NSString *currentElement;
@property(assign,nonatomic)id<VCSecondDelegate> mydelegate;
@end
