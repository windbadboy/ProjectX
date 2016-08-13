//
//  TVtbcell.m
//  ProjectX
//
//  Created by ted on 16/8/12.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "TVtbcell.h"
#import "Masonry.h"

@implementation TVtbcell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _lbltitle=[[UILabel alloc] init];
        _ivnumbers=[[UIImageView alloc]init];
        _lblnumbers=[[UILabel alloc] init];
        _ivtitlelog=[[UIImageView alloc]init];
        [self.contentView addSubview:_lbltitle];
        [self.contentView addSubview:_ivnumbers];
        [self.contentView addSubview:_lblnumbers];
        [self.contentView addSubview:_ivtitlelog];
        [_ivtitlelog mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.contentView).offset(4);
             make.width.equalTo(@43);
             make.height.equalTo(@43);
             make.bottom.equalTo(self.contentView).offset(-32);
         }];
        [_lbltitle mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.contentView).offset(50);
             make.width.equalTo(@120);
             make.height.equalTo(@40);
             make.bottom.equalTo(self.contentView).offset(-32);
         }];
        [_lblnumbers mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.contentView).offset(-12);
             make.width.equalTo(@20);
             make.height.equalTo(@20);
             make.bottom.equalTo(self.contentView).offset(-34);
         }];
        [_ivnumbers mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.contentView).offset(-16);
             make.width.equalTo(@24);
             make.height.equalTo(@24);
             make.bottom.equalTo(self.contentView).offset(-32);
         }];
    }
    return self;
}

-(void)settitle:(NSString *)text1 txtnumbers:(NSString *)text2 img:(UIImage *)img1 img2:(UIImage *)img2
{
    _lbltitle.text=text1;
    _lblnumbers.text=text2;
    _ivnumbers.image=img1;
    _ivtitlelog.image=img2;
    _lblnumbers.textColor=[UIColor whiteColor];
}
@end
