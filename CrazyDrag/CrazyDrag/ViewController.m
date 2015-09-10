//
//  ViewController.m
//  CrazyDrag
//
//  Created by 王新涛 on 8/9/15.
//  Copyright (c) 2015 Sin. All rights reserved.
//

#import "ViewController.h"
#import "AboutViewController.h"

@interface ViewController (){
    int currentValue;
    int targetValue;
    int score;
    int round;
}
- (IBAction)ShowAlert:(id)sender;
- (IBAction)sliderMoved:(UISlider*)sender;
- (IBAction)startOver:(id)sender;
- (IBAction)showInfo:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *targetLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *roundLabel;

@end

@implementation ViewController
@synthesize slider;
@synthesize targetLabel;
@synthesize scoreLabel;
@synthesize roundLabel;

-(void)startNewRound{
    round += 1;
    targetValue = 1+(arc4random()%100);
    currentValue = 50;
    self.slider.value = currentValue;
}

-(void)startNewGame{
    score = 0;
    round = 0;
    [self startNewRound];
}

-(void)updateLabels{
    self.targetLabel.text = [NSString stringWithFormat:@"%d",targetValue];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    self.roundLabel.text = [NSString stringWithFormat:@"%d",round];
}

- (IBAction)startOver:(id)sender {
    
    //添加过渡效果
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self startNewGame];
    [self updateLabels];
    
    [self.view.layer addAnimation:transition forKey:nil];
}

- (IBAction)showInfo:(id)sender {
    AboutViewController *controller = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self startNewRound];
    [self updateLabels];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startNewGame];
    [self updateLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderMoved:(UISlider*)sender {
    //UISlider *slider = (UISlider*)sender;
    currentValue = (int)lround(sender.value);
}

- (IBAction)ShowAlert:(id)sender {
    int difference = abs(currentValue - targetValue);
    int points = 100-difference;
    score += points;
    NSString *title;
    if(difference ==0){
        title = @"土豪你太NB了!";
        points +=100;
    }else if(difference <5){
        if(difference ==1){
            points +=50;
        }
        title = @"土豪太棒了,差一点!";
    }else if(difference <10){
        title = @"好吧,勉强算个土豪";
    }else{
        title = @"不是土豪少来装!";
    }
    NSString *message = [NSString stringWithFormat:@"恭喜高富帅,您的得分是: %d",points];
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"朕已知晓,爱卿辛苦了" otherButtonTitles:nil, nil]show];
}
@end
