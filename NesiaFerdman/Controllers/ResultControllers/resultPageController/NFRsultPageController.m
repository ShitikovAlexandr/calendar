//
//  NFRsultPageController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 8/7/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//



#import "NFRsultPageController.h"
#import "NFResultDayController.h"
#import "NFResultController.h" 
#import "NFResultMonthController.h"
#import "NFSegmentedControl.h"
#import "NFStyleKit.h"
#import "NFResultInfoController.h"



@interface NFRsultPageController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) NSArray *viewControllersArray;
@property (strong, nonatomic) NFSegmentedControl *segmentedControl;
@property (strong, nonatomic) UIView *maskView;
@end

@implementation NFRsultPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    self.navigationItem.title = @"Итоги";
    self.tabBarItem.title = @"Итоги";
    [self addInfoButton];
    [self addMaskViewNavigationBar];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"День", @"Неделя", @"Месяц", nil];
    self.segmentedControl = [[NFSegmentedControl alloc] initWithItems:itemArray];
    _segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width - 30, 34);
    _segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segmentedControl];
    _segmentedControl.center = self.maskView.center;
    [_segmentedControl addTarget:self action:@selector(pressSegment:) forControlEvents:UIControlEventValueChanged];
    
    NFResultDayController *dayController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFResultDayController"];
    NFResultController *weekController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFResultController"];
    NFResultMonthController *monthController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFResultMonthController"];
    
    _viewControllersArray = [NSArray arrayWithObjects:dayController, weekController, monthController, nil];
    [self setViewControllers:@[dayController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO completion:nil];
}

#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource -

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    return _viewControllersArray[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [_viewControllersArray indexOfObject:viewController];
    // get the index of the current view controller on display
    
    if (currentIndex > 0)
    {
        return [_viewControllersArray objectAtIndex:currentIndex-1];
        
        // return the previous viewcontroller
    } else
    {
        return nil;
        // do nothing
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [_viewControllersArray indexOfObject:viewController];
    // get the index of the current view controller on display
    // check if we are at the end and decide if we need to present
    // the next viewcontroller
    
    if (currentIndex < [_viewControllersArray count]-1)
    {
        return [_viewControllersArray objectAtIndex:currentIndex+1];
        // return the next view controller
    } else
    {
        return nil;
        // do nothing
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        UIViewController *currentVC = self.viewControllers[0];
        NSUInteger currentIndex = [_viewControllersArray indexOfObject:currentVC];
        self.segmentedControl.selectedSegmentIndex = currentIndex;
    }
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark - Actions

- (IBAction)pressSegment:(NFSegmentedControl *)sender {

    
    UIViewController *currentVC = self.viewControllers[0];
    NSUInteger currentIndex = [_viewControllersArray indexOfObject:currentVC];
    if (currentIndex < self.segmentedControl.selectedSegmentIndex) {
        [self setViewControllers:@[[self.viewControllersArray objectAtIndex:sender.selectedSegmentIndex]]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES completion:nil];
    } else {
        [self setViewControllers:@[[self.viewControllersArray objectAtIndex:sender.selectedSegmentIndex]]
                       direction:UIPageViewControllerNavigationDirectionReverse
                        animated:YES completion:nil];
    }
}

- (void)showInfoScreen {
    NSLog(@"showInfoScreen");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"NewMain" bundle:[NSBundle mainBundle]];
    NFResultInfoController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NFResultInfoController"];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"NFResultInfoControllerNav"];
    [navController setViewControllers:@[viewController]];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Helpers

- (void)addMaskViewNavigationBar {
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, NAV_BAR_MASK_HEIGHT)];
    _maskView.backgroundColor = [NFStyleKit bASE_GREEN];
    _maskView.userInteractionEnabled = false;
    [self.view addSubview:_maskView];
}

- (void)addInfoButton {
    // Create the info button
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    // Adjust the frame by adding an addition 10 points to its width so the button is padded nicely
    infoButton.frame = CGRectMake(infoButton.frame.origin.x, infoButton.frame.origin.y, infoButton.frame.size.width, infoButton.frame.size.height);
    
    // Hook the button up to an action
    [infoButton addTarget:self action:@selector(showInfoScreen) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the nav bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}




@end
