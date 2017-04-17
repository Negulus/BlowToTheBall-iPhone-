//
//  BlowToTheBall
//
//  Created by Negulus on 2/23/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#import "level.h"

@implementation GameLevel
-(id)init : (struct GameData*)data : (float*)pos
{
    self = [super init : data];
    if (self)
    {
        Position_Game[0] = pos[0];
        Position_Game[1] = pos[1];
        
        Graph_Indices[0] = 0;
        Graph_Indices[1] = 1;
        Graph_Indices[2] = 1;
        Graph_Indices[3] = 2;
        Graph_Indices[4] = 2;
        Graph_Indices[5] = 3;
        Graph_Indices[6] = 3;
        Graph_Indices[7] = 4;
        Graph_Indices[8] = 4;
        Graph_Indices[9] = 5;
        Graph_Indices[10] = 5;
        Graph_Indices[11] = 6;
        Graph_Indices[12] = 6;
        Graph_Indices[13] = 7;
        
        Graph_Color[0] = 1.0f;
        Graph_Color[1] = 0.0f;
        Graph_Color[2] = 0.0f;
        Graph_Color[3] = 1.0f;
        
        //Инициализация уровня
        [self GraphInit: &Amplitude];
        [self GraphInit: &Wind];
        Star_Count = 0;
        Score_Count = 0;
        Time_Life = 0;
        Amplitude_en = false;
        Wind_en = false;
        Accel_en = false;
        Run = false;
        
        //Загрузка уровня из файла
        [self Load];
    }
    return self;
}

//Загрузка уровня
-(void)Load
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *xmlPath = [path stringByAppendingPathComponent:[NSString stringWithFormat: @"level_%d.txt", (Game_Data->Level + 1)]];
    NSString *fileString = [NSString stringWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [fileString componentsSeparatedByString:@"\r\n"];
    NSArray *str;
    
    tmpb = true;
    i = 0;
    j = 0;
    while (tmpb)
    {
        if (i < lines.count)
        {
            if ([lines[i] isEqualToString: @"Amplitude"])
                tmpb = false;
            else
                j++;
        }
        else
            tmpb = false;
        i++;
    }
    
    j = 0;
    tmpb = true;
    while (tmpb)
    {
        if (i < lines.count)
        {
            if ([lines[i] isEqualToString: @"Wind"])
                tmpb = false;
            else
                j++;
        }
        else
            tmpb = false;
        i++;
    }
    Amplitude.Count = j;
    if (Amplitude.Count > 0)
    {
        Amplitude.Time = malloc(sizeof(*Amplitude.Time) * Amplitude.Count);
        Amplitude.Value = malloc(sizeof(*Amplitude.Value) * Amplitude.Count);
    }
    
    j = 0;
    tmpb = true;
    while (tmpb)
    {
        if (i < lines.count)
        {
            if ([lines[i] isEqualToString: @"Stars"])
                tmpb = false;
            else
                j++;
        }
        else
            tmpb = false;
        i++;
    }
    Wind.Count = j;
    if (Wind.Count > 0)
    {
        Wind.Time = malloc(sizeof(*Wind.Time) * Wind.Count);
        Wind.Value = malloc(sizeof(*Wind.Value) * Wind.Count);
    }
    
    j = 0;
    tmpb = true;
    while (tmpb)
    {
        if (i < lines.count)
        {
            if ([lines[i] isEqualToString: @"End"])
                tmpb = false;
            else
                j++;
        }
        else
            tmpb = false;
        i++;
    }
    Star_Count = j;
    if (Star_Count > 0)
    {
        Star = malloc(sizeof(*Star) * Star_Count);
    }
    
    i = 0;
    j = 0;
    tmpb = true;
    while (tmpb)
    {
        if (i < lines.count)
        {
            if ([lines[i] isEqualToString: @"Amplitude"])
                tmpb = false;
            else
            {
                if (i == 0)
                {
                    str = [lines[i] componentsSeparatedByString:@" "];
                    Time_Life = (float)([str[0] longLongValue]/1000.0f);
                    if ([str[1] intValue] == 1)
                        Amplitude_en = true;
                    if ([str[2] intValue] == 1)
                        Wind_en = true;
                    if ([str[3] intValue] == 1)
                        Accel_en = true;
                }
            }
        }
        else
            tmpb = false;
        i++;
        j++;
    }
    
    j = 0;
    tmpb = true;
    while (tmpb)
    {
        if (i < lines.count)
        {
            if ([lines[i] isEqualToString: @"Wind"])
                tmpb = false;
            else
            {
                str = [lines[i] componentsSeparatedByString:@" "];
                Amplitude.Time[j] = (float)([str[0] intValue]/1000.0f);
                Amplitude.Value[j] = (float)([str[1] intValue]/100.0f);
            }
        }
        else
            tmpb = false;
        i++;
        j++;
    }
    
    j = 0;
    tmpb = true;
    while (tmpb)
    {
        if (i < lines.count)
        {
            if ([lines[i] isEqualToString: @"Stars"])
                tmpb = false;
            else
            {
                str = [lines[i] componentsSeparatedByString:@" "];
                Wind.Time[j] = (float)([str[0] intValue]/1000.0f);
                Wind.Value[j] = (float)([str[1] intValue]/100.0f);
            }
        }
        else
            tmpb = false;
        i++;
        j++;
    }
    
    j = 0;
    tmpb = true;
    while (tmpb)
    {
        if (i < lines.count)
        {
            if ([lines[i] isEqualToString: @"End"])
                tmpb = false;
            else
            {
                str = [lines[i] componentsSeparatedByString:@" "];
                Star[j].Time_Start = (double)([str[0] longLongValue]/1000.0f);
                Star[j].Time_End = Star[j].Time_Start + (double)([str[1] intValue]/1000.0f);
                Star[j].Position[0] = Position_Game[0] + [str[2] floatValue];
                Star[j].Position[1] = Position_Game[1] + [str[3] floatValue];
                Star[j].Score = [str[4] intValue];
                Score_Count += Star[j].Score;
                Star[j].Origin[0] = 32;
                Star[j].Origin[1] = 32;
                Star[j].Take = false;
                Star[j].Enable = true;
                Star[j].Enable_Draw = false;
                Star[j].Time_Take = -1;
                Star[j].Time_Fade = 0.5f;
                Star[j].Opacity = 1.0f;
                Star[j].Scale = 1.0f;
            }
        }
        else
            tmpb = false;
        i++;
        j++;
    }
}

//Запуск уровня
-(void)Start
{
    if (Run)
        return;
    
    Time_Start = Game_Data->Time_Sys.Time_Total;
    Amplitude.LastTime = Game_Data->Time_Sys.Time_Total;
    Wind.LastTime = Game_Data->Time_Sys.Time_Total;
    Run = true;
}

//Обновление данных уровня
-(bool)Update
{
    [self GraphUpdate : &Amplitude];
    [self GraphUpdate : &Wind];
    
    if ((Game_Data->Time_Sys.Time_Total - Time_Start) >= Time_Life)
        return true;
    else
        return false;
}

//Инициализация графиков
-(void)GraphInit : (struct LevelGraph*)obj
{
    obj->CurTime = 0;
    obj->CurValue = 0;
    obj->Point = 0;
    obj->GraphCountUp = 0;
    obj->GraphCountDown = 0;
}

//Обновление графиков
-(bool)GraphUpdate : (struct LevelGraph*)obj
{
    if (Run)
    {
        if (obj->Point < obj->Count)
        {
            obj->CurTime = Game_Data->Time_Sys.Time_Total - obj->LastTime;
            tmpf = obj->CurTime / obj->Time[obj->Point];
            
            if (tmpf >= 1)
            {
                obj->LastTime = Game_Data->Time_Sys.Time_Total;
                obj->CurValue = obj->Value[obj->Point];
                obj->Point++;
                obj->CurTime = 0;
                if (obj->Point >= obj->Count)
                    return true;
            }
            else
            {
                if (obj->Point == 0)
                    obj->CurValue = tmpf * obj->Value[0];
                else
                    obj->CurValue = (tmpf * (obj->Value[obj->Point] - obj->Value[obj->Point - 1])) + obj->Value[obj->Point - 1];
            }
        }
        else
        {
            obj->CurTime = Game_Data->Time_Sys.Time_Total - obj->LastTime;
            obj->CurValue = obj->Value[obj->Point - 1];
            return true;
        }
    }
    return false;
}

//Обновление линий графиков
-(void)GraphLineUpdate : (struct LevelGraph*)obj
{
    if (obj->Point == 0)
        obj->GraphUp[0] = 64;
    else
        obj->GraphUp[0] = 64 + obj->Value[obj->Point - 1] * 60.0f;
    obj->GraphUp[1] = 200 + obj->CurTime * 78.125f;
    
    obj->GraphCountUp = 0;
    tmpb = true;
    j = 1;
    for (i = obj->Point; i < obj->Count; i++)
    {
        if (tmpb)
        {
            obj->GraphUp[j * 2] = 64 + obj->Value[i] * 60.0f;
            obj->GraphUp[j * 2 + 1] = obj->GraphUp[(j - 1) * 2 + 1] - (obj->Time[i] * 78.125f);
            if (obj->GraphUp[j * 2 + 1] < 0)
            {
                tmpb = false;
                obj->GraphUp[j * 2] = obj->GraphUp[(j - 1) * 2] - (obj->GraphUp[(j - 1) * 2 + 1] / (obj->GraphUp[(j - 1) * 2 + 1] - obj->GraphUp[j * 2 + 1])) * (obj->GraphUp[(j - 1) * 2] - obj->GraphUp[j * 2]);
                obj->GraphUp[j * 2 + 1] = 0;
            }
            else if (obj->GraphUp[j * 2 + 1] == 0)
            {
                tmpb = false;
            }
            j++;
            if (j >= 8)
                tmpb = false;
            obj->GraphCountUp++;
        }
        else
            break;
    }
    if (tmpb)
    {
        obj->GraphUp[j * 2] = obj->GraphUp[(j - 1) * 2];
        obj->GraphUp[j * 2 + 1] = 0;
        obj->GraphCountUp++;
    }
    
    tmpb = true;
    
    if (obj->GraphUp[1] >= 248)
    {
        tmpb = false;
        obj->GraphUp[0] = obj->GraphUp[2] + ((248 - obj->GraphUp[3]) / (obj->GraphUp[1] - obj->GraphUp[3])) * (obj->GraphUp[0] - obj->GraphUp[2]);
        obj->GraphUp[1] = 248;
    }
    
    obj->GraphDown[0] = obj->GraphUp[0];
    obj->GraphDown[1] = obj->GraphUp[1];
    obj->GraphCountDown = 0;
    j = 1;
    for (i = (obj->Point - 2); i >= -1; i--)
    {
        if (tmpb)
        {
            if (i < 0)
                obj->GraphDown[j * 2] = 64;
            else
                obj->GraphDown[j * 2] = 64 + obj->Value[i] * 60.0f;
            obj->GraphDown[j * 2 + 1] = obj->GraphDown[(j - 1) * 2 + 1] + (obj->Time[i + 1] * 78.125f);
            if (obj->GraphDown[j * 2 + 1] > 248)
            {
                tmpb = false;
                obj->GraphDown[j * 2] = obj->GraphDown[(j - 1) * 2] - ((248 - obj->GraphDown[(j - 1) * 2 + 1]) / (obj->GraphDown[j * 2 + 1] - obj->GraphDown[(j - 1) * 2 + 1])) * (obj->GraphDown[(j - 1) * 2] - obj->GraphDown[j * 2]);
                obj->GraphDown[j * 2 + 1] = 248;
            } else if (obj->GraphDown[j * 2 + 1] == 248)
            {
                tmpb = false;
            }
            j++;
            if (j >= 8)
                tmpb = false;
            obj->GraphCountDown++;
        }
        else
            break;
    }
    if (tmpb)
    {
        obj->GraphDown[j * 2] = obj->GraphDown[(j - 1) * 2];
        obj->GraphDown[j * 2 + 1] = 248;
        obj->GraphCountDown++;
    }
}


//Обновление звёздочек
-(bool)StarUpdate : (struct LevelStar*)obj : (double)time : (float)x : (float)y
{
    if (obj->Enable)
    {
        if (obj->Take)
        {
            if (obj->Time_Take < 0)
                obj->Time_Take = time;
            
            obj->Opacity = (obj->Time_Take + 0.2f - time) / 0.2f;
            if (obj->Opacity < 0)
                obj->Opacity = 0;
            obj->Scale = 1 + (1.0f - obj->Opacity) * 2.0f;
            
            if (time > obj->Time_Take + 0.2f)
                obj->Enable = false;
        }
        else if (time > obj->Time_Start)
        {
            if (time < obj->Time_End)
            {
                obj->Enable_Draw = true;
                tmpi = sqrt(pow(x - obj->Position[0], 2) + pow(y - obj->Position[1], 2));
                if (tmpi < 40)
                    return true;
                
                if (time > (obj->Time_End - obj->Time_Fade))
                {
                    obj->Opacity = (obj->Time_End - time) / obj->Time_Fade;
                    if (obj->Opacity < 0.01f)
                    {
                        obj->Opacity = 0;
                    }
                }
            }
            else
                obj->Enable_Draw = false;
        }
        else
            obj->Enable_Draw = false;
    }
    else
        obj->Enable_Draw = false;
    return false;
}

@end