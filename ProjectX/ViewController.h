//
//  ViewController.h
//  ProjectX
//
//  Created by ted on 16/6/30.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainFrame.h"
#import "VCSecond.h"
#import "FMDB.h"
#import "VCNotification.h"
@interface ViewController : UIViewController

<
NSURLConnectionDelegate,
NSURLConnectionDataDelegate,
NSXMLParserDelegate,
UIAlertViewDelegate,
VCSecondDelegate,
UITabBarControllerDelegate
>

{
    //定义一个URL连接对象
    NSURLConnection* _connect;
    
    NSMutableData* _data;

    UILabel* _lbUserName;
    UILabel* _lbPassword;
    UILabel* _lbTitle;
    UITextField* _tfUsername;
    UITextField* _tfPassword;
    UIButton* _btLogin;
    FMDatabase* noteDB;
    VCNotification *vcNotification;
}
@property (weak, nonatomic) IBOutlet UITextField *idfield;
@property (weak, nonatomic) IBOutlet UITextField *pwfield;

@property (weak, nonatomic) IBOutlet UITextField *celsiusText;
@property NSString *currentElement;


@end

