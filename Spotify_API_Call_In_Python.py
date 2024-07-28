import base64
import requests
import os  # hides sensetive information

# Fetch credentials from environment variables
CLIENT_ID = os.getenv('SPOTIFY_CLIENT_ID')
CLIENT_SECRET = os.getenv('SPOTIFY_CLIENT_SECRET')
access_token = os.getenv('SPOTIFY_ACCESS_TOKEN')
artist_id = '6m9Qgp7wd2QBDFGS9tJExD'

# Function to get access token
def get_access_token(client_id, client_secret):
    auth_url = 'https://accounts.spotify.com/api/token'
    headers = {
        'Authorization': 'Basic ' + base64.b64encode(f"{client_id}:{client_secret}".encode()).decode(),
        'Content-Type': 'application/x-www-form-urlencoded'
    }
    payload = {
        'grant_type': 'client_credentials'
    }
    response = requests.post(auth_url, headers=headers, data=payload)
    return response.json().get('access_token')

# Get an access token
access_token = get_access_token(CLIENT_ID, CLIENT_SECRET)
print("Access Token:", access_token)

# Search Spotify's API for the artist we want
def search_artist(access_token, artist_name):
    search_url = 'https://api.spotify.com/v1/search'
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    params = {
        'q': artist_name,
        'type': 'artist',
        'limit': 1  # Limit the search to the top result
    }
    response = requests.get(search_url, headers=headers, params=params)
    return response.json()
    
# defining more variables 
artist_name = 'Elation Cycle'
search_data = search_artist(access_token, artist_name)

# Extract artist ID
if search_data.get('artists', {}).get('items'):
    artist_id = search_data['artists']['items'][0]['id']
    print("Artist ID:", artist_id)
else:
    print("Artist not found.")

# Function to get artist data
def get_artist_data(access_token, artist_id):
    artist_url = f'https://api.spotify.com/v1/artists/{artist_id}'
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    response = requests.get(artist_url, headers=headers)
    return response.json()

# Elation Cycle artist ID used here
artist_data = get_artist_data(access_token, artist_id)

# Print artist data
print("Artist Name:", artist_data.get('name'))
print("Genres:", artist_data.get('genres'))
print("Popularity:", artist_data.get('popularity'))
print("Followers:", artist_data.get('followers', {}).get('total'))
print("External URL:", artist_data.get('external_urls', {}).get('spotify'))

# Get top tracks for Elation Cycle
def get_artist_top_tracks(access_token, artist_id):
    top_tracks_url = f'https://api.spotify.com/v1/artists/{artist_id}/top-tracks'
    headers = {
        'Authorization': f'Bearer {access_token}'
    }
    params = {
        'market': 'US'  # Specify the market (country) for the top tracks
    }
    response = requests.get(top_tracks_url, headers=headers, params=params)
    return response.json()

# Get top tracks
top_tracks_data = get_artist_top_tracks(access_token, artist_id)
print("Top Tracks:", top_tracks_data)
