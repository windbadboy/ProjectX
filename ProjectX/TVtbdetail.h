//
//  TVtbdetail.h
//  ProjectX
//
//  Created by ted on 16/8/14.
//  Copyright © 2016年 ted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
@protocol newcelldelegate <NSObject>
-(UIButton*)getbtn1;
@end
@interface TVtbdetail : UITableViewCell
<
//实现数据视图的普通协议
//数据视图的普通事件处理
UITableViewDelegate,
//实现数据视图的数据代理协议
//处理数据视图的数据代理
UITableViewDataSource,
NSURLConnectionDelegate,
NSURLConnectionDataDelegate,
NSXMLParserDelegate,
UIAlertViewDelegate,
newcelldelegate
>

{
    UILabel *_lbltbr;
    UILabel *_lblbtbr;
    UILabel *_lblstatus;
    UIButton *_btn1,*_btn2;
    UITableView* _tableView;
    NSMutableData* _data;

}
//*adjustxh,*czyh,*adjuststatus,*roleid;
-(void)settbr:(NSString *)text1 setbtbr:(NSString*)text2 setstatus:(NSString*) text3 setjlzt:(int)jlzt setadjustxh:(NSString*)myadjustxh setczyh:(NSString*)myczyh setadjuststatus:(NSString*)myadjuststatus setroleid:(NSString*)myroleid setwhichone:(NSString*)whichone;
-(UIButton*)getbtn2;
@property(assign,nonatomic)id<newcelldelegate> mydelegate;
@end
