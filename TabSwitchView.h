//
//  TabSwitchView.h
//
//  Created by Eyal Flato on 10/3/13.
//  Copyright (c) 2013 Eyal Flato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@class  TabSwitchView;

@protocol TabSwitchViewDelegate <NSObject>

@optional
-(void) tabSwithcViewCloseRequested:(TabSwitchView*)tabSwitchView;
-(void) tabSwithcView:(TabSwitchView*)tabSwitchView itemSelected:(int)selectedItem;

-(UIImage*) tabSwithcView:(TabSwitchView *)tabSwitchView completeImageForItem:(int)itemIdnex;
@end

@interface TabSwitchView : UIView<UITableViewDataSource, UITableViewDelegate/*, CDCircleDataSource, CDCircleDelegate*/>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) CMMotionManager *motionManager;
@property (nonatomic, assign) id<TabSwitchViewDelegate> delegate;

-(void) loadItems:(NSArray*)items;

-(void) listenToMotion:(BOOL)listen;
-(void) scrollToItem:(int)itemIndex;
@end

@interface TabSwitchItem : NSObject

@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) UIImage *fullImage;
@property (nonatomic, retain) NSString *title;

@end
