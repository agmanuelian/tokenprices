import requests, json

# Default Handler function, receives webhook events posted to AWS API Gateway
# Retrieves USD price for a particular token

def lambda_handler(event, context):
    try:
        symbol = event['symbol'] #  Takes input from API GW query string parameter
    
        if (len(symbol) <  4):
            symbol = symbol_mapping(symbol)
        
        url = f"https://api.coingecko.com/api/v3/simple/price?ids={symbol}&vs_currencies=usd"
        response = requests.get(url)
        data = response.json()
        return data[symbol]["usd"]
    except:
        return "No symbol found in the request"

# Function to get token name in case the ticker is provided as parameter
def symbol_mapping(ticker):
    symbols_mapping = requests.get("https://api.coingecko.com/api/v3/coins/list").json()
    
    #Implementing List Comprehension to get the dict of the target token
    symbol_dict = next((d for d in symbols_mapping if d["symbol"] == ticker), None)

    #print(f"The ticker {ticker} belongs to {symbol_dict['id']}") 
    return symbol_dict['id']
