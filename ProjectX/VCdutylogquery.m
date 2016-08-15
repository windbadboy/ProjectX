//
//  VCdutylogquery.m
//  ProjectX
//
//  Created by ted on 16/8/15.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCdutylogquery.h"

@implementation VCdutylogquery
{
    NSString *userid;
    NSString *roleid;
    NSString *isadmin;
    UIButton *checkbox;
        NSMutableArray *mArray;
        NSString *username,*dutyroleid,*zgqk,*rwzz,*wzbr,*fwtd,*dutyuserid,*rolename,*recordcontent,*recorddate,*myweekday;
        NSMutableString *str1,*str2;
}
@synthesize currentElement;
-(void)viewDidAppear:(BOOL)animated
{
                            str1=[[NSMutableString alloc]init];

    NSUserDefaults *roleid2=[NSUserDefaults standardUserDefaults];
    roleid=[roleid2 objectForKey:@"roleid"];
    NSUserDefaults *userid2=[NSUserDefaults standardUserDefaults];
    userid=[userid2 objectForKey:@"userID"];
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView=[[UITableView alloc] init];
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
    //   NSArray *a=[NSArray arrayWithObjects:@"adjustxh",@"czyh",@"adjuststatus",@"roleid",nil];
    //  NSArray *b=[NSArray arrayWithObjects:adjustxh,userid,whichone,roleid,nil];
    NSString* mycontent=[NSString stringWithFormat:@"<userid>%@</userid><roleid>%@</roleid><justme>%@</justme>",userid,roleid,@"0"];
    
    NSMutableURLRequest *therequest=[self getrequest:@"getduty" paras:mycontent];
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

-(NSMutableURLRequest*)getrequest:(NSString *)myrequest paras:(NSString*)mycontent
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
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = elementName;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //    NSString *username,*roleid,*zgqk,*rwzz,*wzbr,*fwtd,*dutyuserid,*rolename,*recordcontent,*recorddate;
    string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([currentElement isEqualToString:@"username"]) {
        
        username=string;
        
    }
    if ([currentElement isEqualToString:@"roleid"]) {
        
        dutyroleid=string;
        
    }
    if ([currentElement isEqualToString:@"zgqk"]) {
        
        zgqk=string;
        
    }
    if ([currentElement isEqualToString:@"rwzz"]) {
        
        rwzz=string;
        
    }
    if ([currentElement isEqualToString:@"wzbr"]) {
        
        wzbr=string;
        
    }
    if ([currentElement isEqualToString:@"fwtd"]) {
        
        fwtd=string;
        
    }
    if ([currentElement isEqualToString:@"userid"]) {
        
        dutyuserid=string;
        
    }
    if ([currentElement isEqualToString:@"rolename"]) {
        
        rolename=string;
        
    }
    if ([currentElement isEqualToString:@"recordcontent"]) {
        
        [str1 appendString:string];
        
    }
    if ([currentElement isEqualToString:@"recorddate"]) {
        
        recorddate=string;
        
    }
    if ([currentElement isEqualToString:@"myweekday"]) {
        
        myweekday=string;
        
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"dutyinfo"]) {
        
        //*username1,*username2,*pbdate1,*pbdate2,*adjustxh,*jlztname,*jlzt,*czrq,*czyname;
        
        
        
        dutyloginfo *dutyinfo=[[dutyloginfo alloc]init];
        dutyinfo.username=username;
        dutyinfo.roleid=dutyroleid;
        dutyinfo.zgqk=zgqk;
        dutyinfo.rwzz=rwzz;
        dutyinfo.wzbr=wzbr;
        dutyinfo.fwtd=fwtd;
        dutyinfo.userid=dutyuserid;
        dutyinfo.rolename=rolename;
        dutyinfo.recordcontent=str1;
        dutyinfo.recorddate=recorddate;
        dutyinfo.myweekday=myweekday;
      //  NSLog(@"%@",recordcontent);
        if(dutyinfo.username.length>0)
        {
            [mArray addObject:dutyinfo];
        }
        str1=[[NSMutableString alloc]init];
        
        
    }

}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{

        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
}

-(void)updateUI
{
    _tableView=[[UITableView alloc] init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view);
         make.top.equalTo(self.view).offset(50);
         make.height.equalTo(self.view);
     }];
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
    TVdutylogcell* cell=[_tableView dequeueReusableCellWithIdentifier:cellStr];
    //    NSLog(@"hey hey");
    if(cell==nil)
    {
        cell=[[TVdutylogcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }

    dutyloginfo *dutyinfo=[[dutyloginfo alloc]init];
    // NSLog(@"%@",[mArray count]);
    dutyinfo=[mArray objectAtIndex:indexPath.row];
   // NSLog(@"%@",dutyinfo.username);
    [cell setpbdate:[NSString stringWithFormat:@"%@(%@)",dutyinfo.recorddate,dutyinfo.myweekday] setsecond:[NSString stringWithFormat:@"%值班人:%@  在岗情况:%@",dutyinfo.username,dutyinfo.zgqk] setthird:[NSString stringWithFormat:@"着装:%@  危重处理:%@",dutyinfo.rwzz,dutyinfo.wzbr] setfourth:[NSString stringWithFormat:@"服务态度:%@",dutyinfo.fwtd] setfifth:[NSString stringWithFormat:@"值班内容:%@",dutyinfo.recordcontent]];
    
    return cell;
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}
//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dutyloginfo *dutyinfo=[[dutyloginfo alloc]init];
    dutyinfo=[mArray objectAtIndex:indexPath.row];
    if(dutyinfo.recordcontent.length>60)
    {
       // NSLog(@"%i,%@",dutyinfo.recordcontent.length,dutyinfo.recordcontent);
    return 100+dutyinfo.recordcontent.length*0.85;
    }
    else
    {
        return 160;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
 return @"查询值班日志";
}

-(void)checkboxClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
