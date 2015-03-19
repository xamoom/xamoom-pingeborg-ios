//
//  SettingsViewController.m
//  
//
//  Created by Raphael Seher on 19.03.15.
//
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize locations;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locations = [[NSArray alloc] initWithObjects:@"Klagenfurt",@"Villach", @"Wien", @"Graz", nil];
    
    //get and set the saved location
    NSInteger savedRow = [[NSUserDefaults standardUserDefaults] integerForKey:@"location"];
    [self.locationPicker selectRow:savedRow inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 4;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [locations objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    //save picked value to userDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:row
                      forKey:@"location"];
    [userDefaults synchronize];
}

-(void)viewDidAppear:(BOOL)animated {
    self.parentViewController.navigationItem.title = @"Settings";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
