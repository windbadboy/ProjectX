//
//  VCThird.m
//  ProjectX
//
//  Created by ted on 16/7/11.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCThird.h"
#import "TVtbcell.h"
@implementation VCThird
{
NSString *userid;
NSString *roleid;
NSString *isadmin;
    NSString *tbinfo1;//我的调班单
    NSString *tbinfo2;//找我的调班单
    NSString *tbinfo3;//需审核的调班单
    NSTimer *_timer;
        UIButton *checkbox;
}
@synthesize currentElement;
-(void)viewDidAppear:(BOOL)animated
{
//        self.view.backgroundColor=[UIColor whiteColor];
//    UIPickerView* pickerView=[[UIPickerView alloc] init];
//    pickerView.frame=CGRectMake(10, 100, 300, 200);
//    pickerView.delegate=self;
//    pickerView.dataSource=self;
//    [self.view addSubview:pickerView];
    NSUserDefaults *roleid2=[NSUserDefaults standardUserDefaults];
    roleid=[roleid2 objectForKey:@"roleid"];
    NSUserDefaults *isadmin2=[NSUserDefaults standardUserDefaults];
    isadmin=[isadmin2 objectForKey:@"isadmin"];
    NSUserDefaults *userid2=[NSUserDefaults standardUserDefaults];
    userid=[userid2 objectForKey:@"userID"];
   // [self updateUI];
    _timer=[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    [self justdoit];
}
//实现获取组数的协议函数
//返回值为选择视图的组数
//整数类型
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    //返回3组
//    return  3;
//}
//实现每组元素的个数
//每组元素多少行
//P1:调用此协议的选择视图本身
//P2:第几组的元素个数
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return 10;
//}
//显示每个元素的内容
//P1:调用此协议的选择视图本身
//P2:行数
//P3:组数
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSString* str=[NSString stringWithFormat:@"%d组%d行",component+1,row+1];
//    return str;
//}
//
//-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 80;
//}
//
//
//-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UIImage* image=[UIImage imageNamed:@"duty.png"];
//    UIImageView *iView=[[UIImageView alloc]initWithImage:image];
//    return iView;
//}

-(void)timerFire
{
    [self justdoit];
    //  NSLog(@"justtodi zyrs is %@",zyrs);
}
-(void)viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
}
-(void)updateUI
{
    _tableView=[[UITableView alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
   // [_tableView setSeparatorColor:[UIColor orangeColor]];
    _tableView.delegate=self;
    _tableView.dataSource=self;
  //  [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  //  [_tableView setSeparatorColor:[UIColor orangeColor]];

    [self.view addSubview:_tableView];
    

    if([isadmin isEqualToString:@"1"])
    {
            int i=[tbinfo1 intValue]+[tbinfo2 intValue]+[tbinfo3 intValue];
    if(i>0)
    {
    self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%i",i];
    }
        else
        {
                self.tabBarItem.badgeValue=nil;
        }
    }
    else
    {
        int i=[tbinfo1 intValue]+[tbinfo2 intValue];
        if(i>0)
        {
            self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%i",i];
        }
        else
        {
            self.tabBarItem.badgeValue=nil;
        }
    }
    
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view);
         make.top.equalTo(self.view).offset(64);
         make.height.equalTo(self.view);
     }];
    
    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(10, 30, 30, 20);
    // checkbox.frame=CGRectMake(10, 30, 30, 20);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkbox];

}

//获取每组元素的个数(行数)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回组数,最终行数:组数*行数
    if([isadmin intValue]==1)
    {
    return 4;
    }
    else
    {
        return 3;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellStr=@"cell";
    TVtbcell* cell=[_tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell=[[TVtbcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
          //  [_tableView setSeparatorColor:[UIColor orangeColor]];

    }

    
    
//set cells title
    switch (indexPath.section) {
        case 0:
        {
            UIImage* _imgtitlelogo=[UIImage imageNamed:@"tb1.png"];
            [cell settitle:@"我要调班" txtnumbers:nil  img:nil img2:_imgtitlelogo];
            break;
        }
        case 1:
        {
                        UIImage* _imgtitlelogo=[UIImage imageNamed:@"tb0.png"];
            UIImage* _img=[UIImage imageNamed:@"number"];
            if([tbinfo1 intValue]>0)
            {
            [cell settitle:@"我的调班单" txtnumbers:tbinfo1 img:_img img2:_imgtitlelogo];
            }
            else
            {
             [cell settitle:@"我的调班单" txtnumbers:nil img:nil img2:_imgtitlelogo];
            }
            break;
        }
        case 2:
        {
            UIImage* _imgtitlelogo=[UIImage imageNamed:@"tb2.png"];
            UIImage* _img=[UIImage imageNamed:@"number"];
            if([tbinfo2 intValue]>0)
            {
            [cell settitle:@"找我的调班单" txtnumbers:tbinfo2 img:_img img2:_imgtitlelogo];
            }
            else
            {
            [cell settitle:@"找我的调班单" txtnumbers:nil img:nil img2:_imgtitlelogo];
            }
            break;
        }
        case 3:
        {
                        UIImage* _imgtitlelogo=[UIImage imageNamed:@"tb3.png"];
            UIImage* _img=[UIImage imageNamed:@"number"];
            if([tbinfo3 intValue]>0)
            {
                [cell settitle:@"需审核的调班单" txtnumbers:tbinfo3 img:_img img2:_imgtitlelogo];
            }
            else
            {
                [cell settitle:@"需审核的调班单" txtnumbers:nil img:nil img2:_imgtitlelogo];
            }
            break;
        }
        default:
            break;
    }

    //子标题

     //   cell.detailTextLabel.text=@"test";
     //  NSString* str1=[NSString stringWithFormat:@"unfold.png"];

    //图片
    
//    UIImage* image=[UIImage imageNamed:str1];
//    UIImageView *iView=[[UIImageView alloc] initWithImage:image];
//    cell.imageView.image=image;

    return cell;
    
}

//tabview click event
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if([tbinfo1 intValue]+[tbinfo2 intValue]>0)
            {
                NSString *logintips=[NSString stringWithFormat:@"您有未处理完成的调班单."];
                
                UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert1 show];
            }
            else
            {
                VCmytb* vcMytb=[[VCmytb alloc]init];
                    [self presentViewController:vcMytb animated:NO completion:nil];
            }
        }
            break;
        case 1:
        {
            VCmytbdetail* mytbDetail=[[VCmytbdetail alloc]init];
            mytbDetail.whichone=@"1";
            [self presentViewController:mytbDetail animated:NO completion:nil];
            
        }
            break;
        case 2:
        {
            VCmytbdetail* mytbDetail=[[VCmytbdetail alloc]init];
            mytbDetail.whichone=@"2";
            [self presentViewController:mytbDetail animated:NO completion:nil];
            
        }
            break;
        case 3:
        {
            VCmytbdetail* mytbDetail=[[VCmytbdetail alloc]init];
            mytbDetail.whichone=@"3";
            [self presentViewController:mytbDetail animated:NO completion:nil];
            
        }
            break;
        default:
            break;
    }
    
}
//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
//标题
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if(section==0)
//    {
//    return @"我要调班";
//    }
//    else if(section==1)
//        {
//            return @"我的调班单";
//        }
//        else if(section==2)
//        {
//            return @"找我的调班单";
//        }else{
//    return @"需审核的调班单";
//        }
//}

-(void)justdoit
{
    _data=[[NSMutableData alloc] init];

    NSMutableArray *operations=[NSMutableArray array];
    NSArray *a=[NSArray arrayWithObjects:@"userid",@"roleid",nil];
    NSArray *b=[NSArray arrayWithObjects:userid,roleid, nil];
    
    
    NSMutableURLRequest *therequest=[self getrequest:@"gettb" paras:a parascontent:b];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSOperation *operation =[NSBlockOperation blockOperationWithBlock:^{
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:therequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(data)
            {
                [_data appendData:data];
            }
            if(error==nil)
            {

               
                NSString* str;
                str=[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
                NSData *myData = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
                
                //setting delegate of XML parser to self
                xmlParser.delegate = self;
                
                // Run the parser
                @try{
                    BOOL parsingResult = [xmlParser parse];
                    //   NSLog(@"parsing result = %hhd",parsingResult);
                }
                @catch (NSException* exception)
                {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Server Error" message:[exception reason] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    return;
                }
                
                
            }
        }];
        [dataTask resume];
    }];
    [operations addObject:operation];
    NSOperationQueue* _queue=[[NSOperationQueue alloc]init];
    _queue.maxConcurrentOperationCount=1;
    [_queue addOperations:operations waitUntilFinished:NO];
}

-(NSMutableURLRequest*)getrequest:(NSString *)myrequest paras:(NSArray*)a parascontent:(NSArray*)b
{

    
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<%@ xmlns=\"http://tempuri.org/\"><userid>%@</userid><roleid>%@</roleid></%@>",myrequest,userid,roleid,myrequest];//这里是参数
    NSString *webServiceStr = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body />%@</soap:Envelope>",
                               webServiceBodyStr];//webService头
    NSURL *url = [NSURL URLWithString:@"http://183.64.36.130:8090/webservice/webservice1.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [webServiceStr length]];
    
    //ad required headers to the request
    [theRequest addValue:@"183.64.36.130:8090" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"http://tempuri.org/%@",myrequest] forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [webServiceStr dataUsingEncoding:NSUTF8StringEncoding]];
     //   NSLog(@"%@",webServiceStr);
    return theRequest;

}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = elementName;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([currentElement isEqualToString:@"tbinfo1"]) {
        tbinfo1=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"tbinfo2"]) {
        tbinfo2=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"tbinfo3"]) {
        
        tbinfo3=string;
        
        //    NSLog(@"isok is %i",isok+"");
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"tbinfo"]) {
        

        //  NSLog(@"%@",[mArray description]);
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{

        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
}
-(void)checkboxClick
{
    //   NSLog(@"backbutton clicked.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
