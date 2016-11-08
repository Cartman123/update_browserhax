# Install/Update browserhax's website


This is a simple fork from the original [yellows8's update browserhax script](https://github.com/yellows8/browserhax_site).

It automatically downloads the latest browserhax_site, replaces the hardcoded urls, copies the browserhax_cfg.php to the webroot folder and generates a valid qrcode.

## Requirements
A GNU/Linux machine (tested on Ubuntu) with the following packages installed:
- git
- qrencode *(automatic qrcode generation)*
- gcc-arm-none-eabi *(needed to make the 3ds_browserhax_common project and generate the 3ds_arm11code.bin)*

## Usage

`./update_browserhax.sh <path to repos base directory> <path to pub_html root> <webpageURL>`

Full paths are preferable. For cleaner code, don't use trailing slashes (`/some/dir` instead of `/some/dir/`, and `http://example.com` instead of `http://example.com/`).

##### Example

`./update_browserhax.sh /home/user/repos /var/www/html "http://example.com"`


## Compiling browserhax

- Go into the `3ds_browserhax_common` repo directory (`cd /home/user/repos/3ds_browserhax_common`)
- run `make`
- this will generate the `3ds_arm11code.bin`


## Configuring the website

- On the webroot directory, edit `browserhax_cfg.php`
- Use [this gist](https://gist.github.com/Cartman123/5f4cb7e76af47731a1aafd63335727fe) as a base
  - Change `<someid>` to whatever you like
  - Change `realpath(dirname(__FILE__)) . "/payloads/3ds_arm11code.bin"` to the path of your `3ds_arm11code.bin`.
    - Example: `"/home/user/repos/3ds_browserhax_common/3ds_arm11code.bin"`
    - Or keep it that way and copy/symlink the file to a directory named `payloads` in the webroot:
      - `cd webroot_dir`
      - `mkdir payloads`
      - symlink: `ln -s /home/user/repos/3ds_browserhax_common/3ds_arm11code.bin ./payloads/3ds_arm11code.bin`
      - **or** copy: `cp -p repos_dir/3ds_browserhax_common/3ds_arm11code.bin ./payloads/3ds_arm11code.bin`


## Updating the website

Just run the script again. It won't overwrite the config file, so you'll only need to recompile browserhax if it has changed.

