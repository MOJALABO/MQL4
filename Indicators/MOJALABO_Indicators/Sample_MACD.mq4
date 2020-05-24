//+------------------------------------------------------------------+
//|                                               Sample_MACD.mq4|
//|                                     Copyright 2020, MOJA FX LABO |
//|                                       https://fx.mojamegane.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MOJA FX LABO"
#property link      "https://fx.mojamegane.com/"
#property version   "1.00"
#property strict
#property indicator_separate_window //Layout of Custom indicator
//#property indicator_chart_window //カスタムインジケータをチャートウィンドウに表示する

//インジケータプロパティ設定
#property indicator_buffers   2  //number of indicators
#property indicator_color1    clrWhite //indicator1 color
#property indicator_type1     DRAW_LINE   //indicator1 type
#property indicator_color2    clrWhite //indicator1 color
#property indicator_type2     DRAW_HISTOGRAM   //indicator1 type

//インジケータ表示用動的配列
double   _IndBuffer1[];  //Indicator1 Dynamic Array
double   _IndBuffer2[];  //Indicator2 Dynamic Array

//マクロ定義
#define IND_MIN_INDEX   2 //最小バー数

//インプットパラメータ
input int _InputFastEMAPeriod = 12; //fast EMA period
input int _InputSlowEMAPeriod = 26; //slow EMA period
input int _InputSignalPeriod = 9; //signal period

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,_IndBuffer1);   //Bind Indicator1
   SetIndexBuffer(1,_IndBuffer2);   //Bind Indicator2
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, //入力された時系列のバーの数
                const int prev_calculated, //計算済み（前回呼び出し時）のバーの数
                const datetime &time[], //時間
                const double &open[], //始値
                const double &high[], //高値
                const double &low[], //安値
                const double &close[], //終値
                const long &tick_volume[], //Tick出来高
                const long &volume[], //Real出来高
                const int &spread[]) //スプレッド
  {
//

  int end_index = Bars - prev_calculated; //バー数取得
 
  if (end_index <= IND_MIN_INDEX){     //直近２本は常時更新
   end_index =IND_MIN_INDEX;
   }
 
  if(Bars <=IND_MIN_INDEX){   //ヒストリカルデータ不足時
   return 0;      //全て再計算が必要なので、計算済みバー数を0にしてしゅうりょうする。
  }
 

//Main Logic
  for(int icount = 0; icount < end_index; icount++ ){
   double get_macd_main = iMACD(
                        Symbol(),      //通貨ペア
                        0,
                        _InputFastEMAPeriod,            //fast EMA period
                        _InputSlowEMAPeriod,            //slow EMA period
                        _InputSignalPeriod,      //Signal period
                        PRICE_CLOSE,      //applied price
                        MODE_MAIN,   //mode
                        icount         //シフト
   );
   double get_macd_signal = iMACD(
                        Symbol(),      //通貨ペア
                        0,
                        _InputFastEMAPeriod,            //fast EMA period
                        _InputSlowEMAPeriod,            //slow EMA period
                        _InputSignalPeriod,      //Signal period
                        PRICE_CLOSE,      //applied price
                        MODE_SIGNAL,   //mode
                        icount         //シフト
   );

  _IndBuffer1[icount]=get_macd_main;          //MACD MAIN
  _IndBuffer2[icount]=get_macd_signal;          //MACD SIGNAL
  }
     
//--- return value of prev_calculated for next call
   return(rates_total); //戻り値設定:次回OnCalculate関数が呼ばれた時のPREV_calculatedの値に渡される。
  }
//+------------------------------------------------------------------+
