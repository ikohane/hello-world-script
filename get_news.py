import feedparser
import sys

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
    headlines = get_headlines()
    for headline in headlines:
        print(headline)