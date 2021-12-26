# Rclone Pictures

A very haphazard attempt at reconciling photos in Google Photos.

# Usage

Setup rclone to access read-only Google Photos.  Can do this through `rclone config`.

Then get listings of all the files.

Unfortunately, I don't recall what commands I used to get the listings.

Some combination of these:

```
rclone lsf remote:
album/
feature/
media/
shared-album/
upload/

All album names
rclone lsd remote:album > lsd_album

All album names with files
rclone ls remote:album > ls_album

rclone lsf remote:media
all/
by-day/
by-month/
by-year/

rclone ls remote:media/all > ls_media_all2

./remote_albums.rb ls_media_all2 ls_album_all |m
```

# Original Post

https://support.google.com/photos/thread/12363001/viewing-photos-not-in-an-album?hl=en

```
Yes you can list all photos not in albums!
Google Photos has a programming interface, and you need to make use of that.
First you list all Photos by month - this is the fastest way to list all your Google Photos. Save the data.
Then you list all photos by Album. As it suggests this lists all photos in albums. Save the data.
Now you need to find the difference between the two data sets - the difference is a list of photos not in albums.

I use a program called Rclone to extract the data from Google Photos. I have about 40000 images backed up there and it takes about 5 minutes to extract each data set and save it as a file.

I then use a Python script to find the difference between the two data sets and give me a list of images not in albums

My main use of this process is to compare the image lists on Google Photos with my backup external drive, and then get a list of those images I have forgotten to backup to Google Photos. Rclone can then be set to do the backup for me in batches of 12 GB a day, straight into albums - you then have to press the button to compress images before the next batch unless you pay to store at full resolution..

See details at https://rclone.org/
The first step is to set up rclone to use the remote store  - rclone does all the hard work for you.
Set up your remote using rclone config. I have names my remote connection to my Google Photos: gphotopt
Then you can use the following commands:
rclone lsd gphotopt:album -P # lists all ***albums*** and number of photos in them. But if not in album won't list them

rclone ls gphotopt:album -P # lists all photos in each album, but doesn't list them if not in an album

rclone lsl gphotopt:album -P # list all photos with exifdate, or upload date if no exif.

rclone lsf gphotopt:media/by-year -P # lists all file names for ***all*** images

You can also tell rclone to write the output to a file.

Note that you are not downloading the images from GPhoto, only obtaining the information about them
I use a Python3 script to collect this information and then put the information in an SQLite database -but that takes a lot more technical knowledge.
Diamond Product Expert
 janvb recommended this
Last edited 11/11/20
```
