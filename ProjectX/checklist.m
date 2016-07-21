//
//  checklist.m
//  ProjectX
//
//  Created by ted on 16/7/21.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "checklist.h"

@implementation checklist
-(NSString*)description{
    return [NSString stringWithFormat:@"%@,%@,%@",self.username,self.userid,self.checktime];
}
@end
