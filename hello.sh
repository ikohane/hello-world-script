#!/bin/bash

# Install required Python packages if not already installed
pip install feedparser >/dev/null 2>&1

# Display greeting and time
echo "Hello Boston"
current_time=$(TZ="America/New_York" date "+%I:%M %p")
echo "Current time in Boston: $current_time"

# Create HTML file in the current directory
html_file="news.html"

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
    </style>
</head>
<body>
    <div class='container'>
        <h2>Top Headlines</h2>
        <div class='time'>Boston Time: $current_time</div>
        <div class='headlines'>
EOF

# Get headlines using Python script and add them to HTML
echo -e "\nHeadlines:"
python3 get_news.py | while IFS= read -r headline; do
    echo "$headline"
    echo "<div class='headline'>$headline</div>" >> "$html_file"
done

# Close the HTML file
echo "</div></div></body></html>" >> "$html_file"

# Display the path to the HTML file
echo -e "\nHeadlines have been saved to: $html_file"

# Open the file in the OpenHands browser
echo -e "\nOpening news in browser..."
python3 view_news.py