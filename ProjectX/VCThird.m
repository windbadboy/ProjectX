//
//  VCThird.m
//  ProjectX
//
//  Created by ted on 16/7/11.
//  Copyright © 2016年 ted. All rights reserved.
//

#import "VCThird.h"

@implementation VCThird


-(void)viewDidAppear:(BOOL)animated
{
//        self.view.backgroundColor=[UIColor whiteColor];
//    UIPickerView* pickerView=[[UIPickerView alloc] init];
//    pickerView.frame=CGRectMake(10, 100, 300, 200);
//    pickerView.delegate=self;
//    pickerView.dataSource=self;
//    [self.view addSubview:pickerView];
    [self updateUI];
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


-(void)updateUI
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 60, 420, 536) style:UITableViewStylePlain];
    [_tableView setSeparatorColor:[UIColor orangeColor]];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
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
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellStr=@"cell";
    UITableViewCell* cell=[_tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
    }
    


    cell.textLabel.text=@"test";
    //子标题

        cell.detailTextLabel.text=@"test";
       NSString* str1=[NSString stringWithFormat:@"unfold.png"];

    //图片
    
    UIImage* image=[UIImage imageNamed:str1];
    UIImageView *iView=[[UIImageView alloc] initWithImage:image];
    cell.imageView.image=image;

    return cell;
    
}

//tabview click event
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}
//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
//标题
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
    return @"我的调班单";
    }
    else if(section==1)
        {
            return @"找我的调班单";
        }
        else if(section==2)
        {
            return @"需审核的调班单";
        }else{
    return @"我要调班";
        }
}
@end
