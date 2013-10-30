//
//  TBSViewController.h
//  TabSwitch
//
//  Created by Eyal Flato on 10/30/13.
//  Copyright (c) 2013 Eyal Flato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabSwitchView.h"

@interface TBSViewController : UIViewController<TabSwitchViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *numItemsLabel;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)showTabSwitchTapped:(id)sender;
- (IBAction)stepperValueChaned:(id)sender;

@end
