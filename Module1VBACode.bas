Attribute VB_Name = "Module1"
Sub Stock_market()

'Declare and set worksheet
Dim ws As Worksheet

'Loop through all stocks for one year
For Each ws In Worksheets

'Create the column headings
ws.Range("I1").Value = "Ticker"
ws.Range("J1").Value = "Yearly Change"
ws.Range("K1").Value = "Percent Change"
ws.Range("L1").Value = "Total Stock Volume"

ws.Range("P1").Value = "Ticker"
ws.Range("Q1").Value = "Value"
ws.Range("O2").Value = "Greatest % Increase"
ws.Range("O3").Value = "Greatest % Decrease"
ws.Range("O4").Value = "Greatest Total Volume"

'Define Ticker variable
Dim Ticker As String
Ticker = " "
Dim Ticker_volume As Double
Ticker_volume = 0

'Create variable to hold stock volume
Dim stock_volume As Double
stock_volume = 0

'Set initial and last row for worksheet
Dim Lastrow As Long
Dim i As Long
Dim j As Integer

'Define Lastrow of worksheet
Lastrow = ws.Cells(Rows.Count, 1).End(xlUp).Row

'Set new variables for prices and percent changes
Dim open_price As Double
open_price = 0
Dim close_price As Double
close_price = 0
Dim price_change As Double
price_change = 0
Dim price_change_percent As Double
price_change_percent = 0
Dim TickerRow As Long: TickerRow = 1

'Do loop of current worksheet to Lastrow
For i = 2 To Lastrow

'Ticker symbol output
If ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1).Value Then
TickerRow = TickerRow + 1
Ticker = ws.Cells(i, 1).Value
ws.Cells(TickerRow, "I").Value = Ticker

'Calculate change in Price
close_price = ws.Cells(i, 6).Value
price_change_percent = close_price - open_price

'Fixing the open price equal zero problem
ElseIf open_price <> 0 Then
price_change_percent = (price_change_percent / open_price) * 100

End If

Next i

Next ws

End Sub

Sub yearlyprice()

Dim ws As Worksheet
    Dim select_index As Double
    Dim first_row As Double
    Dim select_row As Double
    Dim last_row As Double
    Dim year_opening As Single
    Dim year_closing As Single
    Dim volume As Double

For Each ws In Sheets
        Worksheets(ws.Name).Activate
        select_index = 2
        first_row = 2
        select_row = 2
        last_row = WorksheetFunction.CountA(ActiveSheet.Columns(1))
        volume = 0
        maxincrease = 0
        maxdecrease = 0
        maxtotalvolume = 0
        maxdecreaseticker = " "
        maxincreaseticker = " "
        maxtotalvolumeticker = " "
        
        For i = first_row To last_row
            tickers = Cells(i, 1).Value
            tickers2 = Cells(i - 1, 1).Value
            If tickers <> tickers2 Then
                Cells(select_row, 9).Value = tickers
                select_row = select_row + 1
            End If
         Next i
        
        'Loop through all rows and add to volume if the ticker hasn't changed. Once ticker has changed, reset volume and continue.
        For i = first_row To last_row + 1
            tickers = Cells(i, 1).Value
            tickers2 = Cells(i - 1, 1).Value
            If tickers = tickers2 And i > 2 Then
                volume = volume + Cells(i, 7).Value
            ElseIf i > 2 Then
                Cells(select_index, 12).Value = volume
                select_index = select_index + 1
                volume = 0
            Else
                volume = volume + Cells(i, 7).Value
            End If
            If volume > maxtotalvolume Then
            maxtotalvolume = volume
            maxtotalvolumeticker = Cells(i, 1).Value
            End If
            
        Next i
            
        'Loop through all rows. If previous ticker is different, assign year_opening. If next ticker is different, assign year_closing.
        select_index = 2
        
        For i = first_row To last_row
            If Cells(i, 1).Value <> Cells(i + 1, 1).Value Then
                year_closing = Cells(i, 6).Value
            ElseIf Cells(i, 1).Value <> Cells(i - 1, 1).Value Then
                year_opening = Cells(i, 3).Value
            End If
            If year_opening > 0 And year_closing > 0 Then
                increase = year_closing - year_opening
                percent_increase = increase / year_opening
                If percent_increase > maxincrease Then
                maxincrease = percent_increase
                maxincreaseticker = Cells(i, 1).Value
                End If
                If percent_increase < maxdecrease Then
                maxdecrease = percent_increase
                maxdecreaseticker = Cells(i, 1).Value
                End If
                Cells(select_index, 10).Value = increase
                Cells(select_index, 11).Value = FormatPercent(percent_increase)
                year_closing = 0
                year_opening = 0
                select_index = select_index + 1
            End If
        Next i
         
         'Loops through column 10 then applies either green or red interior
         For i = first_row To last_row
            If IsEmpty(Cells(i, 10).Value) Then Exit For
            If Cells(i, 10).Value > 0 Then
                Cells(i, 10).Interior.ColorIndex = 4
            Else
                Cells(i, 10).Interior.ColorIndex = 3
            End If
        Next i
        Cells(2, 16).Value = maxincreaseticker
        Cells(2, 17).Value = maxincrease
        Cells(3, 16).Value = maxdecreaseticker
        Cells(3, 17).Value = maxdecrease
        Cells(4, 16).Value = maxtotalvolumeticker
        Cells(4, 17).Value = maxtotalvolume
Next ws

End Sub
