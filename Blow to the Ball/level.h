//
//  BlowToTheBall
//
//  Created by Negulus on 2/23/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#ifndef BlowToTheBall_level_h
#define BlowToTheBall_level_h

#include "game.h"

@interface GameLevel : Game
{
    @public
    struct LevelGraph
    {        
        float *Time;
        float *Value;
        int Count;
        float CurTime;
        float CurValue;
        double LastTime;
        int Point;
        float GraphUp[16];
        float GraphDown[16];
        int GraphCountUp;
        int GraphCountDown;
    };
    
    struct LevelStar
    {
        float Position[2];
        float Origin[2];
        double Time_Start;
        double Time_End;
        double Time_Take;
        float Time_Fade;
        int Score;
        bool Take;
        bool Enable;
        bool Enable_Draw;
        float Opacity;
        float Scale;
    };
    
    //Данные уровня
    struct LevelGraph Amplitude;
    struct LevelGraph Wind;
    struct LevelStar *Star;
    int Star_Count;
    int Score_Count;
    float Time_Life;
    bool Amplitude_en;
    bool Wind_en;
    bool Accel_en;
    double Time_Start;
    float Position_Game[2];
    unsigned int Graph_Indices[14];
    float Graph_Color[4];
    
    //Системные переменные
    int Num;
    bool Run;
}

-(id)init : (struct GameData*)data : (float*)pos;
-(void)Load;
-(void)Start;
-(bool)Update;
-(void)GraphInit : (struct LevelGraph*)obj;
-(bool)GraphUpdate : (struct LevelGraph*)obj;
-(void)GraphLineUpdate : (struct LevelGraph*)obj;
-(bool)StarUpdate : (struct LevelStar*)obj : (double)time : (float)x : (float)y;
@end

#endif
