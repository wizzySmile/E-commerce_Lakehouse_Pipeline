Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path $PSScriptRoot -Parent
$manifestPath = Join-Path $projectRoot 'dbt_project\target\manifest.json'
$outputPath = Join-Path $PSScriptRoot 'ecommerce_data_model_erd.png'
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json

$bitmap = New-Object System.Drawing.Bitmap(3200, 1880)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$graphics.Clear([System.Drawing.Color]::FromArgb(247, 249, 252))

$fontTitle = New-Object System.Drawing.Font('Segoe UI', 36, [System.Drawing.FontStyle]::Bold)
$fontSubtitle = New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Regular)
$fontHeading = New-Object System.Drawing.Font('Segoe UI', 23, [System.Drawing.FontStyle]::Bold)
$fontSmallHeading = New-Object System.Drawing.Font('Segoe UI', 15, [System.Drawing.FontStyle]::Bold)
$fontNode = New-Object System.Drawing.Font('Segoe UI', 19, [System.Drawing.FontStyle]::Bold)
$fontDetail = New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Regular)
$fontLegend = New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Regular)
$fontNote = New-Object System.Drawing.Font('Segoe UI', 13, [System.Drawing.FontStyle]::Regular)
$ink = [System.Drawing.Color]::FromArgb(30, 41, 59)
$muted = [System.Drawing.Color]::FromArgb(92, 107, 126)
$inkBrush = New-Object System.Drawing.SolidBrush($ink)
$mutedBrush = New-Object System.Drawing.SolidBrush($muted)

function New-Brush([int]$red, [int]$green, [int]$blue) {
    New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($red, $green, $blue))
}

function New-Pen([int]$red, [int]$green, [int]$blue, [single]$width) {
    New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb($red, $green, $blue), $width)
}

function Draw-RoundedRectangle($target, $brushOrPen, $rectangle, [int]$radius, [bool]$fill) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $diameter = $radius * 2
    $path.AddArc($rectangle.X, $rectangle.Y, $diameter, $diameter, 180, 90)
    $path.AddArc($rectangle.Right - $diameter, $rectangle.Y, $diameter, $diameter, 270, 90)
    $path.AddArc($rectangle.Right - $diameter, $rectangle.Bottom - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($rectangle.X, $rectangle.Bottom - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    if ($fill) {
        $target.FillPath($brushOrPen, $path)
    } else {
        $target.DrawPath($brushOrPen, $path)
    }
    $path.Dispose()
}

function Draw-Panel([int]$x, [int]$y, [int]$width, [int]$height, [string]$title, [string]$subtitle, $fill, $accent) {
    $rectangle = New-Object System.Drawing.Rectangle($x, $y, $width, $height)
    Draw-RoundedRectangle $graphics $fill $rectangle 18 $true
    $outline = New-Pen $accent.R $accent.G $accent.B 2
    Draw-RoundedRectangle $graphics $outline $rectangle 18 $false
    $graphics.FillRectangle((New-Object System.Drawing.SolidBrush($accent)), $x, $y, $width, 8)
    $graphics.DrawString($title, $fontHeading, $inkBrush, [single]($x + 22), [single]($y + 20))
    $graphics.DrawString($subtitle, $fontSubtitle, $mutedBrush, [single]($x + 22), [single]($y + 57))
    $outline.Dispose()
}

$rawAccent = [System.Drawing.Color]::FromArgb(222, 132, 47)
$stagingAccent = [System.Drawing.Color]::FromArgb(26, 137, 186)
$coreAccent = [System.Drawing.Color]::FromArgb(39, 133, 91)
$martAccent = [System.Drawing.Color]::FromArgb(204, 76, 112)

Draw-Panel 55 215 435 1450 'RAW / BRONZE' 'DuckDB source  |  ecommerce.main' (New-Brush 255 245 232) $rawAccent
Draw-Panel 505 215 510 1450 'STAGING / SILVER' 'Cleaned and standardized source models' (New-Brush 234 247 253) $stagingAccent
Draw-Panel 1030 215 1290 1450 'CORE / GOLD' 'Conformed dimensions  +  transactional facts' (New-Brush 241 248 241) $coreAccent
Draw-Panel 2345 215 800 1450 'DATA MARTS' 'Business-ready analytics outputs' (New-Brush 255 240 244) $martAccent
$graphics.DrawString('SCD2 HISTORY', $fontSmallHeading, $mutedBrush, [single]1060, [single]300)
$graphics.DrawString('DIMENSIONS', $fontSmallHeading, $mutedBrush, [single]1420, [single]300)
$graphics.DrawString('FACTS', $fontSmallHeading, $mutedBrush, [single]1840, [single]300)
$separatorPen = New-Pen 214 225 218 1
$graphics.DrawLine($separatorPen, 1405, 292, 1405, 1638)
$graphics.DrawLine($separatorPen, 1818, 292, 1818, 1638)

$rawRows = @{
    orders = 350; customers = 490; order_items = 630; order_payments = 770
    order_reviews = 910; products = 1050; sellers = 1190
    product_category_translation = 1330; geolocation = 1470
}
$stagingRows = @{
    stg_orders = 350; stg_customers = 490; stg_order_items = 630; stg_order_payments = 770
    stg_order_reviews = 910; stg_products = 1050; stg_sellers = 1190
    stg_product_category_translation = 1330; stg_geolocation = 1470
}
$snapshotRows = @{ scd2_dim_customers = 490; scd2_dim_products = 1050; scd2_dim_sellers = 1190 }
$dimensionRows = @{ dim_dates = 350; dim_customers = 490; dim_payment_types = 770; dim_products = 1050; dim_sellers = 1190 }
$factRows = @{ fact_orders = 350; fact_sales = 630; fact_payments = 770; fact_reviews = 910 }
$martRows = @{ mart_monthly_revenue = 350; mart_customer_metrics = 490; mart_marketing_performance = 630; mart_operations_performance = 770 }

$cards = New-Object System.Collections.Generic.List[object]
$cardsById = @{}
foreach ($property in $manifest.sources.PSObject.Properties) {
    $source = $property.Value
    $name = [string]$source.name
    if (-not $rawRows.ContainsKey($name)) { continue }
    $card = [pscustomobject]@{
        Id = $property.Name; Name = $name; Label = "raw.$name"; Detail = 'ecommerce.main'
        X = 75; Y = [int]$rawRows[$name]; W = 395; H = 88
        Accent = $rawAccent; Fill = (New-Brush 255 250 242)
    }
    $cards.Add($card)
    $cardsById[$property.Name] = $card
}

foreach ($property in $manifest.nodes.PSObject.Properties) {
    $node = $property.Value
    if ($node.package_name -ne $manifest.metadata.project_name) { continue }
    $name = [string]$node.name
    $x = 0; $y = 0; $width = 0; $height = 88; $detail = ''; $accent = $stagingAccent
    $fill = New-Brush 255 255 255

    if ($node.resource_type -eq 'snapshot') {
        if (-not $snapshotRows.ContainsKey($name)) { continue }
        $x = 1050; $y = [int]$snapshotRows[$name]; $width = 325
        $detail = 'SCD Type 2 history'
        $accent = [System.Drawing.Color]::FromArgb(126, 87, 194)
        $fill = New-Brush 248 244 255
    } elseif ($node.resource_type -eq 'model' -and $node.original_file_path -like 'models\staging\*') {
        if (-not $stagingRows.ContainsKey($name)) { continue }
        $x = 520; $y = [int]$stagingRows[$name]; $width = 480
        $detail = 'cleaned staging model'
        $fill = New-Brush 248 253 255
        if ($name -eq 'stg_geolocation') { $detail = 'no downstream dbt model currently references it' }
    } elseif ($node.resource_type -eq 'model' -and $node.original_file_path -like 'models\core\dimensions\*') {
        if (-not $dimensionRows.ContainsKey($name)) { continue }
        $x = 1420; $y = [int]$dimensionRows[$name]; $width = 375
        $accent = $coreAccent; $fill = New-Brush 246 253 248
        $detail = switch ($name) {
            'dim_dates' { 'PK date_key | generated calendar' }
            'dim_customers' { 'PK customer_key' }
            'dim_payment_types' { 'PK payment_type_key' }
            'dim_products' { 'PK product_key' }
            'dim_sellers' { 'PK seller_key' }
            default { '' }
        }
    } elseif ($node.resource_type -eq 'model' -and $node.original_file_path -like 'models\core\facts\*') {
        if (-not $factRows.ContainsKey($name)) { continue }
        $x = 1835; $y = [int]$factRows[$name]; $width = 430
        $accent = [System.Drawing.Color]::FromArgb(68, 102, 192); $fill = New-Brush 245 248 255
        $detail = switch ($name) {
            'fact_orders' { 'Grain: 1 order | FK customer / date' }
            'fact_sales' { 'Grain: 1 order item | FK customer / product / seller / date' }
            'fact_payments' { 'Grain: 1 payment | FK customer / type / date' }
            'fact_reviews' { 'Grain: 1 review | FK customer / date' }
            default { '' }
        }
    } elseif ($node.resource_type -eq 'model' -and $node.original_file_path -like 'models\marts\*') {
        if (-not $martRows.ContainsKey($name)) { continue }
        $x = 2370; $y = [int]$martRows[$name]; $width = 750; $height = 100
        $accent = $martAccent; $fill = New-Brush 255 249 251
        $detail = switch ($name) {
            'mart_customer_metrics' { 'Grain: one row per customer' }
            'mart_monthly_revenue' { 'Grain: year + month' }
            'mart_marketing_performance' { 'Grain: year + month + state + city' }
            'mart_operations_performance' { 'Grain: year + month + state' }
            default { '' }
        }
    } else {
        continue
    }

    $card = [pscustomobject]@{
        Id = $property.Name; Name = $name; Label = $name; Detail = $detail
        X = $x; Y = $y; W = $width; H = $height; Accent = $accent; Fill = $fill
    }
    $cards.Add($card)
    $cardsById[$property.Name] = $card
}

$edgePen = New-Pen 145 158 174 1.5
$arrowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(145, 158, 174))
foreach ($to in $cards) {
    $manifestNode = $manifest.nodes.PSObject.Properties[$to.Id]
    if ($null -eq $manifestNode) { continue }
    foreach ($dependencyId in $manifestNode.Value.depends_on.nodes) {
        if (-not $cardsById.ContainsKey([string]$dependencyId)) { continue }
        $from = $cardsById[[string]$dependencyId]
        $x1 = [single]($from.X + $from.W); $y1 = [single]($from.Y + $from.H / 2)
        $x4 = [single]$to.X; $y4 = [single]($to.Y + $to.H / 2); $dx = $x4 - $x1
        $p1 = New-Object System.Drawing.PointF($x1, $y1)
        $p2 = New-Object System.Drawing.PointF(($x1 + $dx * 0.42), $y1)
        $p3 = New-Object System.Drawing.PointF(($x1 + $dx * 0.72), $y4)
        $p4 = New-Object System.Drawing.PointF($x4, $y4)
        $graphics.DrawBezier($edgePen, $p1, $p2, $p3, $p4)
        $arrow = New-Object 'System.Drawing.PointF[]' 3
        $arrow[0] = New-Object System.Drawing.PointF($x4, $y4)
        $arrow[1] = New-Object System.Drawing.PointF(($x4 - 13), ($y4 - 7))
        $arrow[2] = New-Object System.Drawing.PointF(($x4 - 13), ($y4 + 7))
        $graphics.FillPolygon($arrowBrush, $arrow)
    }
}

foreach ($card in $cards) {
    $rectangle = New-Object System.Drawing.Rectangle($card.X, $card.Y, $card.W, $card.H)
    Draw-RoundedRectangle $graphics $card.Fill $rectangle 14 $true
    $outline = New-Pen $card.Accent.R $card.Accent.G $card.Accent.B 2
    Draw-RoundedRectangle $graphics $outline $rectangle 14 $false
    $accentBrush = New-Object System.Drawing.SolidBrush($card.Accent)
    $graphics.FillRectangle($accentBrush, $card.X, $card.Y, 8, $card.H)

    $nameFont = $fontNode
    if ($card.Label.Length -gt 29) {
        $nameFont = New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Bold)
    } elseif ($card.Label.Length -gt 22) {
        $nameFont = New-Object System.Drawing.Font('Segoe UI', 17, [System.Drawing.FontStyle]::Bold)
    }
    $graphics.DrawString($card.Label, $nameFont, $inkBrush, [single]($card.X + 20), [single]($card.Y + 12))
    $graphics.DrawString($card.Detail, $fontDetail, $mutedBrush, [single]($card.X + 20), [single]($card.Y + 55))
    if ($nameFont -ne $fontNode) { $nameFont.Dispose() }
    $outline.Dispose(); $accentBrush.Dispose()
}

$legendY = 1705
$graphics.DrawString('LEGEND', $fontSmallHeading, $inkBrush, [single]70, [single]$legendY)
$legendItems = @(
    @{ X = 175; Text = 'Raw / Bronze'; Color = $rawAccent },
    @{ X = 390; Text = 'Staging / Silver'; Color = $stagingAccent },
    @{ X = 650; Text = 'SCD2 history'; Color = [System.Drawing.Color]::FromArgb(126, 87, 194) },
    @{ X = 870; Text = 'Dimensions'; Color = $coreAccent },
    @{ X = 1070; Text = 'Facts'; Color = [System.Drawing.Color]::FromArgb(68, 102, 192) },
    @{ X = 1220; Text = 'Marts'; Color = $martAccent }
)
foreach ($item in $legendItems) {
    $dotBrush = New-Object System.Drawing.SolidBrush($item.Color)
    $graphics.FillEllipse($dotBrush, [single]$item.X, [single]($legendY + 5), [single]17, [single]17)
    $graphics.DrawString($item.Text, $fontLegend, $inkBrush, [single]($item.X + 25), [single]$legendY)
    $dotBrush.Dispose()
}
$graphics.DrawLine($edgePen, 1510, ($legendY + 14), 1570, ($legendY + 14))
$arrow[0] = New-Object System.Drawing.PointF(1570, ($legendY + 14))
$arrow[1] = New-Object System.Drawing.PointF(1558, ($legendY + 8))
$arrow[2] = New-Object System.Drawing.PointF(1558, ($legendY + 20))
$graphics.FillPolygon($arrowBrush, $arrow)
$graphics.DrawString('dbt model dependency', $fontLegend, $inkBrush, [single]1580, [single]$legendY)
$graphics.DrawString('PK = primary key   |   FK = foreign key   |   Grain = one row per', $fontNote, $mutedBrush, [single]70, [single]($legendY + 40))
$graphics.DrawString('Geolocation currently ends in staging; no downstream model references it.', $fontNote, $mutedBrush, [single]1600, [single]($legendY + 40))
$graphics.DrawString('Generated from the current dbt manifest; arrows show lineage, not row-level cardinality.', $fontNote, $mutedBrush, [single]70, [single]1825)
$graphics.DrawString('E-COMMERCE LAKEHOUSE  |  DATA MODEL ERD', $fontTitle, $inkBrush, [single]65, [single]48)
$graphics.DrawString('End-to-end lineage from raw source tables through staging and core models to business marts', $fontSubtitle, $mutedBrush, [single]72, [single]112)

$bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Output "Created $outputPath"
Write-Output "Manifest entities rendered: $($cards.Count)"

$edgePen.Dispose(); $arrowBrush.Dispose(); $separatorPen.Dispose()
$inkBrush.Dispose(); $mutedBrush.Dispose(); $graphics.Dispose(); $bitmap.Dispose()
