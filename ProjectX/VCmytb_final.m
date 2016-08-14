//
//  VCmytb_final.m
//  ProjectX
//
//  Created by ted on 16/8/13.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCmytb_final.h"

@implementation VCmytb_final
{
    NSString *userid,*roleid,*isok;
        UIButton *checkbox;
    UIButton* btnrefer;
    UILabel* mystatus;
}
@synthesize currentElement;

-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *roleid2=[NSUserDefaults standardUserDefaults];
    roleid=[roleid2 objectForKey:@"roleid"];
    NSUserDefaults *userid2=[NSUserDefaults standardUserDefaults];
    userid=[userid2 objectForKey:@"userID"];
  //  mArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect checkboxRect = CGRectMake(10, 30, 30, 20);
    // checkbox.frame=CGRectMake(10, 30, 30, 20);
    [checkbox setFrame:checkboxRect];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel* mytitle=[[UILabel alloc]init];
    UILabel* myLabelcontent=[[UILabel alloc]init];
    mystatus=[[UILabel alloc]init];
     UILabel* myLabelcontent2=[[UILabel alloc]init];
    mytitle.text=[NSString stringWithFormat:@"%@",self.rolename1];
    myLabelcontent.text=[NSString stringWithFormat:@"调班人:%@  %@(%@)",self.username1,self.pbdate1,self.myweekday1];
    myLabelcontent2.text=[NSString stringWithFormat:@"被调班人:%@  %@(%@)",self.username2,self.pbdate2,self.myweekday2];
    mystatus.text=@"状态:待提交";
    btnrefer=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnrefer addTarget:self action:@selector(pressrefer) forControlEvents:UIControlEventTouchUpInside];
    [btnrefer setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:myLabelcontent];
    [self.view addSubview:myLabelcontent2];
    [self.view addSubview:checkbox];
    [self.view addSubview:btnrefer];
    [self.view addSubview:mytitle];
        [self.view addSubview:mystatus];
    [mytitle mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view.mas_centerX).offset(-32);
         make.top.equalTo(self.view).offset(40);
         make.height.equalTo(@40);
     }];
    [myLabelcontent mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view).offset(8);
         make.top.equalTo(self.view).offset(72);
         make.height.equalTo(@40);
     }];
    [myLabelcontent2 mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view).offset(8);
         make.top.equalTo(self.view).offset(110);
         make.height.equalTo(@40);
     }];
    [mystatus mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(@180);
         make.left.equalTo(self.view).offset(8);
         make.top.equalTo(self.view).offset(158);
         make.height.equalTo(@40);
     }];
    [btnrefer mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(@40);
         make.right.equalTo(self.view).offset(-16);
         make.top.equalTo(self.view).offset(198);
         make.height.equalTo(@40);
     }];

    
}
-(void)justdoit
{
    _data=[[NSMutableData alloc] init];
    
    NSMutableArray *operations=[NSMutableArray array];
    NSArray *a=[NSArray arrayWithObjects:@"userid1",@"roleid",@"pbdate1",@"userid2",@"pbdate2",@"jlzt",nil];
    NSArray *b=[NSArray arrayWithObjects:userid,roleid,self.pbdate1,self.userid2,self.pbdate2,@"1",nil];
    
    
    NSMutableURLRequest *therequest=[self getrequest:@"settb" paras:a parascontent:b];
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
                                   @"<%@ xmlns=\"http://tempuri.org/\"><userid1>%@</userid1><roleid>%@</roleid><pbdate1>%@</pbdate1><userid2>%@</userid2><pbdate2>%@</pbdate2><jlzt>%@</jlzt></%@>",myrequest,[b objectAtIndex:0],[b objectAtIndex:1],[b objectAtIndex:2],[b objectAtIndex:3],[b objectAtIndex:4],[b objectAtIndex:5],myrequest];//这里是参数
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
    string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([currentElement isEqualToString:@"isok"]) {
        
        isok=string;
        
            NSLog(@"isok is %@",isok);
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{

        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];

    
    
}

-(void)updateUI
{
    NSLog(@"updateui isok is %@",isok);
if([isok isEqualToString:@"yes"])
{
    NSString *logintips=[NSString stringWithFormat:@"提交成功"];
    
    UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert1 show];
    btnrefer.hidden=YES;
 //   NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；
    
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
//    NSDateComponents *d = [cal components:unitFlags fromDate:date];
    
 //   mystatus.text=[NSString stringWithFormat:@"已提交(提交人:%@[%@-%@-%@])",self.username1,[d year]];
    mystatus.text=[NSString stringWithFormat:@"状态:等待被调班人同意"];
    [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        //[self dismissViewControllerAnimated:YES completion:nil];
    
}
    else
    {
            NSString *logintips=[NSString stringWithFormat:@"提交失败"];
        UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert1 show];
    }
    
}

-(void)pressrefer
{
    NSString *logintips=[NSString stringWithFormat:@"确认提交吗?"];
    
    UIAlertView* alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:logintips delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确认提交" ,nil];
    [alert1 show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//buttonindex: 0代表取消,1代表确认
    if(buttonIndex==1)
    {
       // NSLog(@"did");
        [self justdoit];
    }
}
-(void)checkboxClick
{
    //   NSLog(@"backbutton clicked.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
