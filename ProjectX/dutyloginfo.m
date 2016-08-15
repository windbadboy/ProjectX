//
//  dutyloginfo.m
//  ProjectX
//
//  Created by ted on 16/8/15.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "dutyloginfo.h"

@implementation dutyloginfo
-(NSString*)description{
    //*username,*roleid,*zgqk,*rwzz,*wzbr,*fwtd,*userid,*rolename,*recordcontent,*recorddate,*myweekday;
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",self.username,self.roleid,self.zgqk,self.rwzz,self.wzbr,self.fwtd,self.userid,self.rolename,self.recordcontent,self.recorddate,self.myweekday];
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
