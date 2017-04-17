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
#import "menuselect.h"

@implementation MenuSelect
-(id)init : (struct GameData*)data
{
    self = [super init : data];
    if (self)
    {
        //Загрузка текстуры кнопок выбора уровня
        Texture_Error = [self loadTexture:@"error"];
        Background = [self loadTexture:@"background"];
        
        //Текстуры
        [self CreateObject : &Tile_BG : 0 : 0 : 128 : 128 : [self loadTexture:@"select_bg"]];
        [self CreateObjectDigit: &Tile_Digit : 35 : 32 : 32 : 64 : 27 : 0];
        Tile_Digit.Texture[0] = [self loadTexture:@"select_0"];
        Tile_Digit.Texture[1] = [self loadTexture:@"select_1"];
        Tile_Digit.Texture[2] = [self loadTexture:@"select_2"];
        Tile_Digit.Texture[3] = [self loadTexture:@"select_3"];
        Tile_Digit.Texture[4] = [self loadTexture:@"select_4"];
        Tile_Digit.Texture[5] = [self loadTexture:@"select_5"];
        Tile_Digit.Texture[6] = [self loadTexture:@"select_6"];
        Tile_Digit.Texture[7] = [self loadTexture:@"select_7"];
        Tile_Digit.Texture[8] = [self loadTexture:@"select_8"];
        Tile_Digit.Texture[9] = [self loadTexture:@"select_9"];
        
        [self CreateObject : &Tile_Stars_0 : Tile_BG.Position[0] : (Tile_BG.Position[1] + 64) : 128 : 64 : [self loadTexture:@"select_star_0"]];
        [self CreateObject : &Tile_Stars_1 : Tile_Stars_0.Position[0] : Tile_Stars_0.Position[1] : 128 : 64 : [self loadTexture:@"select_star_1"]];
        [self CreateObject : &Tile_Stars_2 : Tile_Stars_0.Position[0] : Tile_Stars_0.Position[1] : 128 : 64 : [self loadTexture:@"select_star_2"]];
        [self CreateObject : &Tile_Stars_3 : Tile_Stars_0.Position[0] : Tile_Stars_0.Position[1] : 128 : 64 : [self loadTexture:@"select_star_3"]];
        
        //Инициализация кнопок выбора уровня
        Position_tmp[0] = 43;//Center[0] - 277;
        Position_tmp[1] = 184;
        
        for (i = 0; i < (Game_Data->Level_Count / 4); i++)
        {
            for (j = 0; j < 4; j++)
            {
                if (j == 0)
                    Game_Data->Level_Data[i * 4 + j].Position[0] = Position_tmp[0];
                else
                    Game_Data->Level_Data[i * 4 + j].Position[0] = Game_Data->Level_Data[j - 1].Position[0] + 142;
                
                Game_Data->Level_Data[i * 4 + j].Position[1] = Position_tmp[1] + 122 * i;
            }
        }
        
        [self CreateButton: &Button_Back : 0 : (Game_Data->Game_Height - 128) : 128 : 128 : [self loadTexture:@"button_back"] : 0 : 0 : 128 : 128];
        [self CreateObject : &Texture_Plate : /*(Center[0] - 256)*/64 : 56 : 512 : 128 : [self loadTexture:@"plate"]];
        [self CreateObject : &Texture_Text_Select : Texture_Plate.Position[0] : Texture_Plate.Position[1] : 512 : 128 : [self loadTexture:@"text_select"]];
            
        [self ResetLevelTouch];
        
        //Таймеры
        Timer_Select.Action = Act_Null;
	}
	return self;
}

-(void)Touch_Begin : (float)x : (float)y
{
    for (i = 0; i < Game_Data->Level_Count; i++)
    {
        if (Game_Data->Level_Data[i].Enable)
        {
            if ([self Location_Touched : x : y : Game_Data->Level_Data[i].Position[0] : Game_Data->Level_Data[i].Position[1] : Tile_BG.Vertex[6] : Tile_BG.Vertex[7]])
            {
                if (Game_Data->Sound)
                {
                    if (Game_Data->Sound_Click) [Game_Data->Sound_Click play];
                }
                Game_Data->Level = i;
                [self TimerSet: &Timer_Select : 0.15f : Act_Select];
                Game_Data->Level_Data[i].Touch = true;
                break;
            }
        }
    }
    if ([self Button_Touched : &Button_Back : x : y])
    {
        Game_Data->Status_Next = Stat_MenuMain;
    }
}

-(void)Update
{
    if ([self TimerGet: &Timer_Select])
    {
        switch (Timer_Select.Action)
        {
            case Act_Select:
                Game_Data->Status_Next = Stat_Start;
                break;
            default:
                break;
        }
        Timer_Select.Action = Act_Null;
    }
}

-(void)Draw
{
    [self DrawBG : &Background];
    [self DrawObject: &Texture_Plate];
    [self DrawObject: &Texture_Text_Select];
    
    for (k = 0; k < Game_Data->Level_Count; k++)
        [self DrawTile : k];
    
    [self DrawObject: &Button_Back.But];
}

-(void)DrawTile : (int)num
{
    if (Game_Data->Level_Data[num].Enable)
    {
        if (Game_Data->Level_Data[num].Touch)
        {
            [self NewColor : Vertex_Col_tmp : 0.9f : 0.9f : 1.0f : 1.0f];
            [self BindBuffer : Tile_BG.Vertex : Vertex_Tex_Full : Vertex_Col_tmp];
        }
        else
        {
            [self BindBuffer : Tile_BG.Vertex : Vertex_Tex_Full : Vertex_Col_Full];
        }
        
        Game_Data->effect.texture2d0.name = Tile_BG.Texture;
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, (Game_Data->Level_Data[num].Position[0] + Tile_BG.Position[0]), (Game_Data->Level_Data[num].Position[1] + Tile_BG.Position[1]), 0);
        [Game_Data->effect prepareToDraw];

        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

        if (Game_Data->Level_Data[num].Used)
        {
            [self BindBuffer : Tile_Stars_0.Vertex : Vertex_Tex_Full : Vertex_Col_Full];
            
            if (Game_Data->Level_Data[num].Stars < 1)
                Game_Data->effect.texture2d0.name = Tile_Stars_0.Texture;
            else if (Game_Data->Level_Data[num].Stars == 1)
                Game_Data->effect.texture2d0.name = Tile_Stars_1.Texture;
            else if (Game_Data->Level_Data[num].Stars == 2)
                Game_Data->effect.texture2d0.name = Tile_Stars_2.Texture;
            else
                Game_Data->effect.texture2d0.name = Tile_Stars_3.Texture;
            
            Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->effect.transform.modelviewMatrix, Tile_Stars_0.Position[0], Tile_Stars_0.Position[1], 0);
            [Game_Data->effect prepareToDraw];
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        }
    }
    else
    {
        [self NewColor : Vertex_Col_tmp : 0.7f : 0.7f : 0.7f : 1.0f];
        [self BindBuffer : Tile_BG.Vertex : Vertex_Tex_Full : Vertex_Col_tmp];
 
        Game_Data->effect.texture2d0.name = Tile_BG.Texture;
        Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, (Game_Data->Level_Data[num].Position[0] + Tile_BG.Position[0]), (Game_Data->Level_Data[num].Position[1] + Tile_BG.Position[1]), 0);
        [Game_Data->effect prepareToDraw];

        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    [self DrawObjectDigitLocal : &Tile_Digit : 2 : num];
}

-(void)DrawObjectDigitLocal : (struct Object_digit*)obj : (int) count : (int)num
{
    [self BindBuffer : obj->Vertex : Vertex_Tex_Full : Vertex_Col_Full];
    
    i = (num + 1) % 100;
    j = i % 10;
 
    Game_Data->effect.transform.modelviewMatrix = GLKMatrix4Translate(Game_Data->CameraMatrix, (Game_Data->Level_Data[num].Position[0] + obj->Position[0]), (Game_Data->Level_Data[num].Position[1] + obj->Position[1]), 0);
    
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

-(void)dealloc
{
    glDeleteTextures(1, &Texture_Error);
    glDeleteTextures(1, &Background);
    
    //Текстуры кнопок
    glDeleteTextures(1, &Tile_BG.Texture);
    glDeleteTextures(1, &Tile_Digit.Texture[0]);
    glDeleteTextures(1, &Tile_Digit.Texture[1]);
    glDeleteTextures(1, &Tile_Digit.Texture[2]);
    glDeleteTextures(1, &Tile_Digit.Texture[3]);
    glDeleteTextures(1, &Tile_Digit.Texture[4]);
    glDeleteTextures(1, &Tile_Digit.Texture[5]);
    glDeleteTextures(1, &Tile_Digit.Texture[6]);
    glDeleteTextures(1, &Tile_Digit.Texture[7]);
    glDeleteTextures(1, &Tile_Digit.Texture[8]);
    glDeleteTextures(1, &Tile_Digit.Texture[9]);
    
    glDeleteTextures(1, &Tile_Stars_0.Texture);
    glDeleteTextures(1, &Tile_Stars_1.Texture);
    glDeleteTextures(1, &Tile_Stars_2.Texture);
    glDeleteTextures(1, &Tile_Stars_3.Texture);

    glDeleteTextures(1, &Texture_Plate.Texture);
    glDeleteTextures(1, &Texture_Text_Select.Texture);
    
    glDeleteTextures(1, &Button_Back.But.Texture);

	[super dealloc];
}
@end