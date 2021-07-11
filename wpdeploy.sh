#!/bin/bash
#####################################################################
# Omar Khalil
# https://github.com/DonSYS91
# DEPLOY_WordPress_MariaDB_Nginx.SH
# Version 0.1 (AMD64)
# WordPress
# OpenSSL 1.1.1, TLSv1.3, NGINX latest mainline, PHP 7.4, MariaDB 10.5
# June, 5th 2021
#####################################################################
# Debian Buster 10 AMD64 - WordPress
#####################################################################
set -euo pipefail
IFS=$'\n\t'

#####################################################################
# Global Variables
#####################################################################
#MYSQL_ROOT_PASSWORD = ''


#####################################################################
# Helper Functions - Update and Clean
#####################################################################
function update_and_clean() {
	echo " Cleaning and Updating APT."
	apt update
	apt upgrade -y
	apt autoclean -y
	apt autoremove -y
}

#####################################################################
# Helper Functions - Restart all the Related Services
#####################################################################
function restart_all_services() {
	echo " Restarting Nginx, MariaDB, Redis Server and PHP services."
	/usr/sbin/service nginx restart
	/usr/sbin/service mysql restart
	/usr/sbin/service redis-server restart
	/usr/sbin/service php7.4-fpm restart
}

#####################################################################
# Main Functions - Install Prerequistes and configure APT Repos
#####################################################################
function pre_install_debs() {
	echo " Configuring APT and configuring prerequisites "
	## Install Prerequistes packages
	apt install apt-transport-https curl wget git gnupg2 dirmngr expect sudo lsb-release ca-certificates software-properties-common zip unzip screen ffmpeg ghostscript libfile-fcntllock-perl locate htop tree -y

	## Add the needed apt repos
	echo "deb [arch=amd64] http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list
	echo "deb [arch=amd64] https://packages.sury.org/php/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/php.list
	echo "deb [arch=amd64] https://mirror.dogado.de/mariadb/repo/10.5/debian $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/mariadb.list

	## Get apt keys of the repos
	curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
	wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
	apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8

	update_and_clean

}

#####################################################################
# Main Functions - Install and Configure Nginx
#####################################################################
function install_configure_nginx() {
	echo " Installing and Configuring Nginx "

	## Installing Nginx
	apt remove nginx nginx-common nginx-full -y --allow-change-held-packages
	apt install nginx -y

	systemctl enable nginx.service

	## Configure Nginx

}



