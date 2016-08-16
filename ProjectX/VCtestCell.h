//
//  VCtestCell.h
//  ProjectX
//
//  Created by ted on 16/8/16.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDropDownMenu.h"
@interface VCtestCell : UITableViewCell
<
JSDropDownMenuDataSource,
JSDropDownMenuDelegate
>

{
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
}
-(void)setarray1:(NSMutableArray*)array1 setarray2:(NSMutableArray*)array2;
@end
