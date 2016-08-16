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
}
@end
