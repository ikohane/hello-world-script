#!/bin/bash

# Display greeting and time
echo "Hello Boston"
current_time=$(TZ="America/New_York" date "+%I:%M %p")
echo "Current time in Boston: $current_time"

# Create a temporary file for the HTML output
html_file=$(mktemp)

# Your NY Times API key - replace with your actual key
API_KEY="your_api_key_here"

# Fetch NY Times top stories and create HTML table
echo "<html>
<head>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
            font-family: Arial, sans-serif;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>
    <h2>NY Times Top Headlines</h2>
    <table>
        <tr>
            <th>Title</th>
            <th>Abstract</th>
        </tr>" > "$html_file"

# Fetch and parse NY Times headlines
curl -s "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=$API_KEY" | \
    jq -r '.results[] | "<tr><td>" + .title + "</td><td>" + .abstract + "</td></tr>"' >> "$html_file"

# Close the HTML
echo "</table></body></html>" >> "$html_file"

# Open the HTML file in the default browser
if command -v xdg-open > /dev/null; then
    xdg-open "$html_file"
elif command -v open > /dev/null; then
    open "$html_file"
else
    echo "HTML file created at: $html_file"
fi