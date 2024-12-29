import feedparser
import sys
import yfinance as yf
import json

def get_tesla_info():
    try:
        # Get Tesla stock info
        tesla = yf.Ticker("TSLA")
        stock_info = tesla.info
        
        # Get current price
        current_price = stock_info['currentPrice']
        
        # Elon Musk's estimated TSLA shares (as of last known data)
        # Note: This is approximate and should be updated periodically
        musk_shares = 411000000  # This is an estimate
        
        return {
            'price': current_price,
            'musk_shares': musk_shares,
            'musk_value': current_price * musk_shares
        }
    except Exception as e:
        return {
            'price': 'Unable to fetch',
            'musk_shares': 'Unable to fetch',
            'musk_value': 'Unable to fetch'
        }

def get_headlines():
    try:
        # Use Google News RSS feed
        feed = feedparser.parse("https://news.google.com/news/rss")
        
        # Get the top 10 headlines
        headlines = []
        for entry in feed.entries[:10]:
            headlines.append(entry.title)
        
        return headlines
    except Exception as e:
        return [f"Error fetching headlines: {str(e)}"]

if __name__ == "__main__":
    # Get Tesla info
    tesla_info = get_tesla_info()
    print(json.dumps(tesla_info))
    print("---HEADLINES---")
    # Get headlines
    headlines = get_headlines()
    for headline in headlines:
        print(headline)