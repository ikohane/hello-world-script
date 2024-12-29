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
        
        # Elon Musk's TSLA shares (as of December 2023)
        # Source: SEC filings and Tesla's proxy statement
        musk_shares = 411000000  # Direct ownership
        trust_shares = 412000000  # Shares held in trust
        total_shares = musk_shares + trust_shares  # Total beneficial ownership
        
        return {
            'price': current_price,
            'direct_shares': musk_shares,
            'trust_shares': trust_shares,
            'total_shares': total_shares,
            'total_value': current_price * total_shares
        }
    except Exception as e:
        return {
            'price': 'Unable to fetch',
            'direct_shares': 'Unable to fetch',
            'trust_shares': 'Unable to fetch',
            'total_shares': 'Unable to fetch',
            'total_value': 'Unable to fetch'
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
    try:
        # Get Tesla info
        tesla_info = get_tesla_info()
        print(json.dumps(tesla_info))
        print("---HEADLINES---", flush=True)
        # Get headlines
        headlines = get_headlines()
        for headline in headlines:
            print(headline, flush=True)
    except BrokenPipeError:
        # Python flushes standard streams on exit; redirect remaining output
        # to devnull to avoid another BrokenPipeError at shutdown
        import os
        import sys
        devnull = os.open(os.devnull, os.O_WRONLY)
        os.dup2(devnull, sys.stdout.fileno())
        sys.exit(1)