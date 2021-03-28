#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface SNZPPTimeIntervalPickerCell : PSTableCell <UIPickerViewDataSource, UIPickerViewDelegate>
@end

@interface UIView (Private)
-(UIViewController *)_viewControllerForAncestor;
@end

@interface PSSpecifier (Private)
-(void)performSetterWithValue:(id)value;
-(id)performGetter;
@end