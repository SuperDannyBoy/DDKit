//
//  DDAreaPickerView.h
//  AreaPicker
//
//  Created by SuperDanny on 15/11/10.
//  Copyright © 2015年 SuperDanny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDLocation.h"

typedef enum {
    DDAreaPickerWithStateAndCity,
    DDAreaPickerWithStateAndCityAndDistrict
} DDAreaPickerStyle;

@class DDAreaPickerView;

@protocol DDAreaPickerDatasource <NSObject>

- (NSArray *)areaPickerData:(DDAreaPickerView *)picker;

@end

@protocol DDAreaPickerDelegate <NSObject>

@optional
- (void)pickerDidChaneStatus:(DDAreaPickerView *)picker;

@end

@interface DDAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <DDAreaPickerDelegate> delegate;
@property (assign, nonatomic) id <DDAreaPickerDatasource> datasource;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) DDLocation *locate;
@property (nonatomic) DDAreaPickerStyle pickerStyle;

- (id)initWithStyle:(DDAreaPickerStyle)pickerStyle withDelegate:(id <DDAreaPickerDelegate>)delegate andDatasource:(id <DDAreaPickerDatasource>)datasource;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
