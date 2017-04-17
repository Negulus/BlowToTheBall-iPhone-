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
#import "menugame.h"

@implementation MenuGame
-(id)init : (struct GameData*)data
{
    self = [super init : data];
    if (self)
    {
        Texture_Error = [self loadTexture:@"error"];
        
        Position[0] = 64;//Center[0] - 256;
        Position[1] = -512;
        
        Position_Start = -512;
        Position_End = 100;
        
        [self CreateObject : &Texture_Pause : 0 : 0 : 512 : 512 : [self loadTexture:@"pause_bg"]];
        [self CreateObject : &Texture_Win : 0 : 0 : 512 : 512 : [self loadTexture:@"win_bg"]];
        [self CreateObject : &Texture_Lose : 0 : 0 : 512 : 512 : [self loadTexture:@"lose_bg"]];
        
        [self CreateButton: &Button_Next : 0 : 0 : 512 : 128 : [self loadTexture:@"button_next"] : 120 : 4 : 272 : 72];
        [self CreateButton: &Button_Resume : 0 : 0 : 512 : 128 : [self loadTexture:@"button_resume"] : 120 : 4 : 272 : 72];
        [self CreateButton: &Button_Restart : 0 : 0 : 512 : 128 : [self loadTexture:@"button_restart"] : 120 : 4 : 272 : 72];
        [self CreateButton: &Button_MainMenu : 0 : 0 : 512 : 128 : [self loadTexture:@"button_mainmenu"] : 120 : 4 : 272 : 72];
        
        [self CreateObject : &Texture_Star_0 : 128 : 62 : 256 : 128 : [self loadTexture:@"win_star_0"]];
        [self CreateObject : &Texture_Star_1 : Texture_Star_0.Position[0] : Texture_Star_0.Position[1] : 256 : 128 : [self loadTexture:@"win_star_1"]];
        [self CreateObject : &Texture_Star_2 : Texture_Star_0.Position[0] : Texture_Star_0.Position[1] : 256 : 128 : [self loadTexture:@"win_star_2"]];
        [self CreateObject : &Texture_Star_3 : Texture_Star_0.Position[0] : Texture_Star_0.Position[1] : 256 : 128 : [self loadTexture:@"win_star_3"]];
        
        [self CreateObjectDigit : &Record_Digit : 268 : 164 : 32 : 64 : 28 : 0];
        Record_Digit.Texture[0] = [self loadTexture:@"win_digit_0"];
        Record_Digit.Texture[1] = [self loadTexture:@"win_digit_1"];
        Record_Digit.Texture[2] = [self loadTexture:@"win_digit_2"];
        Record_Digit.Texture[3] = [self loadTexture:@"win_digit_3"];
        Record_Digit.Texture[4] = [self loadTexture:@"win_digit_4"];
        Record_Digit.Texture[5] = [self loadTexture:@"win_digit_5"];
        Record_Digit.Texture[6] = [self loadTexture:@"win_digit_6"];
        Record_Digit.Texture[7] = [self loadTexture:@"win_digit_7"];
        Record_Digit.Texture[8] = [self loadTexture:@"win_digit_8"];
        Record_Digit.Texture[9] = [self loadTexture:@"win_digit_9"];
        
        Score_Digit = Record_Digit;
        Score_Digit.Position[0] = 150;
        
        //Таймеры
        Timer_MenuGame.Action = Act_Null;
        Time_Raise = 0.2f;
	}
	return self;
}

-(void)Pause
{
    Button_Resume.But.Position[0] = 0;
    Button_Resume.But.Position[1] = 100;
    Button_Restart.But.Position[0] = Button_Resume.But.Position[0];
    Button_Restart.But.Position[1] = Button_Resume.But.Position[1] + 92;
    Button_MainMenu.But.Position[0] = Button_Restart.But.Position[0];
    Button_MainMenu.But.Position[1] = Button_Restart.But.Position[1] + 92;
    
    //Перемещение текстур
    Position_Start = -Position_End - 396;
    Time_Raise = 0.25f;
    
    [self Reset];
}

-(void)Win : (int)score
{
    Button_Next.But.Position[0] = 0;
    Button_Next.But.Position[1] = 220;
    Button_Restart.But.Position[0] = Button_Next.But.Position[0];
    Button_Restart.But.Position[1] = Button_Next.But.Position[1] + 92;
    Button_MainMenu.But.Position[0] = Button_Restart.But.Position[0];
    Button_MainMenu.But.Position[1] = Button_Restart.But.Position[1] + 92;
    
    //Перемещение текстур
    Position_Start = -Position_End - 512;
    Time_Raise = 0.5f;
    
    Score_Count = score;
    
    if (Game_Data->Sound)
    {
        if (Game_Data->Sound_Win) [Game_Data->Sound_Win play];
    }
    
    [self Reset];
}

-(void)Lose
{
    Button_Restart.But.Position[0] = 0;
    Button_Restart.But.Position[1] = 100;
    Button_MainMenu.But.Position[0] = Button_Restart.But.Position[0];
    Button_MainMenu.But.Position[1] = Button_Restart.But.Position[1] + 92;
    
    //Перемещение текстур
    Position_Start = -Position_End - 302;
    Time_Raise = 0.5f;
    
    if (Game_Data->Sound)
    {
        if (Game_Data->Sound_Lose) [Game_Data->Sound_Lose play];
    }
    
    [self Reset];
}

-(void)Reset
{
    Button_Next.Touch = false;
    Button_Restart.Touch = false;
    Button_MainMenu.Touch = false;
    Button_Resume.Touch = false;
    Timer_MenuGame.Action = Act_Null;
    Timer_Start = -1;
    Enable = false;
    Position[1] = -512;
}

-(void)Touch_Begin : (float)x : (float)y
{
    if (Enable)
    {
        x -= Position[0];
        y -= Position[1];
        switch (Game_Data->Status_Curent)
        {
            case Stat_Pause:
                if ([self Button_Touched : &Button_MainMenu : x : y])
                    [self TimerSet: &Timer_MenuGame : 0.25f : Act_MainMenu];
                else if ([self Button_Touched : &Button_Restart : x : y])
                    [self TimerSet: &Timer_MenuGame : 0.25f : Act_Restart];
                else if ([self Button_Touched : &Button_Resume : x : y])
                    [self TimerSet: &Timer_MenuGame : 0.25f : Act_Resume];
                break;
            case Stat_Lose:
                if ([self Button_Touched : &Button_MainMenu : x : y])
                    [self TimerSet: &Timer_MenuGame : 0.25f : Act_MainMenu];
                else if ([self Button_Touched : &Button_Restart : x : y])
                    [self TimerSet: &Timer_MenuGame : 0.25f : Act_Restart];
                break;
            case Stat_Win:
                if ((Game_Data->Level + 1) < Game_Data->Level_Count)
                {
                    if (Game_Data->Level_Data[Game_Data->Level + 1].Enable)
                    {
                        if ([self Button_Touched : &Button_Next : x : y])
                            [self TimerSet: &Timer_MenuGame : 0.25f : Act_Next];
                    }
                }
                if ([self Button_Touched : &Button_MainMenu : x : y])
                    [self TimerSet: &Timer_MenuGame : 0.25f : Act_MainMenu];
                else if ([self Button_Touched : &Button_Restart : x : y])
                    [self TimerSet: &Timer_MenuGame : 0.25f : Act_Restart];
                break;
        }
    }
}

-(void)Update
{
    if (!Enable && (Timer_Start < 0))
    {
        Timer_Start = Game_Data->Time_Sys.Time_Total;
    }
    else if (!Enable)
    {
        Position[1] = Position_Start + ((Game_Data->Time_Sys.Time_Total - Timer_Start) / Time_Raise) * (Position_End - Position_Start);
        if (Position[1] >= Position_End)
        {
            Position[1] = Position_End;
            Enable = true;
        }
    }
    
    if ([self TimerGet: &Timer_MenuGame])
    {
        switch (Timer_MenuGame.Action)
        {
            case Act_Restart:
                Game_Data->Status_Next = Stat_Start;
                break;
            case Act_MainMenu:
                Game_Data->Status_Next = Stat_MenuMain;
                break;
            case Act_Resume:
                Game_Data->Status_Next = Stat_Resume;
                break;
            case Act_Next:
                Game_Data->Status_Next = Stat_Next;
                break;
            case Act_MenuGameEnable:
                Enable = true;
                break;
            default:
                break;
        }
        Timer_MenuGame.Action = Act_Null;
    }
}

-(void)Draw
{
    switch (Game_Data->Status_Curent)
    {
        case Stat_Pause:
            [self DrawObjectLocal: &Texture_Pause];
            [self DrawButtonLocal: &Button_MainMenu];
            [self DrawButtonLocal: &Button_Restart];
            [self DrawButtonLocal: &Button_Resume];
            break;
        case Stat_Lose:
            [self DrawObjectLocal: &Texture_Lose];
            [self DrawButtonLocal: &Button_MainMenu];
            [self DrawButtonLocal: &Button_Restart];
            break;
        case Stat_Win:
            [self DrawObjectLocal: &Texture_Win];
            [self DrawButtonLocal: &Button_MainMenu];
            [self DrawButtonLocal: &Button_Restart];
            if ((Game_Data->Level + 1) < Game_Data->Level_Count)
            {
                if (Game_Data->Level_Data[Game_Data->Level + 1].Enable)
                {
                    [self DrawButtonLocal: &Button_Next];
                }
                else
                {
                    [self NewColor : Vertex_Col_tmp : 0.9f : 0.9f : 1.0f : 1.0f];
                    [self BindBuffer : Button_Next.But.Vertex : Vertex_Tex_Full : Vertex_Col_tmp];
                    
                    Game_Data->effect.texture2d0.name = Button_Next.But.Texture;
                    Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, (Position[0] + Button_Next.But.Position[0]), (Position[1] + Button_Next.But.Position[1]), 0);
                    [Game_Data->effect prepareToDraw];
                    
                    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
                }
            }
            else
            {
                [self NewColor : Vertex_Col_tmp : 0.9f : 0.9f : 1.0f : 1.0f];
                [self BindBuffer : Button_Next.But.Vertex : Vertex_Tex_Full : Vertex_Col_tmp];
                
                Game_Data->effect.texture2d0.name = Button_Next.But.Texture;
                Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, (Position[0] + Button_Next.But.Position[0]), (Position[1] + Button_Next.But.Position[1]), 0);
                [Game_Data->effect prepareToDraw];
                
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }
            if (Game_Data->Stars == 0)
                [self DrawObjectLocal: &Texture_Star_0];
            else if (Game_Data->Stars == 1)
                [self DrawObjectLocal: &Texture_Star_1];
            else if (Game_Data->Stars == 2)
                [self DrawObjectLocal: &Texture_Star_2];
            else
                [self DrawObjectLocal: &Texture_Star_3];

            [self DrawObjectDigitLocal : &Record_Digit : 3 : Score_Count];
            [self DrawObjectDigitLocal : &Score_Digit : 3 : Game_Data->Score];
            break;
    }
}

-(void)DrawObjectLocal : (struct Object*)obj
{
    [self BindBuffer : obj->Vertex : Vertex_Tex_Full : Vertex_Col_Full];
    
    Game_Data->effect.texture2d0.name = obj->Texture;
    Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, (obj->Position[0] + Position[0]), (obj->Position[1] + Position[1]), 0);
    [Game_Data->effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}


-(void)DrawObjectDigitLocal : (struct Object_digit*)obj : (int) count : (int)num
{
    [self BindBuffer : obj->Vertex : Vertex_Tex_Full : Vertex_Col_Full];
    
    Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, (obj->Position[0] + Position[0]), (obj->Position[1] + Position[1]), 0);
    
    i = num % 100;
    j = i % 10;
    
    if (count >= 3)
    {
        Game_Data->effect.texture2d0.name = obj->Texture[((num - i) / 100)];
        [Game_Data->effect prepareToDraw];
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->effect.transform.modelviewMatrix, obj->Relative[0], obj->Relative[1], 0);
    }
    
    if (count >= 2)
    {
        Game_Data->effect.texture2d0.name = obj->Texture[((i-j) / 10)];
        [Game_Data->effect prepareToDraw];
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->effect.transform.modelviewMatrix, obj->Relative[0], obj->Relative[1], 0);
    }
    
    if (count >= 1)
    {
        Game_Data->effect.texture2d0.name = obj->Texture[j];
        [Game_Data->effect prepareToDraw];
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
}

-(void)DrawButtonLocal : (struct Button*)obj
{
    if (obj->Touch)
    {
        [self NewColor : Vertex_Col_tmp : 0.9f : 0.9f : 1.0f : 1.0f];
        [self BindBuffer : obj->But.Vertex : Vertex_Tex_Full : Vertex_Col_tmp];
        
        Game_Data->effect.texture2d0.name = obj->But.Texture;
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, (Position[0] + obj->But.Position[0]), (Position[1] + obj->But.Position[1]), 0);
        [Game_Data->effect prepareToDraw];
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    else
    {
        [self DrawObjectLocal: &obj->But];
    }
}

-(void)dealloc
{
    //Текстуры кнопок    
    glDeleteTextures(1, &Button_Resume.But.Texture);
    glDeleteTextures(1, &Button_Next.But.Texture);
    glDeleteTextures(1, &Button_MainMenu.But.Texture);
    glDeleteTextures(1, &Button_Restart.But.Texture);
    
    glDeleteTextures(1, &Texture_Pause.Texture);
    glDeleteTextures(1, &Texture_Win.Texture);
    glDeleteTextures(1, &Texture_Lose.Texture);
    glDeleteTextures(1, &Texture_Star_0.Texture);
    glDeleteTextures(1, &Texture_Star_1.Texture);
    glDeleteTextures(1, &Texture_Star_2.Texture);
    glDeleteTextures(1, &Texture_Star_3.Texture);
    glDeleteTextures(1, &Texture_Star_2.Texture);
    
    glDeleteTextures(1, &Record_Digit.Texture[0]);
    glDeleteTextures(1, &Record_Digit.Texture[1]);
    glDeleteTextures(1, &Record_Digit.Texture[2]);
    glDeleteTextures(1, &Record_Digit.Texture[3]);
    glDeleteTextures(1, &Record_Digit.Texture[4]);
    glDeleteTextures(1, &Record_Digit.Texture[5]);
    glDeleteTextures(1, &Record_Digit.Texture[6]);
    glDeleteTextures(1, &Record_Digit.Texture[7]);
    glDeleteTextures(1, &Record_Digit.Texture[8]);
    glDeleteTextures(1, &Record_Digit.Texture[9]);
    
	[super dealloc];
}
@end