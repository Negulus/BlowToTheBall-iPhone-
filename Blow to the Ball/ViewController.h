//
//  ViewController.h
//  TestGL2
//
//  Created by Администратор on 3/7/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "game.h"
#import "play.h"
#import "menumain.h"
#import "menuselect.h"
#import "AppDelegate.h"

@interface ViewController : GLKViewController
{
@private
    AppDelegate *appDelegate;
    
    struct GameData Game_Data;
    
    //Игровые классы
    Game *Game_Root;
    MenuMain *Menu_Main;
    MenuSelect *Menu_Select;
    Play *Game_Play;
}

//@property (nonatomic) UIAccelerationValue *accel;
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;
-(void)GameInit;
@end