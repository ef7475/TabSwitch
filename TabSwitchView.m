//
//  TabSwitchView.m
//
//  Created by Eyal Flato on 10/3/13.
//  Copyright (c) 2013 Eyal Flato. All rights reserved.
//

#import "TabSwitchView.h"
#define degToRad(x) (x * M_PI / 180.0f)

@interface TabSwitchView()
{
    CGFloat ay;

}
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, assign) int selectedRow;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, retain) NSArray* items;
@property (nonatomic, retain) UIButton* closeButton;
@property (nonatomic, retain) UIImage* textureImage;
@end

@implementation TabSwitchView

-(id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.selectedRow = -1;
        self.itemHeight = 400;
        
        self.textureImage = [[UIImage imageNamed:@"Tab_texture.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor grayColor];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.contentInset = UIEdgeInsetsMake([TabSwitchView topOfScreen], 0, 0, 0);
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
        [self addSubview:self.tableView];

        
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)] ;
        self.bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self addSubview:self.bottomView];

        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.closeButton.frame = CGRectMake((self.frame.size.width - 100) / 2, 4, 100, 32);
        [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2]  forState:UIControlStateHighlighted];
        
        [self.closeButton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.closeButton];
    }
    return self;
}

-(void) listenToMotion:(BOOL)listen
{
    if (self.motionManager != nil)
    {
        if (listen)
        {
            [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                
                //NSLog(@"%.2f %.2f %.2f", accelerometerData.acceleration.x,accelerometerData.acceleration.y, accelerometerData.acceleration.z);
                ay = accelerometerData.acceleration.y;
                [self performSelectorOnMainThread:@selector(updateAngle) withObject:nil waitUntilDone:YES];
                
            } ];
        }
        else
        {
            [self.motionManager stopAccelerometerUpdates];
        }
    }
}

-(void) scrollToItem:(int)itemIndex
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

-(void) loadItems:(NSArray*)items
{
    self.items = items;
    [self.tableView reloadData];
    [self updateAngle];

    [self performSelector:@selector(loadVisibleCompleteImages) withObject:nil afterDelay:1];
}

-(void) updateAngle
{
    CGFloat sdeg = 15 * (1 - MIN(0,ay)) + 20;
    for (UITableViewCell *cell in self.tableView.visibleCells)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (indexPath.row == self.selectedRow)
        {
            //deg = sdeg - 10;
        }
        CGFloat cellY = [self convertRect:cell.frame fromView:self.tableView].origin.y;
        CGFloat degDiff = cellY / self.tableView.frame.size.height * -20.0;
        CGFloat deg = sdeg - degDiff;
        CATransform3D t = CATransform3DIdentity;
        //Setup the perspective modifying the matrix elementat [3][4]
        t.m34 = -1.0f / - 800.0f;
        
        //Perform rotate on the matrix identity
        t = CATransform3DRotate(t, degToRad(deg), 1.0f, 0.0f, 0.0f);
        
        //Perform translate on the current transform matrix (identity + rotate)
        //CGFloat yd = self.itemHeight - cosf(degToRad(deg)) * self.itemHeight / 2;
        //t = CATransform3DTranslate(t, 0.0f, -yd,  0.0);
        
        //Avoid animations
        [CATransaction setAnimationDuration:0.1];
        
        //apply the transoform on the current layer
        //cell.layer.transform = t;
        UIImageView *iv = (UIImageView*)[cell viewWithTag:987];
        if (iv != nil)
        {
            iv.layer.transform = t;
        }
        iv.frame = CGRectMake(10, 0, cell.frame.size.width-20, self.itemHeight);
        
        UIView *coverView = (UIView*)[cell viewWithTag:988];
        if (coverView != nil)
        {
            if (self.selectedRow >= 0)
            {
                if (indexPath.row == self.selectedRow)
                {
                    coverView.backgroundColor = [UIColor clearColor];
                }
                else
                {
                    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                }
            }
            else
            {
                coverView.backgroundColor = [UIColor clearColor];
            }
        }
        //cell.textLabel.text = [NSString stringWithFormat:@"%.2f, %.2f, %.2f, %.2f", iv.frame.size.width, iv.frame.size.height, coverView.frame.size.width, coverView.frame.size.height];
        //[cell bringSubviewToFront:cell.contentView];
        //cell.contentView.layer.zPosition = 1000;
    }
    
    //self.label.text = [NSString stringWithFormat:@"%f\n%d", deg, 0];
}

-(void) loadVisibleCompleteImages
{
    
    if ([self.tableView isDragging] || [self.tableView isDecelerating])
    {
        return;
    }
    for (UITableViewCell *cell in [self.tableView visibleCells])
    {
        NSIndexPath *indexPath =  [self.tableView indexPathForCell:cell];
        TabSwitchItem *tsi = [self.items objectAtIndex:indexPath.row];
        if (tsi.fullImage == nil)
        {
            if ([self.delegate respondsToSelector:@selector(tabSwithcView:completeImageForItem:)])
            {
                tsi.fullImage = [self.delegate tabSwithcView:self completeImageForItem:indexPath.row];
            }
        }
    }
    [self.tableView reloadData];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadVisibleCompleteImages];
    }
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadVisibleCompleteImages];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self notifyItemSelected:indexPath.row];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ([self tableView:tableView numberOfRowsInSection:indexPath.section] - 1))
    {
        return 170;
    }
    return 120;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.highlighted = NO;
    cell.selected = NO;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (![TabSwitchView isIosVersionAbove:@"7"])
    {
        cell.clipsToBounds = YES;
    }
   
    TabSwitchItem *tsi = [self.items objectAtIndex:indexPath.row];
    
    UIImageView *iv = (UIImageView*)[cell viewWithTag:987];
    UILabel *title = nil;
    UIView *contentBg = nil;
    if (iv == nil)
    {
        iv = [[UIImageView alloc] initWithImage:self.textureImage];
        iv.tag = 987;
        iv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        iv.frame = CGRectMake(10, 0, cell.frame.size.width-20, self.itemHeight);
        iv.layer.anchorPoint = CGPointMake(0.5, 0);
        iv.layer.cornerRadius = 7.0;
        iv.layer.masksToBounds = YES;
        iv.backgroundColor = tsi.backgroundColor;
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:iv];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(0,0, iv.frame.size.width, 30)] ;
        title.tag = 1001;
        title.font = [UIFont fontWithName:@"Helvetica" size:14];
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];//[GeneralGraphics darkColor];
        title.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        title.text = tsi.title;
        [iv addSubview:title];
        
        contentBg = [[UIView alloc] initWithFrame:CGRectMake(10, 30, iv.frame.size.width - 20, iv.frame.size.height - 60)] ;
        contentBg.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.9];
        contentBg.tag = 1002;
        contentBg.layer.cornerRadius = 7.0;
        contentBg.layer.masksToBounds = YES;
        contentBg.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [iv addSubview:contentBg];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = iv.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor], nil];
        [iv.layer insertSublayer:gradient atIndex:0];
    }
    else
    {
        title = (UILabel*)[iv viewWithTag:1001];
        contentBg = (UIView*)[iv viewWithTag:1002];
    }
    iv.frame = CGRectMake(10, 0, cell.frame.size.width-20, self.itemHeight);
    CALayer *l = [[iv.layer sublayers] objectAtIndex:0];
    l.frame = iv.bounds;
    iv.backgroundColor = tsi.backgroundColor;
    title.text = tsi.title;
    iv.image = self.textureImage;
    contentBg.hidden = NO;
    if (tsi.fullImage != nil)
    {
        iv.image = tsi.fullImage;
        contentBg.hidden = YES;
        
    }
        
    
    
    
    UIView *gradientView = (UIView*)[cell viewWithTag:989];
    if (gradientView == nil)
    {
        gradientView = [[UIView alloc] initWithFrame:cell.bounds];
        gradientView.tag = 989;
        gradientView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        gradientView.frame = iv.frame;// CGRectMake(20, cell.frame.size.height - 1,
        [cell addSubview:gradientView];
        
        
    }
    
    UIView *coverView = (UIView*)[cell viewWithTag:988];
    if (coverView == nil)
    {
        coverView = [[UIView alloc] initWithFrame:cell.bounds];
        coverView.tag = 988;
        coverView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        coverView.frame = CGRectMake(20, 0, cell.frame.size.width-40, self.itemHeight);
        coverView.backgroundColor = [UIColor clearColor];
        [cell addSubview:coverView];
    }

    gradientView.layer.zPosition = iv.layer.zPosition + 240;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateAngle];
}

-(void) closeTapped:(id)sender
{
    [self notifyClose];
}

-(void) notifyClose
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tabSwithcViewCloseRequested:)])
    {
        [self.delegate tabSwithcViewCloseRequested:self];
    }
}

-(void) notifyItemSelected:(int)selectedIndex
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tabSwithcView:itemSelected:)])
    {
        [self.delegate tabSwithcView:self itemSelected:selectedIndex];
    }
}

+(BOOL) isIosVersionAbove:(NSString*) version
{
    return ([[UIDevice currentDevice].systemVersion compare:version] != NSOrderedAscending);
}

+(CGFloat) topOfScreen
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([TabSwitchView isIosVersionAbove:@"7"])
    {
        return 20;
    }
    else
    {
        return 0;
    }
#else
    return 0;
#endif
}


@end

@implementation TabSwitchItem


@end
