//
//  VCdutylogwritequery.h
//  ProjectX
//
//  Created by ted on 16/8/16.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "TVdutylogwriteinfo.h"
#import "TVdutyelogwritecell.h"
@interface VCdutylogwritequery : UITableViewController
<

UITableViewDelegate,
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
@end
