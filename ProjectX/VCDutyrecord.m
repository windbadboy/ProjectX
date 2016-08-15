//
//  VCDutyrecord.m
//  ProjectX
//
//  Created by ted on 16/7/31.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCDutyrecord.h"

@implementation VCDutyrecord
{
    NSString *userid;
    NSString *roleid;
    NSString *isadmin;
    UIButton *checkbox;
}
-(void)viewDidAppear:(BOOL)animated
{
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
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(self.view);
         make.left.equalTo(self.view);
         make.top.equalTo(self.view).offset(64);
         make.height.equalTo(self.view);
     }];
    
}

//获取每组元素的个数(行数)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return 2;
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
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        //  [_tableView setSeparatorColor:[UIColor orangeColor]];
        
    }
    
    
    
    //set cells title
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text=@"查询值班日志";
            UIImage* dutyquery=[UIImage imageNamed:@"dutyquery"];
            cell.imageView.image=dutyquery;
                        break;
        }

        case 1:
        {
            cell.textLabel.text=@"写值班日志";
            UIImage* writelog=[UIImage imageNamed:@"writelog"];
            cell.imageView.image=writelog;
            break;
        }
        default:
            break;
    }
    return cell;
    
}

//tabview click event
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            VCdutylogquery* vcMytb=[[VCdutylogquery alloc]init];
            [self presentViewController:vcMytb animated:NO completion:nil];
        }
            break;
        case 1:
        {

        }

        default:
            break;
    }
    
}
//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)checkboxClick
{
    //   NSLog(@"backbutton clicked.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
