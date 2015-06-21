<# Author: Sergio Morales
     Date: 6/21/15
   Description: Downloads all photos that I received when purchasing from gradimages.com. Downloading 56 photos by hand seemed slower than writting this script.
#>


$url = "http://fulfillment.gradimages.com/Download/Image/16554222/4a49fd960f244dc8/"   # Link to the pictures, omitting size and file name. 

$urlpos = 7054532;  # Starting position, after size name is appended to URL
$numphotos = 14;    # The number of diff photos there are

$tn_dir = "C:\Users\Sergio\Desktop\Grad Photos\TN";
$ig_dir = "C:\Users\Sergio\Desktop\Grad Photos\IG";
$l_dir  = "C:\Users\Sergio\Desktop\Grad Photos\L";
$xl_dir = "C:\Users\Sergio\Desktop\Grad Photos\XL";
 
$client = new-object System.Net.WebClient # used to download files

# Download Thumbnails
for( $i = 0; $i -lt 14; $i++ )
{
    $full_url = ($url + "Medium/" + ($urlpos+$i));
    $path = (($tn_dir + "\TN" + +($i+1))+".jpg");
    
    Echo "Downloading $full_url at path $path";
    $client.DownloadFile( $full_url, $path );
}

# Download IG size
for( $i = 0; $i -lt 14; $i++ )
{
    $full_url = ($url + "Instagram/" + ($urlpos+$i));
    $path = (($ig_dir + "\IG" + ($i+1))+".jpg");
    
    Echo "Downloading $full_url at path $path";
    $client.DownloadFile( $full_url, $path );
}

# Download Large.
for( $i = 0; $i -lt 14; $i++ )
{
    $full_url = ($url + "Large/" + ($urlpos+$i));
    $path = (($l_dir + "\L" + ($i+1))+".jpg");
    
    Echo "Downloading $full_url at path $path";
    $client.DownloadFile( $full_url, $path );
}

# Download Extra Large.
for( $i = 0; $i -lt 14; $i++ )
{
    $full_url = ($url + "XLarge/" + ($urlpos+$i));
    $path = (($l_dir + "\XL" + ($i+1))+".jpg");
    
    Echo "Downloading $full_url at path $path";
    $client.DownloadFile( $full_url, $path );
}
