#!/usr/bin/perl 
#===============================================================================
#
#         FILE: login-web.pl
#
#        USAGE: ./login-web.pl
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2014年08月03日 11时23分01秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use HTTP::Request;
use HTTP::Cookies;
use LWP::UserAgent;

my $url = 'http://passport.renren.com/PLogin.do';

# 用来存 cookie
my $cookie_jar = HTTP::Cookies->new(
    file     => "./acookies.lwp",
    autosave => 1,
);

# 给处理 cookie 的对象放到 LWP::UserAgent 中来处理 cookie
# 登陆中
my $ua      = LWP::UserAgent->new;
my $cookies = $ua->cookie_jar($cookie_jar);
$ua->agent('Mozilla/9 [en] (Centos; Linux)');
my $res = $ua->post(
    $url,
    [
        email    => 'zhujian0805@gmail.com',
        password => 'zhujian',
#        origURL  => 'http//www.renren.com/home',
#        domain   => 'renren.com',
    ],
);

#Now you can access your protected content

#$res =$ua->get('http://www.renren.com/home.do');
$res = $ua->get(

#    'http://www.renren.com/235018505?pma=p_profile_m_pub_friendslist_a_profile'
#     'https://safe.renren.com/security/account'
#    'http://www.renren.com/702740495/profile?v=info&act=edit'
#    'http://www.renren.com/702740495/profile?v=info&act=edit#pdetails'
#    'http://www.renren.com/privacyhome.do'
    'http://blog.renren.com/blog/702740495/932392877?myblog'
);
print $res->content();
