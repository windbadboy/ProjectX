//
//  tbdetailinfo.m
//  ProjectX
//
//  Created by ted on 16/8/14.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "tbdetailinfo.h"

@implementation tbdetailinfo
-(NSString*)description{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@",self.username1,self.username2,self.pbdate1,self.pbdate2,self.adjustxh,self.jlztname,self.jlzt,self.czrq,self.czyname];
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







