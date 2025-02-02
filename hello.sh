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
tesla_price=$(echo "$tesla_info" | python3 -c "import sys, json; print('{:,.2f}'.format(json.loads(sys.stdin.read())['price']))")
tesla_direct=$(echo "$tesla_info" | python3 -c "import sys, json; print('{:,}'.format(json.loads(sys.stdin.read())['direct_shares']))")
tesla_trust=$(echo "$tesla_info" | python3 -c "import sys, json; print('{:,}'.format(json.loads(sys.stdin.read())['trust_shares']))")
tesla_total=$(echo "$tesla_info" | python3 -c "import sys, json; print('{:,}'.format(json.loads(sys.stdin.read())['total_shares']))")
tesla_value=$(echo "$tesla_info" | python3 -c "import sys, json; print('{:,.2f}'.format(json.loads(sys.stdin.read())['total_value']))")

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
            margin: 20px 0;
        }
        .tesla-shares ul {
            margin: 10px 0;
            padding-left: 20px;
            list-style-type: none;
        }
        .tesla-shares li {
            font-size: 20px;
            margin: 8px 0;
            color: #555;
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
            <div class='tesla-shares'>
                Elon Musk's Tesla Shares:
                <ul>
                    <li>Direct Ownership: $tesla_direct shares</li>
                    <li>Trust Ownership: $tesla_trust shares</li>
                    <li>Total Ownership: $tesla_total shares</li>
                </ul>
            </div>
            <div class='tesla-value'>Total Value: \$$tesla_value</div>
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