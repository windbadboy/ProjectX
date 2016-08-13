//
//  TVtbcell.h
//  ProjectX
//
//  Created by ted on 16/8/12.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVtbcell : UITableViewCell
{
    UILabel *_lbltitle;
    UILabel *_lblnumbers;
    UIImageView *_ivnumbers;
    UIImageView *_ivtitlelog;
}

-(void)settitle:(NSString *)text1 txtnumbers:(NSString*)text2 img:(UIImage*) img1 img2:(UIImage*) img2;

@end
