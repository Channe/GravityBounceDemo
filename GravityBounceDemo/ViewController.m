//
//  ViewController.m
//  GravityBounceDemo
//
//  Created by QianLei on 16/8/14.
//  Copyright © 2016年 ichanne. All rights reserved.
//

#import "ViewController.h"

static CGFloat const kBounceScope = 250;
static NSInteger const kBounceTimes = 1;
static CGFloat const kMagnitude = 0.9;//重力的加速度
static CGFloat const kElasticity = 0.9;//弹性系数

@interface ViewController ()<UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *buttomImageView;

@property (nonatomic, strong) UIDynamicItemBehavior *topImageViewBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *buttomImageViewBehavior;
@property (nonatomic, strong) UIDynamicAnimator *topAnimator;
@property (nonatomic, strong) UIDynamicAnimator *buttomAnimator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)viewDidLayoutSubviews {
    
    [self makeDynamicAnimator];
}

- (void)makeDynamicAnimator {
    //top
    UIDynamicAnimator *topAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *topGravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self.topImageView]];
    topGravityBeahvior.gravityDirection = CGVectorMake(0.0, -1.0);
    topGravityBeahvior.magnitude = kMagnitude;
    
    UICollisionBehavior *topCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.topImageView]];
    topCollisionBehavior.collisionDelegate = self;
    
    CGPoint topPoint1 = CGPointMake(0, -kBounceScope);
    CGPoint topPoint2 = CGPointMake([UIScreen mainScreen].bounds.size.width, -kBounceScope);
    [topCollisionBehavior addBoundaryWithIdentifier:@"top" fromPoint:topPoint1 toPoint:topPoint2];
    
    self.topImageViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.topImageView]];
    self.topImageViewBehavior.elasticity = kElasticity;
    
    [topAnimator addBehavior:self.topImageViewBehavior];
    [topAnimator addBehavior:topGravityBeahvior];
    [topAnimator addBehavior:topCollisionBehavior];
    self.topAnimator = topAnimator;

    //buttom
    UIDynamicAnimator *buttomAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    UIGravityBehavior *buttomGravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self.buttomImageView]];
    buttomGravityBeahvior.gravityDirection = CGVectorMake(0.0, 1.0);
    buttomGravityBeahvior.magnitude = kMagnitude;
    
    UICollisionBehavior *buttomCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.buttomImageView]];
    buttomCollisionBehavior.collisionDelegate = self;
    
    CGPoint bottomPoint1 = CGPointMake(0, [UIScreen mainScreen].bounds.size.height + kBounceScope);
    CGPoint bottomPoint2 = CGPointMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + kBounceScope);
    [buttomCollisionBehavior addBoundaryWithIdentifier:@"bottom" fromPoint:bottomPoint1 toPoint:bottomPoint2];
    
    self.buttomImageViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.buttomImageView]];
    self.buttomImageViewBehavior.elasticity = kElasticity;
    
    [buttomAnimator addBehavior:self.buttomImageViewBehavior];
    [buttomAnimator addBehavior:buttomGravityBeahvior];
    [buttomAnimator addBehavior:buttomCollisionBehavior];
    
    self.buttomAnimator = buttomAnimator;
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier
{
    static NSInteger bounceTimes = 0;
    if (bounceTimes >= kBounceTimes*2) {
        [self.topAnimator removeBehavior:behavior];
        [self.buttomAnimator removeBehavior:behavior];
    }
    bounceTimes++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
