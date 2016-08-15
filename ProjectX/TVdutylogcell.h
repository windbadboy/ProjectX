//
//  TVdutylogcell.h
//  ProjectX
//
//  Created by ted on 16/8/15.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
@interface TVdutylogcell : UITableViewCell
{
    UILabel *_lblpbdate;
    UILabel *_lblsecond;
    UILabel *_lblthird;
    UILabel *_lblfourth;
    UILabel *_lblfifth;
}
-(void)setpbdate:(NSString*)pbdate setsecond:(NSString*)second setthird:(NSString*)third setfourth:(NSString*)fourth setfifth:(NSString*)fifth;
@end
