//
//  VCmytb_second.m
//  ProjectX
//
//  Created by ted on 16/8/13.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCmytb_second.h"

@implementation VCmytb_second
{
    NSString *userid,*userid2;
    NSString *roleid,*roleid2;
    NSString *pbdate2,*username2,*rolename2,*myweekday2;
    NSMutableArray *mArray;
    UIButton *checkbox;
}
@synthesize currentElement;

-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *roleid2=[NSUserDefaults standardUserDefaults];
    roleid=[roleid2 objectForKey:@"roleid"];
    NSUserDefaults *userid2=[NSUserDefaults standardUserDefaults];
    userid=[userid2 objectForKey:@"userID"];
    mArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    [self justdoit];
    
}
-(void)justdoit
{
    _data=[[NSMutableData alloc] init];
    
    NSMutableArray *operations=[NSMutableArray array];
    NSArray *a=[NSArray arrayWithObjects:@"userid",@"roleid",nil];
    NSArray *b=[NSArray arrayWithObjects:userid,roleid, nil];
    
    
    NSMutableURLRequest *therequest=[self getrequest:@"getrunningpbktwomonth" paras:a parascontent:b];
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
  //  NSLog(@"%@",webServiceStr);
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
    if ([currentElement isEqualToString:@"pbdate"]) {
        
        pbdate2=string;
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"username"]) {
        username2=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"rolename"]) {
        rolename2=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"myweekday"]) {
        myweekday2=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"roleid"]) {
        roleid2=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
    if ([currentElement isEqualToString:@"userid"]) {
        userid2=string;
        
        
        //    NSLog(@"isok is %i",isok+"");
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //  NSLog(@"Parsed Element : %@", currentElement);
    if ([elementName isEqualToString:@"mypbinfo"]) {
        
        
        
        //    NSLog(@"isok is %i",isok+"");
        
        mydutyinfo *dutyinfo=[[mydutyinfo alloc]init];
        dutyinfo.myuserid=userid2;
        dutyinfo.myusername=username2;
        dutyinfo.myrolename=rolename2;
        dutyinfo.myweekday=myweekday2;
        dutyinfo.mypbdate=pbdate2;
        dutyinfo.myroleid=roleid2;
        [mArray addObject:dutyinfo];
        
        //  NSLog(@"%@",[mArray description]);
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
    
    //    NSLog(@"%@",username);
    
    
}

-(void)updateUI
{
    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(10, 30, 30, 20);
    // checkbox.frame=CGRectMake(10, 30, 30, 20);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView=[[UITableView alloc] init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    UILabel* myLabelcontent=[[UILabel alloc]init];
    myLabelcontent.text=[NSString stringWithFormat:@"已选择:%@(%@)  %@(%@)",self.username,self.rolename,self.pbdate,self.myweekday];
    [self.view addSubview:myLabelcontent];
    [self.view addSubview:_tableView];
    [self.view addSubview:checkbox];
    [myLabelcontent mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view);
         make.top.equalTo(self.view).offset(32);
         make.height.equalTo(@80);
     }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view);
         make.top.equalTo(self.view).offset(96);
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
    UITableViewCell* cell=[_tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
    }
    
    mydutyinfo *dutyinfo=[[mydutyinfo alloc]init];
    // NSLog(@"%@",[mArray count]);
    dutyinfo=[mArray objectAtIndex:indexPath.row];
    NSString* str=[NSString stringWithFormat:@"%@  %@   %@",dutyinfo.myusername,dutyinfo.myweekday,dutyinfo.mypbdate];
    cell.textLabel.text=str;
    //子标题
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",dutyinfo.myrolename];
    //图片
    //   NSString* str1=[NSString stringWithFormat:@"tabitem.png"];
    //   UIImage* image=[UIImage imageNamed:str1];
    //   UIImageView *iView=[[UIImageView alloc] initWithImage:image];
    //  cell.imageView.image=image;
    // NSLog(@"%@",mArray[0]);
    return cell;
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    mydutyinfo *dutyinfo=[[mydutyinfo alloc]init];
    dutyinfo=[mArray objectAtIndex:indexPath.row];
    VCmytb_final* mytbfinal=[[VCmytb_final alloc]init];
    mytbfinal.username2=dutyinfo.myusername;
    mytbfinal.pbdate2=dutyinfo.mypbdate;
    mytbfinal.rolename2=dutyinfo.myrolename;
    mytbfinal.myweekday2=dutyinfo.myweekday;
    mytbfinal.userid2=dutyinfo.myuserid;
    mytbfinal.roleid2=dutyinfo.myroleid;
    mytbfinal.username1=self.username;
    mytbfinal.pbdate1=self.pbdate;
    mytbfinal.myweekday1=self.myweekday;
    mytbfinal.rolename1=self.rolename;
    [self presentViewController:mytbfinal animated:NO completion:nil];
    
    
}
//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

//标题
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//return @"选择调班日期";
//}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 80)];
    UILabel* mytitle=[[UILabel alloc]init];
    mytitle.text=@"选择被调班人";
    mytitle.textColor=[UIColor redColor];
    [customView addSubview:mytitle];
    [mytitle mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(customView);
         make.left.equalTo(customView.mas_centerX).offset(-50);
         make.top.equalTo(customView);
         make.height.equalTo(customView);
     }];
    return customView;
}
-(void)checkboxClick
{
    //   NSLog(@"backbutton clicked.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
