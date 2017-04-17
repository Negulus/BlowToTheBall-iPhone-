//
//  BlowToTheBall
//
//  Created by Negulus on 2/23/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#ifndef BlowToTheBall_menugame_h
#define BlowToTheBall_menugame_h

#import "game.h"

@interface MenuGame : Game
{
    //Кнопки
    struct Button Button_Resume;
    struct Button Button_Next;
    struct Button Button_MainMenu;
    struct Button Button_Restart;
    
    //Текстуры
    struct Object Texture_Pause;
    struct Object Texture_Win;
    struct Object Texture_Lose;
    struct Object Texture_Star_0;
    struct Object Texture_Star_1;
    struct Object Texture_Star_2;
    struct Object Texture_Star_3;
    struct Object_digit Record_Digit;
    struct Object_digit Score_Digit;
    
    //Перемещение таблички
    float Position_Start;
    float Position_End;
    float Position[2];
    bool Enable;
    double Timer_Start;
    float Time_Raise;
    
    //Таймеры
    struct Timer Timer_MenuGame;
    
    int Score_Count;
}

-(id)init : (struct GameData*)data;
-(void)dealloc;
-(void)Update;
-(void)Draw;
-(void)Touch_Begin : (float)x : (float)y;
-(void)Pause;
-(void)Win : (int)score;
-(void)Lose;
-(void)Reset;
@end


#endif
