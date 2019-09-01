This module is base on .net [System.Windows.Forms.DataVisualization.Charting.Chart](https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datavisualization.charting?view=netframework-4.8) to draw the Chart. The module just help for those who not familiar with .net but want to use powershell to do chart

## Example Usage

Pie Chart for CPU Usage

```Powershell
import-module PowershellChart
$Chart = new-Chart
$Process =Get-Process | Sort-Object CPU -Descending | Select-Object -First 20

$Chart | Set-ChartSeries -X_Values $Process.name -Y_Values $Process.ws
Set-Chart $Chart -charttype Pie
Save-ChartImage -Chart $Chart -FileName "Exmaple.png"
```

Line Chart For Disk Usage Trend

```Powershell
$Chart = new-Chart
$disk = Import-Csv disk.csv
Set-ChartSeries -X_Values $disk.date -Y_Values $disk.disk -Chart $Chart
Save-ChartImage -Chart $Chart -FileName "Exmaple.png"
```

## To Do