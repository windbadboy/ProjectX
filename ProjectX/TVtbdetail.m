//
//  TVtbdetail.m
//  ProjectX
//
//  Created by ted on 16/8/14.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "TVtbdetail.h"

@implementation TVtbdetail
{
    NSString *adjustxh,*czyh,*adjuststatus,*roleid;
}
-(UIButton*)getbtn1
{
    return _btn1;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _lbltbr=[[UILabel alloc] init];
        _lblbtbr=[[UILabel alloc] init];
        _lblstatus=[[UILabel alloc] init];
        _btn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _btn2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:_lbltbr];
        [self.contentView addSubview:_lblbtbr];
        [self.contentView addSubview:_lblstatus];
        [self.contentView addSubview:_btn1];
        [self.contentView addSubview:_btn2];

        [_lbltbr mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.contentView).offset(4);
             make.width.equalTo(self.contentView);
             make.height.equalTo(@20);
             make.top.equalTo(self.contentView).offset(4);
         }];
        [_lblbtbr mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.contentView).offset(4);
             make.width.equalTo(self.contentView);
             make.height.equalTo(@20);
             make.top.equalTo(self.contentView).offset(32);
         }];
        [_lblstatus mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.contentView).offset(4);
             make.width.equalTo(self.contentView);
             make.height.equalTo(@20);
             make.top.equalTo(self.contentView).offset(60);
         }];
        [_btn1 mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.contentView).offset(-80);
             make.width.equalTo(@40);
             make.height.equalTo(@20);
             make.top.equalTo(self.contentView).offset(88);
         }];
        [_btn2 mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.contentView).offset(-16);
             make.width.equalTo(@40);
             make.height.equalTo(@20);
             make.top.equalTo(self.contentView).offset(88);
         }];
    }
    return self;
}
-(void)settbr:(NSString *)text1 setbtbr:(NSString *)text2 setstatus:(NSString *)text3 setjlzt:(int)jlzt setadjustxh:(NSString *)myadjustxh setczyh:(NSString *)myczyh setadjuststatus:(NSString *)myadjuststatus setroleid:(NSString *)myroleid
{
    _lbltbr.text=text1;
    _lblbtbr.text=text2;
    _lblstatus.text=text3;
    adjustxh=myadjustxh;
    czyh=myczyh;
    adjuststatus=myadjuststatus;
    roleid=myroleid;

    
    switch (jlzt) {
        case 1:
        {
            
            
            [_btn1 setTitle:@"作废" forState:UIControlStateNormal];
            _btn2.hidden=YES;
            _btn1.hidden=NO;
            _lblstatus.textColor=[UIColor orangeColor];
          //  _btn1.tag=1;
           // [_btn1 addTarget:self action:@selector(zuofei) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 6:
        {
            _btn1.hidden=YES;
            _btn2.hidden=YES;
            _lblstatus.textColor=[UIColor orangeColor];
              //          _btn1.tag=1;
        }
            break;
        default:
            break;
    }

}
@end
