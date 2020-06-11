//+------------------------------------------------------------------+
//|                                            ResistanceSupport.mqh |
//|                                                        Luan Pham |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luan Pham"
#property link      ""
#property strict

//+------------------------------------------------------------------+
//Xu hướng giảm, giá tăng chạm và close dưới kháng cự => xem xét có phải tăng hồi phục để tiếp tục xu hướng giảm không.
//Xu hướng tăng, giá giảm chạm và close trên hỗ trợ => xem xét có phải giảm hồi phục để tiếp tục xu hướng tăng không.
//+------------------------------------------------------------------+
string PA_Dow(int timeFrame, double &R_bar[][2], double &S_bar[][2])
  {
   string rs_result = "";
   int r_index = ArraySize(R_bar)/2;
   int s_index = ArraySize(S_bar)/2;
   int trend_ema34 = GetTrendByEMA(_Symbol, timeFrame, 21, 34);
   double close_1 = iClose(_Symbol, timeFrame, 1);
   double low_1 = iLow(_Symbol, timeFrame, 1);
   double high_1 = iHigh(_Symbol, timeFrame, 1);
   if(r_index >= 2 && s_index >= 2)
     {
      double r_price_0 = R_bar[0][1];
      int r_index_0    = (int)R_bar[0][0];//Đỉnh 0
      double r_price_1 = R_bar[1][1];
      int r_index_1    = (int)R_bar[1][0];//Đỉnh 1
      double s_price_0 = S_bar[0][1];
      int s_index_0    = (int)S_bar[0][0];//Đáy 0
      double s_price_1 = S_bar[1][1];
      int s_index_1    = (int)S_bar[1][0];//Đáy 1

      if(r_price_0 > low_1 && r_price_0 < high_1 && r_price_0 < close_1)//Giá cắt kháng cự và close trên đường kháng cự
        {
         if(s_price_0 > s_price_1 && s_price_0 < r_price_0)// đáy sau cao hơn đáy trước, đáy sau thấp hơn đỉnh
           {
            if(s_index_0 < r_index_0 && r_index_0 < s_index_1)//đỉnh nằm giữa 2 đáy
              {
               rs_result += "\nMô hình lý thuyết DOW dự đoán giá TĂNG.";//check thêm điều kiện để tuân thủ theo lý thuyết DOW
               text_arr[text_arr_i] = "Mo hinh ly thuyet DOW gia TANG";
               text_arr_i++;
              }
           }
        }

      if(s_price_0 > low_1 && s_price_0 < high_1 && s_price_0 > close_1)//Giá cắt hỗ trợ và close dưới đường hỗ trợ
        {
         if(r_price_0 < r_price_1 && s_price_0 < r_price_0)// đỉnh sau thấp hơn đỉnh trước, đáy thấp hơn đỉnh sau
           {
            if(r_index_0 < s_index_0 && s_index_0 < r_index_1)//đáy nằm giữa 2 đỉnh
              {
               rs_result += "\nMô hình lý thuyết DOW dự đoán giá GIẢM.";
               text_arr[text_arr_i] = "Mo hinh ly thuyet DOW gia GIAM";
               text_arr_i++;
              }
           }
        }
     }
   return rs_result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PA_MarketStructure(int timeFrame, double &R_bar[][2], double &S_bar[][2])
  {
   string rs_result = "";
   int r_index = ArraySize(R_bar)/2;
   int s_index = ArraySize(S_bar)/2;
   int trend_ema34 = GetTrendByEMA(_Symbol, timeFrame, 34, 34);
   double close = iClose(_Symbol, timeFrame, 1);
   double low = iLow(_Symbol, timeFrame, 1);
   double high = iHigh(_Symbol, timeFrame, 1);
   if(r_index > 2 && s_index >= 2)//Kiểm tra Dow tăng
     {
      double high_0    = R_bar[0][1];
      int high_index_0 = (int)R_bar[0][0];//Đỉnh 0
      double high_1    = R_bar[1][1];
      int high_index_1 = (int)R_bar[1][0];//Đỉnh 1
      double low_0     = S_bar[0][1];
      int low_index_0  = (int)S_bar[0][0];//Đáy 0
      double low_1     = S_bar[1][1];
      int low_index_1   = (int)S_bar[1][0];//Đáy 1

      if(high_0 > high_1 && low_0 > low_1 && high_1 > low_0 && low < high_1 && high > high_1 && close > high_1 && close < high_0)//Đỉnh cao hơn đáy và giá close trên đỉnh 1
        {
         if(high_index_0 < low_index_0 && low_index_0 < high_index_1 && high_index_1 < low_index_1)
           {
            rs_result += "\nMô hình Market Structure dự đoán giá TĂNG.";
            text_arr[text_arr_i] = "Mo hinh Market Structure gia TANG.";
            text_arr_i++;
           }
        }
      if(high_0 < high_1 && low_0 < low_1 && high_0 > low_1 && low < low_1 && high > low_1 && close < low_1 && close > low_0)
        {
         if(low_index_0 < high_index_0 && high_index_0 < low_index_1 && low_index_1 < high_index_1)
           {
            rs_result += "\nMô hình Market Structure dự đoán giá GIẢM.";
            text_arr[text_arr_i] = "Mo hinh Market Structure gia GIAM.";
            text_arr_i++;
           }
        }
     }
   return rs_result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PricePosition(int timeFrame, double &R_bar[][2], double &S_bar[][2])
  {
   string rs_result = "";
   int r_index = ArraySize(R_bar)/2;
   int s_index = ArraySize(S_bar)/2;
   int trend_ema34 = GetTrendByEMA(_Symbol, timeFrame, 34, 34);
   double close_1 = iClose(_Symbol, timeFrame, 1);
   double low_1 = iLow(_Symbol, timeFrame, 1);
   double high_1 = iHigh(_Symbol, timeFrame, 1);

   for(int i = 0; i < r_index; i++)
     {
      double r_price = R_bar[i][1];
      if(r_price > low_1 && r_price < high_1  && R_bar[i][0] > 2)//Giá cắt kháng cự, vị trí cản cách vị trí đang xét từ 3 cây nến trở lên
        {
         int bar_cross_prev = GetBarCrossRS(timeFrame, (double)R_bar[i][1], 2,(int)R_bar[i][0]);//Lấy số lần đường giá cắt qua cản
         if(r_price > close_1 && bar_cross_prev == 0 && R_bar[i][0] >= 5)//Giá Close dưới kháng cự và Giá chưa cắt kháng cự lần nào, vị trí cản cách vị trí đang xét từ 5 cây nến trở lên
           {
            rs_result += "\nGiá chạm kháng cự và đóng cửa dưới đường kháng cự.";
            text_arr[text_arr_i] = "Gia cham Khang Cu va dong cua duoi duong Khang cu";
            text_arr_i++;
           }
        }
     }
   for(int i = 0; i < s_index; i++)
     {
      double s_price = S_bar[i][1];
      if(s_price > low_1 && s_price < high_1  && S_bar[i][0] > 2)//Giá cắt hỗ trợ, vị trí cản cách vị trí đang xét từ 3 cây nến trở lên
        {
         int bar_cross_prev = GetBarCrossRS(timeFrame, (double)S_bar[i][1], 2,(int)S_bar[i][0]);//Lấy số lần đường giá cắt qua cản
         if(s_price < close_1 && bar_cross_prev == 0 && S_bar[i][0] >= 5)//Giá Close trên hỗ trợ và Giá chưa cắt hỗ trợ lần nào, vị trí cản cách vị trí đang xét từ 5 cây nến trở lên
           {
            rs_result += "\nGiá chạm hỗ trợ và đóng cửa trên đường hỗ trợ.";
            text_arr[text_arr_i] = "Gia cham Ho tro va dong cua tren duong Ho Tro";
            text_arr_i++;
           }
        }
     }
   return rs_result;
  }

//Đếm số lần đường giá cắt qua kháng cự hỗ trợ
int GetBarCrossRS(int timeFrame, double rs_price, int start_bar, int end_bar)
  {
   int cross_num = 0;
   for(int i = start_bar; i< end_bar; i++)
     {
      double low_i = iOpen(_Symbol, timeFrame, i) < iClose(_Symbol, timeFrame, i) ? iOpen(_Symbol, timeFrame, i) : iClose(_Symbol, timeFrame, i);
      double high_i = iOpen(_Symbol, timeFrame, i) > iClose(_Symbol, timeFrame, i) ? iOpen(_Symbol, timeFrame, i) : iClose(_Symbol, timeFrame, i);
      if(rs_price > low_i && rs_price < high_i)
         cross_num++;
     }
   return cross_num;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Get_ResistanceSupport(int timeFrame, double &R_bar[][2],double &S_bar[][2], int maxBar = 400)
  {
   double HL_bar[1000][2];
   int HL_size;
//ArrayFree(HL_bar);
//printf("Size " + ArraySize(R_bar));
//ArrayResize(R_bar, 1000);
//ArrayResize(S_bar, 1000);
//int HL_bar[1000];//Mảng để lưu vị trí nến cao nhất/ thấp nhất
   int HL_index = 0; //Lưu số lượng nến cao/thấp
   double high_tmp=0, low_tmp=0;

   int hl_pips_dis = 10;//khoảng cách tối thiểu giữa đỉnh và đáy gần nhất là 5 pips, nếu ở timeFrame lớn thì 10 pips/15 pips/20 pips
   if(timeFrame == 60)
      hl_pips_dis = 15;
   if(timeFrame >= 240)
      hl_pips_dis = 25;
   if(StringFind(_Symbol,"XAUUSD") != -1)
      hl_pips_dis = hl_pips_dis+5;

   bool is_Find_Low = false;
   int bar_high_first = iHighest(_Symbol, timeFrame, MODE_CLOSE, 10, maxBar - 10);//Lấy đỉnh đầu tiên
   int bar_low_first = iLowest(_Symbol, timeFrame, MODE_CLOSE, 10, maxBar - 10);//Lấy đáy đầu tiên
   if(bar_low_first > bar_high_first)//low xa hơn high => bắt đầu duyệt với vị trí đầu tiên là low
     {
      low_tmp = iClose(_Symbol, timeFrame, bar_low_first);
      high_tmp = low_tmp;// iClose(_Symbol, timeFrame, bar_high_first);
      HL_bar[HL_index][0] = bar_low_first;
      HL_bar[HL_index][1] = low_tmp;
      HL_index++;
      maxBar = bar_low_first-1;//gán lại vị trí để tìm high tiếp theo
      is_Find_Low = false;
     }
   else
      if(bar_low_first < bar_high_first)//low xa hơn high => bắt đầu duyệt với vị trí đầu tiên là low
        {
         high_tmp = iClose(_Symbol, timeFrame, bar_high_first);
         low_tmp = high_tmp;// iClose(_Symbol, timeFrame, bar_low_first);

         HL_bar[HL_index][0] = bar_high_first;
         HL_bar[HL_index][1] = high_tmp;
         HL_index++;
         maxBar = bar_high_first-1;//gán lại vị trí để tiếp tục tìm low tiếp theo
         is_Find_Low = true;
        }

   int high_idx_tmp = 0, low_idx_tmp = 0;
   while(maxBar >= 2)
     {
      double open = iOpen(_Symbol, timeFrame, maxBar);
      double close = iClose(_Symbol, timeFrame, maxBar);
      double wick_high = iHigh(_Symbol, timeFrame, maxBar);//Lấy râu nến phía trên
      double wick_low = iLow(_Symbol, timeFrame, maxBar);//Lấy râu nến phía dưới
      double high =  close > open ? close : open;//Lấy giá cao
      double low =  close < open ? close : open;//Lấy giá thấp
      if(TinhSoPips(wick_high, high) <= 1)//Nếu râu nến dài không quá 1 pip thì lấy râu luôn
         high = wick_high;
      if(TinhSoPips(wick_low, low) <= 1)//Nếu râu nến dài không quá 1 pip thì lấy râu luôn
         low = wick_low;

      if(is_Find_Low == false)//Tìm high
        {
         //double pips_hl = TinhSoPips(low_prev, high);// Số pip giữa low và high đang tìm
         if(high > high_tmp)// nếu high lớn hơn high cũ thì gán bình thường vào các giá trị tạm thời
           {
            high_idx_tmp = maxBar;
            high_tmp = high;
            //idx = 0;
           }
         else
            if(TinhSoPips(high_tmp, low) >= hl_pips_dis)// khoảng cách pip tối thiểu của nến này với low thì giá trị high trước chính là high, cập nhật lại các giá trị low tạm thời
              {
               low_idx_tmp = maxBar;
               low_tmp = low;
               //high_prev = high;
               HL_bar[HL_index][0] = high_idx_tmp;
               HL_bar[HL_index][1] = high_tmp;
               HL_index++;
               is_Find_Low = true;
              }
            else
               if(low < low_tmp)//tìm chưa ra high nhưng phát hiện low thấp hơn thì cập nhật lại low prev, nhảy high lại low này để tiếp tục tìm high
                 {
                  low_tmp = low;
                  high_tmp = low;
                  low_idx_tmp = maxBar;
                  high_idx_tmp = maxBar;
                  HL_bar[HL_index][0] = maxBar;
                  HL_bar[HL_index][1] = low;
                 }
        }
      else //Tìm low
        {
         if(low < low_tmp)// nếu low nhỏ hơn low cũ thì gán bình thường
           {
            low_idx_tmp = maxBar;
            low_tmp = low;
           }
         else
            if(TinhSoPips(low_tmp, high) >= hl_pips_dis)// khoảng cách pip tối thiểu của nến này với high thì giá trị high trước chính là low
              {
               high_idx_tmp = maxBar;
               high_tmp = high;
               //high_prev = high;
               HL_bar[HL_index][0] = low_idx_tmp;
               HL_bar[HL_index][1] = low_tmp;
               HL_index++;
               is_Find_Low = false;
              }
            else
               if(high > high_tmp)//tìm chưa ra low nhưng phát hiện high cao hơn thì cập nhật lại high prev, nhảy low lại high này để tiếp tục tìm low
                 {
                  low_tmp = high;
                  high_tmp = high;
                  low_idx_tmp = maxBar;
                  high_idx_tmp = maxBar;
                  HL_bar[HL_index][0] = maxBar;
                  HL_bar[HL_index][1] = high;

                 }
        }
      maxBar--;
     }
   HL_size = HL_index;
   ArrayResize(HL_bar, HL_index);
//printf("M " + HL_bar[HL_index-1][0] );
//---------- Chuẩn hóa lại kháng cự hỗ trợ ------------
   int R_index = 0;
   int S_index = 0;
   int pips_range = 10;
   if(HL_size <=1)
      return;
   if(HL_bar[HL_size-1][1] > HL_bar[HL_size-2][1])// bắt đầu là kháng cự
     {
      R_bar[0][0] = HL_bar[HL_size-1][0];
      R_bar[0][1] = HL_bar[HL_size-1][1];
      for(int i = HL_size-1; i>=0; i = i-2)//Ghi kháng cự vào mảng
        {
         double pips = TinhSoPips(R_bar[R_index][1], HL_bar[i][1]);
         //int checkRS = CheckRSValid(timeFrame, (int)HL_bar[i][0], HL_bar[i][1], R_index, true);
         int checkRS = CheckRSValid(timeFrame, (int)HL_bar[i][0], HL_bar[i][1], R_index, true);
         //Kiểm tra điểm kháng cự còn giá trị hay không.
         //Điểm kháng cự không còn giá trị khi nó nằm dưới đường giá hoặc khi nó bị giao cắt quá nhiều lần

         if(pips >= pips_range && checkRS >= 0 /*&& checkRS < 2*/)//số pips đủ lớn để thành kháng cự
           {
            R_index++;
            R_bar[R_index][0] = HL_bar[i][0];
            R_bar[R_index][1] = HL_bar[i][1];
           }
         else
            if(pips < pips_range && R_bar[R_index][1] < HL_bar[i][1] /*&& checkRS >=0*/)// pips nhỏ hơn, và đỉnh i cao hơn đỉnh có
              {
               R_bar[R_index][0] = HL_bar[i][0];
               R_bar[R_index][1] = HL_bar[i][1];
              }
        }
      S_bar[0][0] = HL_bar[HL_size-2][0]; //Ghi hỗ trợ vào mảng
      S_bar[0][1] = HL_bar[HL_size-2][1];
      for(int i = HL_size-2; i >=0; i = i-2)
        {
         double pips = TinhSoPips(S_bar[S_index][1], HL_bar[i][1]);
         int checkRS = CheckRSValid(timeFrame, (int)HL_bar[i][0], HL_bar[i][1], S_index, false);
         if(pips >=pips_range && checkRS >= 0 /*&& checkRS < 2*/)//số pips đủ lớn để thành Hỗ trợ
           {
            S_index++;
            S_bar[S_index][0] = HL_bar[i][0];
            S_bar[S_index][1] = HL_bar[i][1];

           }
         else
            if(pips < pips_range && S_bar[S_index][1] > HL_bar[i][1] /*&& checkRS >=0*/)// pips nhỏ hơn, và đỉnh i cao hơn đỉnh có
              {
               S_bar[S_index][0] = HL_bar[i][0];
               S_bar[S_index][1] = HL_bar[i][1];
              }
        }
     }
   else//bắt đầu là hỗ trợ
     {
      S_bar[0][0] = HL_bar[HL_size-1][0];
      S_bar[0][1] = HL_bar[HL_size-1][1];
      for(int i = HL_size-1; i >=0; i = i-2) //Ghi hỗ trợ vào mảng
        {
         double pips = TinhSoPips(S_bar[S_index][1], HL_bar[i][1]);
         int checkRS = CheckRSValid(timeFrame, (int)HL_bar[i][0], HL_bar[i][1], S_index, false);
         if(pips >=pips_range && checkRS >= 0 /*&& checkRS < 2*/)//số pips đủ lớn để thành Hỗ trợ
           {
            S_index++;
            S_bar[S_index][0] = HL_bar[i][0];
            S_bar[S_index][1] = HL_bar[i][1];
           }
         else
            if(pips < pips_range && S_bar[S_index][1] > HL_bar[i][1] /*&& checkRS >=0*/)// pips nhỏ hơn, và đỉnh i cao hơn đỉnh có
              {
               S_bar[S_index][0] = HL_bar[i][0];
               S_bar[S_index][1] = HL_bar[i][1];
              }
        }
      R_bar[R_index][0] = HL_bar[HL_size-2][0];
      R_bar[R_index][1] = HL_bar[HL_size-2][1];
      for(int i = HL_size-2; i >= 0; i = i-2) //Ghi kháng cự vào mảng
        {
         double pips = TinhSoPips(R_bar[R_index][1], HL_bar[i][1]);
         //int checkRS = CheckRSValid(timeFrame, (int)HL_bar[i][0], HL_bar[i][1], R_index, true);
         int checkRS = CheckRSValid(timeFrame, (int)HL_bar[i][0], HL_bar[i][1], R_index, true);
         if(pips >=pips_range && checkRS >= 0 /*&& checkRS < 2*/)//số pips đủ lớn để thành kháng cự
           {
            R_index++;
            R_bar[R_index][0] = HL_bar[i][0];
            R_bar[R_index][1] = HL_bar[i][1];

           }
         else
            if(pips < pips_range && R_bar[R_index][1] < HL_bar[i][1] /*&& checkRS >=0*/)// pips nhỏ hơn, và đỉnh i cao hơn đỉnh có
              {
               R_bar[R_index][0] = HL_bar[i][0];
               R_bar[R_index][1] = HL_bar[i][1];
              }
        }
     }
   ArrayResize(R_bar, R_index);
   ArrayResize(S_bar, S_index);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ResistanceSupportGraph(int timeFrame, double &R_bar[][2], double &S_bar[][2])
  {
   ObjectsDeleteAll(0, (string)timeFrame+"_RS_*");
   string nextDay = (string)Year() + "." + (string)Month() + "." + (string)(Day()+1);
   datetime end_d = StringToTime(nextDay);
   int R_index = ArraySize(R_bar)/2;
   int S_index = ArraySize(S_bar)/2;
   int pips_range = 10;
   int bar_draw_length = 10;
   double price_1 = iClose(_Symbol, timeFrame, 1);
   double low_1 = (iClose(_Symbol, timeFrame, 1) < iOpen(_Symbol, timeFrame,1) ? iClose(_Symbol, timeFrame,1): iOpen(_Symbol, timeFrame,1));
   double high_1 = (iClose(_Symbol, timeFrame, 1) > iOpen(_Symbol, timeFrame,1) ? iClose(_Symbol, timeFrame,1): iOpen(_Symbol, timeFrame,1));
   int r_num = 0;
   int s_num = 0;
   int idx = 0;
   bool r_is_cut = false;
   bool s_is_cut = false;
   bool price_cross_r = false;

   for(int i = 0; i < R_index; i++)//Vẽ kháng cự
     {
      int checkRS =  CheckRSValid(timeFrame, (int)R_bar[i][0], R_bar[i][1], i, true);
      if(r_num < 3 /*&& checkRS >= 0 && checkRS < 2*/)
        {
         //checkRS = 0;
         DrawTrendLine((string)timeFrame+"_"+"RS_Res_"+(string)idx, false, iTime(_Symbol,timeFrame,(int)R_bar[i][0]),(checkRS >= 0 ? iTime(_Symbol,timeFrame, checkRS) : iTime(_Symbol,timeFrame, 0)), R_bar[i][1], R_bar[i][1], FireBrick,STYLE_SOLID, false, timeFrame,1);
         r_num++;
         idx++;

        }
      else
        {         
        if(R_bar[i][1] < high_1)// giá cắt kháng cự
            price_cross_r = true;
         if(price_cross_r == true)//Tìm kháng cự giá chưa cắt qua lần nào
           {
            //DrawTrendLine((string)timeFrame+"_"+"RS_Res_"+(string)idx, false, iTime(_Symbol,timeFrame,(int)R_bar[i][0]), (checkRS > 0 ? iTime(_Symbol,timeFrame, checkRS) : iTime(_Symbol,timeFrame,(int)R_bar[i][0] - bar_draw_length)), R_bar[i][1], R_bar[i][1], FireBrick,STYLE_SOLID, false, timeFrame,1);
           
           }
         if(price_cross_r == false)
         {
            DrawTrendLine((string)timeFrame+"_"+"RS_Res_"+(string)idx, false, iTime(_Symbol,timeFrame,(int)R_bar[i][0]), (checkRS > 0 ? iTime(_Symbol,timeFrame, checkRS) :  end_d), R_bar[i][1], R_bar[i][1], FireBrick,STYLE_SOLID, false, timeFrame,1);
             //break;
             idx++;
         }
         //idx++;
        }
      if(idx>=5)
         break;
     }
   idx = 0;
   bool price_cross_s = false;
   for(int i = 0; i < S_index; i++)//Vẽ Hỗ trợ
     {
      int checkRS = CheckRSValid(timeFrame, (int)S_bar[i][0], S_bar[i][1], i, false);
      if(s_num < 3 /*&& checkRS >= 0*/)  // Vẽ kháng cự theo nguyên tắc: nếu tất cả các nến sau đó chưa chạm cản thì vẽ theo đến hết ngày. Nếu chạm cản 2 lần thì dừng ngay ở vị trí chạm cuối cùng.
        {
         //checkRS = 0;
         DrawTrendLine((string)timeFrame+"_"+"RS_Sup_"+(string)idx, false, iTime(_Symbol,timeFrame,(int)S_bar[i][0]),(checkRS >= 0 ? iTime(_Symbol,timeFrame, checkRS) : iTime(_Symbol,timeFrame, 0)), S_bar[i][1], S_bar[i][1], Green,STYLE_SOLID, false, timeFrame,1);
         s_num++;
         idx++;
        }
      else//xét cản này có còn cắt hỗ trợ không, nếu cắt thì vẽ ngắn, nếu không cắt thì vẽ dài và dừng lại
        {
         if(S_bar[i][1] > low_1)
            price_cross_s = true;
         if(price_cross_s == true)//giá cắt hỗ trợ
           {
            //DrawTrendLine((string)timeFrame+"_"+"RS_Sup_"+(string)idx, false, iTime(_Symbol,timeFrame,(int)S_bar[i][0]),(checkRS > 0 ? iTime(_Symbol,timeFrame, checkRS) : iTime(_Symbol,timeFrame,(int)S_bar[i][0] - bar_draw_length)), S_bar[i][1], S_bar[i][1], Green,STYLE_SOLID, false, timeFrame,1);
           }
         if(price_cross_s == false)
           {
            DrawTrendLine((string)timeFrame+"_"+"RS_Sup_"+(string)idx + "_" + checkRS, false, iTime(_Symbol,timeFrame,(int)S_bar[i][0]),(checkRS > 0 ? iTime(_Symbol,timeFrame, checkRS) : end_d), S_bar[i][1], S_bar[i][1], Green,STYLE_SOLID, false, timeFrame,1);
            //break;
            idx++;
           }
         
        }
      if(idx>=5)
         break;
     }
  }
//Lấy vị trí cây nến vượt cản, nếu không thấy thì trả về vị trí nến cuối cùng
//Cản bị phá 3 lần => hủy cản
//Cản có 1 nến quét qua và 1 nến quét lại = > hủy cản
int CheckRSValid(int timeFrame, int start_bar, double value_bar, int arr_index=3, bool checkRes = true)
  {
//return 0;
   int breakOut = 0;
   int bar_index = 0;
   for(int i = start_bar-1; i >=0; i--)
     {
      double open = iOpen(_Symbol, timeFrame, i);
      double close = iClose(_Symbol, timeFrame, i);
      //double wick_high = iHigh(_Symbol, timeFrame, i);//Lấy râu nến phía trên
      //double wick_low = iLow(_Symbol, timeFrame, i);//Lấy râu nến phía dưới
      double high =  close > open ? close : open;//Lấy giá cao
      double low  =  close < open ? close : open;//Lấy giá thấp
      if(value_bar >= low && value_bar <= high)// cản cắt giá
        {
         if(bar_index == 0)
            bar_index = i;
         breakOut++;
        }
      if(breakOut >= 2)//Cản cắt giá 2 lần
        {
         if(i<20)//nếu vị trí cắt nhỏ hơn 20 cây nến
            return bar_index;
         return -1;
        }
      if(checkRes && arr_index > 1 && breakOut > 0 && value_bar < iClose(_Symbol,timeFrame,0) && arr_index > 2)//Giá đã break kháng cự và  nằm trên kháng cự
         return -1;
      if(checkRes == false && arr_index > 1 && breakOut > 0 && value_bar > iClose(_Symbol,timeFrame,0) && arr_index > 2)//Giá đã break hỗ trợ và  nằm dưới hỗ trợ
         return -1;

      //return i;
     }
   return 0;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
