//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PTL_System(int timeFrame)
  {
  string str_result = "";
   text_arr_i = 0;
   ArrayFree(text_arr);
   ArrayResize(text_arr,100);
   string tfStr = ConvertTimeFrametoString(timeFrame);
   ObjectsDeleteAll(0, tfStr+"_txt_system_*");
   ObjectsDeleteAll(0, "EMA_" + tfStr+"*");

//GetTrendPrice(timeFrame);
   System_Candles_Pattern(timeFrame);
   string str_ema = System_Candlestick_EMA(timeFrame);
   string str_rs = System_ResistanceSupport(timeFrame, 500);//Vẽ Kháng cự hỗ trợ

   if((str_ema != "" || str_rs != "") && timeFrame > PERIOD_M5)
     {
      str_result =  "\n------------------*["+_Symbol+" - "+tfStr+"]*------------------" + str_ema + str_rs;
     }
   if(text_arr_i > 0 && text_arr[0] !="")
     {
      ArrayResize(text_arr, text_arr_i);
      TextONchart(timeFrame, tfStr+"_txt_system_");
     }
   return str_result;   
  }

//+------------------------------------------------------------------+
//| Tín hiệu nến khung nhỏ, kết hợp trend khung lớn để vào lệnh
//| Tín hiệu nến khung M5, tín hiệu EMA khung M15
//+------------------------------------------------------------------+
void System_M5(int timeFrame)
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string System_Candlestick_EMA(int timeFrame/*, string &text_arr[], int &text_arr_i, int maxBar = 2*/)
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   int bar_index = -1;
   string str_result = "";
   string str_candlestick = "";
   string str_ema = "";
   double price = 0;
   bool is_bullish = true;
   int ema_21 = EMA_Vs_Price(timeFrame, bar_index, 21, 21, 2);
   int ema_34 = EMA_Vs_Price(timeFrame, bar_index, 34, 34, 2);
   int ema_89 = EMA_Vs_Price(timeFrame, bar_index, 89, 34, 2);
   int pin_bar = 0;// Pinbar(timeFrame, maxBar);
   int engulfing_bar = Engulfingbar(timeFrame, 2);
   int doji_bar = Dojibar(timeFrame, 2);
   int inside_bar = Insidebar(timeFrame, 2);

   if(ema_34 != 0)
     {
      is_bullish = ema_34 > 0? true: false;
      price = ema_34 > 0? iLow(_Symbol, timeFrame, bar_index):iHigh(_Symbol, timeFrame, bar_index);
      str_ema += "\n- EMA 34: Giá Close " +(ema_34 > 0? "trên đường EMA 34 xu thế TĂNG": "dưới đường EMA 34 xu thế GIẢM")+ " tại vị trí nến thứ " + (string)bar_index;
      text_arr[text_arr_i] = "EMA 34 xu the "+ (ema_34 > 0? "TANG": "GIAM")+ " tai nen " + (string)bar_index;
      text_arr_i++;
     }
   if(ema_89 != 0)
     {
      is_bullish = ema_89 > 0? true: false;
      price = ema_89 > 0? iLow(_Symbol, timeFrame, bar_index):iHigh(_Symbol, timeFrame, bar_index);
      str_ema += "\n- EMA 89: Giá Close " +(ema_89 > 0? "trên đường EMA 89 xu thế TĂNG": "dưới đường EMA 89 xu thế GIẢM")+ " tại vị trí nến thứ " + (string)bar_index;
      text_arr[text_arr_i] = "EMA 89 xu the "+ (ema_89 > 0? "TANG": "GIAM") + " tai nen " + (string)bar_index;
      text_arr_i++;
     }
   if(str_ema == "" && ema_21 != 0)// giá không chạm ema 34 và ema 89 thì xét thêm ema 21
     {
      is_bullish = ema_21 > 0? true: false;
      price = ema_21 > 0? iLow(_Symbol, timeFrame, bar_index):iHigh(_Symbol, timeFrame, bar_index);
      str_ema += "\n- EMA 21: Giá Close " +(ema_21 > 0? "trên đường EMA 21 xu thế TĂNG": "dưới đường EMA 21 xu thế GIẢM")+ " tại vị trí nến thứ " + (string)bar_index;
      text_arr[text_arr_i] = "EMA 21 xu the "+ (ema_21 > 0? "TANG": "GIAM") + " tai nen " + (string)bar_index;
      text_arr_i++;
     }
   if(pin_bar != 0)//Xuất hiện nến pin bar
     {
      str_candlestick += "\n- Xuất hiện nến Pin bar " +(pin_bar > 0 ? "TĂNG" : "GIẢM") + " tại vị trí nến thứ " + (string)MathAbs(pin_bar);
      text_arr[text_arr_i] = "Pin bar "+(pin_bar > 0 ? "TANG" : "GIAM") + " tai nen " + (string)MathAbs(pin_bar);
      text_arr_i++;
     }
   if(engulfing_bar != 0)//Xuất hiện nến pin bar
     {
      str_candlestick += "\n- Xuất hiện nến Engulfing bar " +(engulfing_bar > 0 ? "TĂNG" : "GIẢM") + " tại vị trí nến thứ " + (string)MathAbs(engulfing_bar);
      text_arr[text_arr_i] = "Engulfing bar "+(engulfing_bar > 0 ? "TANG" : "GIAM")+ " tai nen "  + (string)MathAbs(engulfing_bar);
      text_arr_i++;
     }
   if(doji_bar != 0)//Xuất hiện nến pin bar
     {
      str_candlestick += "\n- Xuất hiện nến Doji bar  tại vị trí nến thứ " + (string)MathAbs(doji_bar);
      text_arr[text_arr_i] = "Doji bar "+(doji_bar > 0 ? "TANG" : "GIAM") + " tai nen " + (string)MathAbs(doji_bar);
      text_arr_i++;
     }
   if(inside_bar != 0)//Xuất hiện nến pin bar
     {
      str_candlestick += "\n- Xuất hiện nến Inside bar " +(inside_bar > 0 ? "TĂNG" : "GIẢM") + " tại vị trí nến thứ " + (string)MathAbs(inside_bar);
      text_arr[text_arr_i] = "Inside bar "+(inside_bar > 0 ? "TANG" : "GIAM") + " tai nen " + (string)MathAbs(inside_bar);
      text_arr_i++;
     }

   if(str_ema != "" /*&& str_candlestick != ""*/)
     {
      DrawArrow("EMA_" + tfStr, price, iTime(_Symbol, timeFrame, bar_index), is_bullish, bar_index, timeFrame);
      if(TelegramNotification == true)
        {
         //return;
         //Telegram_send("["+_Symbol+" - "+tfStr+"] - *TÍN HIỆU EMA vs NẾN*" + str_ema + str_candlestick, tele_EMA_id);
         //string p_id;
         //string s_name  = ScreenShot(timeFrame,_Symbol,"_EMA", "ptl_screenshot", true);
         //bot.SendPhoto(p_id, tele_chat_id, s_name, "*["+_Symbol+" - "+tfStr+"] - TÍN HIỆU EMA vs NẾN*" + str_ema + str_candlestick);
         str_result+= "\n---*TÍN HIỆU EMA*---" + str_ema + str_candlestick;
        }
     }
   return str_result;
  }

//+------------------------------------------------------------------+
//| Giá phá cản
//| Giá quay về test cản
//| Lý thuyết DOW
//| Market structure
//+------------------------------------------------------------------+
string System_ResistanceSupport(int timeFrame, int maxBar = 400, bool onlyDraw = false)
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   string str_result = "";
   double R_bar[1000][2] = {};
   double S_bar[1000][2] = {};
//Lấy danh sách kháng cự hỗ trợ
   Get_ResistanceSupport(timeFrame, R_bar, S_bar, maxBar);
   int R_index = ArraySize(R_bar)/2;
   int S_index = ArraySize(S_bar)/2;
//Vẽ kháng cự hỗ trợ lên chart
   ResistanceSupportGraph(timeFrame, R_bar, S_bar);
   if(onlyDraw == false)//Vẽ xong và kiểm tra kháng cự hỗ trợ theo system
     {
      string rs_result = PricePosition(timeFrame, R_bar, S_bar);
      string str_dow = PA_Dow(timeFrame, R_bar, S_bar);
      string str_ms = PA_MarketStructure(timeFrame, R_bar, S_bar);
      if(rs_result != "" || str_dow != "" || str_ms != "")
        {
         int trend_ema34 = GetTrendByEMA(_Symbol, timeFrame, 34, 34);
         string trend_result = trend_ema34 > 0 ? "\n- Xu hướng  giá khung "+tfStr+" đang TĂNG ":(trend_ema34 == 0 ? "\n- Xu hướng giá khung "+tfStr+" đang Đi Ngang " : "\n- Xu hướng giá khung "+tfStr+" đang GIẢM ");
         //text_arr[text_arr_i] = (trend_ema34 > 0 ? "Trend "+tfStr+" TANG":(trend_ema34 == 0 ? "Trend "+tfStr+" Sideway" : "Trend "+tfStr+" GIAM"));
         if(timeFrame < PERIOD_H1)//Kiểm tra xu hướng khung thời gian lớn hơn
           {
            int trend_ema34_h1 = GetTrendByEMA(_Symbol, PERIOD_H1, 34, 34);
            int trend_ema34_h4 = GetTrendByEMA(_Symbol, PERIOD_H4, 34, 34);
            trend_result += trend_ema34_h1 > 0 ? "\n- Xu hướng giá khung H1 đang TĂNG ":(trend_ema34_h1 == 0 ? "\n- Xu hướng giá khung H1 đang Đi Ngang " : "\n- Xu hướng giá khung H1 đang GIẢM ");
            trend_result += trend_ema34_h4 > 0 ? "\n- Xu hướng giá khung H4 đang TĂNG ":(trend_ema34_h4 == 0 ? "\n- Xu hướng giá khung H4 đang Đi Ngang " : "\n- Xu hướng giá khung H4 đang GIẢM ");
            //text_arr[text_arr_i] += (trend_ema34_h1 > 0 ? " ||- H1 TANG":(trend_ema34_h1 == 0 ? " ||- H1 Sideway" : " ||- H1 GIAM"));
            //text_arr[text_arr_i] += (trend_ema34_h4 > 0 ? " ||- H4 TANG":(trend_ema34_h4 == 0 ? " ||- H4 Sideway" : " ||- H4 GIAM"));
           }
         //text_arr_i++;
         //return;
            if(rs_result != "")
              {
               //string p_id;
               //string s_name  = ScreenShot(timeFrame,_Symbol,"_RS", "ptl_screenshot", true);
               //bot.SendPhoto(p_id, tele_chat_id, s_name, "*["+_Symbol+" - "+tfStr+"] - TÍN HIỆU KHÁNG CỰ - HỖ TRỢ*" + rs_result + trend_result);
              }
            if(str_dow != "")
              {
               str_result+="\n---*TÍN HIỆU DOW*---" + str_dow;
              }
            if(str_ms != "")
              {
               str_result+="\n---*TÍN HIỆU MARKET STRUCTURE*---" + str_ms;
              }
        }
     }
   return str_result;
  }
//+------------------------------------------------------------------+
//| Mô hình nến
//+------------------------------------------------------------------+
void System_Candles_Pattern(int timeFrame/*, string &text_arr[], int &text_arr_i*/)
  {
   string str_singal = "";
   string c7cb = C7CB(timeFrame);
   string c7cc = C7CC(timeFrame);
   string c7pt = C7PT(timeFrame);
//str_singal += C7BT(timeFrame);
   string c75n = C75N(timeFrame);
   string c7tt = C7TT(timeFrame);
   string c74b = C4Block(timeFrame);
   if(c7cb != "")
     {
      str_singal+= c7cb;
      text_arr[text_arr_i] = c7cb;
      text_arr_i++;
     }
   if(c74b != "")
     {
      str_singal+= c74b;
      text_arr[text_arr_i] = c74b;
      text_arr_i++;
     }
   if(c7cc != "")
     {
      str_singal+= c7cc;
      text_arr[text_arr_i] = c7cc;
      text_arr_i++;
     }
   if(c7pt != "")
     {
      str_singal+= c7pt;
      text_arr[text_arr_i] = c7pt;
      text_arr_i++;
     }
   if(c75n != "")
     {
      str_singal+= c75n;
      text_arr[text_arr_i] = c75n;
      text_arr_i++;
     }
   if(c7tt != "")
     {
      str_singal+= c7tt;
      text_arr[text_arr_i] = c7tt;
      text_arr_i++;
     }
//str_singal += Engulfingbar(timeFrame, 2);
   if(str_singal != "")
     {
      //Telegram_send("["+ConvertTimeFrametoString(timeFrame)+" - "+_Symbol+"] - *TÍN HIỆU MÔ HÌNH NẾN*\n" + str_singal, tele_PA_id);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetTrendPrice(int timeFrame = 0)
  {
   string str_trend_0 = "EMA21: ";
   int trend_ema21_m15 = GetTrendByEMA(_Symbol, PERIOD_M15, 21, 15);
   int trend_ema21_m30 = GetTrendByEMA(_Symbol, PERIOD_M30, 21, 15);
   int trend_ema21_h1 = GetTrendByEMA(_Symbol, PERIOD_H1, 21, 15);
   int trend_ema21_h4 = GetTrendByEMA(_Symbol, PERIOD_H4, 21, 15);
   str_trend_0 += (trend_ema21_m15 > 0  ? "M15 TANG":(trend_ema21_m15 == 0 ? "M15  SW  " : "M15 GIAM"));
   str_trend_0 += (trend_ema21_m30 > 0  ? " |- M30 TANG":(trend_ema21_m30 == 0 ? " |- M30  SW  " : " |- M30 GIAM"));
   str_trend_0 += (trend_ema21_h1  > 0  ? " |- H1 TANG" :(trend_ema21_h1 == 0  ? " |- H1  SW  "  : " |- H1 GIAM"));
   str_trend_0 += (trend_ema21_h4  > 0  ? " |- H4 TANG" :(trend_ema21_h4 == 0  ? " |- H4  SW  "  : " |- H4 GIAM"));

   string str_trend_1 = "EMA34: ";
   int trend_ema34_m15 = GetTrendByEMA(_Symbol, PERIOD_M15, 34, 21);
   int trend_ema34_m30 = GetTrendByEMA(_Symbol, PERIOD_M30, 34, 21);
   int trend_ema34_h1 = GetTrendByEMA(_Symbol, PERIOD_H1, 34, 21);
   int trend_ema34_h4 = GetTrendByEMA(_Symbol, PERIOD_H4, 34, 21);
   str_trend_1 += (trend_ema34_m15 > 0  ? "M15 TANG":(trend_ema34_m15 == 0 ? "M15  SW  " : "M15 GIAM"));
   str_trend_1 += (trend_ema34_m30 > 0  ? " |- M30 TANG":(trend_ema34_m30 == 0 ? " |- M30  SW  " : " |- M30 GIAM"));
   str_trend_1 += (trend_ema34_h1  > 0  ? " |- H1 TANG" :(trend_ema34_h1 == 0  ? " |- H1  SW  "  : " |- H1 GIAM"));
   str_trend_1 += (trend_ema34_h4  > 0  ? " |- H4 TANG" :(trend_ema34_h4 == 0  ? " |- H4  SW  "  : " |- H4 GIAM"));

   string str_trend_2 = "EMA89: ";
   int trend_ema89_m15 = GetTrendByEMA(_Symbol, PERIOD_M15, 89, 50);
   int trend_ema89_m30 = GetTrendByEMA(_Symbol, PERIOD_M30, 89, 50);
   int trend_ema89_h1  = GetTrendByEMA(_Symbol, PERIOD_H1, 89, 50);
   int trend_ema89_h4  = GetTrendByEMA(_Symbol, PERIOD_H4, 89, 50);
   str_trend_2 += (trend_ema89_m15 > 0  ? "M15 TANG":(trend_ema89_m15 == 0 ? "M15  SW  " : "M15 GIAM"));
   str_trend_2 += (trend_ema89_m30 > 0 ? " |- M30 TANG":(trend_ema89_m30 == 0 ? " |- M30  SW  " : " |- M30 GIAM"));
   str_trend_2 += (trend_ema89_h1 > 0  ? " |- H1 TANG" :(trend_ema89_h1 == 0  ? " |- H1  SW  "  : " |- H1 GIAM"));
   str_trend_2 += (trend_ema89_h4 > 0  ? " |- H4 TANG" :(trend_ema89_h4 == 0  ? " |- H4  SW  "  : " |- H4 GIAM"));
   DrawTrendPrice(str_trend_0, str_trend_1, str_trend_2);
  }
//+------------------------------------------------------------------+
