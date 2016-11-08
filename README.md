# Install/Update browserhax's website

This is a simple fork from the original [yellows8's update browserhax script](https://github.com/yellows8/browserhax_site).

It automatically downloads the latest browserhax_site, replaces the hardcoded urls, copies the browserhax_cfg.php to the webroot folder and generates a valid qrcode (using the google char api).

This script has 2 versions:
- **`update_browserhax.sh`** is a simple improvement over the original that fixes hardcoded paths and auto copies the `browserhax_cfg.php` to the webroot directory and you must configure it yourself, aswell as compiling the 3ds_browserhax_common repo yourself
- **`update_browserhax_auto.sh`** automatically sets everything up, compiles 3ds_browserhax_common, and uses a predefined configuration file with auto id generation. No extra configuration needed

## Requirements
A GNU/Linux machine (tested on Ubuntu) with the following packages installed:
- git
- gcc-arm-none-eabi *(needed to make the 3ds_browserhax_common project and generate the 3ds_arm11code.bin)*

## Download

You can download this script by either cloning this repo or simply:

- **Using `update_browserhax.sh`:** `curl -o update_browserhax.sh "https://raw.githubusercontent.com/Cartman123/update_browserhax/master/update_browserhax.sh" && chmod +x update_browserhax.sh`
- **Using `update_browserhax_auto.sh`:** `curl -o update_browserhax_auto.sh "https://raw.githubusercontent.com/Cartman123/update_browserhax/master/update_browserhax_auto.sh" && chmod +x update_browserhax_auto.sh`

## Usage

`./update_browserhax.sh <path to repos base directory> <path to pub_html root> <webpageURL>`

or

`./update_browserhax_auto.sh <path to repos base directory> <path to pub_html root> <webpageURL>`

Full paths are preferable. For cleaner code, don't use trailing slashes (`/some/dir` instead of `/some/dir/`, and `http://example.com` instead of `http://example.com/`).

##### Examples

`./update_browserhax.sh /home/user/repos /var/www/html "http://example.com"`

`./update_browserhax_auto.sh /home/user/repos /var/www/html "http://example.com"`

## One line mirror installation/update using update_browserhax_auto.sh

You can create a very simple mirror by running the following line (remember to install de requirements first):

`bash <(curl -s https://raw.githubusercontent.com/Cartman123/update_browserhax/master/update_browserhax_auto.sh) /path/to/repos /path/to/webroot "http://example.com"`

And it's done! The new mirror should be up and running on http://example.com/3dsbrowserhax.php (the qr code will point you to http://example.com/3dsbrowserhax_auto.php)

## Extra steps on update_browserhax.sh (NOT NEEDED ON THE auto VERSION!)

### Compiling browserhax

- Go into the `3ds_browserhax_common` repo directory (`cd /home/user/repos/3ds_browserhax_common`)
- run `make OUTPUT_PATH=./`
- this will generate the `3ds_arm11code.bin`


### Configuring the website

- On the webroot directory, edit `browserhax_cfg.php`
- Use [this file](https://github.com/Cartman123/update_browserhax/blob/master/browserhax_cfg.php) as a base
  - Change `<someid>` to whatever you like
  - Change `realpath(dirname(__FILE__)) . "/payloads/3ds_arm11code.bin"` to the path of your `3ds_arm11code.bin`.
    - Example: `"/home/user/repos/3ds_browserhax_common/3ds_arm11code.bin"`
    - Or keep it that way and copy/symlink the file to a directory named `payloads` in the webroot:
      - `cd webroot_dir`
      - `mkdir payloads`
      - symlink: `ln -s /home/user/repos/3ds_browserhax_common/3ds_arm11code.bin ./payloads/3ds_arm11code.bin`
      - **or** copy: `cp -p repos_dir/3ds_browserhax_common/3ds_arm11code.bin ./payloads/3ds_arm11code.bin`


## Updating the website

Just run the script again. It won't overwrite the config file, so you'll only need to recompile browserhax if it has changed (not necessary if running the auto version).

