#!/bin/bash

# Install required Python packages if not already installed
pip install feedparser >/dev/null 2>&1

# Display greeting and time
echo "Hello Boston"
current_time=$(TZ="America/New_York" date "+%I:%M %p")
echo "Current time in Boston: $current_time"

# Create HTML file in the current directory
html_file="news.html"

# Get Tesla information
tesla_info=$(python3 get_news.py | head -n 1)
tesla_price=$(echo $tesla_info | python3 -c "import sys, json; print(json.loads(sys.stdin.read())['price'])")
tesla_shares=$(echo $tesla_info | python3 -c "import sys, json; print(json.loads(sys.stdin.read())['musk_shares'])")
tesla_value=$(echo $tesla_info | python3 -c "import sys, json; print(json.loads(sys.stdin.read())['musk_value'])")

# Format numbers with commas
tesla_shares_formatted=$(echo $tesla_shares | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')
tesla_value_formatted=$(echo $tesla_value | python3 -c "import sys; print('${:,.2f}'.format(float(sys.stdin.read())))")

# Start the HTML file
cat > "$html_file" << EOF
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f0f0f0;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            border-bottom: 2px solid #ddd;
            padding-bottom: 10px;
        }
        .headline {
            margin: 15px 0;
            padding: 15px;
            border-bottom: 1px solid #eee;
            line-height: 1.4;
        }
        .headline:hover {
            background-color: #f8f8f8;
        }
        .time {
            color: #666;
            margin-bottom: 20px;
            font-style: italic;
        }
        .tesla-info {
            background-color: #f8f8f8;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .tesla-price {
            font-size: 48px;
            color: #2f2f2f;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .tesla-shares {
            font-size: 24px;
            color: #444;
            margin-bottom: 10px;
        }
        .tesla-value {
            font-size: 28px;
            color: #0066cc;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class='container'>
        <div class='time'>Boston Time: $current_time</div>
        <div class='tesla-info'>
            <div class='tesla-price'>TSLA: \$$tesla_price</div>
            <div class='tesla-shares'>Elon Musk's Estimated Shares: $tesla_shares_formatted</div>
            <div class='tesla-value'>Total Value: \$$tesla_value_formatted</div>
        </div>
        <h2>Top Headlines</h2>
        <div class='headlines'>
EOF

# Get headlines using Python script and add them to HTML
echo -e "\nHeadlines:"
python3 get_news.py | sed '1,/---HEADLINES---/d' | while IFS= read -r headline; do
    echo "$headline"
    echo "<div class='headline'>$headline</div>" >> "$html_file"
done

# Close the HTML file
echo "</div></div></body></html>" >> "$html_file"

# Display the path to the HTML file
echo -e "\nHeadlines have been saved to: $html_file"

# The HTML file is now available at: /workspace/hello-world-script/news.html
echo -e "\nTo view the news in a formatted page, look for the browser tab in the OpenHands interface"