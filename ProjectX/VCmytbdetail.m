//
//  VCmytbdetail.m
//  ProjectX
//
//  Created by ted on 16/8/14.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCmytbdetail.h"

@implementation VCmytbdetail
{
    NSString *userid,*roleid,*username1,*username2,*pbdate1,*pbdate2,*adjustxh,*jlztname,*jlzt,*czrq,*czyname,*isok,*tempadjust,*tempadjust2;
    UIButton *checkbox;
    NSMutableArray *mArray;
    int isfirst;
    NSString* mywhichone;//which menu
}
@synthesize currentElement;
-(void)viewDidAppear:(BOOL)animated
{
    
    isfirst=0;
    NSUserDefaults *roleid2=[NSUserDefaults standardUserDefaults];
    roleid=[roleid2 objectForKey:@"roleid"];
    NSUserDefaults *userid2=[NSUserDefaults standardUserDefaults];
    userid=[userid2 objectForKey:@"userID"];
    self.view.backgroundColor=[UIColor whiteColor];
    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(10, 30, 30, 20);
    // checkbox.frame=CGRectMake(10, 30, 30, 20);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkbox];
        mArray=[[NSMutableArray alloc]init];
    [self justdoit];

}

-(void)justdoit
{
    _data=[[NSMutableData alloc] init];
    
    NSMutableArray *operations=[NSMutableArray array];
    NSArray *a=[NSArray arrayWithObjects:@"roleid",@"userid",@"tbd",nil];
    NSArray *b=[NSArray arrayWithObjects:roleid,userid,self.whichone,nil];
    
    
    NSMutableURLRequest *therequest=[self getrequest:@"gettbdetail" paras:a parascontent:b];
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
                                   @"<%@ xmlns=\"http://tempuri.org/\"><roleid>%@</roleid><userid>%@</userid><tbd>%@</tbd></%@>",myrequest,[b objectAtIndex:0],[b objectAtIndex:1],[b objectAtIndex:2],myrequest];//这里是参数
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
    if ([currentElement isEqualToString:@"username1"]) {
        
        username1=string;

    }
    if ([currentElement isEqualToString:@"username2"]) {
        
        username2=string;
        
    }
    if ([currentElement isEqualToString:@"pbdate1"]) {
        
        pbdate1=string;
        
    }
    if ([currentElement isEqualToString:@"pbdate2"]) {
        
        pbdate2=string;
        
    }
    if ([currentElement isEqualToString:@"adjustxh"]) {
        
        adjustxh=string;
        
    }
    if ([currentElement isEqualToString:@"jlztname"]) {
        
        jlztname=string;
        
    }
    if ([currentElement isEqualToString:@"jlzt"]) {
        
        jlzt=string;
        
    }
    if ([currentElement isEqualToString:@"czrq"]) {
        
        czrq=string;
        
    }
    if ([currentElement isEqualToString:@"czyname"]) {
        
        czyname=string;
        
    }
    if ([currentElement isEqualToString:@"isok"]) {
        
        isok=string;
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"tbinfodetail"]) {
        
        //*username1,*username2,*pbdate1,*pbdate2,*adjustxh,*jlztname,*jlzt,*czrq,*czyname;
        

        
        tbdetailinfo *dutyinfo=[[tbdetailinfo alloc]init];
        dutyinfo.username1=username1;
        dutyinfo.username2=username2;
        dutyinfo.pbdate1=pbdate1;
        dutyinfo.pbdate2=pbdate2;
        dutyinfo.adjustxh=adjustxh;
        dutyinfo.jlztname=jlztname;
        dutyinfo.jlzt=jlzt;
        dutyinfo.czrq=czrq;
        dutyinfo.czyname=czyname;
        if(dutyinfo.adjustxh.length>0)
        {
        [mArray addObject:dutyinfo];
        }

        
    }
    else if ([elementName isEqualToString:@"pwok"]) {

        }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{

    if(isfirst==0)
    {
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
        isfirst=1;
    }
    else
    {
     [self performSelectorOnMainThread:@selector(updatecell) withObject:nil waitUntilDone:YES];
    }


    
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    isok=[[NSString alloc]init];
    switch ([alertView tag]) {
        case 1:
        {
            if(buttonIndex==0)
            {
                    //  NSLog(@"%i,%i",buttonIndex,[alertView tag]);
                [self justdoit];
            }
        }
            break;
            
        case 2:
        {
            if(buttonIndex==1)
            {
                               //       NSLog(@"%i,%i",buttonIndex,[alertView tag]);
                mArray=[[NSMutableArray alloc]init];
                [self justdoit2:@"6" mybtn:tempadjust];
            }
        }
            break;
        case 3:
        {
            if(buttonIndex==1)
            {
                //       NSLog(@"%i,%i",buttonIndex,[alertView tag]);
                mArray=[[NSMutableArray alloc]init];
                [self justdoit2:@"2" mybtn:tempadjust];
            }
        }
            break;
        case 4:
        {
            if(buttonIndex==1)
            {
                //       NSLog(@"%i,%i",buttonIndex,[alertView tag]);
                mArray=[[NSMutableArray alloc]init];
                [self justdoit2:@"4" mybtn:tempadjust];
            }
        }
            break;
        case 5:
        {
            if(buttonIndex==1)
            {
                //       NSLog(@"%i,%i",buttonIndex,[alertView tag]);
                mArray=[[NSMutableArray alloc]init];
                [self justdoit2:@"3" mybtn:tempadjust];
            }
        }
            break;
        case 6:
        {
            if(buttonIndex==1)
            {
                //       NSLog(@"%i,%i",buttonIndex,[alertView tag]);
                mArray=[[NSMutableArray alloc]init];
                [self justdoit2:@"5" mybtn:tempadjust];
            }
        }
            break;
        default:
            break;
            
    }

}
-(void)updatecell
{
    if([isok isEqualToString:@"yes"])
    {
        NSString *logintips=[NSString stringWithFormat:@"操作成功"];
        UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert1 setTag:1];  //tips
        [alert1 show];
    }
    else
    {

        [_tableView reloadData];
    }
}
-(void)updateUI
{

       // NSLog(@"refresh?  %@",isok);
    _tableView=[[UITableView alloc] init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view);
         make.top.equalTo(self.view).offset(96);
         make.height.equalTo(self.view);
     }];
     //   [_tableView deleteSections:0 withRowAnimation:UITableViewRowAnimationLeft];
       // [_tableView reloadData];

        
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return [mArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回组数,最终行数:组数*行数

    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    

    NSString* cellStr=@"cell";
   // NSLog(@"marray is %i",[mArray count]);
    if([mArray count]==0)
    {
        UITableViewCell* cell=[_tableView dequeueReusableCellWithIdentifier:cellStr];
        if(cell==nil)
        {
            
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.textLabel.text=@"没有数据.";
        return cell;
    }
    else
    {
    TVtbdetail* cell=[_tableView dequeueReusableCellWithIdentifier:cellStr];

    if(cell==nil)
    {

        cell=[[TVtbdetail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }

    tbdetailinfo *dutyinfo=[[tbdetailinfo alloc]init];
    
    dutyinfo=[mArray objectAtIndex:indexPath.row];
    //    NSLog(@"%i,%i",indexPath.section, indexPath.row);
        [cell settbr:[NSString stringWithFormat:@"调班人:%@(%@)",dutyinfo.username1,dutyinfo.pbdate1] setbtbr:[NSString stringWithFormat:@"被调班人:%@(%@)",dutyinfo.username2,dutyinfo.pbdate2] setstatus:[NSString stringWithFormat:@"状态:%@(%@ %@)",dutyinfo.jlztname,dutyinfo.czyname,dutyinfo.czrq] setjlzt:[dutyinfo.jlzt intValue] setadjustxh:[NSString stringWithFormat:@"%@",dutyinfo.adjustxh] setczyh:[NSString stringWithFormat:@"%@",userid] setadjuststatus:[NSString stringWithFormat:@"%@",dutyinfo.jlzt] setroleid:[NSString stringWithFormat:@"%@",roleid] setwhichone:[NSString stringWithFormat:@"%@",self.whichone]];
        int i=[dutyinfo.jlzt intValue];
   // NSLog(@"%@",dutyinfo.jlztname);
        // according to jlzt to decide button.
    switch ([self.whichone intValue]) {
        case 1:
        {
            if(i==1)
            {
              UIButton* mybtn1=[cell getbtn1];
            mybtn1.tag=[dutyinfo.adjustxh intValue];
           // NSLog(@"adjustxh is %@,%i",dutyinfo.adjustxh,mybtn1.tag);
            [mybtn1 addTarget:self action:@selector(zuofei:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        case 2:
        {
            if(i==1)
            {
            UIButton* mybtn1=[cell getbtn1];
            UIButton* mybtn2=[cell getbtn2];
            mybtn1.tag=[dutyinfo.adjustxh intValue];
            mybtn2.tag=[dutyinfo.adjustxh intValue];
            // NSLog(@"adjustxh is %@,%i",dutyinfo.adjustxh,mybtn1.tag);
            [mybtn1 addTarget:self action:@selector(agree:) forControlEvents:UIControlEventTouchUpInside];
            [mybtn2 addTarget:self action:@selector(deny:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        case 3:
        {
            if(i==2)
            {
                UIButton* mybtn1=[cell getbtn1];
                UIButton* mybtn2=[cell getbtn2];
                mybtn1.tag=[dutyinfo.adjustxh intValue];
                mybtn2.tag=[dutyinfo.adjustxh intValue];
                // NSLog(@"adjustxh is %@,%i",dutyinfo.adjustxh,mybtn1.tag);
                [mybtn1 addTarget:self action:@selector(agreexb:) forControlEvents:UIControlEventTouchUpInside];
                [mybtn2 addTarget:self action:@selector(denyxb:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        default:
            break;
    }


    return cell;
    }
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    mydutyinfo *dutyinfo=[[mydutyinfo alloc]init];
//    dutyinfo=[mArray objectAtIndex:indexPath.row];
//    VCmytb_final* mytbfinal=[[VCmytb_final alloc]init];
//    mytbfinal.username2=dutyinfo.myusername;
//    mytbfinal.pbdate2=dutyinfo.mypbdate;
//    mytbfinal.rolename2=dutyinfo.myrolename;
//    mytbfinal.myweekday2=dutyinfo.myweekday;
//    mytbfinal.userid2=dutyinfo.myuserid;
//    mytbfinal.roleid2=dutyinfo.myroleid;
//    mytbfinal.username1=self.username;
//    mytbfinal.pbdate1=self.pbdate;
//    mytbfinal.myweekday1=self.myweekday;
//    mytbfinal.rolename1=self.rolename;
//    [self presentViewController:mytbfinal animated:NO completion:nil];
    
    
}
//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

//标题
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch ([self.whichone intValue]) {
        case 1:
            return @"我的调班单";
            break;
        case 2:
            return @"找我的调班单";
            break;
        case 3:
            return @"需审核的调班单";
            break;
        default:
            return @"未知菜单";
            break;
    }
}
-(void)zuofei:(UIButton*)mybtn1
{
        tempadjust=[NSString stringWithFormat:@"%i",mybtn1.tag];
    NSString *logintips=[NSString stringWithFormat:@"确认提交吗?"];
    
    UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确认提交" ,nil];
    [alert1 setTag:2];    //zuofei
    [alert1 show];
    

}

-(void)agree:(UIButton*)mybtn1
{
    tempadjust=[NSString stringWithFormat:@"%i",mybtn1.tag];
    NSString *logintips=[NSString stringWithFormat:@"确认提交吗?"];
    
    UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确认提交" ,nil];
    [alert1 setTag:3];   //agree
    [alert1 show];
    
    
}
-(void)agreexb:(UIButton*)mybtn1
{
    tempadjust=[NSString stringWithFormat:@"%i",mybtn1.tag];
    NSString *logintips=[NSString stringWithFormat:@"确认提交吗?"];
    
    UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确认提交" ,nil];
    [alert1 setTag:5];   //agreexb
    [alert1 show];
    
    
}

-(void)deny:(UIButton*)mybtn2
{
    tempadjust=[NSString stringWithFormat:@"%i",mybtn2.tag];
    NSString *logintips=[NSString stringWithFormat:@"确认提交吗?"];
    
    UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确认提交" ,nil];
    [alert1 setTag:4];   //deny
    [alert1 show];
    
    
}

-(void)denyxb:(UIButton*)mybtn2
{
    tempadjust=[NSString stringWithFormat:@"%i",mybtn2.tag];
    NSString *logintips=[NSString stringWithFormat:@"确认提交吗?"];
    
    UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确认提交" ,nil];
    [alert1 setTag:6];   //denyxb
    [alert1 show];
    
    
}

-(void)justdoit2:(NSString*)whichone mybtn:(NSString*)myadjustxh2
{
    _data=[[NSMutableData alloc] init];
    
    NSMutableArray *operations=[NSMutableArray array];
 //   NSArray *a=[NSArray arrayWithObjects:@"adjustxh",@"czyh",@"adjuststatus",@"roleid",nil];
  //  NSArray *b=[NSArray arrayWithObjects:adjustxh,userid,whichone,roleid,nil];
    NSString* mycontent=[NSString stringWithFormat:@"<adjustxh>%@</adjustxh><czyh>%@</czyh><adjuststatus>%@</adjuststatus><roleid>%@</roleid>",myadjustxh2,userid,whichone,roleid];
    
    NSMutableURLRequest *therequest=[self getrequest2:@"setadjuststatus" paras:mycontent];
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

-(NSMutableURLRequest*)getrequest2:(NSString *)myrequest paras:(NSString*)mycontent
{
    
    
    NSString *webServiceBodyStr = [NSString stringWithFormat:
                                   @"<%@ xmlns=\"http://tempuri.org/\">%@</%@>",myrequest,mycontent,myrequest];//这里是参数
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
    // NSLog(@"%@",webServiceStr);
    return theRequest;
    
}
-(void)checkboxClick
{
    //   NSLog(@"backbutton clicked.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end







