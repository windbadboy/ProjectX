//
//  VCtestCell.m
//  ProjectX
//
//  Created by ted on 16/8/16.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCtestCell.h"

@implementation VCtestCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
            self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _data1 = [NSMutableArray arrayWithObjects: @"在岗", @"部分在岗", nil];
    _data2 = [NSMutableArray arrayWithObjects: @"按规定着装", @"未按规定着装", nil];
    _data3 = [NSMutableArray arrayWithObjects: @"无特殊", @"存在问题", nil];

   
    return self;
}
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        return _data1.count;
    } else if (column==1){
        
        return _data2.count;
        
    } else if (column==2){
        
        return _data3.count;
    }
    
    return 0;
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return _data1[0];
            break;
        case 1: return _data2[0];
            break;
        case 2: return _data3[0];
            break;
        default:
            return nil;
            break;
    }
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    
    return 1;
}
//抬头显示的名称
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return _data1[indexPath.row];
    } else if (indexPath.column==1) {
        
        return _data2[indexPath.row];
        
    } else {
        
        return _data3[indexPath.row];
    }
}
//选中具体哪一行数据
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        if(indexPath.row>0)
        {
        _currentData1Index = indexPath.row;
        }
        
    } else if(indexPath.column == 1){
        
        if(indexPath.row>0)
        {
            _currentData2Index = indexPath.row;
        }
        
    } else{
        
        if(indexPath.row>0)
        {
            _currentData3Index = indexPath.row;
        }
    }
}
-(void)setarray1:(NSMutableArray*)array1 setarray2:(NSMutableArray*)array2
{
    _data1=[[NSMutableArray alloc]initWithArray:array1];
    _data2=[[NSMutableArray alloc]initWithArray:array2];
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 60) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    [self.contentView addSubview:menu];
}

@end
