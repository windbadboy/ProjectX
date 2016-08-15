//
//  TVdutylogcell.m
//  ProjectX
//
//  Created by ted on 16/8/15.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "TVdutylogcell.h"

@implementation TVdutylogcell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _lblpbdate=[[UILabel alloc] init];
    _lblsecond=[[UILabel alloc] init];
    _lblthird=[[UILabel alloc] init];
    _lblfourth=[[UILabel alloc] init];
    _lblfifth=[[UILabel alloc] init];
    _lblpbdate.font=[UIFont systemFontOfSize:18];
    _lblpbdate.textColor=[UIColor redColor];
    _lblsecond.font=[UIFont systemFontOfSize:12];
    _lblsecond.font=[UIFont systemFontOfSize:12];
    _lblthird.font=[UIFont systemFontOfSize:12];
    _lblfourth.font=[UIFont systemFontOfSize:12];
    _lblfifth.font=[UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:_lblpbdate];
        [self.contentView addSubview:_lblsecond];
        [self.contentView addSubview:_lblthird];
        [self.contentView addSubview:_lblfourth];
        [self.contentView addSubview:_lblfifth];
         [self.contentView addSubview:_lblpbdate];
    [_lblpbdate mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView).offset(4);
         make.width.equalTo(self.contentView);
         make.height.equalTo(@20);
         make.top.equalTo(self.contentView).offset(4);
     }];
    [_lblsecond mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView).offset(4);
         make.width.equalTo(self.contentView);
         make.height.equalTo(@20);
         make.top.equalTo(self.contentView).offset(24);
     }];
    [_lblthird mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView).offset(4);
         make.width.equalTo(self.contentView);
         make.height.equalTo(@20);
         make.top.equalTo(self.contentView).offset(45);
     }];
    [_lblfourth mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView).offset(4);
         make.width.equalTo(self.contentView);
         make.height.equalTo(@20);
         make.top.equalTo(self.contentView).offset(65);
     }];
    [_lblfifth mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView).offset(4);
         make.width.equalTo(self.contentView).offset(-4);
         make.height.equalTo(@50);
         make.top.equalTo(self.contentView).offset(85);
     }];
    
        return self;
}
-(void)setpbdate:(NSString*)pbdate setsecond:(NSString*)second setthird:(NSString*)third setfourth:(NSString*)fourth setfifth:(NSString*)fifth
{
    _lblpbdate.text=pbdate;
    _lblsecond.text=second;
    _lblthird.text=third;
    _lblfourth.text=fourth;
    _lblfifth.text=fifth;
    _lblfifth.numberOfLines=0;
    [_lblfifth sizeToFit];
}
@end
