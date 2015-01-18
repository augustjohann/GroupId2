//
//  ViewController.m
//  GroupdId2
//
//  Created by Markus Schmid on 14.01.15.
//  Copyright (c) 2015 Markus Schmid. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] fillAndQueryDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
