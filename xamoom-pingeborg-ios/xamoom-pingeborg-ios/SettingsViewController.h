//
//  SettingsViewController.h
//  
//
//  Created by Raphael Seher on 19.03.15.
//
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (nonatomic, strong) NSArray *locations;

@end
