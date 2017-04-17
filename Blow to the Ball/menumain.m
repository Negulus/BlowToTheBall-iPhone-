//
//  BlowToTheBall
//
//  Created by Negulus on 2/23/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "menumain.h"

@implementation MenuMain
-(id)init : (struct GameData*)data
{
    self = [super init : data];
    if (self)
    {
        Texture_Error = [self loadTexture:@"error"];
        Background = [self loadTexture:@"background"];
        
        //Кнопки
        [self CreateButton: &Button_Play : /*(Center[0] - 256)*/64 : 240 : 512 : 128 : [self loadTexture:@"button_play"] : 76 : 5 : 360 : 90];
        [self CreateButton: &Button_Settings : Button_Play.But.Position[0] : (Button_Play.But.Position[1] + 140) : 512 : 128 : [self loadTexture:@"button_settings"] : 76 : 5 : 360 : 90];
        [self CreateButton: &Button_Help : Button_Play.But.Position[0] : (Button_Settings.But.Position[1] + 140) : 512 : 128 : [self loadTexture:@"button_help"] : 76 : 5 : 360 : 90];
        
        [self CreateButton: &Button_Sound_On : Button_Play.But.Position[0] : Button_Play.But.Position[1] : 512 : 128 : [self loadTexture:@"button_soundon"] : 76 : 5 : 360 : 90];
        [self CreateButton: &Button_Sound_Off : Button_Sound_On.But.Position[0] : Button_Sound_On.But.Position[1] : 512 : 128 : [self loadTexture:@"button_soundoff"] : 76 : 5 : 360 : 90];
        [self CreateButton: &Button_Reset : Button_Settings.But.Position[0] : Button_Settings.But.Position[1] : 512 : 128 : [self loadTexture:@"button_reset"] : 76 : 5 : 360 : 90];
        
        [self CreateButton: &Button_Back : 0 : (Game_Data->Game_Height - 128) : 128 : 128 : [self loadTexture:@"button_back"] : 0 : 0 : 128 : 128];

        //Текстуры
        [self CreateObject : &Texture_Plate : /*(Center[0] - 256)*/64 : 56 : 512 : 128 : [self loadTexture:@"plate"]];
        [self CreateObject : &Texture_Text_Main : Texture_Plate.Position[0] : Texture_Plate.Position[1] : 512 : 128 : [self loadTexture:@"text_blowtotheball"]];
        [self CreateObject : &Texture_Text_Settings : Texture_Plate.Position[0] : Texture_Plate.Position[1] : 512 : 128 : [self loadTexture:@"text_settings"]];
        [self CreateObject : &Texture_Text_Help : Texture_Plate.Position[0] : Texture_Plate.Position[1] : 512 : 128 : [self loadTexture:@"text_help"]];
        [self CreateObject : &Texture_Help : 30 : (Texture_Plate.Position[1] + 120) : 1024 : 1024 : [self loadTexture:@"help"]];
        
        //Таймеры
        Timer_Menu.Action = Act_Null;

        [self Reset];
	}
	return self;
}

-(void)Reset
{
    Button_Play.Touch = false;
    Button_Settings.Touch = false;
    Button_Back.Touch = false;
    Button_Sound_On.Touch = false;
    Button_Sound_Off.Touch = false;
    Button_Reset.Touch = false;
    Button_Help.Touch = false;
    Timer_Menu.Action = Act_Null;
}

-(void)Touch_Begin : (float)x : (float)y
{
    switch (Game_Data->Status_Curent)
    {
        case Stat_MenuMain:
            if ([self Button_Touched : &Button_Play : x : y])
            {
                [self TimerSet: &Timer_Menu : 0.25f : Act_Select];
            }
            else if ([self Button_Touched : &Button_Settings : x : y])
            {
                [self TimerSet: &Timer_Menu : 0.25f : Act_Settings];
            }
            else if ([self Button_Touched : &Button_Help : x : y])
            {
                [self TimerSet: &Timer_Menu : 0.25f : Act_Help];
            }
            break;
        case Stat_Help:
            if ([self Button_Touched : &Button_Back : x : y])
            {
                Game_Data->Status_Next = Stat_MenuMain;
            }
            break;
        case Stat_MenuSettings:

            if (Game_Data->Sound)
            {
                if ([self Button_Touched : &Button_Sound_On : x : y])
                {
                    [self TimerSet: &Timer_Menu : 0.25f : Act_Sound];
                }
            }
            else
            {
                if ([self Button_Touched : &Button_Sound_Off : x : y])
                {
                    [self TimerSet: &Timer_Menu : 0.25f : Act_Sound];
                }
            }
            if ([self Button_Touched : &Button_Reset : x : y])
            {
                [self Reset_Data];
                [self TimerSet: &Timer_Menu : 0.25f : Act_MainMenu];
            }
            else if ([self Button_Touched : &Button_Back : x : y])
            {
                [self Save_Data];
                Game_Data->Status_Next = Stat_MenuMain;
            }
            break;
    }
}

-(void)Update
{
    if ([self TimerGet: &Timer_Menu])
    {
        switch (Timer_Menu.Action)
        {
            case Act_Select:
                Game_Data->Status_Next = Stat_MenuSelect;
                break;
            case Act_Settings:
                Game_Data->Status_Next = Stat_MenuSettings;
                break;
            case Act_Exit:
//              game1.Exit();
                break;
            case Act_MainMenu:
                Game_Data->Status_Next = Stat_MenuMain;
                break;
            case Act_Sound:
                if (Game_Data->Sound)
                    Game_Data->Sound = false;
                else
                    Game_Data->Sound = true;
                Button_Sound_Off.Touch = false;
                Button_Sound_On.Touch = false;
                break;
            case Act_Help:
                Game_Data->Status_Next = Stat_Help;
                break;
            default:
                break;
        }
        Timer_Menu.Action = Act_Null;
    }
}

-(void)Draw
{
    [self DrawBG : &Background];
    [self DrawObject: &Texture_Plate];
    
    switch (Game_Data->Status_Curent)
    {
        case Stat_MenuMain:
            [self Draw_Main];
            break;
        case Stat_MenuSettings:
            [self Draw_Settings];
            break;
        case Stat_Help:
            [self Draw_Help];
            break;
    }
}

-(void)Draw_Main
{
    [self DrawObject: &Texture_Text_Main];
    
    [self DrawButton: &Button_Play];
    [self DrawButton: &Button_Settings];
    [self DrawButton: &Button_Help];
}

-(void)Draw_Help
{
    [self DrawObject: &Texture_Text_Help];
    
    [self DrawObject: &Texture_Help];
    
    [self DrawButton: &Button_Back];
}

-(void)Draw_Settings
{
    [self DrawObject: &Texture_Text_Settings];
    
    if (Game_Data->Sound)
        [self DrawButton: &Button_Sound_On];
    else
        [self DrawButton: &Button_Sound_Off];
    
    [self DrawButton: &Button_Reset];
    [self DrawButton: &Button_Back];
}

-(void)dealloc
{
    glDeleteTextures(1, &Texture_Error);
    glDeleteTextures(1, &Background);
    
    //Кнопки
    glDeleteTextures(1, &Button_Play.But.Texture);
    glDeleteTextures(1, &Button_Settings.But.Texture);
    glDeleteTextures(1, &Button_Help.But.Texture);
    glDeleteTextures(1, &Button_Sound_On.But.Texture);
    glDeleteTextures(1, &Button_Sound_Off.But.Texture);
    glDeleteTextures(1, &Button_Reset.But.Texture);
    glDeleteTextures(1, &Button_Back.But.Texture);
    
    //Текстуры
    glDeleteTextures(1, &Texture_Plate.Texture);
    glDeleteTextures(1, &Texture_Text_Main.Texture);
    glDeleteTextures(1, &Texture_Text_Settings.Texture);
    glDeleteTextures(1, &Texture_Text_Help.Texture);
    glDeleteTextures(1, &Texture_Help.Texture);

	[super dealloc];
}
@end