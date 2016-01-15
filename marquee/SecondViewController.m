//
//  SecondViewController.m
//  marquee
//
//  Created by Thomas Robin on 06/01/2016.
//  Copyright © 2016 thomasrobin. All rights reserved.
//

#import "SecondViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface SecondViewController ()

@property (strong, nonatomic) PFQuery *query;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateTextView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_query cancel];
    [_animatedLabel stopAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTextView {
    _query= [PFQuery queryWithClassName:@"Marquee"];
    
    [_query orderByDescending:@"createdAt"];
    
    [_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _marqueeList = [objects valueForKey:@"content"];
        
        [_animatedLabel animateWithWords:_marqueeList forDuration:3.0f withAnimation:ATAnimationTypeSlideTopInBottomOut];
        
        NSLog(@"%@", _marqueeList);
    }];
    
}

@end
