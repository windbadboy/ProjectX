//
//  Changepw.h
//  ProjectX
//
//  Created by ted on 16/7/31.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "NSString+MD5.h"
@interface Changepw : UIViewController
<
NSURLSessionDelegate,
NSURLSessionDataDelegate
>
{
    UILabel* _lbPasswordrepeat;
    UILabel* _lbPassword;
    UITextField* _tfPasswordrepeat;
    UITextField* _tfPassword;
    UIButton* _btChangepw;
        NSMutableData* _data;
}
@property(nonatomic,retain) NSString *userid;

@end
