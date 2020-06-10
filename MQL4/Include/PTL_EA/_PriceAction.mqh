//+------------------------------------------------------------------+
//|                                                 _PriceAction.mqh |
//|                                                        Luan Pham |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luan Pham"
#property link      ""
#property strict

//+------------------------------------------------------------------+
//| Kiểm tra sự biến động của nến, nếu bất ngờ có chuyển động lớn thì báo để theo dõi |
//+------------------------------------------------------------------+
string CheckBarBigMove(int timeFrame)
  {
   double low=iLow(_Symbol,timeFrame,0);
   double high = iHigh(_Symbol, timeFrame, 0);
   double open = iOpen(_Symbol, timeFrame, 0);
   double close= iClose(_Symbol,timeFrame,0);
   double pips = TinhSoPips(low,high);
   if(pips>=19 && StringFind(_Symbol,"XAU")==-1)
     {
      string tfStr=ConvertTimeFrametoString(timeFrame);
      if(close > open)
        {
         return "["+tfStr+" - "+_Symbol+"] - Giá đang biến động mạnh - TĂNG \n Giá đang dao động mạnh với số pips: "+(string)NormPrice(pips);
        }
      else
        {
         return "["+tfStr+" - "+_Symbol+"] - Giá đang biến động mạnh - GIẢM \n Giá đang dao động mạnh với số pips: "+(string)NormPrice(pips);
        }
     }
   return "";
  }

//+------------------------------------------------------------------+
//| Phân tích đường giá theo kháng cự hỗ trợ, hành  vi giá
//+------------------------------------------------------------------+
void PA_TrendLine(int timeFrame, int maxBar = 50)// Hành vi giá với trendline
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   double high_prev = iHigh(_Symbol, timeFrame, 1);
   double low_prev = iLow(_Symbol, timeFrame, 1);
   double open_prev = iOpen(_Symbol, timeFrame, 1);
   double close_prev = iClose(_Symbol, timeFrame, 1);
//int localTrend =  GetTrendByEMA(_Symbol,timeFrame,89,34);
//if(localTrend == 0)
//   localTrend =  GetTrendByEMA(_Symbol,timeFrame,89,89);

   for(int i=0; i<ObjectsTotal(); i++)
     {
      double trend_price;
      string name=ObjectName(i);
      //Trendline
      if(((ObjectType(name)==OBJ_TREND) || (ObjectType(name)== OBJ_HLINE)) && StringFind(name, "Open") == -1 && StringFind(name,"Monday") == -1 && StringFind(name,"MS") == -1)
        {
         if(ObjectType(name)==OBJ_TREND)
           {
            trend_price = ObjectGetValueByShift(name, 0);
           }
         else
           {
            trend_price=ObjectGet(name, OBJPROP_PRICE1);
           }
         if(trend_price >= low_prev && trend_price <= high_prev && StringFind(name,"Equillibrium") < 0)//nến trước đó cắt trendline
           {
            if(StringFind(name,"Trendline") != -1 || StringFind(name,"Horizontal") != -1 )
               name = "TRENDLINE";
            //RS_PriceTrend_Analysis(timeFrame, close_prev, trend_price, name);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PA_Orderblock(int timeFrame, int maxBar = 50)// Hành vi giá với OrderBlock
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   double high_prev = iHigh(_Symbol, timeFrame, 1);
   double low_prev = iLow(_Symbol, timeFrame, 1);
   double open_prev = iOpen(_Symbol, timeFrame, 1);
   double close_prev = iClose(_Symbol, timeFrame, 1);

   for(int i=0; i<ObjectsTotal(); i++)
     {
      string name=ObjectName(i);
      if(ObjectType(name)==OBJ_RECTANGLE)
        {
         double p_top=ObjectGet(name, OBJPROP_PRICE1);
         double p_bottom =ObjectGet(name, OBJPROP_PRICE2);
         double p_medium = (p_bottom + p_top)/2;
         //int price_vs_trend = RS_Price_Trend(timeFrame, p_medium, 2, 10);
         if((low_prev > p_bottom && low_prev < p_top) || (high_prev > p_bottom && high_prev < p_top)) //nến trước đó cắt ob
           {
/*
            if(close_prev > p_medium  && price_vs_trend == -1)// nến close trên trendline và xu hướng tăng
              {
               Telegram_send("_[" +tfStr +" - " +_Symbol+ "]_ - *ORDER BLOCK - TĂNG* \n- Giá đang test Order Block tại: " + (string)NormPrice(p_top), tele_SR_id);

              }
            else
               if(close_prev < p_medium && price_vs_trend == 1)// nến close dưới trendline và xu hướng giảm
                 {
                  //Mail_send("Duong gia cat Order Block - GIAM", "Pair: " + _Symbol + "\n Gia dang test Order Block tai " + (string)NormalizeDouble(p_bottom,5));
                  Telegram_send("_[" +tfStr +" - " +_Symbol+ "]_ - *ORDER BLOCK - GIẢM* \n- Giá đang test Order Block tại: " + (string)NormPrice(p_top), tele_SR_id);

                 }
                 */
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Swing Failure Pattern: săn stop loss để di chuyển lên/xuống
//| Kiểm tra nến vừa đóng có thuộc swing high hay swing low không
//| Kích thước cây nến phải khoảng 10 pips trở lên
//+------------------------------------------------------------------+
void SwingFailurePattern(int timeFrame)
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   int highest_idx = iHighest(_Symbol, timeFrame,MODE_HIGH, 5, 1);
   int lowest_idx = iLowest(_Symbol, timeFrame,MODE_LOW, 5, 1);
   if(highest_idx == 1)// nến số 1 có high cao nhất
     {
      //Kiểm tra râu của nến này có dài không để xác định giá vừa stop hunt
      double low = iLow(_Symbol, timeFrame,highest_idx);
      double high = iHigh(_Symbol, timeFrame,highest_idx);
      double open = iOpen(_Symbol, timeFrame,highest_idx);
      double close = iClose(_Symbol, timeFrame,highest_idx);
      double pips_bar = TinhSoPips(low, high);
      double pips_h = TinhSoPips(high, open > close?open:close);
      if(pips_bar >=15 && pips_h >= 5)
        {
         int highest_idx_prev = iHighest(_Symbol, timeFrame, MODE_HIGH, 10, 2);
         if(highest_idx_prev > 0 && highest_idx_prev <= 5)
           {
            double high_prev = iHigh(_Symbol, timeFrame,highest_idx_prev);
            if(high_prev > close)
              {
               Telegram_send("_[" +tfStr +" - " +_Symbol+ "]_ - *SWING FAILURE PATTERN - DOWNSIDE* \n Giá đã tạo SFP Swing High tại vị trí nến: " + (string)highest_idx + " và nến số: " +(string)highest_idx_prev, tele_PA_id);
              }
           }
        }
     }
   else
      if(lowest_idx == 1)
        {
         //Kiểm tra râu của nến này có dài không để xác định giá vừa stop hunt
         double low = iLow(_Symbol, timeFrame,lowest_idx);
         double high = iHigh(_Symbol, timeFrame,lowest_idx);
         double open = iOpen(_Symbol, timeFrame,lowest_idx);
         double close = iClose(_Symbol, timeFrame,lowest_idx);
         double pips_l = TinhSoPips(low, open < close?open:close);
         double pips_bar = TinhSoPips(low, high);
         if(pips_bar >= 15 && pips_l >= 5)
           {

            int lowest_idx_prev = iLowest(_Symbol, timeFrame, MODE_LOW, 10, 2);
            if(lowest_idx_prev > 0 && lowest_idx_prev <= 5)
              {
               double low_prev = iLow(_Symbol, timeFrame,lowest_idx_prev);
               if(low_prev < close)
                 {
                  Telegram_send("_[" +tfStr +" - " +_Symbol+ "]_ - *SWING FAILURE PATTERN - UPSIDE* \n Giá đã tạo SFP Swing Low tại vị trí nến: " + (string)lowest_idx + " và nến số: " +(string)lowest_idx_prev, tele_PA_id);
                 }
              }
           }
        }
  }