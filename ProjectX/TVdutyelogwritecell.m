//
//  TVdutyelogwritecell.m
//  ProjectX
//
//  Created by ted on 16/8/16.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "TVdutyelogwritecell.h"

@implementation TVdutyelogwritecell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _lblusername=[[UILabel alloc]init];
    _lblpbdate=[[UILabel alloc]init];
    _lblweekday=[[UILabel alloc]init];
    _lblisrecord=[[UILabel alloc]init];
    _lblrolename=[[UILabel alloc]init];
        [self.contentView addSubview:_lblusername];
        [self.contentView addSubview:_lblpbdate];
        [self.contentView addSubview:_lblweekday];
        [self.contentView addSubview:_lblisrecord];
        [self.contentView addSubview:_lblrolename];
    [_lblusername mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView).offset(4);
         make.width.equalTo(@40);
         make.height.equalTo(@20);
         make.top.equalTo(self.contentView).offset(4);
     }];
    [_lblpbdate mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView).offset(65);
         make.width.equalTo(@150);
         make.height.equalTo(@20);
         make.top.equalTo(self.contentView).offset(4);
     }];
    [_lblweekday mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView).offset(180);
         make.width.equalTo(@40);
         make.height.equalTo(@20);
         make.top.equalTo(self.contentView).offset(4);
     }];
    [_lblisrecord mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.equalTo(self.contentView).offset(-4);
         make.width.equalTo(@80);
         make.height.equalTo(@20);
         make.top.equalTo(self.contentView).offset(4);
     }];
    [_lblrolename mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.equalTo(self.contentView).offset(-4);
         make.width.equalTo(@80);
         make.height.equalTo(@20);
         make.bottom.equalTo(self.contentView).offset(-4);
     }];
    return  self;
}
-(void)setusername:(NSString*)username setpbdate:(NSString*)pbdate setweekday:(NSString*)weekday setisrecord:(NSString*)isrecord setrolename:(NSString*)rolename
{
    if([isrecord isEqualToString:@"1"])
    {
            _lblisrecord.text=@"已填写";
        _lblisrecord.textColor=[UIColor greenColor];
    }
    else
    {
        _lblisrecord.text=@"未填写";
        _lblisrecord.textColor=[UIColor redColor];
    }
    _lblpbdate.text=pbdate;
    _lblusername.text=username;
    _lblweekday.text=weekday;
    _lblrolename.text=rolename;
}

@end
