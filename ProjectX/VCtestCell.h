//
//  VCtestCell.h
//  ProjectX
//
//  Created by ted on 16/8/16.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDropDownMenu.h"
#import "Masonry.h"
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
    NSInteger mycount;
    NSInteger _dataindex1,_dataindex2;
}
-(void)setarray1:(NSMutableArray*)array1 setarray2:(NSMutableArray*)array2 setsection:(NSInteger*)section setrow:(NSInteger)row setdataindex1:(NSInteger*)dataindex1 setdataindex2:(NSInteger*)dataindex2;
@end
