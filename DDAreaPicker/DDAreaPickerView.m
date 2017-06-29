//
//  DDAreaPickerView.m
//  AreaPicker
//
//  Created by SuperDanny on 15/11/10.
//  Copyright © 2015年 SuperDanny. All rights reserved.
//

#import "DDAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface DDAreaPickerView () {
    NSArray *provinces, *cities, *areas;
    UIView *bgView;
}

@end

@implementation DDAreaPickerView

@synthesize delegate    = _delegate;
@synthesize datasource  = _datasource;
@synthesize pickerStyle = _pickerStyle;
@synthesize locate      = _locate;

- (void)dealloc {
    self.datasource = nil;
    self.delegate = nil;
}

- (DDLocation *)locate {
    if (_locate == nil) {
        _locate = [[DDLocation alloc] init];
    }
    
    return _locate;
}

- (id)initWithStyle:(DDAreaPickerStyle)pickerStyle withDelegate:(id <DDAreaPickerDelegate>)delegate andDatasource:(id <DDAreaPickerDatasource>)datasource {
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"DDAreaPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate                = delegate;
        self.pickerStyle             = pickerStyle;
        self.datasource              = datasource;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate   = self;
        
        provinces = [self.datasource areaPickerData:self];
        cities = provinces[0][@"sub"];
        
        self.locate.state = provinces[0][@"name"];
        self.locate.zipCode = cities[0][@"zipcode"];
        
        if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
            self.locate.city = cities[0][@"name"];
            
            areas = cities[0][@"sub"];
            if (areas.count > 0) {
                self.locate.district = areas[0];
            } else {
                self.locate.district = @"";
            }
            
        } else {
            self.locate.city = cities[0][@"name"];
        }
    }
    
    return self;
    
}

#pragma mark - PickerView lifecycle
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
                return [areas count];
                break;
            }
        default:
            return 0;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    CGFloat componentWidth = 0.0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
        if (component == 0) {
            componentWidth = width/3.0; // 第1个组键的宽度
        }
        else if (component == 1) {
            componentWidth = width/3.0; // 第2个组键的宽度
        }
        else {
            componentWidth = width/3.0; // 第3个组键的宽度
        }
    } else {
        if (component == 0) {
            componentWidth = width/2.0; // 第1个组键的宽度
        }
        else {
            componentWidth = width/2.0; // 第2个组键的宽度
        }
    }
    return componentWidth;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *myView = nil;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    //是否是两列
    BOOL haveTwoComponent = (self.pickerStyle == DDAreaPickerWithStateAndCity);
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, haveTwoComponent ? width/2.0 : width/3.0, 35)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [NSString stringWithFormat:@"%@", provinces[row][@"name"]];
        
        myView.font = [UIFont systemFontOfSize:haveTwoComponent ? 16 : 14];         //用label来设置字体大小
        
//        myView.backgroundColor = [UIColor yellowColor];
        
    }
    else if (component == 1) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, haveTwoComponent ? width/2.0 : width/3.0, 35)];
        
        myView.text = [NSString stringWithFormat:@"%@", cities[row][@"name"]];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont systemFontOfSize:haveTwoComponent ? 16 : 14];
        
//        myView.backgroundColor = [UIColor orangeColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width/3.0, 35)];
        
        myView.text = [NSString stringWithFormat:@"%@", areas[row]];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont systemFontOfSize:14];
        
//        myView.backgroundColor = [UIColor lightGrayColor];
    }
    
    return myView;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                return provinces[row][@"name"];
                break;
            case 1:
                return cities[row][@"name"];
                break;
            case 2:
                if ([areas count] > 0) {
                    return areas[row];
                    break;
                }
            default:
                return  @"";
                break;
        }
    } else {
        switch (component) {
            case 0:
                return provinces[row][@"name"];
                break;
            case 1:
                return cities[row][@"name"];
                break;
            default:
                return @"";
                break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                cities = provinces[row][@"sub"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                areas = cities[0][@"sub"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.state = provinces[row][@"name"];
                self.locate.city = cities[0][@"name"];
                self.locate.zipCode = cities[0][@"zipcode"];
                if ([areas count] > 0) {
                    self.locate.district = areas[0];
                } else {
                    self.locate.district = @"";
                }
                break;
            case 1:
                areas = cities[row][@"sub"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = cities[row][@"name"];
                self.locate.zipCode = cities[row][@"zipcode"];
                if ([areas count] > 0) {
                    self.locate.district = areas[0];
                } else {
                    self.locate.district = @"";
                }
                break;
            case 2:
                if ([areas count] > 0) {
                    self.locate.district = areas[row];
                } else{
                    self.locate.district = @"";
                }
                break;
            default:
                break;
        }
    } else {
        switch (component) {
            case 0:
                cities = provinces[row][@"sub"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = provinces[row][@"name"];
                self.locate.city = cities[0][@"name"];
                self.locate.zipCode = cities[0][@"zipcode"];
                break;
            case 1:
                self.locate.city = cities[row][@"name"];
                self.locate.zipCode = cities[row][@"zipcode"];
                break;
            default:
                break;
        }
    }
    
//    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
//        [self.delegate pickerDidChaneStatus:self];
//    }
}

#pragma mark - animation

- (void)showInView:(UIView *)view {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.337];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker)]];
    [bgView addSubview:self];
    [view addSubview:bgView];
    
    self.frame = CGRectMake(0, view.frame.size.height, screenWidth, self.frame.size.height);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.frame = CGRectMake(0, view.frame.size.height - weakSelf.frame.size.height, screenWidth, weakSelf.frame.size.height);
    } completion:^(BOOL finished) {
//        if([weakSelf.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
//            [weakSelf.delegate pickerDidChaneStatus:weakSelf];
//        }
    }];
}

- (IBAction)selectArea {
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
    [self cancelPicker];
}

- (IBAction)cancelPicker {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         weakSelf.frame = CGRectMake(0, weakSelf.frame.origin.y+weakSelf.frame.size.height, screenWidth, weakSelf.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [weakSelf removeFromSuperview];
                         [bgView removeFromSuperview];
                     }];
}

@end
