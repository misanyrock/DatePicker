//
//  ViewController.m
//  dataPicker
//
//  Created by misanyrock on 15/12/16.
//  Copyright © 2015年 misanyrock.CE. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "CXCDatePicker.h"

@interface ViewController ()

@property (nonatomic,weak) UITextField *textField;

@property (nonatomic,weak) CXCDatePicker *datePicker;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextField *textField = [[UITextField alloc] init];
    [self.view addSubview:textField];
    self.textField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@30);
    }];
    textField.backgroundColor = [UIColor colorWithRed:1.000 green:0.513 blue:0.816 alpha:1.000];
    
    CXCDatePicker *datepicker = [[CXCDatePicker alloc] init];
    
    self.datePicker = datepicker;
  
    textField.inputView = datepicker;
    textField.inputAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
   
    
    UIBarButtonItem *prevButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(ShowPrevious)];
    
    UIBarButtonItem *selectedTodayItem = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(chooseToday)];
    
    UIBarButtonItem *hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘" style:UIBarButtonItemStylePlain target:self action:@selector(HiddenKeyBoard)];
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    accessoryView.barStyle = UIBarStyleDefault;
    
    accessoryView.items = [NSArray arrayWithObjects:prevButtonItem,selectedTodayItem,spaceButtonItem,hiddenButtonItem,nil];
    
    textField.inputAccessoryView = accessoryView;
}

- (void)ShowPrevious{
    self.textField.text = [self.datePicker date];
}

- (void)chooseToday{
    [self.datePicker selectToday];
}

- (void)HiddenKeyBoard{
    [self.textField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
