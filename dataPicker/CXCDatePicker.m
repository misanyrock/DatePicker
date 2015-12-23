//
//  CXCDatePicker.m
//  dataPicker
//
//  Created by misanyrock on 15/12/17.
//  Copyright © 2015年 misanyrock.CE. All rights reserved.
//

#import "CXCDatePicker.h"


#define MONTH ( 1 )
#define YEAR ( 0 )

#define LABEL_TAG 43

@interface CXCDatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;
@property (nonatomic,copy) NSArray *englishMonths;
@property (nonatomic,copy) NSMutableArray *englishYears;

- (NSArray *)nameOfYears;
- (NSArray *)nameOfMonths;
- (CGFloat)componentWidth;

- (UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected;
- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSIndexPath *)todayPath;
- (NSInteger)bigRowMonthCount;
- (NSInteger)bigRowYearCount;
- (NSString *)currentMonthName;
- (NSString *)currentYearName;

@end
@implementation CXCDatePicker

const NSInteger bigRowCount = 1000;
const NSInteger minYear = 2008;
const NSInteger maxYear = 2030;
const CGFloat rowHeight = 44.f;
const NSInteger numberOfComponents = 2;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.months = [self nameOfMonths];
        self.years = [self nameOfYears];
        self.todayIndexPath = [self todayPath];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self selectToday];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.months = [self nameOfMonths];
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self selectToday];
}

- (NSString *)date
{
    NSInteger monthCount = [self.months count];
    NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
    
    NSInteger yearCount = [self.years count];
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
    
    NSString *date = [NSString stringWithFormat:@"%@%@",year,month];
    return date;
}

#pragma mark - UIPickerViewDelegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView
           viewForRow: (NSInteger)row
         forComponent: (NSInteger)component
          reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == MONTH)
    {
        NSInteger monthCount = [self.englishMonths count];
        NSString *monthName = [self.englishMonths objectAtIndex:(row % monthCount)];
        NSString *currentMonthName = [self currentMonthName];
        if([monthName isEqualToString:currentMonthName] == YES)
        {
            selected = YES;
        }
    }
    else
    {
        NSInteger yearCount = [self.englishYears count];
        NSString *yearName = [self.englishYears objectAtIndex:(row % yearCount)];
        NSString *currenrYearName  = [self currentYearName];
        if([yearName isEqualToString:currenrYearName] == YES)
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent: component selected: selected];
    }
    
    returnView.textColor = selected ? [UIColor blueColor] : [UIColor blackColor];
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return rowHeight;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        return [self bigRowMonthCount];
    }
    return [self bigRowYearCount];
}

#pragma mark - Util
-(NSInteger)bigRowMonthCount
{
    return [self.months count]  * bigRowCount;
}

-(NSInteger)bigRowYearCount
{
    return [self.years count]  * bigRowCount;
}

-(CGFloat)componentWidth
{
    return 100;
    // return self.bounds.size.width / numberOfComponents;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        NSInteger monthCount = [self.months count];
        return [self.months objectAtIndex:(row % monthCount)];
    }
    NSInteger yearCount = [self.years count];
    return [self.years objectAtIndex:(row % yearCount)];
}

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected
{
    CGRect frame = CGRectMake(0.f, 0.f, [self componentWidth],rowHeight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = selected ? [UIColor blueColor] : [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:18.f];
    label.userInteractionEnabled = NO;
    
    label.tag = LABEL_TAG;
    
    return label;
}

-(NSArray *)nameOfMonths
{
    return @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
}

-(NSArray *)nameOfYears
{
    NSMutableArray *years = [NSMutableArray array];
    
    for(NSInteger year = minYear; year <= maxYear; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年", year];
        [years addObject:yearStr];
    }
    return years;
}

- (void)selectToday
{
    [self selectRow: self.todayIndexPath.row
        inComponent: MONTH
           animated: NO];
    
    [self selectRow: self.todayIndexPath.section
        inComponent: YEAR
           animated: NO];
}

-(NSIndexPath *)todayPath // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *year  = [self currentYearName];
    
    //set table on the middle
    for(NSString *cellMonth in self.englishMonths)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.englishMonths indexOfObject:cellMonth];
            row = row + [self bigRowMonthCount] / 2;
            break;
        }
    }
    
    for(NSString *cellYear in self.englishYears)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.englishYears indexOfObject:cellYear];
            section = section + [self bigRowYearCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}
- (NSArray *)englishMonths{
    if (_englishMonths == nil) {
         NSDateFormatter *dateFormatter = [NSDateFormatter new];
        _englishMonths = [dateFormatter standaloneMonthSymbols];
    }
    return _englishMonths;
}
- (NSMutableArray *)englishYears{
    if (_englishYears == nil) {
        _englishYears = [NSMutableArray array];
        for(NSInteger year = minYear; year <= maxYear; year++)
        {
            NSString *yearStr = [NSString stringWithFormat:@"%ld", year];
            [_englishYears addObject:yearStr];
        }
    }
      return _englishYears;
}
@end
