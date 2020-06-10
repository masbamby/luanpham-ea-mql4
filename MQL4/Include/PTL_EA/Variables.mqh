//+------------------------------------------------------------------+
//|                                                   Ptl_Object.mqh |
//|                                       Copyright 2019, Luan Pham. |
//|                                     http://www.phamthanhluan.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Luan Pham."
#property link      "http://www.phamthanhluan.com"
#property strict
/*
extern int EMA_Period_1 = 34;
extern int EMA_Period_2 = 89;
extern int FastMACD = 8;
extern int LowMACD = 17;
extern int SignalMACD = 9;
//----------------------------------------------------------------

/*
extern int FastMACD = 12;
extern int LowMACD = 26;
extern int SignalMACD = 9;
*/
//Biến lưu trữ tín hiệu MACD với 2 thông số: [0]: Vị trí nến | [1]: Tăng/Giảm( 1: tăng | -1: Giảm)
int macdSignal_M5[2];
int macdSignal_M15[2];
int macdSignal_M30[2];
int macdSignal_H1[2];
int macdSignal_H4[2];
int macdSignal_D1[2];
//----------------------------------------------------------------
//Biến lưu trữ tín hiệu Vùng Giá trị với 3 thông số: [x][0]: Giá trị EMA | [x][1]:  Vị trí nến
int vgt_M5[2][3];
int vgt_M15[2][3];
int vgt_M30[2][3];
int vgt_H1[2][3];
int vgt_H4[2][3];
int vgt_D1[2][3];
//----------------------------------------------------------------
//Các vùng hỗ trợ/kháng cự
//Lưu lại 3 vùng hỗ trợ kháng cự gần nhất với các thông số mỗi vùng:
// [Sup(-1) or Res(1)][gần][xa][số lần restest]
double Sup_Res_M15[][4];
double Sup_Res_M30[][4];
double Sup_Res_H1[][4];
double Sup_Res_H4[][4];
double Sup_Res_D1[][4];
/*double Sup_M15[3][3];
double Sup_M30[3][3];
double Sup_H1[3][3];
double Sup_H4[3][3];
double Sup_D1[3][3];
double Res_M15[3][3];
double Res_M30[3][3];
double Res_H1[3][3];
double Res_H4[3][3];
double Res_D1[3][3];*/
//----------------------------------------------------------------

int xuHuongEMA34_H1;
int xuHuongEMA89_H1;
int xuHuongEMA34_H4;
int xuHuongEMA89_H4;
int xuHuongEMA34_D1;
int xuHuongEMA89_D1;

//VGTMACD[Khung Giờ][KhungEMA34][KhungEMA89][KhungMACD1][KhungMACD2][Xu hướng][Vị trí nến MACD 1][[Vị trí nếnMACD 2]][Vị trí nến VGT][Chưa gửi/Đã gửi]
//int VGTMACD[5][10];
//----------------------------------------------------------------
//Biến lưu trữ thông tin để gửi email hoặc thông báo tín hiệu mới đến client, thông tin sẽ được làm mới trong khung H1.
//VGTMACD_XX[chuỗi lưu trữ, tăng/giảm, khung macd, nến macd, nến vgt]
string VGTMACD_M5[5];
string VGTMACD_M15[5];
string VGTMACD_M30[5];
string VGTMACD_H1[5];
string VGTMACD_H4[5];
//
string price_ema_610_987 = "";
//Inside Bar + ema610 987
string ema610_987_InsideBar = "";
string vgt_InsideBar = "";
string pa_supplyDemand = "";
//----------------------------------------------------------------
*/