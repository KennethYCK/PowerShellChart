$ga_charttype =@("Line",
                        "Area",
                        "Bar",
                        "Pie"
                        )

function New-Chart{
param(
     
        [int]
        $Width,

        [int]
        $Height,

        [string]
        $Charttype = "Line",

        [string]
        $Title
    )
 
    
    [void][Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms.DataVisualization')
      
    $Chart = New-Object -TypeName System.Windows.Forms.DataVisualization.Charting.Chart
    $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
    $Chart.ChartAreas.Add($ChartArea)
    [void]$Chart.Series.Add(0)

    [void]$chart.Titles.add("Image")
    if($PSBoundParameters.ContainsKey("Title"))
    {
        $chart.Titles[0].Text = $Title
    }
   
    if($ga_charttype -contains $Charttype)
    {
        $Chart.Series[0].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$ChartType
    }
    else
    {
        Write-Host "Error $($Charttype) is not a correct Chart Type."
        return 
    }
    
    if($PSBoundParameters.ContainsKey("Width"))
    {
        $Chart.Width = $Width
    }
    if($PSBoundParameters.ContainsKey("Height"))
    {
        $Chart.Height = $Height
    }

    return $Chart

    
}

function Get-ChartSeries {
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Windows.Forms.DataVisualization.Charting.Chart]
        $Chart,

        [string]
        $SeriesName
    )

    if($PSBoundParameters.ContainsKey("SeriesName"))
    {
        $Chart.Series[$SeriesName]
    }   
    else{
        return $Chart.Series
    }
}

function Add-ChartSeries {
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Windows.Forms.DataVisualization.Charting.Chart]
        $Chart,

        [string]
        $SeriesName
    )

    if($PSBoundParameters.ContainsKey("SeriesName"))
    {   
        [void]$Chart.Series.Add($SeriesName)
    }   
    else{
        [void]$Chart.Series.Add($Chart.Series.Count)
    }
    
    
    
}


function Set-ChartSeries {
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Windows.Forms.DataVisualization.Charting.Chart]
        $Chart,

        $SeriesName = 0,

        [Parameter(Mandatory=$true)]
        $X_Values,
        [Parameter(Mandatory=$true)]
        $Y_Values
    )
    for($i=0; $i -lt $Y_Values.count ; $i++)
    {
        [void]$Chart.Series[$SeriesName].Points.AddXY($X_Values[$i], $Y_Values[$i])
    }
    
}



function Remove-ChartSeries {
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Windows.Forms.DataVisualization.Charting.Chart]
        $Chart,

        [Parameter(Mandatory=$true)]
        $SeriesName
    )
    $tmp = $chart.Series | Select-Object Name
    $tmp_hash =@{}
    for($i=0 ;$i -lt $tmp.count ;$i++)
    { 
        $tmp_hash[ $tmp[$i].name]  = $i
    }
    if ($null -eq $tmp_hash[$SeriesName] ){
        Write-Host "Error: Series $SeriesName does not exist."
    }
    else {
        [void]$Chart.Series.RemoveAt($tmp_hash[$SeriesName])    
    }
    
    
}


function Clear-ChartSeries {
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Windows.Forms.DataVisualization.Charting.Chart]
        $Chart,

        $SeriesName

    )
    if($PSBoundParameters.ContainsKey("SeriesName"))
    {
        [void]$Chart.Series[$SeriesName].Points.clear()
    }   
    else{
        for($i=0;$i -lt $Chart.Series.count ; $i++)
        {
            [void]$Chart.Series[$i].Points.clear()
        }
    }
        
    
    
}
function Set-Chart{
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Windows.Forms.DataVisualization.Charting.Chart]
        $Chart,

        [string]
        $Charttype,

        [int]
        $Width,

        [int]
        $Height,

        [string]
        $Title
    )
    
    if($PSBoundParameters.ContainsKey("Charttype"))
    {
        if($ga_charttype -contains $Charttype)
        {
            $Chart.Series[0].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$ChartType
        }
        else
        {
            Write-Host "Error $($Charttype) is not a correct Chart Type."
        }
    }
    if($PSBoundParameters.ContainsKey("Width"))
    {
        $Chart.width = $Width
    }
    if($PSBoundParameters.ContainsKey("Height"))
    {
        $Chart.Height = $Height
    }
    if($PSBoundParameters.ContainsKey("Title"))
    {
        $chart.Titles[0].Text = $Title
    }
   
}

function Get-Chart{
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Windows.Forms.DataVisualization.Charting.Chart]
        $Chart
    )

}

function Save-ChartImage{
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Windows.Forms.DataVisualization.Charting.Chart]
        $Chart,

        [String]
        $FileName="Image.png"
    )

    
    $ImageFormat = $FileName.split('.')[1]

    $Chart.SaveImage($FileName , $ImageFormat)
}