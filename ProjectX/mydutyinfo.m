//
//  mydutyinfo.m
//  ProjectX
//
//  Created by ted on 16/7/17.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "mydutyinfo.h"

@implementation mydutyinfo
-(NSString*)description{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",self.myusername,self.myweekday,self.myrolename,self.myroleid,self.myuserid,self.mypbdate];
}
-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"(\n"];
    
    for (id obj in self) {
        [strM appendFormat:@"\t%@,\n", obj];
    }
    [strM appendString:@")"];
    
    return strM;
}
@end
