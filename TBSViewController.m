//
//  TBSViewController.m
//  TabSwitch
//
//  Created by Eyal Flato on 10/30/13.
//  Copyright (c) 2013 Eyal Flato. All rights reserved.
//

#import "TBSViewController.h"
#import "UIColor-Utils.h"
#import <CoreMotion/CoreMotion.h>

@interface TBSViewController ()

@property (nonatomic, strong) TabSwitchView *tabSwitchView;
@property (nonatomic, strong) CMMotionManager *motionManager;
@end

@implementation TBSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self updateLabel];
    
    self.tabSwitchView = [[TabSwitchView alloc] initWithFrame:self.view.bounds];
    self.tabSwitchView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tabSwitchView.delegate = self;
    [self.view addSubview:self.tabSwitchView];
    
    [self showTabSwitch:NO animated:NO];

     self.motionManager = [[CMMotionManager alloc] init];
    self.tabSwitchView.motionManager = self.motionManager;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTabSwitchTapped:(id)sender {
    [self showTabSwitch:YES animated:YES];
}

- (IBAction)stepperValueChaned:(id)sender {
    [self updateLabel];
}

-(void) updateLabel
{
    self.numItemsLabel.text = [NSString stringWithFormat:@"Number of items: %d", (int)self.stepper.value];
}


-(void) showTabSwitch:(BOOL)show animated:(BOOL)animated
{
    NSArray *colors = [self getColors];
    if (show)
    {
        NSMutableArray *items = [NSMutableArray array];
        for (int i = 0; i < self.stepper.value; i++)
        {
            TabSwitchItem *item = [[TabSwitchItem alloc] init];
            item.title = [NSString stringWithFormat:@"Item %d", i];
            item.backgroundColor = [colors objectAtIndex:(i % colors.count) ];
            [items addObject:item];
        }
        [self.tabSwitchView loadItems:items];
        [self.tabSwitchView listenToMotion:YES];
        [self.tabSwitchView scrollToItem:0];
        if (animated)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.tabSwitchView.frame = self.view.bounds;
            }];
           
        }
        else
        {
            self.tabSwitchView.frame = self.view.bounds;
        }
    }
    else
    {
        [self.tabSwitchView listenToMotion:NO];
        if (animated)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.tabSwitchView.frame = CGRectMake(0, self.view.bounds.size.height * -1, self.view.bounds.size.width, self.view.bounds.size.height);
            }];
            
        }
        else
        {
             self.tabSwitchView.frame = CGRectMake(0, self.view.bounds.size.height * -1, self.view.bounds.size.width, self.view.bounds.size.height);
        }
    }
}

- (NSArray*) getColors
{
    static NSArray *kTabColors = nil;
    if (kTabColors == nil)
    {
        kTabColors = [[NSArray alloc] initWithObjects:
                       [UIColor colorWithHexString:@"1badf8"],    //0
                       [UIColor colorWithHexString:@"4189ba"],
                       [UIColor colorWithHexString:@"d9b0ff"],
                       [UIColor colorWithHexString:@"7d92ff"],
                       [UIColor colorWithHexString:@"7b7fff"],
                       [UIColor colorWithHexString:@"95c6eb"],   //5
                       [UIColor colorWithHexString:@"a25cf1"],
                       [UIColor colorWithHexString:@"c039d4"],
                       [UIColor colorWithHexString:@"fb14ac"],
                       [UIColor colorWithHexString:@"a6285e"],
                       [UIColor colorWithHexString:@"ffbc47"],    //10
                       [UIColor colorWithHexString:@"ee9f06"],
                       [UIColor colorWithHexString:@"cedc35"],
                       [UIColor colorWithHexString:@"b7d02a"],
                       [UIColor colorWithHexString:@"c7be26"],
                       [UIColor colorWithHexString:@"b5b804"],   //15
                       [UIColor colorWithHexString:@"63da38"],
                       [UIColor colorWithHexString:@"47b121"],
                       [UIColor colorWithHexString:@"38da9f"],
                       [UIColor colorWithHexString:@"6dd5b9"],
                       [UIColor colorWithHexString:@"ff8787"],   //20
                       [UIColor colorWithHexString:@"ff321c"],
                       [UIColor colorWithHexString:@"d23d52"],
                       [UIColor colorWithHexString:@"c24234"],
                       [UIColor colorWithHexString:@"ff4800"],
                       [UIColor colorWithHexString:@"b09592"],   //25
                       [UIColor colorWithHexString:@"c46d39"],
                       [UIColor colorWithHexString:@"a26700"],
                       [UIColor colorWithHexString:@"d19e54"],
                       [UIColor colorWithHexString:@"efd085"],   //29
                       nil
                       ] ;
    }
    
    return kTabColors;
}

-(void) tabSwithcViewCloseRequested:(TabSwitchView*)tabSwitchView
{
    self.statusLabel.text = @"";
    [self showTabSwitch:NO animated:YES];
}

-(void) tabSwithcView:(TabSwitchView*)tabSwitchView itemSelected:(int)selectedItem
{
    self.statusLabel.text = [NSString stringWithFormat:@"Item %d selected", selectedItem];
    [self showTabSwitch:NO animated:YES];
}

-(UIImage*) tabSwithcView:(TabSwitchView *)tabSwitchView completeImageForItem:(int)itemIdnex
{
    if (itemIdnex == 5)
        return [UIImage imageNamed:@"pic.png"];
    return nil;
}

@end
