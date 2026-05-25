#!/bin/bash
CITY=${1:-Perm}

JSON=$(curl -s "wttr.in/$CITY?format=j1")
TEMP=$(echo "$JSON" | jq -r '.["current_condition"][0] | .temp_C')
HUM=$(echo "$JSON" | jq -r '.["current_condition"][0] | .humidity')

sudo tee /var/www/html/index.nginx-debian.html > /dev/null << EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Погода в Перми</title>
    <style>
        body { font-family: Arial; max-width: 400px; margin: 50px auto; padding: 20px; }
        h1 { color: #333; }
        .data { font-size: 24px; margin: 15px 0; }
    </style>
</head>
<body>
    <h1>Погода в Перми</h1>
    <div class="data">Температура: $TEMP °C</div>
    <div class="data">Влажность: $HUM %</div>
    <p>Хорошего дня!</p>
    <p>Время обновления: $(TZ=Asia/Yekaterinburg date +'%Y-%m-%d %H:%M:%S')</p>

</body>
</html>
EOF

echo "Погода обновлена. Откройте http://127.0.0.1"

