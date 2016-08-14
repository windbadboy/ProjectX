//
//  VCThird.h
//  ProjectX
//
//  Created by ted on 16/7/11.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "VCmytb.h"
#import "VCmytbdetail.h"
@interface VCThird : UIViewController
<
UIPickerViewDelegate,
UIPickerViewDataSource
>
{
        UITableView* _tableView;
        NSMutableData* _data;
}
@property NSString *currentElement;
@end
