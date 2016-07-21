//
//  noteinfo.m
//  ProjectX
//
//  Created by ted on 16/7/19.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "noteinfo.h"

@implementation noteinfo
-(NSString*)description{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",self.myusername,self.mytitle ,self.mybody,self.notificationid,self.sendtime,self.isread];
}
@end
