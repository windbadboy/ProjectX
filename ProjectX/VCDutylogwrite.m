//
//  VCDutylogwrite.m
//  ProjectX
//
//  Created by ted on 16/8/16.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCDutylogwrite.h"


@interface VCDutylogwrite ()

@end

@implementation VCDutylogwrite
{
        UIButton *checkbox;
    NSString *username2,*dutyroleid2,*zgqk,*rwzz,*wzbr,*fwtd,*dutyuserid2,*rolename2,*recordcontent2,*recorddate2,*myweekday2;
    NSMutableString *str1,*str2;
        NSMutableArray *mArray;
}
@synthesize roleid,userid,pbdate,isrecord,myweekday,username,rolename,currentElement;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(10, 30, 30, 20);
    // checkbox.frame=CGRectMake(10, 30, 30, 20);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkbox];
    UILabel* lblinfo=[[UILabel alloc]init];
    lblinfo.text=[NSString stringWithFormat:@"填写人:%@(%@) %@",self.username,self.pbdate,self.rolename];
    lblinfo.textColor=[UIColor redColor];
    [self.view addSubview:lblinfo];
    [lblinfo mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view);
         make.top.equalTo(self.view).offset(60);
         make.height.equalTo(@30);
     }];
  //  self.view.backgroundColor=[UIColor whiteColor];
    mArray=[[NSMutableArray alloc]init];
    str1=[[NSMutableString alloc]init];
    [self justdoit];
    
    
}

-(void)justdoit
{
    _data=[[NSMutableData alloc] init];
    
    NSMutableArray *operations=[NSMutableArray array];
    //   NSArray *a=[NSArray arrayWithObjects:@"adjustxh",@"czyh",@"adjuststatus",@"roleid",nil];
    //  NSArray *b=[NSArray arrayWithObjects:adjustxh,userid,whichone,roleid,nil];
    NSString* mycontent=[NSString stringWithFormat:@"<userid>%@</userid><roleid>%@</roleid><pbdate>%@</pbdate>",userid,roleid,self.pbdate];
    
    NSMutableURLRequest *therequest=[self getrequest:@"getdutyrecord" paras:mycontent];
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
        
        username2=string;
        
    }
    if ([currentElement isEqualToString:@"roleid"]) {
        
        dutyroleid2=string;
        
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
        
        dutyuserid2=string;
        
    }
    if ([currentElement isEqualToString:@"rolename"]) {
        
        rolename=string;
        
    }
    if ([currentElement isEqualToString:@"recordcontent"]) {
        
        [str1 appendString:string];
        
    }
    if ([currentElement isEqualToString:@"recorddate"]) {
        
        recorddate2=string;
        
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
        

       // NSLog(@"%@",rwzz);
        dutyloginfo *dutyinfo=[[dutyloginfo alloc]init];
        dutyinfo.username=username2;
        dutyinfo.roleid=dutyroleid2;
        dutyinfo.zgqk=zgqk;
        dutyinfo.rwzz=rwzz;
        dutyinfo.wzbr=wzbr;
        dutyinfo.fwtd=fwtd;
        dutyinfo.userid=dutyuserid2;
        dutyinfo.rolename=rolename2;
        dutyinfo.recordcontent=str1;
        dutyinfo.recorddate=recorddate2;
        dutyinfo.myweekday=myweekday;
        //  NSLog(@"%@",recordcontent);
        if(dutyinfo.username.length>0)
        {

            [mArray addObject:dutyinfo];

        }
        str1=[[NSMutableString alloc]init];
        
        
    }
    
}
-(void)updateUI
{
    
    
    _tableView=[[UITableView alloc] init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    self.view.backgroundColor=[UIColor whiteColor];

    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view);
         make.top.equalTo(self.view).offset(100);
         make.height.equalTo(self.view);
     }];
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回组数,最终行数:组数*行数
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellStr=@"cell";
    VCtestCell* cell=[_tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell=[[VCtestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    dutyloginfo *dutyinfo=[[dutyloginfo alloc]init];
    dutyinfo=[mArray objectAtIndex:indexPath.row];

    switch (indexPath.section) {
        case 0:
        {
            _data1 = [NSMutableArray arrayWithObjects: @"在岗", @"部分在岗", nil];
            _data2 = [NSMutableArray arrayWithObjects: @"按规定着装", @"未按规定着装", nil];
                                                NSLog(@"%@,%i",dutyinfo.zgqk,dutyinfo.rwzz);
            [cell setarray1:_data1 setarray2:_data2 setsection:indexPath.section setrow:indexPath.row setdataindex1:[dutyinfo.zgqk intValue] setdataindex2:[dutyinfo.rwzz intValue]];

        }
            break;
        case 1:
        {
            _data1 = [NSMutableArray arrayWithObjects: @"无不良反映", @"有投诉", nil];
            _data2 = [NSMutableArray arrayWithObjects: @"无特殊", @"存在问题", nil];
            [cell setarray1:_data1 setarray2:_data2 setsection:indexPath.section setrow:indexPath.row setdataindex1:[dutyinfo.wzbr intValue] setdataindex2:[dutyinfo.fwtd intValue]];
            break;
        }
        case 2:
        {
             [cell setarray1:nil setarray2:nil setsection:indexPath.section setrow:indexPath.row setdataindex1:nil setdataindex2:nil];
        }
            break;
            
        default:
            break;
    }

    
    return cell;
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}
//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"             在岗情况                              着装     ";
            break;
        case 1:
             return @"            服务态度                              危重处理";
        default:
            break;
    }
    return @"填写值班内容";
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)checkboxClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
