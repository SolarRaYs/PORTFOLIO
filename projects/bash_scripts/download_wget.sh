
#!/bin/bash
write a bash script to download image video music and pdf from the given url
echo "Enter the website URL:"
read rurl

echo "Enter the content needed to be downloaded (separate by spaces, e.g., image video music pdf):"
read content

# Download images 
if [ -n "$(echo "$content" | grep "image")" ]
then
    echo "Downloading images..."
    wget -nd -r -P /home/parrot/skill/images -e robots=off -A "png,jpg,jpeg,gif,bmp" "https://$rurl"
fi

# Download videos 
if [ -n "$(echo "$content" | grep "video")" ]
then
    echo "Downloading videos..."
    wget -nd -r -P /home/parrot/skill/video -e robots=off -A "mp4,avi,mov" "https://$rurl"
fi

# Download music 
if [ -n "$(echo "$content" | grep "music")" ]
then
    echo "Downloading music..."
    wget -nd -r -P /home/parrot/skill/music -e robots=off -A "mp3,wav" "https://$rurl"
fi

# Download PDF
if [ -n "$(echo "$content" | grep "pdf")" ]
then
    echo "Downloading PDFs..."
    wget -nd -r -P /home/parrot/skill/pdf -e robots=off -A "pdf" "https://$rurl"
fi
