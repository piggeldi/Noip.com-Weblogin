#!/usr/bin/perl -w

############# Edit your Account-Data here! ################

$username='NoIp-Login-Name-or-Email-Adress';
$password='NoIp-Password';

# If there is an Proxy in your Env
#$ENV{'https_proxy'}="http://proxy.mydomain.com:8080";
########################################################################################

$epuburl= "https://www.noip.com/login/";
$epuburl2="https://www.noip.com/members/";
$epuburl3="https://www.noip.com/login";

$file="noip";
$cookie="cookie-noip.txt";

$useragent='Mozilla/5.0 (Windows NT 6.0; WOW64; rv:24.0) Gecko/20100101 Firefox/24.0';

$debug="";

print "##################################################\n";
print "Start login with Loginname: $username... \n";
if (-f $cookie) {
	system("rm $cookie");
}

if (-f $file."in1.html") {
	system("del $file"."in1.html");
}
system("wget -q $debug --referer=$epuburl --cookies=on --load-cookies=$cookie --keep-session-cookies --save-cookies=$cookie --no-check-certificate --user-agent=\"$useragent\" --post-data \"username=$username&password=$password&submit_login_page=1&Login=\" \"$epuburl3\" -t 1 -O $file"."in1.html");
if (-f $file."in.html") {
	system("del $file"."in.html");
}
system("wget -q $debug --referer=$epuburl3 --cookies=on --load-cookies=$cookie --keep-session-cookies --save-cookies=$cookie --no-check-certificate --user-agent=\"$useragent\" --post-data \"username=$username&password=$password&submit_login_page=1&Login=\" \"$epuburl2\" -t 1 -O $file"."in.html");
open (CONFFILE, "$file"."in.html") || die "Can't open $file"."in.html!\n";
while (<CONFFILE>) {
	$line=$_;
	if ($line=~/^\s*<span id="user">Signed in as:<\/span> <a class="offwhite" href="\/members\/">(.*?)<\/a>\s*$/) {
		$loginName=$1;
		
		print "Login successfull!\n";
		print "Signed in as: $loginName\n";
		$loginOk=1;
		
		if (-f $file."out.html") {
			system("del $file"."out.html");
		}
		print "Logging out... \n";
		system("wget -q $debug --referer=$epuburl2 --cookies=on --load-cookies=$cookie --keep-session-cookies --save-cookies=$cookie --no-check-certificate --user-agent=\"$useragent\" \"$epuburl"."?logout=1\" -O $file"."out.html");
	}
	elsif ($line=~/^\s*<p><span class="gray bold1 size1">Last Login: (.*)<\/span><\/p>\s*$/) {
		$lastLoginInfo=$1;
		print "Last Login: $lastLoginInfo\n";
		last;
	}
}
close CONFFILE;	
if ($loginOk==0) {
			print "ATTENTION: Login failed!\n";
			
}
print "##################################################\n";

system ("rm *.html");
system ("rm *.txt");
