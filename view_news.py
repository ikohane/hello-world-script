import os

# Get the absolute path to news.html
current_dir = os.path.dirname(os.path.abspath(__file__))
html_path = os.path.join(current_dir, 'news.html')

# Convert to file:// URL format
file_url = f'file://{html_path}'
print(f"Opening {file_url}")

# Use the browser tool to open the file
from browser import goto
goto(file_url)