//+------------------------------------------------------------------+
//|                                                  LuanPham_EA.mq4 |
//|                                                        Luan Pham |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luan Pham"
#property link      ""
#property version   "1.00"
#property strict

#include <stdlib.mqh>
#include <PTL_EA/PTL_Systems.mqh>
#include <PTL_EA/_Utilities.mqh>
#include <PTL_EA/_DrawSignal.mqh>
#include <Telegram.mqh>
#include <PTL_EA/PTL_MyBot.mqh>
#include <PTL_EA/_PriceAction.mqh>
#include <PTL_EA/_PriceOpen.mqh>
#include <PTL_EA/_EMA.mqh>
#include <PTL_EA/_Trend.mqh>
#include <PTL_EA/_CandlestickPatterns.mqh>
#include <PTL_EA/_ResistanceSupport.mqh>

input ENUM_LANGUAGES    InpLanguage=LANGUAGE_VN;//Language
input string TelegramToken = "927322228:AAFxIy4Tw_rfZr6LEoyO5tocsMNBxwNXIHI";
extern bool TelegramNotification = true;
//extern bool MobileNotification = false;
//extern bool EmailNotification = false;
extern string Pair_suffix = "";//pair prefix
input ENUM_UPDATE_MODE  InpUpdateMode=UPDATE_NORMAL;//Update Mode
input string            InpTemplates="ptl_screenshot;ptl_screenshot_zoom";
bool isBigMove= false;

long tele_EMA_id = -1001181930926;//-1001415417026;
long tele_PA_id = -1001207582460;//-1001200978562;
long tele_SR_id = -1001158562267;//-1001364314480;
long tele_chat_id = -1;
string list_pairs = "XAUUSD.yt,GBPUSD.yt,EURUSD.yt,EURJPY.yt, GBPJPY.yt,USDJPY.yt,USDCAD.yt";
int text_arr_i = 0;
string text_arr[100];
CMyBot bot;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   string broker = AccountInfoString(ACCOUNT_SERVER);
   if(StringFind(broker,"AxiTrader") >= 0)
      Pair_suffix = ".pro";
   if(StringFind(broker,"Think") >= 0)
      Pair_suffix = "x";
   if(StringFind(broker,"Yulo") >= 0)
      Pair_suffix = ".yt";

   bot.Token(TelegramToken);
   bot.Language(InpLanguage);
   bot.Templates(InpTemplates);
   tele_chat_id = GetTeleTokenPair();
   System_ResistanceSupport(Period(), 500, true);//Vẽ Kháng cự hỗ trợ
//--- set timer
   EventSetMillisecondTimer(1000);
   OnTimer();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//ObjectsDeleteAll(0, "_RS_*");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+-------------1-----------------------------------------------------+
void start()
  {
   if(TimeHour(TimeLocal()) < 6 || TimeHour(TimeLocal()) > 23)
     {
      return;
     }
// return;
//ObjectsDeleteAll(0, "*txt_system_*");

   if(StringFind(_Symbol,"GBPJPY") >= 0 /*|| StringFind(_Symbol,"GBPUSD") >= 0  || StringFind(_Symbol,"EURJPY") >= 0*/)
     {
      //PTL_System(5);
      //string filename ="D://"+ _Symbol +"_" +TimeCurrent() + ".png";
      //PlaySound("news.wav");
     }
   if(isNewBar(PERIOD_M1))
     {
      if(StringFind(_Symbol,"EURJPY") >= 0 /*|| StringFind(_Symbol,"GBPUSD") >= 0  || StringFind(_Symbol,"EURJPY") >= 0*/)
        {
         //PTL_System(PERIOD_M5);
         //string p_id;
         //string s_name  = ScreenShot(PERIOD_M5, false);
         //bot.SendPhoto(p_id, -1001200978562, s_name, s_name);
        }
      isBigMove = false;
     }

   if(isNewBar(PERIOD_M5))
     {
      PTL_System(PERIOD_M5);
      //System_ResistanceSupport(PERIOD_M5, 500, true);//Vẽ Kháng cự hỗ trợ
      //ChartSetSymbolPeriod(NULL, _Symbol, PERIOD_M5);
      //if(StringFind(_Symbol,"XAUUSD") >= 0 || StringFind(_Symbol,"GBPUSD") >= 0)
      //   PTL_System(PERIOD_M5);
      //RS_Analysis(PERIOD_M5);
     }
   if(isNewBar(PERIOD_M15))
     {
      //System_ResistanceSupport(PERIOD_M15, 500);//Vẽ Kháng cự hỗ trợ
      //RS_Analysis(PERIOD_M15);
      //ChartSetSymbolPeriod(NULL, _Symbol, PERIOD_M15);
      PTL_System(PERIOD_M15);
     }
   if(isNewBar(PERIOD_M30))
     {
      //System_ResistanceSupport(PERIOD_M30, 500);//Vẽ Kháng cự hỗ trợ
      //RS_Analysis(PERIOD_M30);
      //ChartSetSymbolPeriod(NULL, _Symbol, PERIOD_M30);
      PTL_System(PERIOD_M30);
     }
   if(isNewBar(PERIOD_H1))
     {
      //RS_Analysis(PERIOD_H1);
      //ChartSetSymbolPeriod(NULL, _Symbol, PERIOD_H1);
      //System_ResistanceSupport(PERIOD_H1, 500);//Vẽ Kháng cự hỗ trợ
      PTL_System(PERIOD_H1);
     }
   if(isNewBar(PERIOD_H4))
     {
      //System_ResistanceSupport(PERIOD_H4, 500);//Vẽ Kháng cự hỗ trợ
      //PTL_System(PERIOD_H4);
     }
   if(isNewBar(PERIOD_D1))
     {

     }
   if(isBigMove==false)
     {
      string strBigMove = CheckBarBigMove(PERIOD_M1);
      if(strBigMove != "")
        {
         isBigMove = true;
         Sleep(500);
         //string p_id;
         //string s_name  = ScreenShot(PERIOD_M5,_Symbol,"_BigMove", "ptl_screenshot", true);
         //bot.SendPhoto(p_id, tele_PA_id, s_name, strBigMove);
         //bot.SendMessage(tele_chat_id, strBigMove);
        }

     }
//Comment(trendOverview + str_singals);
  }

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   PriceOpenGraph();//Vẽ line giá mở cửa
   GetTrendPrice();

   if(StringFind(_Symbol,"GBPJPY") >= 0)
     {
       //bot.GetUpdates();
       //bot.ProcessMessages();
     }
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
