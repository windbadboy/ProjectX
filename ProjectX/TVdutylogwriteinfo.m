//
//  TVdutylogwriteinfo.m
//  ProjectX
//
//  Created by ted on 16/8/16.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "TVdutylogwriteinfo.h"

@implementation TVdutylogwriteinfo
-(NSString*)description{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",self.username,self.rolename,self.myweekday,self.userid,self.roleid,self.isrecord,self.pbdate];
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
