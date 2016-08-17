//
//  VCDutylogwrite.h
//  ProjectX
//
//  Created by ted on 16/8/16.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDropDownMenu.h"
#import "Masonry.h"
#import "VCtestCell.h"
#import "dutyloginfo.h"
@interface VCDutylogwrite : UIViewController
<
JSDropDownMenuDataSource,
JSDropDownMenuDelegate,
UITableViewDelegate,
UITableViewDataSource,
NSURLConnectionDelegate,
NSURLConnectionDataDelegate,
NSXMLParserDelegate,
UIAlertViewDelegate
>

{
    
    NSArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
        UITableView* _tableView;
        NSMutableData* _data;
}
//dutyinfo.username=username;
//dutyinfo.roleid=roleid;
//dutyinfo.userid=userid;
//dutyinfo.rolename=rolename;
//dutyinfo.myweekday=myweekday;
//dutyinfo.isrecord=isrecord;
//dutyinfo.pbdate=pbdate;
@property NSString *currentElement;
@property NSString *roleid,*userid,*pbdate,*isrecord,*myweekday,*username,*rolename;
@end
