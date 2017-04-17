//
//  ViewController.m
//  TestGL2
//
//  Created by Администратор on 3/7/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

//@synthesize accel;

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context)
    {
        [EAGLContext setCurrentContext:nil];
    }
    
    [_context release];
    [_effect release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] autorelease];
    
    if (!self.context)
    {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self GameInit];
    [self setupGL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil))
    {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context)
        {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

-(void)GameInit
{
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    Game_Data.Time_Sys.Time_Last = 0;
    Game_Data.Time_Sys.Time_Total = CFAbsoluteTimeGetCurrent();
    Game_Data.Time_Sys.Time_Elapsed = Game_Data.Time_Sys.Time_Total - Game_Data.Time_Sys.Time_Last;
    
    Game_Root = [[Game alloc] init : &Game_Data];
    Game_Data.firm_id = 99;
    Game_Data.Sound = false;
    Game_Data.Accel[0] = appDelegate.accel_x;
    Game_Data.Accel[1] = appDelegate.accel_y;
    Game_Data.Accel[2] = appDelegate.accel_z;
    Game_Data.Draw_Scale = 2;//self.contentScaleFactor / 2.0f;
 
    //Загрузка звуков
    Game_Data.Sound_Click = [Game_Root CreateSound: @"click.wav" : 0];
    Game_Data.Sound_Fan = [Game_Root CreateSound: @"fan.wav" : -1];
    Game_Data.Sound_Star = [Game_Root CreateSound: @"star.wav" : 0];
    Game_Data.Sound_Win = [Game_Root CreateSound: @"win.wav" : 0];
    Game_Data.Sound_Lose = [Game_Root CreateSound: @"lose.wav" : 0];
    
    Game_Data.Level = 0;
    Game_Data.Level_Count = 20;
    Game_Data.Level_Data = malloc(sizeof(*Game_Data.Level_Data) * Game_Data.Level_Count);
    if (![Game_Root Load_Data])
        [Game_Root Reset_Data];
    [Game_Root Check_Data];
    
    Game_Data.Status_Curent = Stat_Null;
    Game_Data.Status_Next = Stat_MenuMain;
}

-(void)GameUpdate
{  
    Game_Data.Time_Sys.Time_Total = CFAbsoluteTimeGetCurrent();
    Game_Data.Time_Sys.Time_Elapsed = Game_Data.Time_Sys.Time_Total - Game_Data.Time_Sys.Time_Last;
    Game_Data.Time_Sys.Time_Last = Game_Data.Time_Sys.Time_Total;
    
    Game_Data.Accel[0] = appDelegate.accel_x;
    Game_Data.Accel[1] = appDelegate.accel_y;
    Game_Data.Accel[2] = appDelegate.accel_z;
    
    [self ChangeStat];
    
    switch (Game_Data.Status_Curent)
    {
        case Stat_MenuMain:
        case Stat_MenuSettings:
        case Stat_Help:
            [Menu_Main Update];
            break;
        case Stat_MenuSelect:
            [Menu_Select Update];
            break;
        case Stat_Play:
        case Stat_Win:
        case Stat_Lose:
        case Stat_Pause:
            [Game_Play Update];
            break;
        default:
            Game_Data.Status_Next = Stat_MenuMain;
            break;
    }
}

-(void)ChangeStat
{
    if (Game_Data.Status_Next == Stat_Null)
        return;
    
    switch (Game_Data.Status_Next)
    {
        case Stat_MenuMain:
            [self Stat_Menu_Main];
            break;
        case Stat_MenuSelect:
            [self Stat_Menu_Select];
            break;
        case Stat_MenuSettings:
            [self Stat_Menu_Settings];
            break;
        case Stat_Help:
            [self Stat_Menu_Help];
            break;
        case Stat_Start:
            [self Stat_Game_Start];
            break;
        case Stat_Win:
            [self Stat_Game_Win];
            break;
        case Stat_Lose:
            [self Stat_Game_Lose];
            break;
        case Stat_Pause:
            [self Stat_Game_Pause];
            break;
        case Stat_Next:
            [self Stat_Game_Next];
            break;
        case Stat_Resume:
            [self Stat_Game_Resume];
            break;
    }
    glFlush();
    
    Game_Data.Status_Next = Stat_Null;
}

-(void)Stat_Menu_Main
{
    switch (Game_Data.Status_Curent)
    {
        case Stat_MenuSelect:
            if (Menu_Main)
                [Menu_Main dealloc];
            Menu_Main = nil;
            Menu_Main = [[MenuMain alloc] init : &Game_Data];
            [Menu_Select dealloc];
            Menu_Select = nil;
            break;
        case Stat_MenuSettings:
            [Menu_Main Reset];
            break;
        case Stat_Help:
            [Menu_Main Reset];
            break;
        case Stat_Win:
            if (Menu_Main)
                [Menu_Main dealloc];
            Menu_Main = nil;
            Menu_Main = [[MenuMain alloc] init : &Game_Data];
            [Game_Play dealloc];
            Game_Play = nil;
            break;
        case Stat_Lose:
            if (Menu_Main)
                [Menu_Main dealloc];
            Menu_Main = nil;
            Menu_Main = [[MenuMain alloc] init : &Game_Data];
            [Game_Play dealloc];
            Game_Play = nil;
            break;
        case Stat_Pause:
            if (Menu_Main)
                [Menu_Main dealloc];
            Menu_Main = nil;
            Menu_Main = [[MenuMain alloc] init : &Game_Data];
            if (Game_Play)
                [Game_Play dealloc];
            Game_Play = nil;
            if (Game_Data.Sound_Fan)
            {
                if (Game_Data.Sound_Fan.isPlaying) [Game_Data.Sound_Fan stop];
            }
            break;
        case Stat_Null:
            if (Menu_Main)
                [Menu_Main dealloc];
            Menu_Main = nil;
            Menu_Main = [[MenuMain alloc] init : &Game_Data];
            break;
    }
    Game_Data.Status_Curent = Stat_MenuMain;
}

-(void)Stat_Menu_Select
{
    switch (Game_Data.Status_Curent)
    {
        case Stat_MenuMain:
            if (Menu_Main)
                [Menu_Main dealloc];
            Menu_Main = nil;
            [Game_Root Check_Data];
            Menu_Select = [[MenuSelect alloc] init : &Game_Data];
            break;
    }
    Game_Data.Status_Curent = Stat_MenuSelect;
}

-(void)Stat_Menu_Settings
{
    switch (Game_Data.Status_Curent)
    {
        case Stat_MenuMain:
            [Menu_Main Reset];
            break;
    }
    Game_Data.Status_Curent = Stat_MenuSettings;
}

-(void)Stat_Menu_Help
{
    switch (Game_Data.Status_Curent)
    {
        case Stat_MenuMain:
            [Menu_Main Reset];
            break;
    }
    Game_Data.Status_Curent = Stat_Help;
}

-(void)Stat_Game_Start
{
    if (Menu_Select)
        [Menu_Select dealloc];
    Menu_Select = nil;
    if (Game_Play)
        [Game_Play dealloc];
    Game_Play = nil;
    Game_Play = [[Play alloc] init : &Game_Data];
    
    if (Game_Data.Sound_Fan)
    {
        if (Game_Data.Sound_Fan.isPlaying) [Game_Data.Sound_Fan stop];
    }
    
    Game_Data.Status_Curent = Stat_Play;
}

-(void)Stat_Game_Next
{
    Game_Data.Level++;
    if (Game_Play)
        [Game_Play dealloc];
    Game_Play = nil;
    Game_Play = [[Play alloc] init : &Game_Data];
    Game_Data.Status_Curent = Stat_Play;
}

-(void)Stat_Game_Resume
{
    Game_Data.Status_Curent = Stat_Play;
    Game_Play->Return_En = true;
    Game_Play->Return_Time = 3;
    
    if (Game_Data.Sound)
    {
        if (Game_Data.Sound_Fan) [Game_Data.Sound_Fan play];
    }
}

-(void)Stat_Game_Pause
{
    if (Game_Data.Status_Curent == Stat_Play)
    {
        [Game_Play->Menu_Game Pause];
        Game_Data.Status_Curent = Stat_Pause;
        Game_Play->GamePauseTime = Game_Data.Time_Sys.Time_Total;
        
        if (Game_Data.Sound_Fan)
        {
            if (Game_Data.Sound_Fan.isPlaying) [Game_Data.Sound_Fan stop];
        }
    }
}

-(void)Stat_Game_Win
{
    [Game_Play->Menu_Game Win : Game_Play->Game_Level->Score_Count];
    
    if (Game_Play->Game_Level->Score_Count == 0)
        Game_Data.Stars = 3;
    else
        Game_Data.Stars = (int)(((float)Game_Data.Score / (float)Game_Play->Game_Level->Score_Count) * 3.0f);
    
    if (Game_Data.Score >= Game_Data.Level_Data[Game_Data.Level].Score)
    {
        Game_Data.Level_Data[Game_Data.Level].Score = Game_Data.Score;
        Game_Data.Level_Data[Game_Data.Level].Stars = Game_Data.Stars;
    }
    Game_Data.Level_Data[Game_Data.Level].Used = true;
    [Game_Root Save_Data];
    [Game_Root Check_Data];
    
    if (Game_Data.Sound_Fan)
    {
        if (Game_Data.Sound_Fan.isPlaying) [Game_Data.Sound_Fan stop];
    }
    
    Game_Data.Status_Curent = Stat_Win;
}

-(void)Stat_Game_Lose
{
    [Game_Play->Menu_Game Lose];
    
    if (Game_Data.Sound_Fan)
    {
        if (Game_Data.Sound_Fan.isPlaying) [Game_Data.Sound_Fan stop];
    }
    
    Game_Data.Status_Curent = Stat_Lose;
}

-(void)GameDraw
{
    switch (Game_Data.Status_Curent)
    {
        case Stat_MenuMain:
        case Stat_MenuSettings:
        case Stat_Help:
            [Menu_Main Draw];
            break;
        case Stat_MenuSelect:
            [Menu_Select Draw];
            break;
        case Stat_Play:
        case Stat_Win:
        case Stat_Lose:
        case Stat_Pause:
            [Game_Play Draw];
            break;
    }
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    self.effect = [[[GLKBaseEffect alloc] init] autorelease];
    Game_Data.effect = self.effect;
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glGenVertexArraysOES(1, &Game_Data.vertexArray);
    glGenBuffers(1, &Game_Data.vertexBufferPos);
    glGenBuffers(1, &Game_Data.vertexBufferTex);
    glGenBuffers(1, &Game_Data.vertexBufferCol);
    glBindVertexArrayOES(0);
    
    Game_Data.Game_Width = 640;
    
    if (self.view.bounds.size.height > 480)
        Game_Data.Game_Height = 1136;
    else
        Game_Data.Game_Height = 960;
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.bounds.size.width, self.view.bounds.size.height, 0, -1.0f, 1.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    Game_Data.CameraMatrix = GLKMatrix4MakeTranslation(0, 0, 0);
    Game_Data.CameraMatrix = GLKMatrix4Scale(Game_Data.CameraMatrix, 0.5f, 0.5f, 0.0f);
    self.effect.transform.modelviewMatrix = Game_Data.CameraMatrix;
    
    self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    self.effect.texture2d0.enabled = true;
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &Game_Data.vertexBufferPos);
    glDeleteBuffers(1, &Game_Data.vertexBufferTex);
    glDeleteBuffers(1, &Game_Data.vertexBufferCol);
    glDeleteVertexArraysOES(1, &Game_Data.vertexArray);
    
    self.effect = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [self GameUpdate];  
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self GameDraw];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    [self TapBegin : location.x : location.y];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self TapEnd];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self TapEnd];
}

-(void)TapBegin: (float)x : (float)y
{
    x *= 2;
    y *= 2;
    
    
    switch (Game_Data.Status_Curent)
    {
        case Stat_MenuMain:
        case Stat_MenuSettings:
        case Stat_Help:
            [Menu_Main Touch_Begin : x : y];
            break;
        case Stat_MenuSelect:
            [Menu_Select Touch_Begin : x : y];
            break;
        case Stat_Play:
        case Stat_Win:
        case Stat_Lose:
        case Stat_Pause:
            [Game_Play Touch_Begin : x : y];
            break;
        default:
            break;
    }
}

-(void)TapEnd
{
    switch (Game_Data.Status_Curent)
    {
        case Stat_Play:
        case Stat_Win:
        case Stat_Lose:
        case Stat_Pause:
            [Game_Play Touch_End];
            break;
        default:
            break;
    }
}

@end
