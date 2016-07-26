//
//  todayduty.m
//  ProjectX
//
//  Created by ted on 16/7/26.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "todayduty.h"

@implementation todayduty
-(NSString*)description{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@",self.username,self.pbrole,self.pbdate,self.telshort,self.tel];
}
@end
