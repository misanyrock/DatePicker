//
//  CXCDatePicker.h
//  dataPicker
//
//  Created by misanyrock on 15/12/17.
//  Copyright © 2015年 misanyrock.CE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXCDatePicker : UIPickerView

@property (nonatomic, strong, readonly) NSString *date;

- (void)selectToday;

@end
