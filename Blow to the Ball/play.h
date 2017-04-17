//
//  BlowToTheBall
//
//  Created by Negulus on 2/23/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#ifndef BlowToTheBall_play_h
#define BlowToTheBall_play_h

#import "game.h"
#import "level.h"
#import "menugame.h"

struct HelpPlate
{
    struct Object Obj;
    bool Enable;
    float Opacity;
    float TimeLife;
    float TimeRaise;
    float TimeFade;
    bool Hold;
    bool Once;
    double StartTime;
};

@interface Play : Game
{
    //Игровые объекты
    GLuint Background;
    GLuint Graph_on;
    GLuint Graph_off;
    struct Object Ball;
    struct Object Zone;
    struct Object Vent;
    struct Object Post_G;
    struct Object Post_Y;
    struct Object Post_R;
    struct Object Arrow;
    struct Object Arrow_BG;
    struct Object Graph_R;
    struct Object Graph_L;
    struct Object Star;
    struct Button Button_Pause;
    
    float Ball_Speed[2];
    float Ball_Origin[2];
    
    @public
    GameLevel *Game_Level;
    MenuGame *Menu_Game;
    
    @protected
    //Текстуры очков
    struct Object Record;
    struct Object Score;
    struct Object_digit Score_Digit;
    struct Object_digit Record_Digit;
    
    //Текстуры таймера
    struct Object Timer_Obj;
    struct Object_digit Timer_Digit;
    
    //Точки игры
    float Position_Start[2];
    float Position_Game[2];
    float Position_tmp[2];
    float Vertex_tmp[8];
    float Vertex_tmp_2[8];
        
    //Таймеры
    struct Timer Timer_Play;
    
    //Таймер возврата
    struct Object Texture_Return_1;
    struct Object Texture_Return_2;
    struct Object Texture_Return_3;
    float Return_Timer;
    
    //Таблички помощи
    struct HelpPlate Help_Plate_1;
    struct HelpPlate Help_Plate_2;
    struct HelpPlate Help_Plate_3;
    
    @public
    int Return_Time;
    bool Return_En;
    
    @protected
    //Переменные для звуков
    float Sound_Fan_Volume;
    bool Sound_Fan_Run;
    double Sound_Fan_Start;
    
    //Системные переменные
    double GameStartTime;
    @public
    double GamePauseTime;
    @protected
    int Time_Left;
    bool Draw_Win;
    bool Game_Wait;
    bool Game_Begin;
    bool Game_Start;
    bool Game_Run;
    bool Game_End;
    bool touch;
}

-(id)init : (struct GameData*)data;
-(void)dealloc;
-(void)Update;
-(void)Draw;
-(void)Touch_Begin : (float)x : (float)y;
-(void)Touch_End;
-(void)DrawObjectLocal : (struct Object*)obj : (float)opacity;
@end

#endif