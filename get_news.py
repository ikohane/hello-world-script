import requests
from bs4 import BeautifulSoup
import sys

def get_headlines():
    try:
        # Use a recent User-Agent
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        
        # Get Google News page
        response = requests.get('https://news.google.com', headers=headers)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Find article headlines
        articles = soup.find_all('article', limit=10)
        headlines = []
        
        for article in articles:
            headline = article.find('h3')
            if headline:
                headlines.append(headline.get_text().strip())
        
        return headlines
    except Exception as e:
        return [f"Error fetching headlines: {str(e)}"]

if __name__ == "__main__":
    headlines = get_headlines()
    for headline in headlines:
        print(headline)