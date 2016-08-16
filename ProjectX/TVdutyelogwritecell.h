//
//  TVdutyelogwritecell.h
//  ProjectX
//
//  Created by ted on 16/8/16.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
@interface TVdutyelogwritecell : UITableViewCell
{
    UILabel *_lblusername;
    UILabel *_lblpbdate;
    UILabel *_lblweekday;
    UILabel *_lblisrecord;
    UILabel *_lblrolename;
}
-(void)setusername:(NSString*)username setpbdate:(NSString*)pbdate setweekday:(NSString*)weekday setisrecord:(NSString*)isrecord setrolename:(NSString*)rolename;
@end
